module mult_q_16_16(
    input             clk,
    input             rst_n,
    input [31:0]      a, b,      // operanzi in format Q16.16 (32-bit signed fixed-point)
    output reg        overflow,  // flag de overflow (pentru debug / saturatie)
    output reg [31:0] result     // rezultat Q16.16, cu saturatie
);

    // Limitele pe 32 de biti semnati.
    // In format Q16.16 acestea corespund valorilor maxime/minime reprezentabile
    localparam [31:0] MAX = 32'h7FFF_FFFF; // +32767.99998474121
    localparam [31:0] MIN = 32'h8000_0000; // -32768
    // Fun fact: 8000_0001 este -32767.99998474121

    wire result_sign;
    wire [31:0] abs_a, abs_b;
    wire [63:0] raw_product;
    wire [63:0] shifted;
    wire comb_overflow;


    // Aflam bitul de semn al produsului
    assign result_sign = a[31] ^ b[31];

    // Transformam operanzii in valori pozitive
    assign abs_a = a[31] ? (~a + 1) : a;
    assign abs_b = b[31] ? (~b + 1) : b;

    // Produsul brut pe 64 de biti   
    assign raw_product = abs_a * abs_b;
    assign shifted     = raw_product >> 16;

    wire pos_overflow = !result_sign && (|shifted[63:31]);
    wire neg_overflow =  result_sign && (|shifted[63:32] || (shifted[31:0] > 32'h8000_0000));
    assign comb_overflow = pos_overflow || neg_overflow;

    wire [31:0] neg_result  = ~shifted[31:0] + 1;
    wire [31:0] final_result = result_sign ? neg_result : shifted[31:0];

    // Saturare
    always @(posedge clk or negedge rst_n)
        if (!rst_n ) begin
            result <= 32'h0;
            overflow <= 1'b0;
        end else begin
            result <= comb_overflow ? (result_sign ? MIN : MAX) : final_result;
            overflow <= comb_overflow;
        end
endmodule
