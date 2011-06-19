--------------------------------------------------------------------------------
-- LIBRARY
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE work.spear_pkg.all;

use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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

    small_ram_address1	: out std_logic_vector(11 downto 0);
    small_ram_data1	: in  std_logic_vector(7 downto 0);
    small_ram_address2	: out std_logic_vector(11 downto 0);
    small_ram_data2	: in  std_logic_vector(7 downto 0);

    ram_address	: out std_logic_vector(11 downto 0);
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

  type state_type is (reset, wait_conv, read1, read2, write2, write3, write4);

  type reg_type is record
    --Variablen für Berechnung
    state	: state_type;				--Status der State-Machine
    col_cnt	: std_logic_vector(16 downto 0);	--werden für die Adressierung benötigt
    --row_cnt	: std_logic_vector(16 downto 0);
    --row_toggle	: std_logic;		--0 = gerade Zeile(grün1, rot), 1 ungerade Zeile (grün2, blau)
    --col_toggle	: std_logic;	
    index	: std_logic_vector(11 downto 0);
    index_toggle: std_logic;
    dot_r	: std_logic_vector(7 downto 0);	
    dot_g1	: std_logic_vector(7 downto 0);	
    dot_g2	: std_logic_vector(7 downto 0);	
    dot_b	: std_logic_vector(7 downto 0);	
    addr1	: std_logic_vector(11 downto 0);
    addr2	: std_logic_vector(11 downto 0);
  end record;

  signal r_next : reg_type;
  signal r : reg_type := 
  (
    --Signale initialisieren
    state => reset,
    col_cnt => (others => '0'),
    --row_cnt => (others => '0'),
    --row_toggle => '0',
    --col_toggle => '0',
    index => (others => '0'),
    index_toggle => '0',
    dot_r => (others => '0'),
    dot_g1 => (others => '0'),
    dot_g2 => (others => '0'),
    dot_b => (others => '0'),
    addr1 => (others => '0'),
    addr2 => (others => '0')
  );
  
begin

  convert : process(r, start_conv)
  variable s 	: reg_type;
  begin
    s := r;

    ram_en <= '0';
    ram_address <= (others => '0');
    ram_data <= (others => '0');
    
    case r.state is
      when reset =>
        s.state := wait_conv;

      when wait_conv =>
        if start_conv = '1' then
          s.state := read1;
          s.col_cnt := (others => '0');

          if s.index_toggle = '0' then
            s.index := (others => '0');
          else
            s.index := x"500";
          end if;

          s.index_toggle := not s.index_toggle;

          small_ram_address1 <= s.index;
          small_ram_address2 <= s.index+1;

          s.addr1 := s.index + FRAME_WIDTH;
          s.addr2 := s.index + FRAME_WIDTH + 1;
        end if;

      --when ready =>
      --  s.state := read1;
      --  s.col_cnt := (others => '0');
      --  s.row_cnt := (others => '0');
      --  s.col_toggle := '0';
      --  s.row_toggle := '0';
      --  s.index := (others => '0');

      --  small_ram_address1 <= r.addr1;
      --  small_ram_address2 <= r.addr2;

      --  s.addr1 := r.index + FRAME_WIDTH;
      --  s.addr2 := r.index + FRAME_WIDTH + 1;

      when read1 =>
        s.dot_g1 := small_ram_data1;
        s.dot_r := small_ram_data2;

        small_ram_address1 <= r.addr1;
        small_ram_address2 <= r.addr2;

        s.state := read2;

      when read2 =>
        s.dot_b := small_ram_data1;
        s.dot_g2 := small_ram_data2;

        --s.state := write1;

      --when write1 =>
        ram_address <= r.index;
        ram_data <= r.dot_r & r.dot_g1 & small_ram_data1;
        ram_en <= '1';

        s.state := write2;

      when write2 =>
        ram_address <= r.index + 1;
        ram_data <= r.dot_r & r.dot_g1 & r.dot_b;
        ram_en <= '1';

        s.state := write3;

      when write3 =>
        ram_address <= r.index + FRAME_WIDTH;
        ram_data <= r.dot_r & r.dot_g2 & r.dot_b;
        ram_en <= '1';

        s.state := write4;

      when write4 =>
        ram_address <= r.index + FRAME_WIDTH + 1;
        ram_data <= r.dot_r & r.dot_g2 & r.dot_b;
        ram_en <= '1';

        s.state := read1;

        s.col_cnt := r.col_cnt + 2;
        if r.col_cnt = FRAME_WIDTH - 2 then
          s.state := wait_conv;
        else
          s.index := r.index + 2;

          small_ram_address1 <= s.index;
          small_ram_address2 <= s.index+1;

          s.addr1 := s.index + FRAME_WIDTH;
          s.addr2 := s.index + FRAME_WIDTH + 1;
        end if;

    end case;

    r_next <= s;

  end process;


  reg : process(sys_clk)
  begin
    if rising_edge(sys_clk) then 
      if sys_res = RST_ACT then
        --Signale initialisieren
      else
        r <= r_next;
      end if;
    end if;
  end process;

end behaviour;
