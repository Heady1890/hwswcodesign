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

entity converter is
  port (
    start_conv	: in  std_logic;
    
    sys_res : in  std_logic;
    sys_clk : in  std_logic;

    small_ram_address1	: out std_logic_vector(18 downto 0);
    small_ram_data1	: in  std_logic_vector(7 downto 0);
    small_ram_address2	: out std_logic_vector(18 downto 0);
    small_ram_data2	: in  std_logic_vector(7 downto 0);

    ram_address	: out std_logic_vector(18 downto 0);
    ram_data	: out std_logic_vector(23 downto 0);
    ram_en	: out std_logic
  );  
end entity converter;

----------------------------------------------------------------------------------
-- ARCHITECTURE
----------------------------------------------------------------------------------

architecture behaviour of converter is
  constant FRAME_WIDTH : integer := 640;
  constant FRAME_HEIGHT : integer := 480;

  type state_type is (reset, ready, read1, read2, write1, write2, write3, write4);

  type reg_type is record
    --Variablen für Berechnung
    state	: state_type;				--Status der State-Machine
    col_cnt	: std_logic_vector(16 downto 0);	--werden für die Adressierung benötigt
    row_cnt	: std_logic_vector(16 downto 0);
    row_toggle	: std_logic;		--0 = gerade Zeile(grün1, rot), 1 ungerade Zeile (grün2, blau)
    col_toggle	: std_logic;	
    index	: std_logic_vector(18 downto 0);
    dot_r	: std_logic_vector(7 downto 0);	
    dot_g1	: std_logic_vector(7 downto 0);	
    dot_g2	: std_logic_vector(7 downto 0);	
    dot_b	: std_logic_vector(7 downto 0);	
  end record;

  signal r_next : reg_type;
  signal r : reg_type := 
  (
    --Signale initialisieren
    state => reset,
    col_cnt => (others => '0'),
    row_cnt => (others => '0'),
    row_toggle => '0',
    col_toggle => '0',
    index => (others => '0'),
    dot_r => (others => '0'),
    dot_g1 => (others => '0'),
    dot_g2 => (others => '0'),
    dot_b => (others => '0')
  );
  
begin

  convert : process(r)
  begin
    r_next <= r;

    ram_en <= '0';
    ram_address <= (others => '0');
    ram_data <= (others => '0');
    
    case r.state is
      when reset =>
        if start_conv = '1' then
          r_next.state <= ready;
        end if;

      when ready =>
        r_next.state <= read1;
        r_next.col_cnt <= (others => '0');
        r_next.row_cnt <= (others => '0');
        r_next.col_toggle <= '0';
        r_next.row_toggle <= '0';
        r_next.index <= (others => '0');

        small_ram_address1 <= r.index;
        small_ram_address2 <= r.index + 1;

      when read1 =>
        r_next.dot_g1 <= small_ram_data1;
        r_next.dot_r <= small_ram_data2;

        small_ram_address1 <= r.index + FRAME_WIDTH;
        small_ram_address2 <= r.index + FRAME_WIDTH + 1;

        r_next.state <= new_line;

      when read2 =>
        r_next.dot_b <= small_ram_data1;
        r_next.dot_g2 <= small_ram_data2;

        r_next.state <= write1;

      when write1 =>
        ram_address <= r.index;
        ram_data <= r.dot_r & r.dot_g1 & r.dot_b;
        ram_en <= '1';

        r_next.state <= write2;

      when write2 =>
        ram_address <= index + 1;
        ram_data <= r.dot_r & r.dot_g1 & r.dot_b;
        ram_en <= '1';

        r_next.state <= write3;

      when write3 =>
        ram_address <= index + FRAME_WIDTH;
        ram_data <= r.dot_r & r.dot_g2 & r.dot_b;
        ram_en <= '1';

        r_next.state <= write4;

      when write4 =>
        ram_address <= index + FRAME_WIDTH + 1;
        ram_data <= r.dot_r & r.dot_g2 & r.dot_b;
        ram_en <= '1';

        r_next.state <= read1;

        r_next.col_cnt <= r.col_cnt + 2;
        if r.col_cnt = FRAME_WIDTH then
          r_next.index <= r.index + 2 + FRAME_WIDTH;
          if row_cnt = FRAME_HEIGHT then
            r_next.state <= ready;
          else
            r_next.row_cnt <= r.row_cnt + 1;
          end if;
        else
          r_next.index <= r.index + 2;
        end if;

    end case;

  end process;


  reg : process(sys_clk)
  begin
    if rising_edge(sys_clk) then 
      if rstint = RST_ACT then
        --Signale initialisieren
      else
        r <= r_next;
      end if;
    end if;
  end process;

end behaviour;
