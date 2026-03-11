module sub_q_16_16(
    input clk,
    input rst_n,
    input  [31:0] a, b,     // operanzi in format Q16.16 (32-bit signed fixed-point)
    output reg       overflow, // flag de overflow (pentru debug / saturatie)
    output reg [31:0] dif   // rezultat Q16.16, cu saturatie
);

    // Limitele pe 32 de biti semnati.
    // In format Q16.16 acestea corespund valorilor maxime/minime reprezentabile
    localparam [31:0] MAX = 32'h7FFF_FFFF; // +32767.99998474121
    localparam [31:0] MIN = 32'h8000_0000; // -32768
    // Fun fact: 8000_0001 este -32767.99998474121

    wire [31:0] raw_dif; // Rezultatul brut al scaderii (fara saturatie)
    wire sub_overflow;

    // Scadere propriu-zisa (aritmetica pe 32 de biti semnati)
    assign raw_dif = a - b;

    // Detectarea overflow-ului la scadere:
    // - overflow poate aparea doar daca a si b au semne diferite
    // - iar semnul rezultatului difera de semnul lui a
    // Formula este echivalenta cu analiza clasica a overflow-ului
    assign sub_overflow = (a[31] ^ b[31]) & (raw_dif[31] ^ a[31]);

    // Aplicarea saturatiei:
    // - daca overflow = 0 -> rezultatul brut este valid
    // - daca overflow = 1:
    //     * a pozitiv  -> rezultat prea mare  -> saturatie la MAX
    //     * a negativ  -> rezultat prea mic   -> saturatie la MIN
    // Semnul lui a indica directia reala a overflow-ului
    always @(posedge clk or negedge rst_n)
        if (!rst_n ) begin
            dif <= 32'h0;
            overflow <= 1'b0;
        end else begin
            dif <= sub_overflow ? (a[31] ? MIN : MAX) : raw_dif;
            overflow <= sub_overflow;
        end
endmodule
