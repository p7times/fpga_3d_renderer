//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : mult_ctrl_q
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Unitatea de Control (FSM) pentru Multiplicatorul Booth.
//              Gestioneaza starile de incarcare, calcul si finalizare.
//---------------------------------------------------------------

module mult_ctrl_q (
    input      clk,      // Semnal de ceas
    input      rst_n,    // Reset asincron (activ in 0)
    input      start,    // Semnal pentru pornirea operatiei de inmultire
    input      done,     // Semnal de finalizare de la Datapath
    output reg ld,       // Comanda incarcare registre (Load)
    output reg valid     // Indica prezenta rezultatului final la iesire
);

    // -----------------------------
    // Definitie stari FSM
    // -----------------------------

    localparam S_IDLE = 2'b00;  // Asteapta semnalul de start
    localparam S_INIT = 2'b01;  // Incarca datele in registrele interne
    localparam S_CALC = 2'b10;  // Calculeaza inmultirea prin pasi Booth
    localparam S_DONE = 2'b11;  // Rezultat final valid

    reg [1:0] state, next_state;


    // -----------------------------
    // Actualizare stare
    // -----------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= S_IDLE;        // reset activ LOW
        else        state <= next_state;
    end


    // -----------------------------
    // Logica combinationala (tranzitii si iesiri)
    // -----------------------------

    always @(*) begin
        ld = 0;
        valid = 0;

        case(state)
            S_IDLE:
                next_state = start ? S_INIT : S_IDLE;

            S_INIT: begin
                ld = 1; // Activam incarcarea datelor in Datapath
                next_state = S_CALC;
            end

            S_CALC:
                next_state = done ? S_DONE : S_CALC;

            S_DONE: begin
                valid = 1; // Rezultatul este stabil si poate fi citit
                next_state = S_IDLE;
            end

            default:
                next_state = S_IDLE;
        endcase
    end

endmodule // mult_ctrl_q