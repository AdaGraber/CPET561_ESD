library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity filter_tb is
end entity;

architecture rtl of filter_tb is
  component low_pass_filter is
    port (
      clk, reset_n : in std_logic;
      filter_en    : in std_logic;
      data_in      : in std_logic_vector(15 downto 0);
      data_out     : out std_logic_vector(15 downto 0)
    );
  end component;
begin
  stimulus : process is
    file read_file      : text open read_mode is "/one_cycle_integer.csv";
    file results_file   : text open write_mode is "/output_waveform.csv";
    variable lineIn     : line;
    variable lineOut    : line;
    variable readValue  : integer;
    variable writeValue : integer;
  begin
    wait for 100 ns;
    reset <= '1';
    -- Read data from file into an array
    for i in 0 to 39 loop
      readline(read_file, lineIn);
      read(lineIn, readValue);
      audioSampleArray(i) <= to_signed(readValue, 16);
      wait for 50 ns;
    end loop;
    file_close(read_file);
    -- Apply the test data and put the result into an output file
    for i in 1 to 10 loop
      for j in 0 to 39 loop
        -- Your code here...
        -- Read the data from the array and apply it to Data_In
        -- Remember to provide an enable pulse with each new sample
        -- Write filter output to file
        writeValue := to_integer(data_out);
        write(lineOut, writeValue);
        writeline(results_file, lineOut);
        -- Your code here...
      end loop;
    end loop;
    file_close(results_file);
    -- end simulation
    sim_done <= true;
    wait for 100 ns;
    -- last wait statement needs to be here to prevent the process
    -- sequence from restarting at the beginning
    wait;
  end process stimulus;

end architecture;