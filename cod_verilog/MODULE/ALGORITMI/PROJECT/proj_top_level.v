module proj_top_level #(
    parameter INT_BITS  = 16,
    parameter FRAC_BITS = 16
)(
    input                               clk,      // Semnal de ceas
    input                               rst_n,    // Reset asincron, activ in 0
    input                               start,    // Semnal pentru startul operatiei de impărtire
    output [INT_BITS+FRAC_BITS-1:0]     f,        // Distanta focala
    input  [INT_BITS+FRAC_BITS-1:0]     x, y, z   // Coordonatele punctului
    output [INT_BITS+FRAC_BITS-1:0]     xp, yp    // Coordonatele dupa proiectia in perspectiva
    output                              valid     // Semnal de finalizare a operatiilor
);
    
    localparam WIDTH = INT_BITS + FRAC_BITS;

    wire [WIDTH-1:0] cat;
    wire ld;
    wire done;

    // CONTROL
    proj_ctrl ctrl (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .ld(ld),
        .valid(valid)
    );

    // DATA
    proj_data data (
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

