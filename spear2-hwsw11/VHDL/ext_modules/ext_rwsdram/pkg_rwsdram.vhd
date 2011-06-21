library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library techmap;
use techmap.gencomp.all;
library gaisler;
use gaisler.misc.all;
use work.spear_pkg.all;

package pkg_rwsdram is

  component rwsdram
    generic(
      hindex 	: integer := 0;
      hirq	: integer := 0
    );
    port (
      rst       	: in std_logic;
      clk       	: in std_logic;
      extsel     	: in std_ulogic;
      exti       	: in  module_in_type;
      exto       	: out module_out_type;
      ahbi      	: in  ahb_mst_in_type;
      ahbo      	: out ahb_mst_out_type;
      addr_ram_out	: out std_logic_vector(11 downto 0);
      data_ram_in	: in std_logic_vector(23 downto 0)
--       LED_RED		: out std_logic_vector(17 downto 0)
      );
  end component;

end package pkg_rwsdram;