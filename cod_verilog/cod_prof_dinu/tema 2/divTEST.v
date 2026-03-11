module divTEST();

parameter N	= 22;

wire ck;
wire reset;
wire start;
wire[N-1:0] op1; 
wire[N-1:0] op2;
wire[N-1:0] cat;
wire[N-1:0] rest;
wire		valid;

divTB #(N) TB(
.ck		(ck		), 
.reset	(reset	),
.start	(start	), 
.op1	(op1	), 
.op2	(op2	)
);

div #(N) DUT(
.ck		(ck		), 
.reset	(reset	),
.start	(start	), 
.valid	(valid	),
.op1	(op1	), 
.op2	(op2	), 
.cat    (cat    ),
.rest   (rest   )
);

endmodule
