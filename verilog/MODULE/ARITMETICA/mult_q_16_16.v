module mult_q_16_16(
  input clk,
  input rst_n,

    input  signed [31:0] a, b,     // operanzi in format Q16.16 (32-bit signed fixed-point)
    output               overflow, // flag de overflow (pentru debug / saturatie)
    output reg [31:0] result       // rezultat Q16.16, cu saturatie
);

    // Limitele pe 32 de biti semnati.
    // In format Q16.16 acestea corespund valorilor maxime/minime reprezentabile
    // dupa saturatie (nu limitelor matematice ±32768).
    localparam signed [31:0] MAX = 32'sh7FFF_FFFF;
    localparam signed [31:0] MIN = 32'sh8000_0000;

    // Produsul brut pe 64 de biti
    wire signed [63:0] raw_product;

    // Scadere propriu-zisa (aritmetica pe 32 de biti semnati)
    assign raw_product = a * b;

    wire signed [63:0] shifted;
    assign shifted = raw_product >>> 16;

    // Detectie overflow
    assign overflow = (shifted[63:31] != {33{shifted[31]}});

    // Saturare

    always @(posedge clk or negedge rst_n)
    if (!rst_n ) result <= 0; else
                 result <= overflow ? (shifted[63] ? MIN : MAX) : shifted[31:0];


endmodule
