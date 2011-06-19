library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

--use work.spear_pkg.all;
use work.pkg_kamera.all;

--use std.textio.all;

entity top_tb_kamera is
end top_tb_kamera;

architecture behaviour of top_tb_kamera is

  constant  cc    : TIME := 20 ns;
  constant  cc2   : TIME := 40 ns;	--PIXCLK bei Prescaler 4

  signal init_done_sig    : std_logic := '0';

  signal tp_address1_sig	: std_logic_vector(11 downto 0);
  signal tp_address2_sig	: std_logic_vector(11 downto 0);
  signal tp_address3_sig	: std_logic_vector(11 downto 0);
  signal tp_data_in1_sig	: std_logic_vector( 7 downto 0);
  signal tp_wr1_sig		: std_logic;
  signal tp_data_out2_sig	: std_logic_vector( 7 downto 0);
  signal tp_data_out3_sig	: std_logic_vector( 7 downto 0); 

  signal dp_address1_sig	: std_logic_vector(11 downto 0);
  signal dp_address2_sig	: std_logic_vector(11 downto 0);
  signal dp_wr1_sig		: std_logic;
  signal dp_data_in1_sig	: std_logic_vector(23 downto 0);
  signal dp_data_out1_sig	: std_logic_vector(23 downto 0);
  signal dp_data_out2_sig	: std_logic_vector(23 downto 0);  

  signal start_conv_sig		: std_logic;
  
    -- Camera
  signal CAM_PIXCLK	:  std_logic;
  --signal CAM_XCLKIN	:  std_logic;
  signal CAM_LVAL	:  std_logic;
  --signal CAM_RESET   	:  std_logic;
  signal CAM_SDATA	:  std_logic;
  signal CAM_TRIGGER	:  std_logic;
  --signal CAM_SCLK	:  std_logic;
  signal CAM_STROBE	:  std_logic;
  signal CAM_FVAL	:  std_logic;
  signal CAM_D		:  std_logic_vector(11 downto 0);
    
  --signal LED_RED	:  std_logic_vector(17 downto 0);
  --signal LED_GREEN	:  std_logic_vector(8 downto 0);
  signal sys_res 	: std_logic; 	 
  signal sys_clk 	: std_logic;

  component read_kamera
  port (
    CAM_PIXCLK	: in  std_logic;
    CAM_LVAL	: in  std_logic;
    CAM_TRIGGER	: out std_logic;
    CAM_STROBE	: in  std_logic;
    CAM_FVAL	: in  std_logic;
    CAM_D	: in  std_logic_vector(11 downto 0);
    
    INIT_DONE	: in  std_logic;
    start_conv	: out std_logic;
    
    sys_res : in  std_logic;
    --sys_clk : in  std_logic;

    ram_address	: out std_logic_vector(11 downto 0);
    ram_data	: out std_logic_vector(7 downto 0);
    ram_en	: out std_logic
  );
  end component;

  component tp_ram
    generic
    (
      ADDR_WIDTH : integer range 1 to integer'high;
      DATA_WIDTH : integer range 1 to integer'high
    );
    port
    (
      clk                           	: in std_logic;
      address1, address2, address3	: in std_logic_vector(ADDR_WIDTH - 1 downto 0);
      data_in1                      	: in std_logic_vector(DATA_WIDTH - 1 downto 0);
      wr1                           	: in std_logic;
      data_out2, data_out3          	: out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
  end component;

  component dp_ram
    generic
    (
      ADDR_WIDTH : integer range 1 to integer'high;
      DATA_WIDTH : integer range 1 to integer'high
    );
    port
    (
      clk       : in std_logic;
      address1  : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
      data_out1 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
      wr1       : in std_logic;
      data_in1  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
      address2  : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
      data_out2 : out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
  end component;

  component converter
    port (
      start_conv	: in  std_logic;
    
      sys_res 		: in  std_logic;
      sys_clk 		: in  std_logic;

      small_ram_address1	: out std_logic_vector(11 downto 0);
      small_ram_data1		: in  std_logic_vector(7 downto 0);
      small_ram_address2	: out std_logic_vector(11 downto 0);
      small_ram_data2		: in  std_logic_vector(7 downto 0);

      ram_address	: out std_logic_vector(11 downto 0);
      ram_data		: out std_logic_vector(23 downto 0);
      ram_en		: out std_logic
    );  
  end component converter;

begin

  read_kamera1 : entity work.read_kamera
  port map (
    CAM_PIXCLK	=> CAM_PIXCLK,
    CAM_LVAL	=> CAM_LVAL,
    CAM_TRIGGER	=> CAM_TRIGGER,
    CAM_STROBE	=> CAM_STROBE,
    CAM_FVAL	=> CAM_FVAL,
    CAM_D	=> CAM_D,
    INIT_DONE	=> init_done_sig,
    start_conv	=> start_conv_sig,
    sys_res	=> sys_res,
    ram_address	=> tp_address1_sig,
    ram_data	=> tp_data_in1_sig,
    ram_en	=> tp_wr1_sig
  ); 

  tp_ram1 : entity work.tp_ram
  generic map
  (
     ADDR_WIDTH => 12,
     DATA_WIDTH => 8
  )
  port map
  (
     clk	=> sys_clk,                           	
     address1	=> tp_address1_sig,
     address2	=> tp_address2_sig,
     address3	=> tp_address3_sig,
     data_in1   => tp_data_in1_sig,              	
     wr1        => tp_wr1_sig,             	
     data_out2	=> tp_data_out2_sig,
     data_out3  => tp_data_out3_sig       	
  );

  dp_ram1 : entity work.dp_ram
  generic map
  (
     ADDR_WIDTH => 12,
     DATA_WIDTH => 24
  )
  port map
  (
     clk 	=> sys_clk,
     address1 	=> dp_address1_sig,
     data_out1 	=> dp_data_out1_sig,
     wr1 	=> dp_wr1_sig,
     data_in1 	=> dp_data_in1_sig,
     address2 	=> dp_address2_sig,
     data_out2 	=> dp_data_out2_sig
  );

  conv1 : entity work.converter
  port map (
    start_conv		=> start_conv_sig,
    sys_res		=> sys_res,
    sys_clk		=> sys_clk,
    small_ram_address1	=> tp_address2_sig,
    small_ram_data1	=> tp_data_out2_sig,
    small_ram_address2	=> tp_address3_sig,
    small_ram_data2	=> tp_data_out3_sig,
    ram_address		=> dp_address1_sig,
    ram_data		=> dp_data_in1_sig,
    ram_en		=> dp_wr1_sig
  );  

  clkgen : process
  begin
    sys_clk <= '1';
    wait for cc/2;
    sys_clk <= '0'; 
    wait for cc/2;
  end process clkgen;

  clkgen2 : process
  begin
    CAM_PIXCLK <= '1';
    wait for cc2/2;
    CAM_PIXCLK <= '0'; 
    wait for cc2/2;
  end process clkgen2;
  
  
  process
  variable counter	: std_logic_vector(7 downto 0) := x"01";
  begin
    CAM_LVAL <= '0';
    CAM_FVAL <= '0';
    CAM_D <= x"000";
    
    sys_res <= '0';
    wait for 50 ns;
    sys_res <= '1';
    wait for 50 ns; 

    init_done_sig <= '1';
    wait for 50 ns;

    CAM_FVAL <= '1';
    wait for 100 ns;

    for i in 0 to 479 loop
      CAM_LVAL <= '1';
      for j in 0 to 639 loop
        CAM_D <= counter & x"0";
        counter := counter + 1;
        wait for cc2;
      end loop;
      CAM_LVAL <= '0';
      wait for 100 ns;
    end loop;
    
  end process;

  

end behaviour; 

