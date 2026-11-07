library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity adder_16bit is
    PORT(
        CLOCK_50 : in std_logic;
        in_a,in_b : in std_logic_vector(15 downto 0);
        result : out std_logic_vector(15 downto 0)
    );
end adder_16bit;

architecture rtl of adder_16bit is
	signal a, b : std_logic_vector (15 downto 0);
begin
    process(CLOCK_50)
    begin
	 if(rising_edge(CLOCK_50)) then
		  a <= in_a;
		  b <= in_b;
        result <= a + b;
		  end if;
    end process;
    

end architecture;