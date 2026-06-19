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
    parameter INT_BITS   = 16,                      // Numar de biti parte intreaga (include semnul)
    parameter FRAC_BITS  = 12,                      // Numar de biti parte fractionara
    parameter DATA_WIDTH = INT_BITS + FRAC_BITS     // Latime date, biti
)(
    input                       clk,                // Semnal de ceas
    input                       rst_n,              // Reset asincron (activ in 0)
    input      [DATA_WIDTH-1:0] a, b,               // Operanzi in format Q (semnati)
    output reg                  overflow,           // Indicator depasire domeniu numeric (pentru debug/saturatie)
    output reg [DATA_WIDTH-1:0] product             // Rezultat saturat
);

    // ------------------------
    // Limite reprezentabile in format Q (Complement de 2)
    // ------------------------
    
    // MAX: 0 urmat de toti 1 (cel mai mare numar pozitiv)
    // MIN: 1 urmat de toti 0 (cel mai mic numar negativ)
    localparam [DATA_WIDTH-1:0] MAX = {1'b0, {(DATA_WIDTH-1){1'b1}}};
    localparam [DATA_WIDTH-1:0] MIN = {1'b1, {(DATA_WIDTH-1){1'b0}}};

    // -------------------------------------------------------
    // Etapa 1: Inregistrare abs si semn
    // -------------------------------------------------------
    reg [DATA_WIDTH-1:0] abs_a_r, abs_b_r;
    reg                  sign_r;

    // Calculam semnul si valoarea absoluta in mod combinational
    // inainte de a le stoca in registre.
    wire                  sign_w  = a[DATA_WIDTH-1] ^ b[DATA_WIDTH-1];
    wire [DATA_WIDTH-1:0] abs_a_w = a[DATA_WIDTH-1] ? (~a + 1) : a;
    wire [DATA_WIDTH-1:0] abs_b_w = b[DATA_WIDTH-1] ? (~b + 1) : b;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            abs_a_r <= 0;
            abs_b_r <= 0;
            sign_r  <= 0;
        end else begin
            abs_a_r <= abs_a_w;
            abs_b_r <= abs_b_w;
            sign_r  <= sign_w;
        end
    end

    // -------------------------------------------------------
    // Etapa 2: Multiplicare, Shiftare, Overflow si Saturare
    // -------------------------------------------------------
    
    // Multiplicarea numerelor in format virgula fixa
    wire [2*DATA_WIDTH-1:0] raw_product = abs_a_r * abs_b_r;
    
    // Shiftare la dreapta pentru a realinia virgula fixa
    wire [2*DATA_WIDTH-1:0] shifted     = raw_product >> FRAC_BITS;

    // ------------------------
    // Detectie overflow
    // ------------------------

    // 1. OVERFLOW POZITIV:
    // Activ dacă rezultatul teoretic este pozitiv (!sign_r) ȘI există biți de 1 
    // în zona superioară a ferestrei Q (de la bitul de semn DATA_WIDTH-1 în sus).
    // Orice bit de 1 detectat prin operatia de OR-reduction (|) în acest interval
    // înseamnă că valoarea a invadat bitul de semn sau a depășit partea întreagă.
    wire pos_overflow = !sign_r && (|shifted[2*DATA_WIDTH-1:DATA_WIDTH-1]);
    
    // 2. OVERFLOW NEGATIV:
    // Activ dacă rezultatul teoretic este negativ (sign_r) ȘI magnitudinea sa absolută
    // depășește limita inferioară reprezentabilă. Depășirea se declanșează dacă:
    //   - Există biți de 1 dincolo de lățimea standard a cuvântului (|shifted[...:DATA_WIDTH])
    //   - SAU: Valoarea stocată pe cei DATA_WIDTH biți este strict mai mare decât magnitudinea 
    //     limitei MIN. În acest caz, operația ulterioară de complementare (~shifted + 1) ar genera un număr sub limita MIN.
    wire neg_overflow =  sign_r && (|shifted[2*DATA_WIDTH-1:DATA_WIDTH] || 
                                   (shifted[DATA_WIDTH-1:0] > MIN));
    
    wire comb_overflow = pos_overflow || neg_overflow;

    // Calculul rezultatului final (reaplicarea semnului)
    wire [DATA_WIDTH-1:0] neg_result   = ~shifted[DATA_WIDTH-1:0] + 1;
    wire [DATA_WIDTH-1:0] final_result = sign_r ? neg_result : shifted[DATA_WIDTH-1:0];

    // Inregistrarea iesirilor finale (product si overflow)
    // Se aplica saturarea daca comb_overflow este activ.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product  <= 0;
            overflow <= 0;
        end else begin
            product  <= comb_overflow ? (sign_r ? MIN : MAX) : final_result;
            overflow <= comb_overflow;
        end
    end

endmodule // mult_q
