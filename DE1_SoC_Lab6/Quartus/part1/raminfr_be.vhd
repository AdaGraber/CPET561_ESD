library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity raminfr_be is
  port (
    clk               : in std_logic;
    reset_n           : in std_logic;
    writebyteenable_n : in std_logic_vector(3 downto 0);
    address           : in std_logic_vector(11 downto 0);
    writedata         : in std_logic_vector(31 downto 0);
    --
    readdata : out std_logic_vector(31 downto 0)
  );
end entity raminfr_be;

architecture rtl of raminfr_be is
  type ram_type is array (4095 downto 0) of std_logic_vector (7 downto 0);
  signal RAM0, RAM1, RAM2, RAM3 : ram_type;
  signal read_addr              : std_logic_vector(11 downto 0);
begin
  RamBlock : process (clk)
  begin
    if (rising_edge(CLK)) then
      if (reset_n = '0') then
        read_addr <= (others => '0');
      else
        if (writebyteenable_n(0) = '0') then
          RAM0(conv_integer(address)) <= writedata(7 downto 0);
        end if;
        if (writebyteenable_n(1) = '0') then
          RAM1(conv_integer(address)) <= writedata(15 downto 8);
        end if;
        if (writebyteenable_n(2) = '0') then
          RAM2(conv_integer(address)) <= writedata(23 downto 16);
        end if;
        if (writebyteenable_n(3) = '0') then
          RAM3(conv_integer(address)) <= writedata(31 downto 24);
        end if;
      end if;
      read_addr <= address;
    end if;
  end process RamBlock;
  readdata <= RAM3(conv_integer(read_addr)) & RAM2(conv_integer(read_addr)) & RAM1(conv_integer(read_addr)) & RAM0(conv_integer(read_addr));
end architecture rtl;