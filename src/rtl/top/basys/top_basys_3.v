//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : top_basys_3
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Acesta este modulul de nivel inalt (top-level) al proiectului.
//              Rolul sau principal este de a integra si interconecta toate sub-modulele 
//              sistemului de randare 3D:
// 
//              1. config_block     - Gestioneaza starile, memoriile si datele de intrare.
//              2. top_graphics     - Nucleul grafic care proceseaza si randeaza modelul 3D.
//              3. clk_wiz_0        - Genereaza semnalele de ceas (sistem, pixel si TMDS).
//              4. vga_fb_interface - Interfata intre framebuffer și timer-ul VGA 
//              5. video_timing     - Controleaza timpii de sincronizare pentru rezolutia setata.
//
//              De asemenea, modulul calculeaza adresele pentru citirea din 
//              framebuffer pe baza coordonatelor curente (pixel_x, pixel_y) 
//              si implementeaza o intarziere logica (pipeline delay) a semnalelor 
//              de sincronizare (vde, hsync, vsync) pentru a compensa latenta 
//              de citire din memoria BRAM.
//---------------------------------------------------------------

`timescale 1ns / 1ps
`include "model_params.vh"

module top_basys_3 #(
   
    // --- PARAMETRI MODEL 3D ---
    parameter NUM_VERTICES = `NUM_VERTICES_AUTO,
    parameter NUM_EDGES    = `NUM_EDGES_AUTO,
    
    parameter VERT_FILE    = "vertices_japatext.mem",
    parameter EDGE_FILE    = "edges_japatext.mem",
    
    // --- PARAMETRI ECRAN ---
    parameter WORD_BITS     = 32,
    parameter H_RES         = 640,
    parameter V_RES         = 480,
    parameter FB_WORD_ADDR  = $clog2((H_RES*V_RES)/WORD_BITS)

)(
    input         sys_clk,      // Ceas 100 MHz de pe FPGA
    input   [2:0] sw,           // Switch-uri FPGA
    input         btn_rst,      // Buton Reset
    
    input         btn_left,     // Conectat la W19 (CCW)
    input         btn_right,    // Conectat la T17 (CW)
    input         btn_up,       // Conectat la T18
    input         btn_down,     // Conectat la U17
    
    output        hsync,
    output        vsync,
    output  [3:0] vga_red,
    output  [3:0] vga_green,
    output  [3:0] vga_blue,
    
    output  [3:0] an,           // Anozii celor 4 display-uri
    output  [6:0] seg,          // Catozii (segmentele A-G)
    output        dp,           // Punctul zecimal
 
    output        rst_led       // LED aprins cat timp reset e apasat
);

    localparam FOCAL            = 1;
    localparam CAM_Z            = 1;
    
    localparam COORD_BITS       = 12;
    localparam INT_BITS         = 16;
    localparam FRAC_BITS        = 12;
    localparam DATA_WIDTH       = INT_BITS + FRAC_BITS; 
    
    localparam VERT_ADDR = `VERT_ADDR_AUTO;   // lățimea adresei se calculează automat
    localparam EDGE_ADDR = `EDGE_ADDR_AUTO;   // din numărul curent de vârfuri/muchii
    
    wire pixel_clk;
    wire rst_n = ~btn_rst;
    assign rst_led = btn_rst;

    // Semnale de interconectare Control -> Grafica
    wire                        buffer_mode;
    wire                        start_frame;
    wire                        frame_done;
    wire [VERT_ADDR-1:0]        vertex_count;
    wire [EDGE_ADDR-1:0]        edge_count;
    wire [9:0]                  angle;
    wire [DATA_WIDTH-1:0]       camz;
    wire [DATA_WIDTH-1:0]       focal;

    wire [1:0]                  rotation_type;
    wire                        ready_internal;

    // Magistrale de Incarcare Geometrie
    wire [VERT_ADDR-1:0]        vb_wr_addr;
    wire [3*DATA_WIDTH-1:0]     vb_wr_data;
    wire                        vb_wr_cs;
    wire                        vb_wr_en;

    wire [EDGE_ADDR-1:0]        eb_wr_addr;
    wire [2*VERT_ADDR-1:0]      eb_wr_data; 
    wire                        eb_wr_cs;
    wire                        eb_wr_en;
    
    // Semnale Video Timing
    wire hsync_i, vsync_i, vde;
    wire [11:0] pixel_x, pixel_y;
    
    // Semnale Framebuffer
    wire [FB_WORD_ADDR-1:0] fb_video_addr;
    wire [WORD_BITS-1:0]    fb_video_data;


    // 1. Instantiere Bloc de Configurare Automata
    config_block #(
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS),
        
        .VERT_ADDR(VERT_ADDR),
        .EDGE_ADDR(EDGE_ADDR),
        
        .NUM_VERTICES(NUM_VERTICES),
        .NUM_EDGES(NUM_EDGES),
        .VERT_FILE(VERT_FILE),
        .EDGE_FILE(EDGE_FILE),
        .COORD_BITS(COORD_BITS),
        .H_RES(H_RES),
        .V_RES(V_RES),
        .FOCAL(FOCAL),
        .CAM_Z(CAM_Z),
        .WORD_BITS(WORD_BITS)
    ) u_config  (
        .clk(pixel_clk),
        .rst_n(rst_n),
        
        .sw(sw),
        .btn_left(btn_left),   
        .btn_right(btn_right),  
        .btn_up(btn_up),   
        .btn_down(btn_down),
        .ready(ready_internal),

        .buffer_mode(buffer_mode),
        .start_frame(start_frame),
        .vertex_count(vertex_count),
        .edge_count(edge_count),
        .angle(angle),
        .focal(focal),
        .camz(camz),
        .rotation_type(rotation_type),
        .frame_done(frame_done),

        .vb_wr_addr(vb_wr_addr), .vb_wr_data(vb_wr_data), .vb_wr_cs(vb_wr_cs), .vb_wr_en(vb_wr_en),
        .eb_wr_addr(eb_wr_addr), .eb_wr_data(eb_wr_data), .eb_wr_cs(eb_wr_cs), .eb_wr_en(eb_wr_en)
    );


    // 2. Instantiere Nucleu Grafic 3D
    top_graphics #(
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS),
        
        .VERT_ADDR(VERT_ADDR),
        .EDGE_ADDR(EDGE_ADDR),
        
        .COORD_BITS(COORD_BITS),
        .H_RES(H_RES),
        .V_RES(V_RES),
        
        .FOCAL(FOCAL),
        .CAM_Z(CAM_Z),      
        
        .WORD_BITS(WORD_BITS)
    ) u_graphics_core (
        .clk(pixel_clk),
        .rst_n(rst_n),

        .buffer_mode(buffer_mode),
        .start_frame(start_frame),
        .vertex_count(vertex_count),

        .edge_count(edge_count),
        .angle(angle),
        .focal_in(focal),
        .camz_in(camz),
        .rotation_type(rotation_type),
        .frame_done(frame_done),
        
        .vb_wr_addr(vb_wr_addr), .vb_wr_data(vb_wr_data), .vb_wr_cs(vb_wr_cs), .vb_wr_en(vb_wr_en),
        .eb_wr_addr(eb_wr_addr), .eb_wr_data(eb_wr_data), .eb_wr_cs(eb_wr_cs), .eb_wr_en(eb_wr_en),
        
        .fb_rd_addr(fb_video_addr),
        .fb_rd_data(fb_video_data)
    );


    // 3. Instantiere Generator de Frecvente
    clk_wiz_0 clock_wizard (
        .clk_out1(pixel_clk),       // output: 25.175 MHz 
        .reset(btn_rst),            
        .clk_in1(sys_clk)           // input:  100 MHz
    );
    
    // 4. Video timing
    vga_driver #(
        .H_ACTIVE(H_RES),
        .V_ACTIVE(V_RES),
        .COORD_BITS(COORD_BITS)
    ) u_vt (
        .pixel_clk (pixel_clk),
        .rst_n     (rst_n),
        
        .hsync     (hsync_i),
        .vsync     (vsync_i),
        .vde       (vde),
        .pixel_x   (pixel_x),
        .pixel_y   (pixel_y)
    );
    
    // 5. Logica de Pipelining si Iesire VGA ---
    vga_fb_interface #(
        .WORD_BITS(WORD_BITS),
        .H_RES(H_RES),
        .V_RES(V_RES),
        .FB_WORD_ADDR(FB_WORD_ADDR)
    ) u_vga_pipeline (
        .pixel_clk(pixel_clk),      .rst_n(rst_n),
        
        // De la timing
        .hsync_i(hsync_i),          .vsync_i(vsync_i),
        .vde_i(vde),                .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        
        // Catre/de la grafice (Framebuffer)
        .fb_video_data(fb_video_data),
        .fb_video_addr(fb_video_addr),
        
        // Interne
        .ready_internal(ready_internal),
        
        // Catre pinii FPGA fizici
        .hsync_o(hsync),            .vsync_o(vsync),
        .vga_red(vga_red),          .vga_green(vga_green),
        .vga_blue(vga_blue)
    );
    
    // 6. Afisare FPS ---
    fps_counter u_fps_counter (
        .clk    (pixel_clk),    // Ceasul direct de 25.175MHz de pe pinul W5 al plăcii
        .rst_n  (rst_n),        // Reset general
       // .vsync  (vsync_i),  
        .vsync  (frame_done),    
        .an     (an),          
        .seg    (seg),         
        .dp     (dp)           
    );
    
endmodule // top_basys_3
