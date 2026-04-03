module mult_q #(
    parameter INT_BITS  = 16,
    parameter FRAC_BITS = 16
)(
    input                               clk,
    input                               rst_n,     // reset asincron, activ in 0
    input [INT_BITS+FRAC_BITS-1:0]      a, b,      // operanzi in format Q (signed cu virgula fixa)
    output reg                          overflow,  // flag de overflow (pentru debug / saturatie)
    output reg [INT_BITS+FRAC_BITS-1:0] result     // rezultat in format Q, cu saturatie
);

    localparam TOTAL = INT_BITS + FRAC_BITS;

    // Limitele reprezentabile in format Q
    localparam [TOTAL-1:0] MAX = {1'b0, {(TOTAL-1){1'b1}}};
    localparam [TOTAL-1:0] MIN = {1'b1, {(TOTAL-1){1'b0}}}; 
    // In format Q16.16 acestea corespund valorilor
    // MAX = +32767.99998474121 (7FFF_FFFF)
    // MIN = -32768             (8000_0000)

    wire               result_sign;
    wire [TOTAL-1:0]   abs_a, abs_b;
    wire [2*TOTAL-1:0] raw_product, shifted;
    wire               comb_overflow;


    // Aflam bitul de semn al produsului
    assign result_sign = a[TOTAL-1] ^ b[TOTAL-1];

    // Transformam operanzii in valori pozitive
    assign abs_a = a[TOTAL-1] ? (~a + 1) : a;
    assign abs_b = b[TOTAL-1] ? (~b + 1) : b;

    // Produsul brut pe 64 de biti   
    assign raw_product = abs_a * abs_b;
    assign shifted     = raw_product >> FRAC_BITS;

    wire pos_overflow = !result_sign && (|shifted[2*TOTAL-1 : TOTAL-1]);
    wire neg_overflow =  result_sign && (|shifted[2*TOTAL-1 : TOTAL] || 
                                        (shifted[TOTAL-1:0] > MIN));

    assign comb_overflow = pos_overflow || neg_overflow;

    wire [TOTAL-1:0] neg_result   = ~shifted[TOTAL-1:0] + 1;
    wire [TOTAL-1:0] final_result = result_sign ? neg_result : shifted[TOTAL-1:0];

    // Saturare
    always @(posedge clk or negedge rst_n)
        if (!rst_n ) begin
            result   <= 0;
            overflow <= 1'b0;
        end else begin
            result   <= comb_overflow ? (result_sign ? MIN : MAX) : final_result;
            overflow <= comb_overflow;
        end
endmodule
