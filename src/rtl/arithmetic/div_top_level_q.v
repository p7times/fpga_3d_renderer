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

`timescale 1ns / 1ps

module div_top_level_q #(
    parameter INT_BITS   = 16,                    // Numar de biti parte intreaga (include semnul) 
    parameter FRAC_BITS  = 12,                    // Numar de biti parte fractionara
    parameter DATA_WIDTH = INT_BITS + FRAC_BITS   // Latime date, biti
)(
    input                               clk,      // Semnal de ceas
    input                               rst_n,    // Reset asincron (activ in 0)
    input                               start,    // Semnal pentru pornirea operatiei de impărtire
    input  [DATA_WIDTH-1:0]             a, b,     // Operanzi in format Q (semnati)
    output [DATA_WIDTH-1:0]             quotient, // Rezultatul final
    output                              valid     // Flag finalizare calcul
);
    
    // ------------------------
    // Interfata submodule divizor
    // ------------------------

    wire [DATA_WIDTH-1:0] q;
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
    div_data_q #(
        .INT_BITS  (INT_BITS),
        .FRAC_BITS (FRAC_BITS)
    ) data (
        .clk(clk),
        .rst_n(rst_n),
        .ld(ld),
        .dividend(a),
        .divisor(b),
        .done(done),
        .quotient(q)
    );

    // Rezultatul final este catul calculat
    assign quotient = q;

endmodule // div_top_level_q

