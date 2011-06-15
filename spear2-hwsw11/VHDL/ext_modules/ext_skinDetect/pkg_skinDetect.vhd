



-------------------------------------------------------------------------------
-- LIBRARIES
-------------------------------------------------------------------------------

LIBRARY IEEE;
use IEEE.std_logic_1164.all;

use work.spear_pkg.all;

-------------------------------------------------------------------------------
-- PACKAGE
-------------------------------------------------------------------------------

package pkg_skinDetect is

-------------------------------------------------------------------------------
--CONSTANT
-------------------------------------------------------------------------------  

constant Y_LOW   : signed(63 downto 0) := to_signed( 100000000,64);
constant CB_LOW  : signed(63 downto 0) := to_signed(-150000000,64);
constant CR_LOW  : signed(63 downto 0) := to_signed(  50000000,64);

constant Y_HIGH  : signed(63 downto 0) := to_signed(1000000000,64);
constant CB_HIGH : signed(63 downto 0) := to_signed(  50000000,64);
constant CR_HIGH : signed(63 downto 0) := to_signed( 200000000,64);

-------------------------------------------------------------------------------
--COMPONENT
-------------------------------------------------------------------------------

component ext_skinDetect
  port (
    clk        : IN  std_logic;
    extsel     : in   std_ulogic;
    exti       : in  module_in_type;
    exto       : out module_out_type);
end component;

end pkg_skinDetect;
