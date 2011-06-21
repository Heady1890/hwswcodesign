library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library techmap;
use techmap.gencomp.all;
use work.spear_pkg.all;
library gaisler;
use gaisler.misc.all;

entity rwsdram is
  generic(
    hindex 	: integer := 1;
    hirq	: integer := 1
  );
  port (
    rst       	: in std_logic;
    clk       	: in std_logic;
    extsel      : in std_ulogic;
    exti        : in  module_in_type;
    exto        : out module_out_type;
    ahbi      	: in  ahb_mst_in_type;
    ahbo      	: out ahb_mst_out_type;
    addr_ram_out: out std_logic_vector(11 downto 0);
    data_ram_in	: in std_logic_vector(23 downto 0)
--     LED_RED	: out std_logic_vector(17 downto 0)
    );
end rwsdram;

architecture rtl of rwsdram is

  type state_type is (INIT_STATE, READY_STATE, ADR_ASS_STATE, DATA_OUT_STATE);

  --signal declaration
  signal dmai           	: ahb_dma_in_type;
  signal dmao           	: ahb_dma_out_type;
  signal write_en       	: std_logic;
  signal write_en_next		: std_logic;
  signal write_start		: std_logic;
  signal write_start_next	: std_logic;
  signal write_data		: std_logic_vector(31 downto 0);
  signal write_data_next	: std_logic_vector(31 downto 0);
  signal write_en_byte		: std_logic_vector(7 downto 0);
  signal write_address		: std_logic_vector(31 downto 0);
  signal write_address_next	: std_logic_vector(31 downto 0);
  signal write_state		: state_type;
  signal write_state_next	: state_type;
  signal red_led_state		: std_logic_vector(17 downto 0);
  signal red_led_state_next	: std_logic_vector(17 downto 0);
  signal addr_ram		: std_logic_vector(11 downto 0);
  signal addr_ram_next		: std_logic_vector(11 downto 0);

begin

  --including amba master
  ahb_master : ahbmst generic map (hindex, hirq, VENDOR_RWSDRAM,
	GAISLER_RWSDRAM, 0, 3, 1)
  port map (rst, clk, dmai, dmao, ahbi, ahbo);

  proc_ext : process (exti, extsel, write_data, red_led_state, write_en)
  begin
    write_en_next <= write_en;
    --write_data_next <= write_data;
    red_led_state_next <= red_led_state;
    if ((extsel = '1') and (exti.write_en = '1')) then
      case exti.addr(4 downto 2) is
	when "000" =>
	  red_led_state_next(9 downto 8) <= (others => '1');
	  write_en_next <= '1';
          --write_data_next <= exti.data;
        when "001" =>
	  red_led_state_next(11 downto 10) <= (others => '1');
	  write_en_next <= '1';
          --write_data_next <= exti.data;
        when others =>
          null;
      end case;
    else
      write_en_next <= '0';
    end if;

    --auslesen
    exto.data <= (others => '0');
    if ((extsel = '1') and (exti.write_en = '0')) then
      case exti.addr(4 downto 2) is
        when "000" =>
	  exto.data <= write_data;
          --exto.data <= r.ifacereg(3) & r.ifacereg(2) & r.ifacereg(1) & r.ifacereg(0);
        when "001" =>
          exto.data <= write_data; --(others => '0');
        when others =>
          null;
      end case;
    end if;

  end process;

  --synchron part
  proc_syn : process(clk, rst)
  begin
    if rising_edge(clk) then
      --synchron reset of signals
      if rst = '0' then
	write_state <= INIT_STATE;
	write_address <= x"E0000000";
	red_led_state <= (others => '0');
	write_data <= x"00000000";
	write_en <= '0';
	write_start <= '0';
	addr_ram <= (others => '0');
      --update for the signals on rising edge
      else
	write_data <= write_data_next;
	write_en <= write_en_next;
	write_state <= write_state_next;
	write_address <= write_address_next;
	write_start <= write_start_next;
	red_led_state <= red_led_state_next;
-- 	LED_RED <= red_led_state;
	addr_ram <= addr_ram_next;
	addr_ram_out <= addr_ram_next;
      end if;
    end if;
  end process;

  proc_write_next : process (write_state, write_state_next, write_en, write_address, write_data, dmao, addr_ram)
  begin
    write_state_next <= write_state;
    addr_ram_next <= addr_ram;
    case write_state is
      when INIT_STATE =>
	addr_ram_next <= (others => '0');
	if write_en = '1' then
	  write_state_next <= READY_STATE;
	end if;
      when READY_STATE =>
	if dmao.ready = '1' then
	  if addr_ram >= x"9FF" then
	    addr_ram_next <= (others => '0');
	  else
	    addr_ram_next <= addr_ram + 1;
	  end if;
	  write_state_next <= ADR_ASS_STATE;
	end if;
      when ADR_ASS_STATE =>
	write_state_next <= DATA_OUT_STATE;
      when DATA_OUT_STATE =>
	--if (write_address < X"E0000400") then
	if (write_address < X"E0177000") then
	  if dmao.ready = '1' then  -- and not finished else init state
	    if addr_ram >= x"9FF" then
	      addr_ram_next <= (others => '0');
	    else
	      addr_ram_next <= addr_ram + 1;
 	    end if;
	    write_state_next <= ADR_ASS_STATE;
	  end if;
	else
	  write_state_next <= INIT_STATE;
	end if;
    end case;

  end process;

  proc_control : process (write_state, write_address, write_data, write_start, data_ram_in)
  begin
    write_address_next <= write_address;
    write_start_next <= write_start;
    write_data_next <= write_data;
    case write_state is
      when INIT_STATE =>
	write_start_next <= '0';
	write_address_next <= x"E0000000";
      when READY_STATE =>
	write_start_next <= '1';
      when ADR_ASS_STATE =>
	--write_data_next <= data_ram_in;
	write_data_next(23 downto 0) <= data_ram_in;
	write_address_next <= write_address + 4;
      when DATA_OUT_STATE =>
	null;
      end case;
      --ram_addr_out <= ram_addr;
      dmai.irq <= '0';
      dmai.busy <= '0';
      dmai.burst <= '0';
      dmai.size <= "10";
      dmai.start <= write_start;
      dmai.write <= write_start;
      dmai.wdata <= write_data;
      dmai.address <= write_address;
  end process;

end rtl;
