library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity high_pass_filter is
  port (
    clk, reset_n : in std_logic;
    filter_en    : in std_logic;
    data_in      : in std_logic_vector(15 downto 0);
    data_out     : out std_logic_vector(15 downto 0)
  );
end high_pass_filter;

architecture rtl of high_pass_filter is
  --mult component to be instantiated
  component mult_filter is
    port (
      dataa  : in std_logic_vector (15 downto 0);
      datab  : in std_logic_vector (15 downto 0);
      result : out std_logic_vector (31 downto 0)
    );
  end component;

  --z register component instantiations
  component z_reg is
    port (
      clk, reset_n, filter_en : in std_logic;
      d_in                    : in std_logic_vector (15 downto 0);
      d_out                   : out std_logic_vector(15 downto 0)
    );
  end component;

  --constants for low pass filter
  type ram_type is array (16 downto 0) of std_logic_vector (15 downto 0);
  signal S : ram_type := (x"003E", x"FF9A", x"FE9E", x"0000", x"0536", X"05B2", X"F5AC", X"DAB7", X"4C91",
  X"DAB7", X"F5AC", X"05B2", X"0536", X"0000", X"FE9E", X"FF9A", X"003E");

  type signal_type is array (16 downto 0) of std_logic_vector (15 downto 0);
  signal data : signal_type := (others => (others => '0'));

  type result_type is array (16 downto 0) of std_logic_vector (31 downto 0);
  signal result : result_type := (others => (others => '0'));

begin
  data(0) <= data_in;

  --generate THE REGISTERS
  gen_z_reg : for i in 0 to 15 generate
  begin
    inst : z_reg
    port map
    (
      clk       => clk,
      reset_n   => reset_n,
      filter_en => filter_en,
      d_in      => data(i),
      d_out     => data(i + 1)
    );
  end generate;

  mult_gen : for i in 0 to 16 generate
  begin
    mult_filter_inst : mult_filter
    port map
    (
      dataa  => data(i),
      datab  => S(i),
      result => result(i)
    );
  end generate;

  process (result)
    variable temp_sum : signed(31 downto 0);
  begin
    temp_sum := (others => '0');
    for i in 0 to 16 loop
      temp_sum := temp_sum + signed(result(i));
    end loop;
    data_out <= std_logic_vector(temp_sum(30 downto 15));
  end process;
end architecture;