library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity servo_controller_tb is
end entity;

architecture arch of servo_controller_tb is
    component servo_controller 
        PORT(
        CLK_50: in std_logic;
        reset_n: in std_logic; -- active low system reset
        writedata: in std_logic_vector(31 downto 0); --data from the CPU to be stored in the component
        write: in std_logic; -- active high write enable
        address: in std_logic; --whcih address register to use (determines count up or down)
        irq: out std_logic; --signal to interrupt the processor
        out_wave_export: out std_logic
        );
    end component;

    signal write : std_logic := '0';
    signal clk_50_tb : std_logic := '0';
    signal reset_n_tb : std_logic := '0';
    signal writedata : std_logic_vector(31 downto 0) := x"00001388";
    signal address : std_logic := '0';
    signal irq : std_logic := '0';
    signal out_wave : std_logic := '0';
    
begin

    uut : servo_controller
    PORT MAP(
        CLK_50 => clk_50_tb,
        reset_n => reset_n_tb,
        writedata => writedata,
        write => write,
        address => address,
        irq => irq,
        out_wave_export => out_wave
    );


end arch;