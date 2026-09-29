library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity servo_controller is
  port (
    CLK_50          : in std_logic;
    reset_n         : in std_logic; -- active low system reset
    writedata       : in std_logic_vector(31 downto 0); --data from the CPU to be stored in the component
    write           : in std_logic; -- active high write enable
    address         : in std_logic; --whcih address register to use (determines count up or down)
    irq             : out std_logic; --signal to interrupt the processor
    out_wave_export : out std_logic
  );
end servo_controller;

architecture arch of servo_controller is
  constant period_20ms      : std_logic_vector(31 downto 0) := x"000F4240"; --20ms period
  constant neutral_angle    : std_logic_vector(31 downto 0) := x"000124F8"; --90 degrees
  constant min_angle_count  : std_logic_vector(31 downto 0) := x"000186A0"; -- 45 degrees
  constant max_angle_count  : std_logic_vector(31 downto 0) := x"0000C350"; -- 135 degrees
  signal internal_writedata : std_logic_vector(31 downto 0);
  signal internal_address   : std_logic;
  signal pwm_wave           : std_logic;
  signal internal_irq       : std_logic;
  signal angle_count        : std_logic_vector(31 downto 0);
  signal period_count       : std_logic_vector(31 downto 0);

  -- 2 32 bit registers for the counter, 1 being count for max pulse width, 1 being count for min pulse width
  type ram_type is array (1 downto 0) of std_logic_vector(31 downto 0);
  signal count_registers : ram_type; --instance of ram_type

  --STATE MACHINE
  type state_type is (SWEEP_RIGHT, SWEEP_LEFT, IRQ_LEFT, IRQ_RIGHT);
  signal present_state, next_state : state_type;
begin
  --put external signals into internal ones
  internal_writedata <= writedata;
  out_wave_export    <= pwm_wave;
  internal_address   <= address;

  --synchronize states
  sync : process (CLK_50, reset_N)
  begin
    if (reset_n = '0') then
      present_state <= IRQ_LEFT;
    elsif (rising_edge(CLK_50)) then
      present_state <= next_state;
    end if;
  end process;

  --load registers with write data based on address
  reg_load : process (CLK_50, reset_N)
  begin
    if (reset_n = '0') then
      count_registers(1) <= max_angle_count;
      count_registers(0) <= min_angle_count;
    end if;
    if (rising_edge (CLK_50)) then
      if (internal_address = '1') then
        count_registers(1) <= internal_writedata; -- load max count with write data
      elsif (internal_address = '0') then
        count_registers(0) <= internal_writedata; -- load min count with write data
      end if;
    end if;
  end process;

  --transition between states
  trans_states : process (present_state, internal_address, write, internal_writedata, reset_N)
  begin
    if (reset_n = '0') then
      next_state <= SWEEP_RIGHT;
    end if;
    case (present_state) is
      when SWEEP_RIGHT =>
        if (angle_count >= count_registers(1)) then
          next_state <= IRQ_RIGHT;
        end if;
      when IRQ_RIGHT =>
        if (write = '1') then
          next_state <= SWEEP_LEFT;
        end if;
      when SWEEP_LEFT =>
        if (angle_count <= count_registers(0)) then
          next_state      <= IRQ_LEFT;
        end if;
      when IRQ_LEFT =>
        if (write = '1') then
          next_state <= SWEEP_RIGHT;n
        end if;
    end case;
  end process;

  --count in either direction
  state_actions : process (CLK_50, reset_N)
  begin
    if (reset_n = '0') then
      angle_count <= neutral_angle;
    end if;
    if (rising_edge(clk_50)) then
      if (next_state = SWEEP_RIGHT) then
        if (period_count = 0) then
          angle_count <= angle_count + 550;
        end if;
      elsif (next_state = IRQ_LEFT) then
        --left blank for now. no counting done
      elsif (next_state = SWEEP_LEFT) then
        if (period_count = 0) then
          angle_count <= angle_count - 550;
        end if;
      elsif (next_state = IRQ_RIGHT) then
        --left blank for now. no counting done
      end if;
    end if;
  end process;

  --output the pwm signal
  pwm : process (CLK_50, reset_N)
  begin
    if (reset_n = '0') then
      pwm_wave <= '1';
    end if;
    if (rising_edge(clk_50)) then
      if (period_count >= angle_count) then
        pwm_wave <= '0';
      elsif (period_count = 0) then
        pwm_wave <= '1';
      end if;
    end if;
  end process;

  --process to see if IRQ needs to be sent out
  irq_out : process (CLK_50, reset_N)
  begin
    if (reset_n = '0') then
      irq <= '0';
    end if;
    if (rising_edge(CLK_50)) then
      if (next_state = SWEEP_RIGHT) then
        irq <= '0';
      elsif (next_state = IRQ_RIGHT) then
        irq <= '1';
      elsif (next_state = SWEEP_LEFT) then
        irq <= '0';
      elsif (next_state = IRQ_LEFT) then
        IRQ <= '1';
      end if;
    end if;
  end process;

  --process for period count
  per_count : process (CLK_50, reset_N)
  begin
    if (reset_n = '0') then
      period_count <= (others => '0');
    end if;
    if (rising_edge(CLK_50)) then
      if (period_count >= period_20ms) then
        period_count <= (others => '0');
      else
        period_count <= period_count + 1;
      end if;
    end if;
  end process;
end arch;
