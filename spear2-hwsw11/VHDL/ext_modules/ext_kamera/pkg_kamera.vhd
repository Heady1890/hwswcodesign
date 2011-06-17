

library ieee;
use ieee.std_logic_1164.all;

use work.spear_pkg.all;

package pkg_kamera is
  


  component dp_ram
    generic
    (
      ADDR_WIDTH : integer range 1 to integer‘high;
      DATA_WIDTH : integer range 1 to integer‘high
    );
    port
    (
      clk       : in std_logic;
      address1  : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
      data_out1 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
      wr1       : in std_logic;
      data_in1  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
      address2  : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
      data_out2 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    );
  end component dp_ram;


  component tp_ram
    generic
    (
      ADDR_WIDTH : integer range 1 to integer‘high;
      DATA_WIDTH : integer range 1 to integer‘high
    );
    port
    (
      clk                           	: in std_logic;
      address1, address2, address3	: in std_logic_vector(ADDR_WIDTH - 1 downto 0);
      data_in1                      	: in std_logic_vector(DATA_WIDTH - 1 downto 0);
      wr1                           	: in std_logic;
      data_out2, data_out3          	: out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
  end component tp_ram;


  component read_kamera
    port (
      CAM_PIXCLK	: in  std_logic;
      CAM_LVAL		: in  std_logic;
      CAM_TRIGGER	: out std_logic;
      CAM_STROBE	: in  std_logic;
      CAM_FVAL		: in  std_logic;
      CAM_D		: in  std_logic_vector(11 downto 0);
      INIT_DONE		: in  std_logic;
      sys_res 		: in  std_logic;
      ram_address	: out std_logic_vector(18 downto 0);
      ram_data		: out std_logic_vector(7 downto 0);
      ram_en		: out std_logic
    );  
  end component


  component converter
    port (
      start_conv	: in  std_logic;
    
      sys_res 		: in  std_logic;
      sys_clk 		: in  std_logic;

      small_ram_address1	: out std_logic_vector(18 downto 0);
      small_ram_data1		: out std_logic_vector(7 downto 0);
      small_ram_address2	: out std_logic_vector(18 downto 0);
      small_ram_data2		: out std_logic_vector(7 downto 0);

      ram_address	: out std_logic_vector(18 downto 0);
      ram_data		: out std_logic_vector(23 downto 0);
      ram_en		: out std_logic
    );  
  end component converter

end pkg_kamera;
