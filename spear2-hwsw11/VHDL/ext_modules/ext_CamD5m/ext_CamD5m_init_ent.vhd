-------------------------------------------------------------------------------
-- Title      : D5m Camera
-- Project    : SPEAR - Scalable Processor for Embedded Applications in
--              Realtime Environment
-------------------------------------------------------------------------------
-- File       : ext_CamD5m.vhd
-- Author     : BSc Folie Simon
-- Company    : TU Wien - Institut fr technische Informatik
-- Created    : 2011-29-05
-- Last update: 2011-29-05
-- Platform   : Altera 
-------------------------------------------------------------------------------
-- Description:
--
-------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- LIBRARY
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE work.spear_pkg.all;

use work.pkg_camd5m_init.all;

----------------------------------------------------------------------------------
-- ENTITY
----------------------------------------------------------------------------------

entity ext_camd5m_init is
  port (
   
    --CAM_RESET   : out std_logic;
    CAM_SDATA	: inout std_logic;
    CAM_SCLK	: out std_logic;
    
    LED_RED	: out std_logic_vector(17 downto 0);
    INIT_DONE	: out std_logic;
    
    sys_res : in  std_logic;
    sys_clk : in  std_logic);
    
end entity ext_camd5m_init;

----------------------------------------------------------------------------------
-- END ENTITY
----------------------------------------------------------------------------------


