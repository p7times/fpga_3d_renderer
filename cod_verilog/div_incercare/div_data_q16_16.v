// ======================================================
// Datapath pentru impartire Q16.16
// Implementare de tip restoring / non-restoring division
// Gestioneaza:
//  - semn
//  - overflow
//  - saturare
// ======================================================
module div_data_q16_16 (
    input  wire clk,
    input  wire reset_n,

    // Semnale de control
    input  wire ld,     // initializare
    input  wire step,   // un pas de calcul

    // Operanzi
    input  wire [31:0] a,
    input  wire [31:0] b,

    // Rezultat
    output reg  done,       // calcul terminat
    output reg  [31:0] q,   // cat Q16.16
    output reg  overflow    // flag overflow
);

    // Latimi
    localparam IW = 32;          // input width
    localparam FW = 16;          // fractional width
    localparam AW = IW + FW;     // accumulator width (48)

    // Limite pentru saturare
    localparam [31:0] MAX = 32'sh7FFF_FFFF;
    localparam [31:0] MIN = 32'sh8000_0000;
    
    localparam [AW-1:0] MAX_S = 48'sh0000_7FFF_FFFF;
    localparam [AW-1:0] MIN_S = 48'sh0000_8000_0000;

    // Registre interne
    reg sign;                // semnul rezultatului
    reg [AW-1:0] A;          // registru pentru dividend
    reg [IW-1:0] B;          // divizor (modul)
    reg [AW:0]   P;          // partial remainder
    reg [5:0]    cnt;        // contor de pasi

    // Valori temporare
    reg [AW:0]   Pn;
    reg [AW-1:0] An;

    reg signed [AW-1:0] q_mag;
    reg signed [AW-1:0] q_signed;

    // Logica secventiala
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Reset global
            P <= 0;
            A <= 0;
            B <= 0;
            cnt <= 0;
            sign <= 0;
            done <= 0;
            q <= 0;
            overflow <= 0;
        end

        // ================= INIT =================
        else if (ld) begin
            done <= 0;
            cnt <= 0;
            overflow <= 0;

            // Impartire la zero
            if (b == 0) begin
                q <= a[31] ? MIN : MAX;
                overflow <= 1;
                done <= 1;
            end else begin
                // Determinare semn rezultat
                sign <= a[31] ^ b[31];

                // Modul operandilor
                A <= (a[31] ? -a : a) << FW;
                B <= (b[31] ? -b : b);

                // Partial remainder initial
                P <= 0;
            end
        end

        // ================= STEP =================
        else if (step && !done) begin
            // Shift P si A
            Pn = {P[AW-1:0], A[AW-1]};
            An = {A[AW-2:0], 1'b0};

            // Add / subtract
            if (P[AW])
                Pn = Pn + B;
            else
                Pn = Pn - B;

            // Bit de cat
            An[0] = ~Pn[AW];

            // Update registre
            P <= Pn;
            A <= An;
            cnt <= cnt + 1;

            // ================= FINAL =================
            if (cnt == AW-1) begin
                // Corectie remainder final
                if (Pn[AW])
                    P <= Pn + B;

                // Aplicare semn
                q_mag    = An;
                q_signed = sign ? -q_mag : q_mag;

                // Saturare + overflow
                if (q_signed > MAX_S) begin
                    q <= MAX;
                    overflow <= 1;
                end
                else if (q_signed < MIN_S) begin
                    q <= MIN;
                    overflow <= 1;
                end
                else begin
                    q <= q_signed[31:0];
                end

                done <= 1;
            end
        end
    end

endmodule