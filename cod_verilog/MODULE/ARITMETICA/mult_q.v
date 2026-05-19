//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : mult_q
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Multiplicator in virgula fixa semnata (signed fixed-point) cu saturatie.
//
//              Realizeaza inmultirea a doua numere in format Q si 
//              reajusteaza rezultatul prin shiftare la dreapta cu 
//              numarul de biti fractionari.
//---------------------------------------------------------------

module mult_q #(
    parameter INT_BITS  = 16,                       // Numar de biti parte intreaga (include semnul)
    parameter FRAC_BITS = 16                        // Numar de biti parte fractionara
)(
    input                               clk,        // Semnal de ceas
    input                               rst_n,      // Reset asincron (activ in 0)
    input [INT_BITS+FRAC_BITS-1:0]      a, b,       // Operanzi in format Q (semnati)
    output reg                          overflow,   // Indicator depasire domeniu numeric (pentru debug/saturatie)
    output reg [INT_BITS+FRAC_BITS-1:0] result      // Rezultat saturat
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


    wire               result_sign;             
    wire [TOTAL-1:0]   abs_a, abs_b;
    wire [2*TOTAL-1:0] raw_product, shifted;
    wire               comb_overflow;


    // ------------------------
    // Determinarea semnului si valorilor absolute
    // ------------------------

    // Inmultirea se face pe valori pozitive pentru a simplifica shiftarea si detectia overflow
    assign result_sign = a[TOTAL-1] ^ b[TOTAL-1];   // Semnul final: XOR intre semnele operanzilor
    assign abs_a = a[TOTAL-1] ? (~a + 1) : a;       // Transformam operanzii in valori pozitive
    assign abs_b = b[TOTAL-1] ? (~b + 1) : b;


    // ------------------------
    // Operatia de inmultire si realiniere
    // ------------------------

    // Produsul a doua numere pe TOTAL biti rezulta in 2*TOTAL biti (ex: 32x32 -> 64 biti)
    assign raw_product = abs_a * abs_b;

    // Realinierea punctului binar: (Q16.16 * Q16.16) = Q32.32
    // Trebuie sa shiftam la dreapta cu FRAC_BITS pentru a reveni la formatul Q16.16
    assign shifted     = raw_product >> FRAC_BITS;


    // ------------------------
    // Detectie overflow (Logica pentru numere semnate)
    // ------------------------

    // Overflow pozitiv: daca bitul de semn e 0 si avem biti de 1 peste limita partii intregi
    wire pos_overflow = !result_sign && (|shifted[2*TOTAL-1 : TOTAL-1]);
    
    // Overflow negativ: verificam daca valoarea depaseste limita minima negativa (MIN)
    wire neg_overflow =  result_sign && (|shifted[2*TOTAL-1 : TOTAL] || 
                                        (shifted[TOTAL-1:0] > MIN));

    assign comb_overflow = pos_overflow || neg_overflow;


    // ------------------------
    // Conversia inapoi in Complement de 2
    // ------------------------

    wire [TOTAL-1:0] neg_result   = ~shifted[TOTAL-1:0] + 1;
    wire [TOTAL-1:0] final_result = result_sign ? neg_result : shifted[TOTAL-1:0];


    // ------------------------
    // Logica secventiala cu saturatie
    // ------------------------

    always @(posedge clk or negedge rst_n)
        if (!rst_n ) begin
            result   <= 0;
            overflow <= 1'b0;
        end else begin
            // Daca detectam overflow, saturam la valoarea extrema corespunzatoare semnului
            result   <= comb_overflow ? (result_sign ? MIN : MAX) : final_result;
            overflow <= comb_overflow;
        end
endmodule
