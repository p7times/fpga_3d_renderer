//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : master_controller
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Controller principal al pipeline-ului grafic.
//
//              Orchestreaza randarea unui frame complet:
//
//                  1. Sterge framebuffer-ul
//                  2. Proceseaza toti vertecșii prin VP
//                     (citeste vertex_buffer -> VP -> point_buffer)
//                  3. Rasterizeaza toate muchiile prin Bresenham
//                     (citeste edge_buffer + point_buffer -> BU -> framebuffer)
//                  4. Semnalizeaza finalizarea cadrului
//
//              Functioneaza ca un scheduler hardware secvential (FSM Moore).
//
//              Valorile geometrice (dimensiuni ecran, focala, camera)
//              sunt primite ca porturi, configurabile din exterior.
//
//              Unghiul de rotatie este primit ca valoare de 10 biti
//              in format jumatati de grad [0..719], calculat in modulul Top.
//
// Interfete:
//              - vertex_buffer : citire {z, y, x} Q16.16
//              - edge_buffer   : citire {idx_b, idx_a}
//              - point_buffer  : scriere/citire {ys, xs} Q16.16
//              - VP            : start/valid/overflow + date geometrice
//              - BU            : start/done + coordonate integer
//              - framebuffer   : clear + busy
//---------------------------------------------------------------

`timescale 1ns / 1ps

module master_controller #(
    parameter INT_BITS      = 16,                                   // Numar de biti parte intreaga (include semnul) 
    parameter FRAC_BITS     = 16,                                   // Numar de biti parte fractionara
    parameter DATA_WIDTH    = INT_BITS + FRAC_BITS,                 // Latime date, biti

    parameter VERT_ADDR     = 8,                                    // Dimensiune adrese buffere: max 2^ADDR_WIDTH locatii    
    parameter EDGE_ADDR     = 10,                                   // Dimensiune adrese buffere: max 2^ADDR_WIDTH locatii
    
    parameter COORD_BITS    = 12,                                   // Biti coordonate integer pentru Bresenham [-2048, +2047]
    parameter H_RES         = 1280,
    parameter V_RES         = 720,
    
    parameter FOCAL         = 1,
    parameter CAM_Z         = 2
    
)(
    input                               clk,                        // Semnal de ceas
    input                               rst_n,                      // Reset asincron (activ in 0)

    //------------------------------------------------------------
    // Control (de la PS sau Top)
    //------------------------------------------------------------
    input                               start_frame,                // Puls: porneste randarea unui frame
    input  [VERT_ADDR-1:0]              vertex_count,               // Numarul de vertecsi din mesh
    input  [EDGE_ADDR-1:0]              edge_count,                 // Numarul de muchii din mesh
    input  [9:0]                        angle,                      // Unghi rotatie: jumatati de grade [0..719]
    input  [DATA_WIDTH-1:0]             focal_in,                   // Distanta focala
    input  [DATA_WIDTH-1:0]             camz_in,                    // Distanta fata de camera
    input  [1:0]                        rotation_type,              // Tip rotatie (SW[2:0])
    output reg                          frame_done,                 // Puls: frame complet randat
    
    //------------------------------------------------------------
    // Interfata vertex_buffer (doar citire)
    // Format: mem[addr] = { z[DW-1:0], y[DW-1:0], x[DW-1:0] }
    //------------------------------------------------------------
    output reg [VERT_ADDR-1:0]          vb_addr,
    output reg                          vb_cs,
    input      [3*DATA_WIDTH-1:0]       vb_data,

    //------------------------------------------------------------
    // Interfata edge_buffer (doar citire)
    // Format: mem[addr] = { idx_b[AW-1:0], idx_a[AW-1:0] }
    //------------------------------------------------------------
    output reg [EDGE_ADDR-1:0]          eb_addr,
    output reg                          eb_cs,
    input      [2*VERT_ADDR-1:0]        eb_data,

    //------------------------------------------------------------
    // Interfata point_buffer (scriere si citire)
    // Format: mem[addr] = { ys[DW-1:0], xs[DW-1:0] }
    //------------------------------------------------------------
    output reg [VERT_ADDR-1:0]          pb_addr,
    output reg                          pb_cs,
    output reg                          pb_wr,
    output reg [2*DATA_WIDTH-1:0]       pb_dataIn,  // {ys, xs}
    input      [2*DATA_WIDTH-1:0]       pb_dataOut,

    //------------------------------------------------------------
    // Interfata Vertex Processor (VP)
    //------------------------------------------------------------
    output reg                          vp_start,
    output reg [DATA_WIDTH-1:0]         vp_x, vp_y, vp_z, vp_f, vp_w, vp_h, vp_cam_z,
    output reg [9:0]                    vp_angle,
    output reg [1:0]                    vp_rotation,
    input      [DATA_WIDTH-1:0]         vp_xs, vp_ys,
    input                               vp_valid,

    //------------------------------------------------------------
    // Interfata Bresenham Unit (BU)
    //------------------------------------------------------------
    output reg                          bu_start,
    output reg signed [COORD_BITS-1:0]  bu_x0, bu_y0, bu_x1, bu_y1,
    input                               bu_done,

    //------------------------------------------------------------
    // Interfata framebuffer
    //------------------------------------------------------------
    output reg                          fb_clear,
    input                               fb_busy,
    
    //------------------------------------------------------------
    // Semnale DEBUG
    //------------------------------------------------------------    
    output [4:0]                        dbg_state,
    output [VERT_ADDR-1:0]              dbg_v_idx,
    output [EDGE_ADDR-1:0]              dbg_e_idx

);

    // -------------------------------------------------------
    // Parametri locali
    // -------------------------------------------------------

    // Valori extreme pentru saturarea coordonatelor la COORD_BITS biti signed
    localparam signed [COORD_BITS-1:0] COORD_MAX    =  (1 << (COORD_BITS-1)) - 1;
    localparam signed [COORD_BITS-1:0] COORD_MIN    = -(1 << (COORD_BITS-1));
    
    localparam [DATA_WIDTH-1:0] SCREEN_W_FP         = H_RES << FRAC_BITS;
    localparam [DATA_WIDTH-1:0] SCREEN_H_FP         = V_RES << FRAC_BITS;

    // ------------------------
    // Definitie stari FSM
    // ------------------------

    localparam
            IDLE          = 5'd0,   // Asteapta semnalul de start

            CLEAR_FB      = 5'd1,   // Trimite clear la framebuffer
            WAIT_CLEAR    = 5'd2,   // Asteapta finalizarea operatiei de clear

            // Loop vertices
            READ_VERTEX   = 5'd3,   // Adreseaza vertex_buffer cu v_idx
            WAIT_VERTEX   = 5'd4,   // Latenta BRAM: date disponibile dupa 1 ciclu
            LATCH_VERTEX  = 5'd5,   // un ciclu extra: vb_data acum valid
            SEND_VP       = 5'd6,   // Incarca date in VP si trimite puls start
            WAIT_VP       = 5'd7,   // Asteapta vp_valid (dureaza ~80 cicluri)
            WRITE_POINT   = 5'd8,   // Scrie {vp_ys, vp_xs} in point_buffer[v_idx]
            NEXT_VERTEX   = 5'd9,   // Incrementeaza v_idx; verifica terminare loop

            // Loop edges
            READ_EDGE     = 5'd10,   // Adreseaza edge_buffer cu e_idx
            WAIT_EDGE     = 5'd11,  // Latenta BRAM
            LATCH_EDGE    = 5'd12,
            READ_PT_A     = 5'd13,  // Citeste point_buffer[idx_a]
            WAIT_PT_A     = 5'd14,  // Latenta BRAM
            LATCH_PT_A    = 5'd15,
            READ_PT_B     = 5'd16,  // Citeste point_buffer[idx_b]
            WAIT_PT_B     = 5'd17,  // Latenta BRAM
            LATCH_PT_B    = 5'd18,
            SEND_BU       = 5'd19,  // Converteste Q16.16->integer, trimite la BU
            WAIT_BU       = 5'd20,  // Asteapta bu_done
            NEXT_EDGE     = 5'd21,  // Incrementeaza e_idx; verifica terminare loop

            DONE          = 5'd22;  // Ridica frame_done pentru un ciclu

    reg [4:0]  state, next_state;
    assign dbg_state = state;


    // -------------------------------------------------------
    // Registre interne
    // -------------------------------------------------------
    reg [VERT_ADDR-1:0] v_idx;         // Contor vertex curent
    reg [EDGE_ADDR-1:0] e_idx;         // Contor muchie curenta
    assign dbg_v_idx = v_idx;
    assign dbg_e_idx = e_idx;

    // Date latched din vertex_buffer
    reg [DATA_WIDTH-1:0] latch_x, latch_y, latch_z;

    // Indecsi latched din edge_buffer
    reg [VERT_ADDR-1:0]  latch_idx_a, latch_idx_b;

    // Coordonate ecran latched din point_buffer pentru cele 2 capete
    reg [DATA_WIDTH-1:0] latch_xs_a, latch_ys_a;
    reg [DATA_WIDTH-1:0] latch_xs_b, latch_ys_b;

    // -------------------------------------------------------
    // Functie de saturare Q16.16 -> COORD_BITS biti signed
    // Extrage partea intreaga [DATA_WIDTH-1:FRAC_BITS] si satureaza
    // la intervalul [COORD_MIN, COORD_MAX]
    // -------------------------------------------------------
    function signed [COORD_BITS-1:0] saturate (input [DATA_WIDTH-1:0] q_val);
        reg signed [INT_BITS-1:0] int_part;
    begin
        int_part = $signed(q_val[DATA_WIDTH-1:FRAC_BITS]);
        if      (int_part > $signed(COORD_MAX)) saturate = COORD_MAX;
        else if (int_part < $signed(COORD_MIN)) saturate = COORD_MIN;
        else                                    saturate = int_part[COORD_BITS-1:0];
    end
    endfunction


    // ------------------------
    // Logica FSM - Calea de control
    // ------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= IDLE;
        else        state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE:           next_state = start_frame ? CLEAR_FB : IDLE;
            CLEAR_FB:       next_state = WAIT_CLEAR;
            WAIT_CLEAR:     next_state = !fb_busy ? READ_VERTEX : WAIT_CLEAR;

            READ_VERTEX:    next_state = WAIT_VERTEX;
            WAIT_VERTEX:    next_state = LATCH_VERTEX;
            LATCH_VERTEX:   next_state = SEND_VP;  
            SEND_VP:        next_state = WAIT_VP;
            WAIT_VP:        next_state = vp_valid ? WRITE_POINT : WAIT_VP;
            WRITE_POINT:    next_state = NEXT_VERTEX;
            NEXT_VERTEX:    next_state = (v_idx + 1 >= vertex_count) ? READ_EDGE : READ_VERTEX;

            READ_EDGE:      next_state = WAIT_EDGE;
            WAIT_EDGE:      next_state = LATCH_EDGE;
            LATCH_EDGE:     next_state = READ_PT_A;
            READ_PT_A:      next_state = WAIT_PT_A;
            WAIT_PT_A:      next_state = LATCH_PT_A;
            LATCH_PT_A:     next_state = READ_PT_B;

            READ_PT_B:      next_state = WAIT_PT_B;
            WAIT_PT_B:      next_state = LATCH_PT_B;
            LATCH_PT_B:     next_state = SEND_BU;
            SEND_BU:        next_state = WAIT_BU;
            WAIT_BU:        next_state = bu_done ? NEXT_EDGE : WAIT_BU;
            NEXT_EDGE:      next_state = (e_idx + 1 >= edge_count) ? DONE : READ_EDGE;

            DONE:           next_state = IDLE;

            default:        next_state = IDLE;
        endcase
    end

    // ------------------------
    // Logica FSM - Calea de date
    // ------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            v_idx       <= 0;
            e_idx       <= 0;

            vb_addr     <= 0; vb_cs    <= 0;
            eb_addr     <= 0; eb_cs    <= 0;
            pb_addr     <= 0; pb_cs    <= 0; pb_wr <= 0; pb_dataIn <= 0;

            vp_start    <= 0;
            vp_x        <= 0; vp_y  <= 0; vp_z     <= 0;
            vp_f        <= 0; vp_w  <= 0; vp_h     <= 0; vp_cam_z <= 0;
            vp_angle    <= 0; vp_rotation <= 0;

            bu_start    <= 0;
            bu_x0       <= 0; bu_y0 <= 0; bu_x1 <= 0; bu_y1 <= 0;

            fb_clear    <= 0;
            frame_done  <= 0;

            latch_x     <= 0; latch_y <= 0; latch_z <= 0;
            latch_idx_a <= 0; latch_idx_b <= 0;
            latch_xs_a  <= 0; latch_ys_a  <= 0;
            latch_xs_b  <= 0; latch_ys_b  <= 0;
        end else begin

            // Semnale cu durata de un ciclu, reset implicit in fiecare ciclu
            vp_start   <= 0;
            bu_start   <= 0;
            fb_clear   <= 0;
            frame_done <= 0;
            pb_wr      <= 0;
            pb_cs      <= 0;
            vb_cs      <= 0;
            eb_cs      <= 0;

            case (state)
                IDLE: begin
                    v_idx <= 0; 
                    e_idx <= 0;
                end

                CLEAR_FB: begin
                    fb_clear <= 1;
                end

                WAIT_CLEAR: begin
                    // Asteapta !fb_busy
                end

                READ_VERTEX: begin
                    vb_addr <= v_idx;
                    vb_cs   <= 1;
                end

                WAIT_VERTEX: begin
                    // nu face nimic, asteapta ca vertex_buffer sa actualizeze dataOut
                end
                
                LATCH_VERTEX: begin
                    latch_z <= vb_data[DATA_WIDTH-1:0];
                    latch_y <= vb_data[2*DATA_WIDTH-1:DATA_WIDTH];
                    latch_x <= vb_data[3*DATA_WIDTH-1:2*DATA_WIDTH];
                end 

                SEND_VP: begin
                    vp_x        <= latch_x;
                    vp_y        <= latch_y;
                    vp_z        <= latch_z;
                    
                    vp_w        <= SCREEN_W_FP;
                    vp_h        <= SCREEN_H_FP;
                    vp_f        <= focal_in;
                    vp_cam_z    <= camz_in;
                    
                    vp_angle    <= angle;
                    vp_rotation <= rotation_type;
                    vp_start    <= 1;
                end

                WRITE_POINT: begin
                    pb_addr  <= v_idx;
                    pb_dataIn <= {vp_xs, vp_ys};
                    pb_cs    <= 1;
                    pb_wr    <= 1;
                end

                NEXT_VERTEX: begin
                    v_idx <= v_idx + 1;
                end

                READ_EDGE: begin
                    eb_addr <= e_idx;
                    eb_cs   <= 1;
                end

                WAIT_EDGE: begin
                end
         
                LATCH_EDGE: begin
                    latch_idx_b <= eb_data[VERT_ADDR-1:0];
                    latch_idx_a <= eb_data[2*VERT_ADDR-1:VERT_ADDR];
                end

                READ_PT_A: begin
                    pb_addr <= latch_idx_a;
                    pb_cs   <= 1;
                end

                WAIT_PT_A: begin
                end
                
                LATCH_PT_A: begin
                    latch_ys_a  <= pb_dataOut[DATA_WIDTH-1:0];
                    latch_xs_a  <= pb_dataOut[2*DATA_WIDTH-1:DATA_WIDTH];
                end

                READ_PT_B: begin
                    pb_addr <= latch_idx_b;
                    pb_cs   <= 1;
                end

                WAIT_PT_B: begin
                end
                
                LATCH_PT_B: begin
                    latch_ys_b <= pb_dataOut[DATA_WIDTH-1:0];
                    latch_xs_b <= pb_dataOut[2*DATA_WIDTH-1:DATA_WIDTH];
                end

                SEND_BU: begin
                    // conversie Q16.16 -> integer (parte intreaga)
                    bu_x0    <= saturate(latch_xs_a);
                    bu_y0    <= saturate(latch_ys_a);
                    bu_x1    <= saturate(latch_xs_b);
                    bu_y1    <= saturate(latch_ys_b);
                    bu_start <= 1;
                end

                NEXT_EDGE: begin
                    e_idx <= e_idx + 1;
                end

                DONE: begin
                    frame_done <= 1;
                end
            endcase
        end
    end

endmodule // master_controller
