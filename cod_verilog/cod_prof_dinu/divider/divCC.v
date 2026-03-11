`timescale 1ns /1ns
module divCC(
ck, 
reset,
start, 
valid,
ldOp, 
iter, 
BeqZ
);


input ck;
input reset;
input start;
output valid;
// de la / spre CD
output	ldOp; 
output	iter;
input	BeqZ;


reg[1:0] stare;

// reg stare + CLC stare
always @(posedge ck or posedge reset)
if (reset)  stare <= 'b00; else
case (stare)
2'b00: stare <= start ? 'b01 : 'b00;
2'b01: stare <= BeqZ  ? 'b11 : 'b10;
2'b10: stare <= BeqZ  ? 'b11 : 'b10;
default: stare <= 'b00;		// 2'b00
endcase

// CLC iesiri
//assign valid = (stare == 2'b11);
assign valid = (stare == 2'b10) & BeqZ;
// assign ldOp  = (stare == 2'b01);
assign ldOp  = start;
assign iter  = (stare == 2'b10);


endmodule
