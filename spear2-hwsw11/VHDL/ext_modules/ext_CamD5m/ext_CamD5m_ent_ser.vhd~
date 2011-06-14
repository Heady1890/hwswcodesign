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

use work.pkg_camd5m.all;

----------------------------------------------------------------------------------
-- ENTITY
----------------------------------------------------------------------------------

entity ext_camd5m is
  port (
    CAM_PIXCLK	: in  std_logic;
    CAM_XCLKIN	: out std_logic;
    CAM_LVAL	: in  std_logic;
    CAM_RESET   : out std_logic;
    CAM_SDATA	: inout std_logic;
    CAM_TRIGGER	: out std_logic;
    CAM_SCLK	: out std_logic;
    CAM_STROBE	: in  std_logic;
    CAM_FVAL	: in  std_logic;
    CAM_D	: in std_logic_vector(11 downto 0));
    
end entity ext_camd5m;

----------------------------------------------------------------------------------
-- END ENTITY
----------------------------------------------------------------------------------


