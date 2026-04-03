module add_q #(
    parameter INT_BITS  = 16,
    parameter FRAC_BITS = 16
)(
    input                               clk,
    input                               rst_n,     // reset asincron, activ in 0
    input [INT_BITS+FRAC_BITS-1:0]      a, b,      // operanzi in format Q (signed cu virgula fixa)
    output reg                          overflow,  // flag de overflow (folosit pentru debug / saturatie)
    output reg [INT_BITS+FRAC_BITS-1:0] sum        // rezultat in format Q, cu saturatie
);

    localparam WIDTH = INT_BITS + FRAC_BITS;

    // Limitele reprezentabile in format Q
    localparam [WIDTH-1:0] MAX = {1'b0, {(WIDTH-1){1'b1}}};
    localparam [WIDTH-1:0] MIN = {1'b1, {(WIDTH-1){1'b0}}}; 
    // In format Q16.16 acestea corespund valorilor
    // MAX = +32767.99998474121 (7FFF_FFFF)
    // MIN = -32768             (8000_0000)
    
    wire [WIDTH-1:0] raw_sum;      // Rezultatul brut al adunarii (fara saturatie)
    wire             add_overflow; // Flag intern pentru detectarea overflow-ului

    assign raw_sum = a + b;        // Adunare propriu-zisa

    // Detectarea overflow-ului la adunare:
    // - overflow apare doar daca a si b au acelasi semn
    // - iar semnul rezultatului difera de semnul oricarui operand
    assign add_overflow = (~(a[WIDTH-1] ^ b[WIDTH-1])) & (raw_sum[WIDTH-1] ^ a[WIDTH-1]);

    // Aplicarea saturatiei:
    // - daca overflow = 0 -> rezultatul brut este valid
    // - daca overflow = 1:
    //     * a pozitiv  -> suma reala depaseste MAX -> saturatie la MAX
    //     * a negativ  -> suma reala sub MIN       -> saturatie la MIN
    // Semnul lui a (egal cu al lui b) indica directia overflow-ului
    always @(posedge clk or negedge rst_n)
        if (!rst_n ) begin
            sum      <= 0;
            overflow <= 1'b0;
        end else begin
            sum      <= add_overflow ? (a[WIDTH-1] ? MIN : MAX) : raw_sum;
            overflow <= add_overflow;
        end
endmodule
