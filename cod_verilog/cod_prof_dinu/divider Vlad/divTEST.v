module divTEST();

parameter N	= 22;

wire ck;
wire reset;
wire start;
wire[N-1:0] op1; 
wire[N-1:0] op2;
wire[N-1:0] cat;
wire		valid;

divTB #(N) TB(
.ck		(ck		), 
.reset	(reset	),
.start	(start	), 
.op1	(op1	), 
.op2	(op2	)
);

Divider #(N) DUT(
.clk_i		(ck		), 
.reset_i	(reset	),
.start	(start	), 
.valid	(valid	),
.dividend	(op1	), 
.divider	(op2	), 
.quotient   (cat    )
);


endmodule
