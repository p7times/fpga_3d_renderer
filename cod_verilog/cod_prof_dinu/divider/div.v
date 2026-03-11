`timescale 1ns /1ns
module div(
ck, 
reset,
start, 
valid,
op1, 
op2, 
cat,
rest
);
parameter N	= 22;

input ck;
input reset;
input start;
output valid;
input[N-1:0] 	op1; 
input[N-1:0]	op2;
output[N-1:0]	cat;
output[N-1:0]	rest;

wire	ldOp; 
wire	iter;
wire	BeqZ;

divCC  CC(
.ck	   (ck	  ), 
.reset (reset),
.start (start),
.valid (valid),
.ldOp  (ldOp ), 
.iter  (iter ), 
.BeqZ  (BeqZ )
);

divCD #(N) CD(
.ck		(ck		), 
.reset	(reset	),
.op1	(op1	), 
.op2	(op2	), 
.cat	(cat	),
.rest   (rest   ), 
.ldOp	(ldOp	), 
.iter	(iter	), 
.BeqZ   (BeqZ  )
);


endmodule
