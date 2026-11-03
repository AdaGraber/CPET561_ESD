
module nios_system (
	clk_clk,
	key_export,
	leds_export,
	reset_reset_n);	

	input		clk_clk;
	input		key_export;
	output	[7:0]	leds_export;
	input		reset_reset_n;
endmodule
