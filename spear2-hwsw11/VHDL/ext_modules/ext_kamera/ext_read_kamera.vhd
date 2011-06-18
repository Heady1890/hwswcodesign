--------------------------------------------------------------------------------
-- LIBRARY
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE work.spear_pkg.all;

use work.pkg_camd5m_read.all;
use work.pkg_kamera.all;

----------------------------------------------------------------------------------
-- ENTITY
----------------------------------------------------------------------------------

entity read_kamera is
  port (
    CAM_PIXCLK	: in  std_logic;
    CAM_LVAL	: in  std_logic;
    CAM_TRIGGER	: out std_logic;
    CAM_STROBE	: in  std_logic;
    CAM_FVAL	: in  std_logic;
    CAM_D	: in std_logic_vector(11 downto 0);
    
    
    --LED_GREEN	: out std_logic_vector(8 downto 0);
    INIT_DONE	: in std_logic;
    
    sys_res : in  std_logic;
    --sys_clk : in  std_logic;

    ram_address	: out std_logic_vector(10 downto 0);
    ram_data	: out std_logic_vector(7 downto 0);
    ram_en	: out std_logic
  );  
end entity read_kamera;

----------------------------------------------------------------------------------
-- ARCHITECTURE
----------------------------------------------------------------------------------

architecture behaviour of read_kamera is
  type state_type is (reset, ready, wait_line, read_line);

  type reg_type is record
    --Variablen für Berechnung
    state	: state_type;				--Status der State-Machine
    index	: std_logic_vector(10 downto 0);			
  end record;

  signal r_next : reg_type;
  signal r : reg_type := 
  (
    --Signale initialisieren
    state => reset,
    index => (others => '0')
  );

begin

  read : process(r, CAM_LVAL, CAM_FVAL, CAM_PIXCLK, CAM_D)
  begin
    r_next <= r;

    ram_address <= r.index;
    ram_data <= (others => '0');
    ram_en <= '0';

    case r.state is
      when reset =>
        if INIT_DONE = '1' then
          r_next.state <= ready;
        end if;

      when ready =>
        if CAM_FVAL = '1' then
          r_next.state <= wait_line;
        end if;

      when wait_line =>
        if CAM_FVAL = '0' then
          r_next.state <= ready;
        elsif CAM_LVAL = '1' then
          r_next.state <= read_line;
        end if;

      when read_line =>
        if CAM_LVAL = '0' then
          r_next.state <= wait_line;
        else
          ram_address <= r.index;
          ram_data <= CAM_D(11 downto 4);
          ram_en <= '1';
        end if;
      end case;
  end process;


  reg : process(CAM_PIXCLK)
  begin
    if rising_edge(CAM_PIXCLK) then 
      if sys_res = RST_ACT then
        --Signale initialisieren
        --ram_address <= (others => '0');
        --ram_data <= (others => '0');
        --ram_en <= '0';
      else
        r <= r_next;
      end if;
    end if;
  end process;

end behaviour;
