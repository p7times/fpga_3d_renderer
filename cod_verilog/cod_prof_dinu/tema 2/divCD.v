module divCD (
ck, 
reset,
op1, 
op2, 
cat,
rest,
ldOp, 
iter, 
BeqZ
);
parameter N	= 4;


input ck;
input reset;
input[N-1:0] 	op1; 
input[N-1:0]    op2;
output[N-1:0]	cat;
output[N-1:0]	rest;
// de la / spre CC
input	ldOp; 
input	iter;
output	BeqZ;

reg[N-1:0] Areg;
reg[N:0] Breg;
reg[N:0] Preg;
wire[N:0] negBreg;
reg[N-1:0] count;

assign negBreg=~Breg +1;

always @(posedge ck or negedge reset)
if (!reset)  begin 
Areg <= 'b0; 
count <=N;
end else
if (ldOp) begin	Areg <= op1;
                count<=N;
			end

always @(posedge ck or negedge reset)
if (!reset)  Breg <= 'b0; else
if (ldOp)	Breg <= op2;  //extindere de semn

always @(posedge ck or negedge reset)
if (!reset)  Preg <= 'b0; else
if (ldOp)	Preg <= 'b0; else
if (iter)	begin if (Preg[N]) begin
				      Preg={Preg[N-1:0], Areg[N-1]};
				      Preg=Preg+Breg;
			      end
				else begin
				Preg={Preg[N-1:0], Areg[N-1]};
				Preg=Preg+negBreg;
				end
				Areg = {Areg[N-2:0], ~Preg[N]};
				count = count-1;
			end

assign BeqZ = ~|count;
assign cat = Areg;
assign rest = Preg[N] ? Preg+Breg: Preg[N-1:0];

endmodule
