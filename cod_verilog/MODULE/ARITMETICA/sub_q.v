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
    parameter INT_BITS  = 16,                       // Numar de biti parte intreaga (include semnul)
    parameter FRAC_BITS = 16                        // Numar de biti parte fractionara
)(
    input                               clk,        // Semnal de ceas
    input                               rst_n,      // Reset asincron (activ in 0)
    input [INT_BITS+FRAC_BITS-1:0]      a, b,       // Operanzi in format Q (semnati)
    output reg                          overflow,   // Indicator depasire domeniu numeric (pentru debug/saturatie)
    output reg [INT_BITS+FRAC_BITS-1:0] dif         // Rezultat saturat
);  

    localparam TOTAL = INT_BITS + FRAC_BITS;


    // ------------------------
    // Limite reprezentabile in format Q (Complement de 2)
    // ------------------------

    // MAX: 0 urmat de 1-uri (cel mai mare numar pozitiv)
    // MIN: 1 urmat de 0-uri (cel mai mic numar negativ)
    localparam [TOTAL-1:0] MAX = {1'b0, {(TOTAL-1){1'b1}}};
    localparam [TOTAL-1:0] MIN = {1'b1, {(TOTAL-1){1'b0}}}; 


    // ------------------------
    // Semnale pentru calculul aritmetic
    // ------------------------

    wire [TOTAL-1:0] raw_dif;       // Rezultatul brut al scaderii
    wire             sub_overflow;  // Flag intern pentru detectare overflow
    
    assign raw_dif = a - b;         // Scadere aritmetica standard


    // ------------------------
    // Detectie overflow (Logica pentru numere semnate)
    // ------------------------

    // 1. Operanzii au semne diferite: (a[MSB] ^ b[MSB])
    // 2. Semnul rezultatului difera de semnul descazutului: (raw_dif[MSB] ^ a[MSB])
    // Daca ambele conditii sunt adevarate, inseamna ca am depasit domeniul numeric
    assign sub_overflow = (a[TOTAL-1] ^ b[TOTAL-1]) & (raw_dif[TOTAL-1] ^ a[TOTAL-1]);


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
            dif      <= sub_overflow ? (a[TOTAL-1] ? MIN : MAX) : raw_dif;
            overflow <= sub_overflow;
        end
endmodule
