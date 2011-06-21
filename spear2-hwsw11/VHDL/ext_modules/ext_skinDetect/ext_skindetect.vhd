library ieee;
use ieee.std_logic_1164.all;

use ieee.numeric_std.all;
use work.spear_pkg.all;

entity ext_skindetect is
  port (
    clk       : in  std_logic;
    extsel    : in  std_ulogic;
    exti      : in  module_in_type;
    exto      : out module_out_type
  );
end;

architecture behaviour of ext_skindetect is
  subtype BYTE is std_logic_vector(7 downto 0);
  type register_set is array (0 to 4) of BYTE;

  type reg_type is record
    ifacereg	: register_set;
    --index	: std_logic_vector(18 downto 0);
    r		: std_logic_vector(7 downto 0);
    g		: std_logic_vector(7 downto 0);
    b		: std_logic_vector(7 downto 0);
    rf		: signed(31 downto 0);
    gf		: signed(31 downto 0);
    bf 		: signed(31 downto 0);
  end record;

  signal r_next : reg_type;
  signal r : reg_type := 
  (
    ifacereg => (others => (others => '0')),
    --index	=> (others => '0'),
    r => (others => '0'),
    g => (others => '0'),
    b => (others => '0'),
    rf => (others => '0'),
    gf => (others => '0'),
    bf => (others => '0')
  );
	
  signal rstint : std_ulogic;
  signal isSkin, isSkin_next : std_logic;

begin

  comb : process(r, exti, extsel)
  variable v : reg_type;
  begin
    v := r;

    --schreiben
    if ((extsel = '1') and (exti.write_en = '1')) then
      case exti.addr(4 downto 2) is
        when "000" =>
          if ((exti.byte_en(0) = '1') or (exti.byte_en(1) = '1')) then
            v.ifacereg(STATUSREG)(STA_INT) := '1';
            v.ifacereg(CONFIGREG)(CONF_INTA) :='0';
          else
            if ((exti.byte_en(2) = '1')) then
              v.ifacereg(2) := exti.data(23 downto 16);
            end if;
            if ((exti.byte_en(3) = '1')) then
              v.ifacereg(3) := exti.data(31 downto 24);
            end if; 
          end if;
        when "001" =>
          if ((exti.byte_en(0) = '1')) then
            v.r := exti.data(7 downto 0);
          end if;
          if ((exti.byte_en(1) = '1')) then
            v.g := exti.data(15 downto 8);
          end if;
          if ((exti.byte_en(2) = '1')) then
            v.b := exti.data(23 downto 16);
          end if;
        when others =>
          null;
      end case;
    end if;

    --auslesen
    exto.data <= (others => '0');
    if ((extsel = '1') and (exti.write_en = '0')) then
      case exti.addr(4 downto 2) is
        when "000" =>
          exto.data <= r.ifacereg(3) & r.ifacereg(2) & r.ifacereg(1) & r.ifacereg(0);
        when "010" =>
          exto.data(0) <= isSkin;
        when others =>
          null;
      end case;
    end if;

    --berechnen der neuen status flags
    v.ifacereg(STATUSREG)(STA_LOOR) := r.ifacereg(CONFIGREG)(CONF_LOOW);
    v.ifacereg(STATUSREG)(STA_FSS) := '0';
    v.ifacereg(STATUSREG)(STA_RESH) := '0';
    v.ifacereg(STATUSREG)(STA_RESL) := '0';
    v.ifacereg(STATUSREG)(STA_BUSY) := '0';
    v.ifacereg(STATUSREG)(STA_ERR) := '0';
    v.ifacereg(STATUSREG)(STA_RDY) := '1';

    -- Output soll Defaultmassig auf eingeschalten sie 
    v.ifacereg(CONFIGREG)(CONF_OUTD) := '1';
    
    
    --soft- und hard-reset vereinen
    rstint <= not RST_ACT;
    if exti.reset = RST_ACT or r.ifacereg(CONFIGREG)(CONF_SRES) = '1' then
      rstint <= RST_ACT;
    end if;
    
    -- Interrupt
    if r.ifacereg(STATUSREG)(STA_INT) = '1' and r.ifacereg(CONFIGREG)(CONF_INTA) ='0' then
      v.ifacereg(STATUSREG)(STA_INT) := '0';
    end if; 
    exto.intreq <= r.ifacereg(STATUSREG)(STA_INT);



    r_next <= v;

  end process;

  reg : process(clk)
  begin
    if rising_edge(clk) then 
      if rstint = RST_ACT then
        r.ifacereg <= (others => (others => '0'));
      else
        r <= r_next;
      end if;
    end if;
  end process;

end behaviour;
