module sub_q #(
    parameter INT_BITS  = 16,
    parameter FRAC_BITS = 16
)(
    input                               clk,
    input                               rst_n,    // reset asincron, activ in 0
    input [INT_BITS+FRAC_BITS-1:0]      a, b,     // operanzi in format Q (signed cu virgula fixa)
    output reg                          overflow, // flag de overflow (pentru debug / saturatie)
    output reg [INT_BITS+FRAC_BITS-1:0] dif       // rezultat in format Q, cu saturatie
);

    localparam TOTAL = INT_BITS + FRAC_BITS;

    // Limitele reprezentabile in format Q
    localparam [TOTAL-1:0] MAX = {1'b0, {(TOTAL-1){1'b1}}};
    localparam [TOTAL-1:0] MIN = {1'b1, {(TOTAL-1){1'b0}}}; 
    // In format Q16.16 acestea corespund valorilor
    // MAX = +32767.99998474121 (7FFF_FFFF)
    // MIN = -32768             (8000_0000)

    wire [TOTAL-1:0] raw_dif;       // Rezultatul brut al scaderii (fara saturatie)
    wire             sub_overflow;  // Flag intern pentru detectarea overflow-ului
    
    assign raw_dif = a - b;         // Scadere propriu-zisa

    // Detectarea overflow-ului la scadere:
    // - overflow apare doar daca a si b au semne diferite
    // - iar semnul rezultatului difera de semnul lui a
    assign sub_overflow = (a[TOTAL-1] ^ b[TOTAL-1]) & (raw_dif[TOTAL-1] ^ a[TOTAL-1]);

    // Aplicarea saturatiei:
    // - daca overflow = 0 -> rezultatul brut este valid
    // - daca overflow = 1:
    //     * a pozitiv  -> diferenta reala depaseste MAX  -> saturatie la MAX
    //     * a negativ  -> diferenta reala sub MIN        -> saturatie la MIN
    // Semnul lui a indica directia reala a overflow-ului
    always @(posedge clk or negedge rst_n)
        if (!rst_n ) begin
            dif      <= 0;
            overflow <= 1'b0;
        end else begin
            dif      <= sub_overflow ? (a[TOTAL-1] ? MIN : MAX) : raw_dif;
            overflow <= sub_overflow;
        end
endmodule
