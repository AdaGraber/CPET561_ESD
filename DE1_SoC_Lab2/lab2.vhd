library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity lab2 is
  port (
    CLOCK_50 : in std_logic;
    KEY      : in std_logic_vector(3 downto 0);
    SW       : in std_logic_vector(7 downto 0);
    HEX0     : out std_logic_vector(6 downto 0));
end entity lab2;

architecture lab2_arch of lab2 is
  signal led0    : std_logic;
  signal cntr    : std_logic_vector(25 downto 0);
  signal reset_n : std_logic;
  signal key_d1  : std_logic_vector(3 downto 0);
  signal key_d2  : std_logic_vector(3 downto 0);
  signal key_d3  : std_logic_vector(3 downto 0);
  signal sw_d1   : std_logic_vector(7 downto 0);
  signal sw_d2   : std_logic_vector(7 downto 0);

	component nios_system is
		port (
			clk_clk            : in  std_logic                    := 'X';             -- clk
			reset_reset_n      : in  std_logic                    := 'X';             -- reset_n
			hex_export         : out std_logic_vector(6 downto 0);                    -- export
			pushbuttons_export : in  std_logic_vector(2 downto 0) := (others => 'X'); -- export
			switches_export    : in  std_logic_vector(7 downto 0) := (others => 'X')  -- export
		);
	end component nios_system;

begin

  synchReset_proc : process (CLOCK_50) begin
    if (rising_edge(CLOCK_50)) then
      key_d1 <= KEY;
      key_d2 <= key_d1;
      key_d3 <= key_d2;
    end if;
  end process synchReset_proc;
  reset_n <= key_d3(0);
  
  synchUserIn_proc : process (CLOCK_50) begin
    if (rising_edge(CLOCK_50)) then
      if (reset_n = '0') then
        cntr  <= "00" & x"000000";
        sw_d1 <= "00"x;
        sw_d2 <= x"00";
      else
        cntr  <= cntr + ("00" & x"000001");
        sw_d1 <= SW;
        sw_d2 <= sw_d1;
      end if;
    end if;
  end process synchUserIn_proc;

	u0 : component nios_system
		port map (
			clk_clk            => CLOCK_50,            --         clk.clk
			reset_reset_n      => RESET_N,      --       reset.reset_n
			hex_export         => HEX0,         --         hex.export
			pushbuttons_export => KEY(3 downto 1), -- pushbuttons.export
			switches_export    => sw_d2     --    switches.export
		);

  end architecture lab2_arch;
