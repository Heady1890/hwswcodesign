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

use work.pkg_camd5m_read.all;

----------------------------------------------------------------------------------
-- ENTITY
----------------------------------------------------------------------------------

entity ext_camd5m_read is
  port (
    CAM_PIXCLK	: in  std_logic;
    CAM_LVAL	: in  std_logic;
    CAM_TRIGGER	: out std_logic;
    CAM_STROBE	: in  std_logic;
    CAM_FVAL	: in  std_logic;
    CAM_D	: in std_logic_vector(11 downto 0);
    
    
    LED_GREEN	: out std_logic_vector(8 downto 0);
    INIT_DONE	: in std_logic;
    
    sys_res : in  std_logic;
    sys_clk : in  std_logic);
    
end entity ext_camd5m_read;

----------------------------------------------------------------------------------
-- END ENTITY
----------------------------------------------------------------------------------


