module Divider(clk_i, reset_i, start, dividend, divider, quotient, valid);

	parameter N = 22;

	input clk_i, reset_i;
	input start;
	input [N-1:0] dividend, divider;
	output [N-1:0] quotient;
	output valid;
	
	wire  iter;
	
	restoreDiv_CD CD(
		.clk_i		(clk_i),
		.reset_i	(reset_i),
		.dividend	(dividend),
		.divider	(divider),
		.start		(start),
		.iter		(iter),
		.quotient	(quotient)
	);
	
	restoreDiv_CC CC(
		.clk_i		(clk_i),
		.reset_i	(reset_i),
		.start		(start),
		.iter		(iter),
		.valid		(valid)
	);

endmodule