//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : sub_q
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Subtractor in virgula fixa semnata (signed fixed-point).
//
//              Implementeaza logica de saturatie: rezultatul este
//              limitat la MAX sau MIN in caz de overflow, evitand
//              fenomenul de wrap-around aritmetic.
//---------------------------------------------------------------

module sub_q #(
    parameter INT_BITS   = 16,                      // Numar de biti parte intreaga (include semnul)
    parameter FRAC_BITS  = 16,                      // Numar de biti parte fractionara
    parameter DATA_WIDTH = INT_BITS + FRAC_BITS     // Latime date, biti
)(
    input                       clk,                // Semnal de ceas
    input                       rst_n,              // Reset asincron (activ in 0)
    input      [DATA_WIDTH-1:0] a, b,               // Operanzi in format Q (semnati)
    output reg                  overflow,           // Indicator depasire domeniu numeric (pentru debug/saturatie)
    output reg [DATA_WIDTH-1:0] dif                 // Rezultat saturat
);  

    // ------------------------
    // Limite reprezentabile in format Q (Complement de 2)
    // ------------------------

    // MAX: 0 urmat de 1-uri (cel mai mare numar pozitiv)
    // MIN: 1 urmat de 0-uri (cel mai mic numar negativ)
    localparam [DATA_WIDTH-1:0] MAX = {1'b0, {(DATA_WIDTH-1){1'b1}}};
    localparam [DATA_WIDTH-1:0] MIN = {1'b1, {(DATA_WIDTH-1){1'b0}}}; 


    // ------------------------
    // Semnale pentru calculul aritmetic
    // ------------------------

    wire [DATA_WIDTH-1:0] raw_dif;      // Rezultatul brut al scaderii
    wire                  sub_overflow; // Flag intern pentru detectare overflow
    
    assign raw_dif = a - b;             // Scadere aritmetica standard


    // ------------------------
    // Detectie overflow
    // ------------------------

    // 1. Operanzii au semne diferite: (a[MSB] ^ b[MSB])
    // 2. Semnul rezultatului difera de semnul descazutului: (raw_dif[MSB] ^ a[MSB])
    // Daca ambele conditii sunt adevarate, inseamna ca am depasit domeniul numeric
    assign sub_overflow = (a[DATA_WIDTH-1] ^ b[DATA_WIDTH-1]) & (raw_dif[DATA_WIDTH-1] ^ a[DATA_WIDTH-1]);


    // ------------------------
    // Logica secventiala cu saturatie
    // ------------------------

    always @(posedge clk or negedge rst_n)
        if (!rst_n ) begin
            dif      <= 0;
            overflow <= 1'b0;
        end else begin
            // Saturatie: daca add_overflow e activ, limitam rezultatul la extreme
            // Semnul lui 'a' indica directia reala a overflow-ului
            dif      <= sub_overflow ? (a[DATA_WIDTH-1] ? MIN : MAX) : raw_dif;
            overflow <= sub_overflow;
        end

endmodule // sub_q
