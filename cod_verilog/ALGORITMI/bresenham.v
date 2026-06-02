//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : bresenham
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Modul hardware pentru desenarea liniilor utilizand
//              algoritmul Bresenham.
//
//              Acesta calculeaza iterativ pixelii unui segment
//              definit de doua coordonate si transmite rezultatele
//              catre framebuffer printr-o interfata sincronizata.
//
//              Implementarea utilizeaza:
//                - aritmetica integer semnata
//                - masina de stari finite (FSM)
//                - control al accesului la framebuffer
//                - verificare a limitelor de afisare
//
//              Ideea principala:
//
//                  - se porneste din punctul (x0, y0)
//                  - la fiecare pas se decide daca:
//                      * avansam pe axa X
//                      * avansam pe axa Y
//                      * sau pe ambele
//
//              Decizia este luata pe baza unei erori acumulate:
//
//                      err = dx + dy
//
//              unde:
//                      dx = |x1 - x0|
//                      dy = -|y1 - y0|
//
//              Variabila e2 = 2 * err determina directia urmatorului pas.
//
//              Sunt suportate:
//                - linii in orice directie
//                - clipping implicit prin verificare bounds
//                - sincronizare cu framebuffer prin semnalul busy
//---------------------------------------------------------------

module bresenham #(
    parameter COORD_BITS = 12,              // Numar biti coordonate: interval -2048 .. +2047
    parameter H_RES      = 1920,            // Rezolutie orizontala in pixeli
    parameter V_RES      = 1080             // Rezolutie verticala in pixeli
)(
    input                           clk,    // Semnal de ceas
    input                           rst_n,  // Reset asincron (activ in 0)
    input                           start,  // Puls start desenare linie

    // Coordonate intrare - integer, convertite din Q16.16 de controller
    input signed [COORD_BITS-1:0]     x0_in, y0_in,     // 12 biti signed
    input signed [COORD_BITS-1:0]     x1_in, y1_in,

    // Interfata framebuffer
    output reg [COORD_BITS-1:0]     fb_x,
    output reg [COORD_BITS-1:0]     fb_y,

    output reg                      fb_cs,              // Chip select framebuffer
    output reg                      fb_wr,              // Comanda scriere/citire framebuffer
    input                           fb_busy,            // Semnal ca framebuffer-ul e inca ocupat

    output reg                      done,               // Puls finalizare linie
    output [2:0]                    dbg_state           // Debug stare FSM
);

    // ------------------------
    // Definitie stari FSM
    // ------------------------
    localparam IDLE       = 3'b000,     // Asteapta semnalul de start
               LOAD       = 3'b001,     // Initializeaza parametrii Bresenham
               DRAW_PIXEL = 3'b010,     // Trimite pixel catre framebuffer (daca e in bounds)
               DRAW_WAIT  = 3'b011,     // Asteapta framebuffer-ul sa termine
               DRAW_STEP  = 3'b100,     // Actualizeaza algoritmul Bresenham
               DONE_ST    = 3'b101;     // Semnalizeaza finalizarea

    reg [2:0] state, next_state;
    assign dbg_state = state;


    // ------------------------
    // Registre Bresenham
    // ------------------------
    reg signed [COORD_BITS-1:0]   x0, y0, x1, y1; // Coordonate linie

    reg signed [COORD_BITS+1:0]   dx;             //  abs(x1-x0), mereu pozitiv
    reg signed [COORD_BITS+1:0]   dy;             // -abs(y1-y0), mereu negativ sau 0

    //-----------------------------------------------------------
    //
    // sx:
    //      +1 -> dreapta
    //      -1 -> stanga
    //
    // sy:
    //      +1 -> jos
    //      -1 -> sus
    //-----------------------------------------------------------

    reg signed [1:0]            sx, sy;         // directii incrementare: +1 / -1
    reg signed [COORD_BITS+1:0] err;            // eroare acumulata, signed 13 biti (poate depasi dimensiunea coordonatelor)


    // ------------------------
    // Semnale combinatoriale
    // ------------------------

    // e2 = 2 * err: shift-left utilizat in locul inmultirii
    wire signed [COORD_BITS+2:0] e2 = err <<< 1;

    //-----------------------------------------------------------
    // Conditii Bresenham
    //-----------------------------------------------------------
    //
    // IMPORTANT:
    //
    // cond_x si cond_y NU sunt mutual exclusive.
    //
    // Pentru anumite pante:
    //      ambele pot fi adevarate simultan.
    //
    // Acest lucru produce deplasare diagonala:
    //
    //      x += sx
    //      y += sy
    //
    // astfel algoritmul suporta toate octantele.
    //-----------------------------------------------------------
    wire cond_x = (e2 >= $signed(dy));
    wire cond_y = (e2 <= $signed(dx));

    // Verificare daca pixelul curent e in ecran (pixelii din afara ecranului NU sunt trimisi catre framebuffer)
    wire in_bounds = (x0 >= 0) && (x0 < H_RES) && (y0 >= 0) && (y0 < V_RES);

    // Verificare daca am ajuns la capatul liniei
    wire reached_end = (x0 == x1) && (y0 == y1);


    // ------------------------
    // FSM - Calea de control
    // ------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= IDLE;
        else        state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE:       next_state = start ? LOAD : IDLE;                   // Asteapta start
            LOAD:       next_state = DRAW_PIXEL;                            // Initializare algoritm
            DRAW_PIXEL: next_state = in_bounds ? DRAW_WAIT : DRAW_STEP;     // Trimite pixel la framebuffer
            DRAW_WAIT:  next_state = !fb_busy ? DRAW_STEP : DRAW_WAIT;      // Asteapta framebuffer 
            DRAW_STEP:  next_state = reached_end ? DONE_ST : DRAW_PIXEL;    // Actualizare Bresenham
            DONE_ST:    next_state = IDLE;                                  // Linie finalizata
            default:    next_state = IDLE;  
        endcase
    end


    // ------------------------
    // FSM - Calea de date
    // ------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x0   <= 0; y0  <= 0;
            x1   <= 0; y1  <= 0;
            dx   <= 0; dy  <= 0;
            sx   <= 0; sy  <= 0;
            err  <= 0;
            fb_x <= 0; fb_y <= 0;
            fb_cs <= 1'b0;
            fb_wr <= 1'b0;
            done  <= 1'b0;
        end else begin
            case (state)

                IDLE: begin
                    done  <= 1'b0; // done este puls sincron de un singur ciclu
                    fb_cs <= 1'b0;
                    fb_wr <= 1'b0;
                end

                LOAD: begin
                    // Latch coordonate
                    x0 <= x0_in;
                    y0 <= y0_in;
                    x1 <= x1_in;
                    y1 <= y1_in;

                    // dx = abs(x1-x0) - mereu pozitiv
                    dx <= (x1_in >= x0_in) ? (x1_in - x0_in) : (x0_in - x1_in);

                    // dy = -abs(y1-y0) - mereu negativ
                    dy <= (y1_in >= y0_in) ? -(y1_in - y0_in) : -(y0_in - y1_in);

                    // directii de parcurgere
                    sx <= (x0_in < x1_in) ? 1 : -1;
                    sy <= (y0_in < y1_in) ? 1 : -1;

                    // err = dx + dy - calculat direct din intrari
                    err <= ((x1_in >= x0_in) ? (x1_in - x0_in) : (x0_in - x1_in)) +
                           ((y1_in >= y0_in) ? -(y1_in - y0_in) : -(y0_in - y1_in));
                end

                DRAW_PIXEL: begin
                    fb_x <= x0[COORD_BITS-1:0];
                    fb_y <= y0[COORD_BITS-1:0];
                    if (in_bounds) begin
                        fb_cs <= 1'b1;
                        fb_wr <= 1'b1;
                    end
                end

                DRAW_WAIT: begin
                    // Dezactiveaza pulsul de scriere dupa primul ciclu
                    fb_cs <= 1'b0;
                    fb_wr <= 1'b0;
                end

                DRAW_STEP: begin
                    fb_cs <= 1'b0;
                    fb_wr <= 1'b0;

                    // Ambele conditii pot fi adevarate simultan
                    // err acumulat combinat intr-un singur ciclu
                    err <= err + (cond_x ? dy : 0)
                               + (cond_y ? dx : 0);

                    x0 <= x0 + (cond_x ? $signed(sx) : 0);
                    y0 <= y0 + (cond_y ? $signed(sy) : 0);
                end

                DONE_ST: begin
                    done <= 1'b1;
                end

            endcase
        end
    end

endmodule // bresenham