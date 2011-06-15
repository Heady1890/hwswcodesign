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

package pkg_camd5m_init is

-------------------------------------------------------------------------------
--                             CONSTANT
-------------------------------------------------------------------------------  

constant IRGENDWAS : natural := 3;
 
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--                             COMPONENT
-------------------------------------------------------------------------------  
-------------------------------------------------------------------------------


  
  component ext_camd5m_init
    port (
    
    --CAM_RESET   : out std_logic;
    CAM_SDATA	: inout std_logic;
    CAM_SCLK	: out std_logic;
    
    LED_RED	: out std_logic_vector(17 downto 0);
    INIT_DONE	: out std_logic;
    
    sys_res : in  std_logic;
    sys_clk : in  std_logic);
  end component;
  
  type  states is (idle,idle_second_round,start_bit,write_slave_adr,wait_to_ack_adr,wait_to_ack_reg,wait_to_ack_value1,wait_to_ack_value2,write_reg,write_value1,write_value2,error_state,stop_bit,end_state);
  
  constant SLAVEADRESS : std_logic_vector(7 downto 0) := ("10111010");
  --debugging Pixel Clock inverting
  constant REGISTER03 : std_logic_vector(7 downto 0) := ("00001010");
  --constant REGISTER03 : std_logic_vector(7 downto 0) := ("00000011");
  constant REGISTER04 : std_logic_vector(7 downto 0) := ("00000100");
  constant REGISTER22 : std_logic_vector(7 downto 0) := ("00010110");
  constant REGISTER23 : std_logic_vector(7 downto 0) := ("00010111");
  
  --debugging Pixel Clock inverting
  constant REGISTER03_WERT : std_logic_vector(15 downto 0) := ("1000000000000000");  
  --constant REGISTER03_WERT : std_logic_vector(15 downto 0) := ("0000011101111111");
  constant REGISTER04_WERT : std_logic_vector(15 downto 0) := ("0000100111111111");
  constant REGISTER22_WERT : std_logic_vector(15 downto 0) := ("0000000000000011");
  constant REGISTER23_WERT : std_logic_vector(15 downto 0) := ("0000000000000011");
  
  --constant REGISTER22_WERT : std_logic_vector(15 downto 0) := ("XXXXXXXXXX00X011");
  --constant REGISTER23_WERT : std_logic_vector(15 downto 0) := ("XXXXXXXXXX00X011");
  constant SRTH			:integer range 0 to 300 := 10;
  constant STPH			:integer range 0 to 300 := 10;
  constant SDH			:integer range 0 to 300 := 75;
  constant SHAW			:integer range 0 to 300 := 75;
  constant FULL_CLOCK		:integer range 0 to 300 := 0;
  constant HALF_CLOCK		:integer range 0 to 300 := 75;
  
  type signals is record
	 second_round:boolean;
	 second_register:boolean;
  	 ack_wait_adr : boolean;
  	 ack_wait_reg : boolean;
  	 ack_wait_value1 : boolean;
  	 ack_wait_value2 : boolean;
  	 ack_receive : boolean;
  	 --counter : integer range 0 to 151 := 0;
  	 bit_counter :integer range -16 to 16;
  	 --cam_sclk : std_logic :='0';
  	 led_red_sig : std_logic_vector(17 downto 0);
  	 state     : states;
  	 cam_sdata : std_logic;
  end record;
  
  
  
end pkg_camd5m_init;



package body pkg_camd5m_init is


end pkg_camd5m_init;




-------------------------------------------------------------------------------
--                             END PACKAGE
------------------------------------------------------------------------------- 
