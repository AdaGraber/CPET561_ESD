library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity servo_controller_tb is
end entity;

architecture arch of servo_controller_tb is
  component servo_controller
    port (
      CLK_50          : in std_logic;
      reset_n         : in std_logic; -- active low system reset
      writedata       : in std_logic_vector(31 downto 0); --data from the CPU to be stored in the component
      write           : in std_logic; -- active high write enable
      address         : in std_logic; --whcih address register to use (determines count up or down)
      irq             : out std_logic; --signal to interrupt the processor
      out_wave_export : out std_logic
    );
  end component;

  constant period   : time                          := 20 ns;
  signal write      : std_logic                     := '0';
  signal clk_50_tb  : std_logic                     := '0';
  signal reset_n_tb : std_logic                     := '0';
  signal writedata  : std_logic_vector(31 downto 0) := x"00001388";
  signal address    : std_logic                     := '0';
  signal irq        : std_logic                     := '0';
  signal out_wave   : std_logic                     := '0';

begin

  uut : servo_controller
  port map
  (
    CLK_50          => clk_50_tb,
    reset_n         => reset_n_tb,
    writedata       => writedata,
    write           => write,
    address         => address,
    irq             => irq,
    out_wave_export => out_wave
  );
  -- clock process
  clock : process
  begin
    clk_50_tb <= not clk_50_tb;
    wait for period/2;
  end process;

  -- reset process
  async_reset : process
  begin
    wait for 2 * period;
    reset_n_tb <= '1';
    wait;
  end process;

  --stimulus process
  stim : process
  begin
    report "**** sim start ****";
    wait for 4 * period;
    wait until irq = '1';
    address   <= '0';
    writedata <= x"0000D6D8";
    wait for period;
    write <= '1';
    wait for period;
    write <= '0';
    wait until irq = '1';
    address <= '1';
    writedata <= x"00017318";
    wait for period;
    write <= '1';
    wait for period;
    write <= '0';
    report " **** sim end ****";
  end process;
end arch;