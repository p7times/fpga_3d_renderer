module multCD (
ck, 
reset,
op1, 
op2, 
rez,
ldOp, 
iter, 
BeqZ
);


input ck;
input reset;
input[3:0] 	op1; 
input[3:0]	op2;
output[7:0]	rez;
// de la / spre CC
input	ldOp; 
input	iter;
output	BeqZ;

reg[3:0] Areg;
reg[3:0] Breg;
reg[7:0] Preg;


always @(posedge ck or posedge reset)
if (reset)  Areg <= 'b0; else
if (ldOp)	Areg <= op1;

always @(posedge ck or posedge reset)
if (reset)  Breg <= 'b0; else
if (ldOp)	Breg <= op2; else
if (iter)	Breg <= Breg - 1; 

always @(posedge ck or posedge reset)
if (reset)  Preg <= 'b0; else
if (ldOp)	Preg <= 'b0; else
if (iter)	Preg <= Preg + Areg; 

assign BeqZ = ~|Breg;
assign rez = Preg;

endmodule
