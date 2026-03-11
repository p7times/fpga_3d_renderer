module restoreDiv_CC(clk_i, reset_i, start, iter, valid);

	parameter N = 22;

	input clk_i, reset_i;
	input start;
	output reg iter;
	output reg valid;

	reg [N-1:0] countIter;

	always @(posedge clk_i or posedge reset_i)
		if (reset_i) countIter <= {1'b1,{N-1{1'b0}}};
			else if (start) countIter <= {1'b1,{N-1{1'b0}}};
				else if (iter) countIter <= (countIter >> 1);
	
	always @(posedge clk_i or posedge reset_i)
		if (reset_i) valid <= 1'b0;
			else valid <= countIter[0];
	
	always @(posedge clk_i or posedge reset_i)
		if (reset_i) iter <= 1'b0;
			else if (~iter) iter <= start;
				else iter <= ~countIter[0];
	
endmodule