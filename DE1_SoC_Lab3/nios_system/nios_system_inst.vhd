	component nios_system is
		port (
			clk_clk           : in  std_logic                    := 'X';             -- clk
			hex0_export       : out std_logic_vector(6 downto 0);                    -- export
			leds_export       : out std_logic_vector(7 downto 0);                    -- export
			pushbutton_export : in  std_logic_vector(2 downto 0) := (others => 'X'); -- export
			reset_reset_n     : in  std_logic                    := 'X';             -- reset_n
			switches_export   : in  std_logic_vector(7 downto 0) := (others => 'X')  -- export
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk           => CONNECTED_TO_clk_clk,           --        clk.clk
			hex0_export       => CONNECTED_TO_hex0_export,       --       hex0.export
			leds_export       => CONNECTED_TO_leds_export,       --       leds.export
			pushbutton_export => CONNECTED_TO_pushbutton_export, -- pushbutton.export
			reset_reset_n     => CONNECTED_TO_reset_reset_n,     --      reset.reset_n
			switches_export   => CONNECTED_TO_switches_export    --   switches.export
		);

