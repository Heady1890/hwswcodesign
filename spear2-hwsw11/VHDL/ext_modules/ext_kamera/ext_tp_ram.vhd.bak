library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tp_ram_small is
  generic
  (
     ADDR_WIDTH : integer range 1 to integer'high;
     DATA_WIDTH : integer range 1 to integer'high
  );
  port
  (
     clk                           	: in std_logic;
     address1, address2, address3	: in std_logic_vector(ADDR_WIDTH - 1 downto 0);
     data_in1                      	: in std_logic_vector(DATA_WIDTH - 1 downto 0);
     wr1                           	: in std_logic;
     data_out2, data_out3          	: out std_logic_vector(DATA_WIDTH - 1 downto 0)
);
end entity tp_ram_small;


architecture beh of tp_ram_small is
  subtype RAM_ENTRY_TYPE is std_logic_vector(DATA_WIDTH - 1 downto 0);
  type RAM_TYPE is array (0 to (2 ** ADDR_WIDTH) - 1) of RAM_ENTRY_TYPE;
  signal ram : RAM_TYPE := (others => x"00");
begin
  process(clk)
  begin
    if rising_edge(clk) then
      data_out2 <= ram(to_integer(unsigned(address2)));
      data_out3 <= ram(to_integer(unsigned(address3)));
      if wr1 = '1' then
        ram(to_integer(unsigned(address1))) <= data_in1;
      end if;
    end if;
  end process;
end architecture beh;

