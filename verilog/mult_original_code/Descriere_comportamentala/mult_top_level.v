module mult_top_level #(
    parameter N = 16
)(
    input ck,                    // Semnal de ceas
    input reset_n,               // Reset asincron, activ in 0
    input start,                 // Semnal pentru startul operatiei de inmultire
    input  [N-1:0] op1,          // Primul operand
    input  [N-1:0] op2,          // Al doilea operand
    output [2*N-1:0] rezultat,   // Produsul
    output valid
);

wire ld;
wire done;
wire [2*N-1:0] produs;

// CONTROL
mult_control #(N) ctrl (
    .ck(ck),
    .reset_n(reset_n),
    .start(start),
    .done(done),
    .ld(ld),
    .valid(valid)
);

// DATA
mult_data #(N) dp (
    .ck(ck),
    .reset_n(reset_n),
    .ld(ld),
    .deinmultit(op1),
    .inmultitor(op2),
    .done(done),
    .produs(produs)
);

// AMBALARE REZULTAT
assign rezultat = produs;

endmodule

