module div_control #(
    parameter N = 32
)(
    input ck,           // Semnal de ceas
    input reset_n,      // Reset asincron activ in 0
    input start,        // Semnal pentru startul operatiei de impărtire
    input done,         // Semnal de final de la datapath
    output reg ld,      // Load registre datapath
    output reg valid    // Rezultat valid
);

// -----------------------------
// DEFINIRE STARI FSM
// -----------------------------
localparam S_IDLE = 2'b00;  // Asteapta start
localparam S_INIT = 2'b01;  // Initializeaza datapath
localparam S_CALC = 2'b10;  // Calculeaza divizarea
localparam S_DONE = 2'b11;  // Rezultat gata

reg [1:0] state, next_state;

// -----------------------------
// ACTUALIZARE STARE
// -----------------------------
always @(posedge ck or negedge reset_n) begin
    if (!reset_n)
        state <= S_IDLE;  // reset activ LOW
    else
        state <= next_state;
end

// -----------------------------
// LOGICA COMBINATIONALA - TRANZITII SI IESIRI
// -----------------------------
always @(*) begin
    ld = 0;
    valid = 0;
    next_state = state;

    case(state)
        S_IDLE:
            next_state = start ? S_INIT : S_IDLE;

        S_INIT: begin
            ld = 1;
            next_state = S_CALC;
        end

        S_CALC:
            next_state = done ? S_DONE : S_CALC;

        S_DONE: begin
            valid = 1;
            next_state = S_IDLE;
        end

        default:
            next_state = S_IDLE;
    endcase
end

endmodule

