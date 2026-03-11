module mult(
ck, 
reset,
start, 
valid,
op1, 
op2, 
rez
);

input ck;
input reset;
input start;
output valid;
input[3:0] 	op1; 
input[3:0]	op2;
output[7:0]	rez;

wire	ldOp; 
wire	iter;
wire	BeqZ;

multCC  CC(
.ck	   (ck	  ), 
.reset (reset),
.start (start),
.valid (valid),
.ldOp  (ldOp ), 
.iter  (iter ), 
.BeqZ  (BeqZ )
);

multCD CD(
.ck		(ck		), 
.reset	(reset	),
.op1	(op1	), 
.op2	(op2	), 
.rez	(rez	),
.ldOp	(ldOp	), 
.iter	(iter	), 
.BeqZ   (BeqZ  )
);


endmodule
