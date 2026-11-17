library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity z_reg is
    PORT(
        clk, reset_n, filter_en : in std_logic;
        d_in : in std_logic_vector (15 downto 0);
        d_out : out std_logic_vector(15 downto 0)
    );
end z_reg;

architecture rtl of z_reg is
begin
    process(clk, reset_n)
    begin
        if(reset_n = '0') then
            d_out <= (others => '0');
        elsif (rising_edge(clk)) then
            if(filter_en = '1') then
                d_out <= d_in;
            end if;
        end if;
    end process;
end architecture;