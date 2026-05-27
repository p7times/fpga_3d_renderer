//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : framebuffer
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Modul framebuffer implementat folosind Block RAM (BRAM)
//              inferat automat de sintetizator.
//
//              Memoria stocheaza un framebuffer monocrom binar,
//              unde fiecare bit reprezinta un pixel.
//
//              Organizare memorie:
//                  - 1 cuvant = 32 pixeli
//                  - fiecare pixel ocupa 1 bit
//                  - framebuffer "bit-packed"
//
//              Functionalitati:
//                  - scriere individuala de pixeli
//                  - citire continua pentru HDMI controller
//                  - stergere completa a framebuffer-ului
//
//              Arhitectura:
//                  - Dual-port BRAM
//                      * Port A -> citire HDMI
//                      * Port B -> scriere / clear FSM
//
//              Scrierea unui pixel necesita operatie Read-Modify-Write:
//                  1. se citeste cuvantul din BRAM
//                  2. se modifica bitul dorit
//                  3. se scrie inapoi cuvantul modificat
//---------------------------------------------------------------

module framebuffer #(
    parameter H_RES       = 1920,                           // Rezolutie orizontala in pixeli
    parameter V_RES       = 1080,                           // Rezolutie verticala in pixeli
    parameter WORD_BITS   = 32,                             // Numar de biti per cuvant BRAM (32 biti = 32 pixeli monocromi)
    parameter TOTAL_WORDS = (H_RES * V_RES) / WORD_BITS,    // Numarul total de cuvinte in memorie (64800)
    parameter ADDR_WIDTH = $clog2(TOTAL_WORDS)              // Numarul minim de biti necesari pentru adresare
)(
    input                       clk,                        // Semnal de ceas
    input                       rst_n,                      // Reset asincron (activ in 0)
    input                       cs,                         // Chip select
    input                       wr,                         // Scriere/citire
    input                       clear,                      // Comanda pentru stergerea framebuffer-ului

    // Interfata scriere pixel individual (de la BU)
    input  [10:0]               x_in,               // 0..1919
    input  [10:0]               y_in,               // 0..1079
    input                       pixel_in,           // Valoare pixel: 0 -> negru, 1 -> alb

    // Interfata citire HDMI
    input      [ADDR_WIDTH-1:0] rd_adresa,
    output reg [WORD_BITS-1:0]  rd_dataOut,

    // Semnale status/debug
    output                      busy,
    output     [ADDR_WIDTH-1:0] dbg_clear_addr,     // Debug FSM clear
    output     [2:0]            dbg_state           // Debug stare FSM
);
    
    // ------------------------
    // Definitie stari FSM
    // ------------------------

    localparam IDLE         = 3'd0,   // Asteapta semnalul de start
               CLEARING     = 3'd1,   // Sterge datele din memorie
               WRITE_READ   = 3'd2,   // Pas 1: Cere datele de la BRAM (cuvantul care contine pixelul)
               WRITE_MODIFY = 3'd3;   // Pas 2: Modifica bitul si scrie inapoi

    reg [2:0] state, next_state;
    assign dbg_state = state;
    assign dbg_clear_addr = clear_addr;


    // ------------------------------------------------
    // Memorie framebuffer
    // ------------------------------------------------

    // mem[word_address] (fiecare locatie contine 32 pixeli)
    reg [WORD_BITS-1:0] mem [0:TOTAL_WORDS-1];


    //-----------------------------------------------------------
    // CALCUL ADRESA PIXEL
    //-----------------------------------------------------------
    //
    // pixel_index = y * H_RES + x
    //
    // Exemplu:
    //   pixel (40,2)
    //
    //   index = 2*1920 + 40 = 3880
    //
    // Din index:
    //   - pixel_addr = index / 32 = 1940
    //   - bit_offset = index % 32 = 0
    //-----------------------------------------------------------

    localparam OFFSET_BITS = $clog2(WORD_BITS);

    wire [$clog2(H_RES*V_RES)-1:0] pixel_index;         // Index liniar pixel
    wire [ADDR_WIDTH-1:0]          pixel_addr;          // Adresa cuvantului BRAM
    wire [OFFSET_BITS-1:0]         bit_offset;          // Pozitia bitului in cuvant
    wire [WORD_BITS-1:0]           bit_mask;            // Masca pentru modificarea pixelului
    wire in_bounds = (x_in < H_RES) && (y_in < V_RES);  // Protectie coordonate invalide

    assign pixel_index = y_in * H_RES + x_in;
    assign pixel_addr = pixel_index >> OFFSET_BITS;
    assign bit_offset = pixel_index[OFFSET_BITS-1:0];

    // Exemplu: bit_offset = 5 -> bit_mask = 0000000000100000
    assign bit_mask = ({{(WORD_BITS-1){1'b0}},1'b1} << bit_offset);


    // ------------------------------------------------
    // Registre interne FSM si semnale Clear
    // ------------------------------------------------

    reg [ADDR_WIDTH-1:0] clear_addr;
    reg clear_d;                            // Delay pentru detectie front pozitiv clear
    wire clear_start = clear & ~clear_d;    // Puls un singur ciclu la activarea clear

    // Latch-uri pentru a salva datele de intrare (local) deoarece operatia
    // Read-Modify-Write dureaza mai multe cicluri.
    reg [ADDR_WIDTH-1:0] latched_addr;
    reg [WORD_BITS-1:0]  latched_mask;
    reg                  latched_pixel;

    assign busy = (state != IDLE);          // Modul ocupat daca FSM nu este in IDLE


    // ------------------------
    // Logica FSM - Calea de control
    // ------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= IDLE;
        else        state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE:         next_state = clear_start ? CLEARING : ((cs && wr) ? WRITE_READ : IDLE);   // Asteptare comenzi
            CLEARING:     next_state = (clear_addr == TOTAL_WORDS - 1) ? IDLE : CLEARING;           // Stergere secventiala a framebuffer-ului
            WRITE_READ:   next_state = WRITE_MODIFY;                                                // Citire BRAM
            WRITE_MODIFY: next_state = IDLE;                                                        // Scriere BRAM
            default:      next_state = IDLE;
        endcase
    end


    // ------------------------------------------------
    // Logica FSM - Calea de date
    // ------------------------------------------------
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            clear_d    <= 1'b0;
            clear_addr <= {ADDR_WIDTH{1'b0}};

            latched_addr  <= {ADDR_WIDTH{1'b0}};
            latched_mask  <= {WORD_BITS{1'b0}};
            latched_pixel <= 1'b0;
        end
        else begin

            clear_d <= clear;   // memoram clear pentru edge detect

            case (state)
                IDLE: begin
                    if (clear_start) clear_addr <= 0;

                    // Salvam intrarile pentru a nu depinde de sursa pe parcursul scrierii
                    if (cs && wr && in_bounds) begin
                        latched_addr  <= pixel_addr;
                        latched_mask  <= bit_mask;
                        latched_pixel <= pixel_in;
                    end
                end

                // Incrementare adresa clear
                CLEARING: begin
                    clear_addr <= clear_addr + 1'b1;
                end

            endcase

        end

    end


    // ------------------------------------------------
    // Port A (Citire HDMI)
    // ------------------------------------------------

    always @(posedge clk) begin
        rd_dataOut <= mem[rd_adresa];
    end


    // ------------------------------------------------
    // Port B (Acces FSM pentru Write/Clear)
    // ------------------------------------------------

    reg [WORD_BITS-1:0] b_read_data;
    wire port_b_we;
    wire [ADDR_WIDTH-1:0] port_b_addr;
    wire [WORD_BITS-1:0] port_b_data_in;

    // Write Enable
    assign port_b_we = (state == CLEARING) || (state == WRITE_MODIFY);

    // Selectie adresa
    assign port_b_addr = (state == CLEARING) ? clear_addr : 
                         (state == WRITE_READ || state == WRITE_MODIFY) ? latched_addr : clear_addr;

    // Date scrise in BRAM: pixel_in = 1: seteaza bitul, pixel_in = 0: sterge bitul
    assign port_b_data_in = (state == CLEARING) ? {WORD_BITS{1'b0}} : 
                            (latched_pixel ? (b_read_data | latched_mask) : (b_read_data & ~latched_mask));


    // Inferare Block RAM dual-port:
    always @(posedge clk) begin
        if (port_b_we) begin
            mem[port_b_addr] <= port_b_data_in;     // Scriere
        end
        b_read_data <= mem[port_b_addr];            // Citire
    end

endmodule // framebuffer
