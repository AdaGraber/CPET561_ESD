library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity servo_controller is
  generic (
    min_angle_count : integer := 1000000; -- 1ms pulse width
    max_angle_count : integer := 2000000 -- 2ms pulse width
  );
  port (
    CLK_50    : in std_logic;
    reset_n   : in std_logic; -- active low system reset
    writedata : in std_logic_vector(31 downto 0); --data from the CPU to be stored in the component
    write     : in std_logic; -- active high write enable
    address   : in std_logic;
    irq       : out std_logic --signal to interrupt the processor                      
  );
end servo_controller;

architecture arch of servo_controller is

begin
end arch;