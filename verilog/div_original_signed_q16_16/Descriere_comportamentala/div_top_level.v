module div_top_level #(
    parameter N = 16
)(
    input ck,                    // Semnal de ceas
    input reset_n,               // Reset asincron, activ in 0
    input start,                 // Semnal pentru startul operatiei de impărtire
    input  [N-1:0] op1,          // Primul operand
    input  [N-1:0] op2,          // Al doilea operand
    output [2*N-1:0] rezultat,   // Rezultatul pe 16 biti, primii 8 ptr q (cat), urmatorii ptr r (rest)
    output valid
);

wire [N-1:0] cat;
wire [N-1:0] rest;
wire ld;
wire done;

// CONTROL
div_control ctrl (
    .ck(ck),
    .reset_n(reset_n),
    .start(start),
    .done(done),
    .ld(ld),
    .valid(valid)
);

// DATA
div_data dp (
    .ck(ck),
    .reset_n(reset_n),
    .ld(ld),
    .deimpartit(op1),
    .impartitor(op2),
    .done(done),
    .cat(cat),
    .rest(rest)
);

// AMBALARE REZULTAT
assign rezultat = {cat, rest};

endmodule

