module add_q_16_16(
    input clk,
    input rst_n,
    input [31:0]  a, b,      // operanzi in format Q16.16 (32-bit signed fixed-point)
    output reg       overflow,  // flag de overflow (folosit pentru debug / monitorizare)
    output reg [31:0] sum        // rezultat Q16.16 cu saturatie
);

    // Limitele pe 32 de biti semnati.
    // In format Q16.16 acestea corespund valorilor maxime/minime reprezentabile
    localparam [31:0] MAX = 32'h7FFF_FFFF; // +32767.99998474121
    localparam [31:0] MIN = 32'h8000_0000; // -32768
    // Fun fact: 8000_0001 este -32767.99998474121
    
    wire [31:0] raw_sum; // Rezultatul brut al adunarii (fara saturatie)
    wire add_overflow; // Flag intern pentru detectarea overflow-ului

    assign raw_sum = a + b; // Adunare aritmetica pe 32 de biti semnati

    // Detectarea overflow-ului la adunare:
    // - overflow apare doar daca a si b au acelasi semn
    // - iar semnul rezultatului difera de semnul operanzilor
    assign add_overflow = (~(a[31] ^ b[31])) & (raw_sum[31] ^ a[31]);

    // Aplicarea saturatiei:
    // - fara overflow -> rezultatul brut este valid
    // - cu overflow:
    //     * a pozitiv  -> suma reala depaseste MAX -> saturatie la MAX
    //     * a negativ  -> suma reala sub MIN       -> saturatie la MIN
    // Semnul lui a (egal cu al lui b) indica directia overflow-ului
    always @(posedge clk or negedge rst_n)
        if (!rst_n ) begin
            sum <= 0;
            overflow <= 1'b0;
        end else begin
            sum <= add_overflow ? (a[31] ? MIN : MAX) : raw_sum;
            overflow <= add_overflow;
        end
endmodule
