library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spear_pkg.all;
use work.pkg_dis7seg.all;
use work.pkg_rwsdram.all;

use std.textio.all;

library grlib;
use grlib.amba.all;

library techmap;
use techmap.gencomp.all;

library gaisler;
use gaisler.misc.all;
use gaisler.memctrl.all;

entity top_tb is
end top_tb;

architecture behaviour of top_tb is

  constant  cc    : TIME := 20 ns;
  constant  bittime    : integer := 434; --8.681 us / 20 ns ;

  type parity_type is (none, even, odd);

  signal clk      : std_ulogic;
  signal rst      : std_ulogic;
  signal D_RxD    : std_logic;
  signal D_TxD    : std_logic;
  signal digits   : digit_vector_t(7 downto 0);
  -- SDRAM Interface (AMBA)
  signal sdcke    : std_logic;
  signal sdcsn    : std_logic;
  signal sdwen    : std_logic;
  signal sdrasn   : std_logic;
  signal sdcasn   : std_logic;
  signal sddqm    : std_logic_vector(3 downto 0);
  signal sdclk    : std_logic;
  signal sa       : std_logic_vector(14 downto 0);
  signal sd       : std_logic_vector(31 downto 0);
  -- LCD (AMBA)
  signal ltm_hd      : std_logic;
  signal ltm_vd      : std_logic;
  signal ltm_r       : std_logic_vector(7 downto 0);
  signal ltm_g       : std_logic_vector(7 downto 0);
  signal ltm_b       : std_logic_vector(7 downto 0);
  signal ltm_nclk    : std_logic;
  signal ltm_den     : std_logic;
  signal ltm_grest   : std_logic;

  -- Write SDRAM extension segsel
  signal rwsdramsel 	: std_ulogic;
  signal rwsdramsegexto : module_out_type;
  signal exti      	: module_in_type;
  signal grlib_ahbmi    : ahb_mst_in_type;
  signal rwsdram_ahbmo	: ahb_mst_out_type;

  
  file appFile : text  open read_mode is "test.c";
  --file appFile : text  open read_mode is "app.srec";

  component top
    port (
      db_clk   : in    std_ulogic;
      rst      : in    std_ulogic;
      D_RxD    : in    std_logic;
      D_TxD    : out   std_logic;
      -- 7Segment Anzeige
      digits      : out digit_vector_t(7 downto 0);
      -- SDRAM Controller Interface (AMBA)
      sdcke       : out std_logic;
      sdcsn       : out std_logic;
      sdwen       : out std_logic;
      sdrasn      : out std_logic;
      sdcasn      : out std_logic;
      sddqm       : out std_logic_vector(3 downto 0);
      sdclk       : out std_logic;
      sa          : out std_logic_vector(14 downto 0);
      sd          : inout std_logic_vector(31 downto 0);
      -- LCD (AMBA)
      ltm_hd      : out std_logic;
      ltm_vd      : out std_logic;
      ltm_r       : out std_logic_vector(7 downto 0);
      ltm_g       : out std_logic_vector(7 downto 0);
      ltm_b       : out std_logic_vector(7 downto 0);
      ltm_nclk    : out std_logic;
      ltm_den     : out std_logic;
      ltm_grest   : out std_logic
      );    
  end component;
  
  
begin

  top_1: top
    port map (
      db_clk         => clk,
      rst            => rst,
      D_RxD          => D_RxD,
      D_TxD          => D_TxD,
      digits         => digits,
      sdcke          => sdcke,
      sdcsn          => sdcsn,
      sdwen          => sdwen,
      sdrasn         => sdrasn,
      sdcasn         => sdcasn,
      sddqm          => sddqm,
      sdclk          => sdclk,
      sa             => sa,
      sd             => sd,
      ltm_hd         => ltm_hd,
      ltm_vd         => ltm_vd,
      ltm_r          => ltm_r,
      ltm_g          => ltm_g,
      ltm_b          => ltm_b,
      ltm_nclk       => ltm_nclk,
      ltm_den        => ltm_den,
      ltm_grest      => ltm_grest
      );

  rwsdram0 : rwsdram
    port map
    (
      rst => rst,
      clk => clk,
      extsel => rwsdramsel,
      exti => exti,
      exto => rwsdramsegexto,
      ahbi => grlib_ahbmi,
      ahbo => rwsdram_ahbmo
    );

  clkgen : process
  begin
    clk <= '1';
    wait for cc/2;
    clk <= '0'; 
    wait for cc/2;
  end process clkgen;

  process begin
    wait for 50 ns;
    rwsdramsel <= '1';
  end process;

end behaviour; 
