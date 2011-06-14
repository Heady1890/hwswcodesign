-------------------------------------------------------------------------------
-- Title      : Package Extension-Module
-- Project    : SPEAR - Scalable Processor for Embedded Applications in
--              Realtime Environment
-------------------------------------------------------------------------------
-- File       : pkg_display.vhd
-- Author     : Dipl. Ing. Martin Delvai
-- Company    : TU Wien - Institut fr Technische Informatik
-- Created    : 2002-02-11
-- Last update: 2011-03-20
-- Platform   : SUN Solaris
-------------------------------------------------------------------------------
-- Description:
-- Deklarationen und Konstanten r die 7 Segment Anzeige
-------------------------------------------------------------------------------
-- Copyright (c) 2002 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2002-02-11  1.0      delvai	Created
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- LIBRARIES
-------------------------------------------------------------------------------

LIBRARY IEEE;
use IEEE.std_logic_1164.all;

use work.spear_pkg.all;


-------------------------------------------------------------------------------
-- PACKAGE
-------------------------------------------------------------------------------

package pkg_camd5m is

-------------------------------------------------------------------------------
--                             CONSTANT
-------------------------------------------------------------------------------  

constant IRGENDWAS : natural := 3;
 
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--                             COMPONENT
-------------------------------------------------------------------------------  
-------------------------------------------------------------------------------


  
  component ext_camd5m
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
  end component;

end pkg_camd5m;



package body pkg_camd5m is


end pkg_camd5m;




-------------------------------------------------------------------------------
--                             END PACKAGE
------------------------------------------------------------------------------- 
