// ======================================================
// Modul de control pentru divizor
// Gestioneaza:
//  - handshake-ul in_valid / in_ready
//  - secventa de initializare
//  - ciclurile de calcul
//  - handshake-ul out_valid / out_ready
// ======================================================
module div_control (
    input  wire clk,
    input  wire reset_n,

    // Interfata de intrare
    input  wire in_valid,   // intrare valida de la upstream
    output wire in_ready,   // controlerul este liber sa accepte date

    // Semnale de la datapath
    input  wire done,       // calculul s-a terminat
    input  wire out_ready,  // downstream este gata sa primeasca rezultatul

    // Semnale de control catre datapath
    output reg  ld,         // load / initializare
    output reg  step,       // executa un pas de calcul
    output reg  out_valid   // rezultatul este valid
);

    // Stari FSM
    localparam IDLE = 2'b00,   // asteapta input
               INIT = 2'b01,   // initializeaza registrele
               CALC = 2'b10,   // calculeaza impartirea
               DONE = 2'b11;   // rezultat gata

    reg [1:0] state, next;

    // Ready este activ doar in starea IDLE
    assign in_ready = (state == IDLE);

    // Registrul de stare
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next;
    end

    // Logica combinationala FSM
    always @(*) begin
        // valori default
        ld = 0;
        step = 0;
        out_valid = 0;
        next = state;

        case (state)
            // ================= IDLE =================
            // Asteapta un input valid
            IDLE:
                if (in_valid)
                    next = INIT;

            // ================= INIT =================
            // Initializeaza datapath-ul
            INIT: begin
                ld = 1;
                next = CALC;
            end

            // ================= CALC =================
            // Executa pasi de impartire
            CALC: begin
                step = 1;
                if (done)
                    next = DONE;
            end

            // ================= DONE =================
            // Rezultatul este valid
            DONE: begin
                out_valid = 1;
                if (out_ready)
                    next = IDLE;
            end
        endcase
    end

endmodule