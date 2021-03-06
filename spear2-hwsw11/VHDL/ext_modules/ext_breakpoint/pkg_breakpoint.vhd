-------------------------------------------------------------------------------
-- Title      : Package Extension-Module
-- Project    : SPEAR - Scalable Processor for Embedded Applications in
--              Realtime Environment
-------------------------------------------------------------------------------
-- File       : pkg_display.vhd
-- Author     : Dipl. Ing. Martin Delvai
-- Company    : TU Wien - Institut fr Technische Informatik
-- Created    : 2002-02-11
-- Last update: 2011-03-17
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

use work.pkg_basic.all;
use work.spear_conf.all;
use work.pkg_spear.all;



-------------------------------------------------------------------------------
-- PACKAGE
-------------------------------------------------------------------------------

package pkg_breakpoint is


-------------------------------------------------------------------------------
--                             CONSTANT
-------------------------------------------------------------------------------  



 
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--                             COMPONENT
-------------------------------------------------------------------------------  
-------------------------------------------------------------------------------

  component ext_breakpoint
    generic (
      CONF : spear_conf_type);
    port (
      clk              : IN  std_logic;
      extsel           : in  std_ulogic;
      exti             : in  module_in_type;
      exto             : out module_out_type;
      -- Modul specific interface (= Pins)
      debugo_wdata     : in  INSTR;
      debugo_waddr     : in  std_logic_vector(CONF.instr_ram_size-1 downto 0);
      debugo_wen       : in  std_ulogic;
      debugo_raddr     : in  std_logic_vector(CONF.instr_ram_size-1 downto 0);
      debugo_rdata     : in  INSTR;
      debugo_read_en   : in  std_ulogic;    
      debugo_hi_addr   : in  std_logic_vector(CONF.word_size-1 downto 15);   
      debugi_rdata     : out INSTR;   
      watchpoint_act   : in std_ulogic);
    end component;
  

end pkg_breakpoint;
-------------------------------------------------------------------------------
--                             END PACKAGE
------------------------------------------------------------------------------- 
