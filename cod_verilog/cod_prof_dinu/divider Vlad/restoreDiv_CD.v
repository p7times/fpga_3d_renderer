module restoreDiv_CD(clk_i, reset_i, dividend, divider, start, iter, quotient);

	parameter N = 22;

	input clk_i, reset_i;
	input [N-1:0] dividend;	// ÎMPÃRTIT
	input [N-1:0] divider;	// ÎMPÃRTITOR
	input start, iter;
	
	output reg [N-1:0]	quotient;	// CÂT
	
	reg [N-1:0] 	remainder;	// REST
	reg  [N-1:0] divider_tmp;
	wire [N:0] rem_minus_div;
	wire [N:0] rem_shifted;
	
	assign rem_shifted   = {remainder[N-1:0],quotient[N-1]};
	assign rem_minus_div = rem_shifted - divider_tmp;
	
	always @(posedge clk_i or posedge reset_i)
		if (reset_i) begin
			remainder   <= 'b0;
			quotient    <= 'b0;
			divider_tmp <= 'b0;
		end
			else if (start) begin
				remainder   <= 'b0;
				quotient    <= dividend;
				divider_tmp <= divider;
			end
				else if (iter) begin
					if (~rem_minus_div[N])	remainder <= rem_minus_div;
					else					remainder <= rem_shifted;
					quotient <= {quotient[N-2:0], ~rem_minus_div[N]};
				end

endmodule