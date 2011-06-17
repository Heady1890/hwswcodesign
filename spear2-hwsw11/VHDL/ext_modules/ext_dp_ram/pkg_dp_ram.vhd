library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library techmap;
use techmap.gencomp.all;

package pkg_dp_ram is

  component dp_ram
   generic
  (
     ADDR_WIDTH : natural := 19;
     DATA_WIDTH : natural := 32
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

end package pkg_dp_ram;