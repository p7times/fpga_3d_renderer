//---------------------------------------------------------------
// Proiect    : Grafica 3D implementata pe FPGA
//
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Sumator in virgula fixa semnata (signed fixed-point).
//
//              Implementeaza logica de saturatie: rezultatul este
//              limitat la MAX sau MIN in caz de overflow, evitand
//              fenomenul de wrap-around aritmetic.
//---------------------------------------------------------------

module add_q #(
    parameter INT_BITS  = 16,                       // Numar de biti parte intreaga (include semnul)
    parameter FRAC_BITS = 16                        // Numar de biti parte fractionara
)(
    input                               clk,        // Semnal de ceas
    input                               rst_n,      // Reset asincron (activ in 0)
    input [INT_BITS+FRAC_BITS-1:0]      a, b,       // Operanzi in format Q (semnati)
    output reg                          overflow,   // Indicator depasire domeniu numeric (pentru debug/saturatie)
    output reg [INT_BITS+FRAC_BITS-1:0] sum         // Rezultat saturat
);

    localparam WIDTH = INT_BITS + FRAC_BITS;


    // ------------------------
    // Limite reprezentabile in format Q (Complement de 2)
    // ------------------------

    // MAX: 0 urmat de 1-uri (cel mai mare numar pozitiv)
    // MIN: 1 urmat de 0-uri (cel mai mic numar negativ)
    localparam [WIDTH-1:0] MAX = {1'b0, {(WIDTH-1){1'b1}}};
    localparam [WIDTH-1:0] MIN = {1'b1, {(WIDTH-1){1'b0}}}; 


    // ------------------------
    // Semnale pentru calculul aritmetic
    // ------------------------

    wire [WIDTH-1:0] raw_sum;      // Rezultatul brut al adunarii
    wire             add_overflow; // Flag intern pentru detectare overflow

    assign raw_sum = a + b;        // Adunare aritmetica standard


    // ------------------------
    // Detectie overflow (Logica pentru numere semnate)
    // ------------------------

    // 1. Operanzii au acelasi semn: (~(a[MSB] ^ b[MSB]))
    // 2. Semnul rezultatului difera de semnul operanzilor: (raw_sum[MSB] ^ a[MSB])
    // Daca ambele conditii sunt adevarate, inseamna ca am depasit domeniul numeric
    assign add_overflow = (~(a[WIDTH-1] ^ b[WIDTH-1])) & (raw_sum[WIDTH-1] ^ a[WIDTH-1]);


    // ------------------------
    // Logica secventiala cu saturatie
    // ------------------------

    always @(posedge clk or negedge rst_n)
        if (!rst_n ) begin
            sum      <= 0;
            overflow <= 1'b0;
        end else begin
            // Saturatie: daca add_overflow e activ, alegem MIN sau MAX in functie
            // de semnul operandului 'a' (care este acelasi cu semnul lui 'b')
            sum      <= add_overflow ? (a[WIDTH-1] ? MIN : MAX) : raw_sum;
            overflow <= add_overflow;
        end
endmodule
