library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity lab2 is
port(
CLOCK_50 : in std_logic;
reset_n : in std_logic;
SW : in std_logic_vector(7 downto 0);
hex : out std_logic_vector (6 downto 0);
pb : in std_logic_vector (3 downto 0)
);
end entity lab2;

architecture arch of lab2 is
	component nios_system is
		port (
			clk_clk            : in  std_logic                    := 'X';             -- clk
			reset_reset_n      : in  std_logic                    := 'X';             -- reset_n
			hex_export         : out std_logic_vector(6 downto 0);                    -- export
			pushbuttons_export : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			switches_export    : in  std_logic_vector(7 downto 0) := (others => 'X')  -- export
		);
	end component nios_system;
	
begin
	u0 : component nios_system
		port map (
			clk_clk            => CLOCK_50,            --         clk.clk
			reset_reset_n      => reset_n,      --       reset.reset_n
			hex_export         => hex,         --         hex.export
			pushbuttons_export => pb, -- pushbuttons.export
			switches_export    => sw     --    switches.export
		);
end arch;