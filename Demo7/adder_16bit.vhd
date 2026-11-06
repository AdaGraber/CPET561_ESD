library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity adder_16bit is
    PORT(
        CLOCK_50 : in std_logic;
        a,b : in std_logic_vector(15 downto 0);
        result : out std_logic_vector(15 downto 0)
    );
end adder_16bit;

architecture rtl of adder_16bit is

begin
    process(CLOCK_50)
    begin
        result <= a + b;
    end process;
    

end architecture;