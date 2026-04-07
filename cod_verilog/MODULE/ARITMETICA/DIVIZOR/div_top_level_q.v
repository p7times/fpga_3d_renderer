module div_top_level_q #(
    parameter INT_BITS  = 16,
    parameter FRAC_BITS = 16
)(
    input                               clk,      // Semnal de ceas
    input                               rst_n,    // Reset asincron, activ in 0
    input                               start,    // Semnal pentru startul operatiei de impărtire
    input  [INT_BITS+FRAC_BITS-1:0]     op1,      // Primul operand
    input  [INT_BITS+FRAC_BITS-1:0]     op2,      // Al doilea operand
    output [INT_BITS+FRAC_BITS-1:0]     rezultat, // Rezultatul pe 16 biti, primii 8 ptr q (cat), urmatorii ptr r (rest)
    output                              valid
);
    
    localparam WIDTH = INT_BITS + FRAC_BITS;

    wire [WIDTH-1:0] cat;
    wire ld;
    wire done;

    // CONTROL
    div_ctrl_q ctrl (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .ld(ld),
        .valid(valid)
    );

    // DATA
    div_data_q data (
        .clk(clk),
        .rst_n(rst_n),
        .ld(ld),
        .deimpartit(op1),
        .impartitor(op2),
        .done(done),
        .cat(cat)
    );

    // AMBALARE REZULTAT
    assign rezultat = cat;

endmodule

