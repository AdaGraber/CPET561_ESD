library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity lab6 is
  port (
    CLOCK_50 : in std_logic;
    KEY      : in std_logic_vector(1 downto 0);
    LEDR     : out std_logic_vector (7 downto 0)
  );
end entity lab6;

architecture arch of lab6 is
  -- component
  component nios_system is
    port (
      clk_clk       : in std_logic := 'X'; -- clk
      key_export    : in std_logic := 'X'; -- export
      leds_export   : out std_logic_vector(7 downto 0); -- export
      reset_reset_n : in std_logic := 'X' -- reset_n
    );
  end component nios_system;

  --signals
  signal key_d1  : std_logic_vector(1 downto 0);
  signal key_d2  : std_logic_vector(1 downto 0);
  signal key_d3  : std_logic_vector(1 downto 0);
  signal reset_n : std_logic;

begin

  --synch key and send 1 to reset
  synchReset_proc : process (CLOCK_50) begin
    if (rising_edge(CLOCK_50)) then
      key_d1 <= KEY;
      key_d2 <= key_d1;
      key_d3 <= key_d2;
    end if;
  end process synchReset_proc;
  reset_n <= key_d3(0);

  --port map
  u0 : component nios_system
    port map
    (
      clk_clk       => CLOCK_50, --   clk.clk
      key_export    => key(0), --   key.export
      leds_export   => ledr, --  leds.export
      reset_reset_n => reset_n -- reset.reset_n
    );

  end arch;