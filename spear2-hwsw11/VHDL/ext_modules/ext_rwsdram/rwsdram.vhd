library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library techmap;
use techmap.gencomp.all;
use work.spear_pkg.all;
library gaisler;
use gaisler.misc.all;

entity rwsdram is
  generic(
    hindex 	: integer := 1;
    hirq	: integer := 1
  );
  port (
    rst       	: in std_logic;
    clk       	: in std_logic;
    extsel      : in std_ulogic;
    exti        : in  module_in_type;
    exto        : out module_out_type;
    ahbi      	: in  ahb_mst_in_type;
    ahbo      	: out ahb_mst_out_type;
    LED_RED	: out std_logic_vector(17 downto 0);
    LED_GREEN	: out std_logic_vector(8 downto 0)
    );
end rwsdram;

architecture rtl of rwsdram is

  type state_type is (INIT_STATE, READY_STATE, ADR_ASS_STATE, DATA_OUT_STATE);

  --constant declaration
  --constant startaddress		: std_logic_vector(31 downto 0) := x"E0000000";

  --signal declaration
  signal dmai           	: ahb_dma_in_type;
  signal dmao           	: ahb_dma_out_type;
  signal write_en       	: std_logic;
  signal write_en_next		: std_logic;
  signal write_data		: std_logic_vector(31 downto 0);
  signal write_data_next	: std_logic_vector(31 downto 0);
  signal write_en_byte		: std_logic_vector(7 downto 0);
  signal write_address		: std_logic_vector(31 downto 0);
  signal write_address_next	: std_logic_vector(31 downto 0);
  signal write_state		: state_type;
  signal write_state_next	: state_type;
  signal red_led_state		 : std_logic_vector(17 downto 0);
  signal red_led_state_next	: std_logic_vector(17 downto 0);

begin

  --including amba master
  ahb_master : ahbmst generic map (hindex, hirq, VENDOR_RWSDRAM,
	GAISLER_RWSDRAM, 0, 3, 1)
  port map (rst, clk, dmai, dmao, ahbi, ahbo);

  proc_ext : process (exti, extsel, write_en, write_data)
  begin
    write_en_next <= write_en;
    write_data_next <= write_data;
    if ((extsel = '1') and (exti.write_en = '1')) then
      write_en_next <= '1';
      if exti.addr(4 downto 2) = "000" then
         if ((exti.byte_en(3) = '1')) then
            write_en_byte <= exti.data(31 downto 24);
         end if;
      end if;
      if exti.addr(4 downto 2) = "001" then
        write_data_next <= exti.data;
      end if;
    end if;
  end process;

  --synchron part
  proc_syn : process(clk, rst)
  begin
    if rising_edge(clk) then
      --synchron reset of signals
      if rst = '0' then
	write_state <= INIT_STATE;
	write_address <= x"E0000000";
	red_led_state <= (others => '0');
	red_led_state_next <= (others => '0');
	write_data <= x"00000000";
	--not here!!!!
        --dmai.wdata  <= (others => '0');
        --dmai.burst  <= '0';
        --dmai.irq    <= '0';
	--dmai.busy   <= '0';
        --dmai.address  <= write_address;
        --dmai.size   <= "00";
        --dmai.write  <= '0';
        --dmai.start    <= '0';
      --update for the signals on rising edge
      else
	write_data <= write_data_next;
	write_en <= write_en_next;
	write_state <= write_state_next;
	write_address <= write_address_next;
	red_led_state <= red_led_state_next;
	LED_RED <= red_led_state;
      end if;
    end if;
  end process;

  proc_write_next : process (write_state, write_state_next, write_en, write_address, write_data, dmao)
  begin
    write_state_next <= write_state;
    case write_state is
      when INIT_STATE =>
	if write_en = '1' then
	  write_state_next <= READY_STATE;
	end if;
      when READY_STATE =>
	if dmao.ready = '1' then
	  write_state_next <= ADR_ASS_STATE;
	end if;
      when ADR_ASS_STATE =>
	if dmao.ready = '1' then
	  write_state_next <= DATA_OUT_STATE;
	end if;
      when DATA_OUT_STATE =>
	--if (write_address <= X"E0177000") then
	if (write_address <= X"E000F000") then
	  if dmao.ready = '1' then  -- and not finished else init state
	    write_state_next <= ADR_ASS_STATE;
	  end if;
	else
	  write_state_next <= INIT_STATE;
	end if;
    end case;

  end process;

  proc_control : process (write_state, write_address)
  begin
    write_address_next <= write_address;
    
    case write_state is
      when INIT_STATE =>
	dmai.start <= '0';
	dmai.write <= '0';
	dmai.burst <= '0';
	dmai.size <= "00";
	write_address_next <= x"E0000000";
      when READY_STATE =>
	dmai.start <= '1';
      when ADR_ASS_STATE =>
	dmai.address <= write_address; --my adress
	dmai.write <= '1';
	write_address_next <= write_address + 4;
      when DATA_OUT_STATE =>
	dmai.wdata <= write_data; --my data
	dmai.write <= '1';
      end case;

  end process;

end rtl;