//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : mult_top_level_q
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Modul Top-Level pentru Multiplicatorul Booth.
//              Interconecteaza Controlerul FSM cu Calea de Date (Iesire pe DATA_WIDTH).
//---------------------------------------------------------------

module mult_top_level_q #(
    parameter INT_BITS   = 16,                    // Numar de biti parte intreaga (include semnul) 
    parameter FRAC_BITS  = 16,                    // Numar de biti parte fractionara
    parameter DATA_WIDTH = INT_BITS + FRAC_BITS   // Latime date, biti
)(
    input                               clk,      // Semnal de ceas
    input                               rst_n,    // Reset asincron (activ in 0)
    input                               start,    // Semnal pentru pornirea operatiei de inmultire
    input  [DATA_WIDTH-1:0]             a, b,     // Operanzi in format Q (semnati)
    output [DATA_WIDTH-1:0]             product,  // Rezultatul final pe precizie simpla
    output                              overflow, // Flag de overflow expus pe Top
    output                              valid     // Flag finalizare calcul
);
    
    // ------------------------
    // Interfata submodule
    // ------------------------

    wire [DATA_WIDTH-1:0] p;
    wire ld;
    wire done;
    wire ov;


    // ------------------------
    // Instantiere submodule multiplicator
    // ------------------------

    // Unitatea de Control (FSM)
    mult_ctrl_q ctrl (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .ld(ld),
        .valid(valid)
    );

    // Calea de Date (Datapath)
    mult_data_q #(
        .INT_BITS  (INT_BITS),
        .FRAC_BITS (FRAC_BITS)
    ) data (
        .clk(clk),
        .rst_n(rst_n),
        .ld(ld),
        .multiplicand(a),
        .multiplier(b),
        .done(done),
        .overflow(ov),
        .product(p)
    );

    // Rezultatul final trunchiat si saturat corespunzator la DATA_WIDTH
    assign product = p;
    assign overflow = ov;

endmodule // mult_top_level_q
