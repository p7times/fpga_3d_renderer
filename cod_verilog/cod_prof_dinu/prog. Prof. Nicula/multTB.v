module multTB(
ck, 
reset,
start, 
op1, 
op2
);

output ck;
output reset;
output start;
output[3:0] 	op1; 
output[3:0]		op2;

reg ck;
reg reset;
reg start;
reg[3:0] 	op1; 
reg[3:0]		op2;

initial begin
	ck <= 1'b0;
	forever #10 ck <= ~ck;
end

initial begin
	reset <= 1'b0;
	@(posedge ck);
	reset <= 1'b1;
	@(posedge ck);
	@(posedge ck);
	reset <= 1'b0;
	@(posedge ck);
end

initial begin
	start	<= 1'bx;
 	op1		<= 'bx; 
	op2		<= 'bx;
	@(posedge reset);
	start	<= 1'b0;
	@(negedge reset);
	@(posedge ck);
	@(posedge ck);
	@(posedge ck);
	@(posedge ck);
	@(posedge ck);
	start	<= 1'b1;
 	op1		<= 3; 
	op2		<= 5;
	@(posedge ck);
	start	<= 1'b0;
 	op1		<= 'bx;
	op2		<= 'bx;
	@(posedge ck);
	
	end


endmodule
