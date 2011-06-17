library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dp_ram is
  generic
  (
     --ADDR_WIDTH : integer range 1 to integer‘high;
     --DATA_WIDTH : integer range 1 to integer‘high

     --Adressiert einen 1,048kB großen RAM mit 8Bit Blöcken
     ADDR_WIDTH : natural := 19;
     DATA_WIDTH : natural := 24
  );
  port
  (
     clk       : in std_logic;
     address1  : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
     data_out1 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
     wr1       : in std_logic;
     data_in1  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
     address2  : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
     data_out2 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
);
end entity dp_ram;


architecture beh of dp_ram is
  subtype RAM_ENTRY_TYPE is std_logic_vector(DATA_WIDTH - 1 downto 0);
  type RAM_TYPE is array (0 to (2 ** ADDR_WIDTH) – 1) of RAM_ENTRY_TYPE;
  signal ram : RAM_TYPE := (others => x”00”);
begin
  process(clk)
  begin
    if rising_edge(clk) then
      data_out1 <= ram(to_integer(unsigned(address1)));
      data_out2 <= ram(to_integer(unsigned(address2)));
      if wr1 = ‘1’ then
        ram(to_integer(unsigned(address1))) <= data_in1;
      end if;
    end if;
  end process;
end architecture beh;
