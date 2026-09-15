
module nios_system (
	clk_clk,
	reset_reset_n,
	hex_export,
	pushbuttons_export,
	switches_export);	

	input		clk_clk;
	input		reset_reset_n;
	output	[6:0]	hex_export;
	input	[3:0]	pushbuttons_export;
	input	[7:0]	switches_export;
endmodule
