--------------------------------------------------------------------------------
-- LIBRARY
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE work.spear_pkg.all;

use work.pkg_camd5m_read.all;

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
    --sys_clk : in  std_logic);

    ram_address	: out std_logic_vector(18 downto 0);
    ram_data	: out std_logic_vector(7 downto 0);
    ram_en	: out std_logic;
    
end entity read_kamera;

----------------------------------------------------------------------------------
-- ARCHITECTURE
----------------------------------------------------------------------------------

architecture behaviour of read_kamera is
  --constant FRAME_WIDTH : integer := 640;
  --constant FRAME_HEIGHT : integer := 480;
  
  type state_type is (reset, ready, wait_line, read_line);

  type reg_type is record
    --Variablen für Berechnung
    state	: state_type;				--Status der State-Machine
    --col_cnt	: std_logic_vector(16 downto 0);	--werden für die Adressierung benötigt
    --row_cnt	: std_logic_vector(16 downto 0);
    --row_toggle	: std_logic;			--0 = gerade Zeile(grün1, rot), 1 ungerade Zeile (grün2, blau)
    --col_toggle	: std_logic;	
    index	: std_logic_vector(18 downto 0);			
  end record;

  signal r_next : reg_type;
  signal r : reg_type := 
  (
    --Signale initialisieren
    state => reset,
    index => (others => '0')
  );

begin

  read : process(r,fval,lval,cam_clk, cam_d)
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
        if fval = '1' then
          r_next.state <= wait_line;
          --row_toggle <= '0';
        end if;

      when wait_line then
        if fval = '0' then
          r_next.state <= ready;
        else if lval = '1' then
          r_next.state <= read_line;
          --col_cnt <= 0;
          --row_toggle <= not(row_toggle);
        end if;

      when read_line =>
        if lval = '0' then
          r_next.state <= wait_line;
        else
          ram_address <= r.index;
          ram_data <= cam_d(11 downto 4);
          ram_en <= '1';
        end if;
      end case;
  end process;


  reg : process(CAM_PIXCLK)
  begin
    if rising_edge(CAM_PIXCLK) then 
      if rstint = RST_ACT then
        --Signale initialisieren
      else
        r <= r_next;
      end if;
    end if;
  end process;

end behaviour;
