//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : framebuffer
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Buffer de memorie BRAM cu toti pixelii dintr-un cadru video.
//              Memorie organizata pe cuvinte de 32 de pixeli (bit-packed framebuffer),
//              optimizata pentru acces paralel la randare si citire continua pentru
//              controller-ul HDMI.
//
//              Include un FSM dedicat pentru operatia de clear secvential al intregului
//              buffer, precum si mecanism de scriere per-pixel prin mascare pe bit,
//              in functie de coordonatele (x, y) convertite in index liniar.
//
//              Suporta acces dual: port de citire pentru afisare si port de scriere
//              pentru pipeline-ul de rasterizare.
//---------------------------------------------------------------

module framebuffer #(
    parameter H_RES      = 1920,
    parameter V_RES      = 1080,
    parameter WORD_BITS  = 32,                              // biti per cuvant, 32 pixeli per locatie de memorie
    parameter TOTAL_WORDS = (H_RES * V_RES) / WORD_BITS,    // 64800
    parameter ADDR_WIDTH = 17                               // ceil(log2(64800))
)(
    input                       clk,
    input                       rst_n,  // reset asincron, activ 0
    input                       cs,     // chip select
    input                       wr,     // scriere/citire
    input                       clear,  // comanda pentru stergerea framebuffer-ului

    // interfata scriere pixel individual (de la BU)
    input  [10:0]               x_in,       // 0..1919
    input  [10:0]               y_in,       // 0..1079
    input                       pixel_in,   // 0 sau 1

    // interfata citire cuvant (de la HDMI controller)
    input  [ADDR_WIDTH-1:0]     rd_adresa,
    output reg [WORD_BITS-1:0]  rd_dataOut,
    output                      busy,
    output [ADDR_WIDTH-1:0]     dbg_clear_addr,
    output [2:0]                dbg_state         // Flag stare FSM (DEBUG)
);
    

    // ------------------------
    // Definitie stari FSM
    // ------------------------

    localparam IDLE         = 3'b000,   // Asteapta semnalul de start
               CLEARING     = 3'b001,   // Sterge datele din memorie
               WRITE_READ   = 3'b010,   // Pas 1: Cere datele de la BRAM
               WRITE_MODIFY = 3'b011;   // Pas 2: Modifica valoarea si scrie inapoi

    reg [2:0] state, next_state;
    assign dbg_state = state;
    assign dbg_clear_addr = clear_addr;

    // ------------------------------------------------
    // Memorie framebuffer
    // ------------------------------------------------
    reg [WORD_BITS-1:0] mem [0:TOTAL_WORDS-1];

    // ------------------------
    // Parametri locali & Calcul adrese
    // ------------------------
    localparam OFFSET_BITS = $clog2(WORD_BITS);

    wire [$clog2(H_RES*V_RES)-1:0] pixel_index;
    wire [ADDR_WIDTH-1:0] pixel_addr;
    wire [OFFSET_BITS-1:0] bit_offset;
    wire [WORD_BITS-1:0] bit_mask;
    wire in_bounds = (x_in < H_RES) && (y_in < V_RES);

    assign pixel_index = y_in * H_RES + x_in;
    assign pixel_addr = pixel_index >> OFFSET_BITS;
    assign bit_offset = pixel_index[OFFSET_BITS-1:0];
    assign bit_mask = ({{(WORD_BITS-1){1'b0}},1'b1} << bit_offset);

    // ------------------------------------------------
    // Registre interne FSM si semnale Clear
    // ------------------------------------------------
    reg [ADDR_WIDTH-1:0] clear_addr;
    reg clear_d;
    wire clear_start = clear & ~clear_d;

    // Latch-uri pentru a salva datele de intrare pe durata operatiei multi-ciclu
    reg [ADDR_WIDTH-1:0] latched_addr;
    reg [WORD_BITS-1:0]  latched_mask;
    reg                  latched_pixel;

    assign busy = (state != IDLE);


    // ------------------------
    // Logica FSM - Calea de control
    // ------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= IDLE;
        else        state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE:         next_state = clear_start ? CLEARING : ((cs && wr) ? WRITE_READ : IDLE);
            CLEARING:     next_state = (clear_addr == TOTAL_WORDS - 1) ? IDLE : CLEARING;
            WRITE_READ:   next_state = WRITE_MODIFY; // Tranzitie automata spre scriere
            WRITE_MODIFY: next_state = IDLE;         // Scriere finalizata
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

            clear_d <= clear;

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

                CLEARING: begin
                    clear_addr      <= clear_addr + 1'b1;
                end

                // WRITE_READ si WRITE_MODIFY sunt gestionate in blocul dedicat memoriei
            endcase

        end

    end


    // ================================================
    // INFERARE BRAM DUAL-PORT EXACTA
    // ================================================

    // --- Port A (Citire HDMI) ---
    always @(posedge clk) begin
        rd_dataOut <= mem[rd_adresa];
    end

    // --- Port B (Acces FSM pentru Write/Clear) ---
    reg [WORD_BITS-1:0] b_read_data;
    wire port_b_we;
    wire [ADDR_WIDTH-1:0] port_b_addr;
    wire [WORD_BITS-1:0] port_b_data_in;

    // Determinam cand facem scriere
    assign port_b_we = (state == CLEARING) || (state == WRITE_MODIFY);

    // Determinam adresa pentru portul B
    assign port_b_addr = (state == CLEARING) ? clear_addr : 
                         (state == WRITE_READ || state == WRITE_MODIFY) ? latched_addr : clear_addr;

    // Determinam ce date scriem 
    assign port_b_data_in = (state == CLEARING) ? {WORD_BITS{1'b0}} : 
                            (latched_pixel ? (b_read_data | latched_mask) : (b_read_data & ~latched_mask));

    // Blocul fizic de memorie (Port B)
    always @(posedge clk) begin
        if (port_b_we) begin
            mem[port_b_addr] <= port_b_data_in;
        end
        b_read_data <= mem[port_b_addr];
    end

endmodule
