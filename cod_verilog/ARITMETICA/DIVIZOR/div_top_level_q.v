//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : div_top_level_q
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Modul Top-Level pentru Divizorul Hardware.
//              Interconecteaza Controlerul FSM cu Calea de Date.
//---------------------------------------------------------------

module div_top_level_q #(
    parameter INT_BITS  = 16,                     // Numar de biti parte intreaga (include semnul) 
    parameter FRAC_BITS = 16                      // Numar de biti parte fractionara
)(
    input                               clk,      // Semnal de ceas
    input                               rst_n,    // Reset asincron (activ in 0)
    input                               start,    // Semnal pentru pornirea operatiei de impărtire
    input  [INT_BITS+FRAC_BITS-1:0]     op1, op2, // Operanzi in format Q (semnati)
    output [INT_BITS+FRAC_BITS-1:0]     rezultat, // Rezultatul final
    output                              valid     // Flag finalizare calcul
);
    
    localparam WIDTH = INT_BITS + FRAC_BITS;


    // ------------------------
    // Interfata submodule divizor
    // ------------------------

    wire [WIDTH-1:0] cat;
    wire ld;
    wire done;


    // ------------------------
    // Instantiere submodule divizor
    // ------------------------

    // Calea de Control
    div_ctrl_q ctrl (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .ld(ld),
        .valid(valid)
    );

    // Calea de Date
    div_data_q data (
        .clk(clk),
        .rst_n(rst_n),
        .ld(ld),
        .deimpartit(op1),
        .impartitor(op2),
        .done(done),
        .cat(cat)
    );

    // Rezultatul final este catul calculat
    assign rezultat = cat;

endmodule

