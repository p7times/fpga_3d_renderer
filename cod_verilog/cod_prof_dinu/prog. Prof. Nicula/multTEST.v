module multTEST();

wire ck;
wire reset;
wire start;
wire[3:0] 	op1; 
wire[3:0] 	op2;
wire[7:0] 	rez;
wire		valid;

multTB  TB(
.ck		(ck		), 
.reset	(reset	),
.start	(start	), 
.op1	(op1	), 
.op2	(op2	)
);

mult DUT(
.ck		(ck		), 
.reset	(reset	),
.start	(start	), 
.valid	(valid	),
.op1	(op1	), 
.op2	(op2	), 
.rez    (rez    )
);

endmodule
