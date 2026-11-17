library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity audio_filter is
  port (
    clk, reset_n : in std_logic;
    write        : in std_logic;
    address      : in std_logic;
    data_in      : in std_logic_vector(15 downto 0);
    data_out     : out std_logic_vector(15 downto 0)
  );
end audio_filter;

architecture rtl of audio_filter is
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
  signal Sh : ram_type := (x"003E", x"FF9A", x"FE9E", x"0000", x"0536", X"05B2", X"F5AC", X"DAB7", X"4C91",
  X"DAB7", X"F5AC", X"05B2", X"0536", X"0000", X"FE9E", X"FF9A", X"003E"); -- high pass values

  signal Sl : ram_type := (x"0051", x"00BA", x"01E1", x"0408", x"071A", X"0AAC", X"0E11", X"107F", X"1161",
  X"107F", X"0E11", X"0AAC", X"071A", X"0408", X"01E1", X"00BA", X"0051"); -- low pass values

  signal S : ram_type := (others => (others => '0'));

  type signal_type is array (16 downto 0) of std_logic_vector (15 downto 0);
  signal data : signal_type := (others => (others => '0'));
  signal data_buffer : std_logic_vector(15 downto 0) := (others => '0');

  type result_type is array (16 downto 0) of std_logic_vector (31 downto 0);
  signal result : result_type := (others => (others => '0'));

  signal sw_reg : std_logic;
begin
  --address switch S into based on high or low
  addrswitch : process (clk, reset_n)
  begin
    if (reset_n = '0') then
      data_buffer <= (others => '0');
      sw_reg <= '0';
    elsif (rising_edge(CLK)) then
      if (write = '1') then
        if(address = '0') then
          data_buffer <= data_in;
        else 
          sw_reg <= data_in(0);
        end if;
      else
        sw_reg <= sw_reg;
        data_buffer <= data_buffer;
      end if;
    end if;
  end process;
  data(0) <= data_buffer;

  low_high_mux : process(clk, reset_n)
  begin 
    if(reset_n = '0') then
      S <= sl;
    elsif(rising_edge(clk)) then
      if(sw_reg = '1') then
        S <= Sh;
      else
        S <= Sl;
      end if;
    end if;
  end process;

  --generate THE REGISTERS
  gen_z_reg : for i in 0 to 15 generate
  begin
    inst : z_reg
    port map
    (
      clk       => clk,
      reset_n   => reset_n,
      filter_en => write,
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