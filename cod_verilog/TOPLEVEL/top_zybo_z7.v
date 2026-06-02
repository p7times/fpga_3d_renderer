`timescale 1ns / 1ps

module top_zybo_z7 #(
   
    // --- PARAMETRI MODEL 3D ---
    parameter NUM_VERTICES = 16,
    parameter NUM_EDGES    = 24,
    
    parameter VERT_FILE    = "vertices.mem",
    parameter EDGE_FILE    = "edges.mem",
    
    // --- PARAMETRI ECRAN ---
    parameter WORD_BITS     = 32,
    parameter H_RES         = 1280,
    parameter V_RES         = 720,
    parameter FB_WORD_ADDR  = $clog2((H_RES*V_RES)/WORD_BITS)

)(
    input                       sys_clk,        // Ceas 125 MHz de pe FPGA
    input   [3:0]               sw,             // Switch-uri FPGA
    input                       btn0,           // Buton Reset
    input   [FB_WORD_ADDR-1:0]  fb_rd_addr,     // Adresa unui cuvant din framebuffer
    
    output  [WORD_BITS-1:0]     fb_rd_data,     // Datele de iesire din framebuffer
    output                      frame_done_out  // Status calculare cadru
);
    localparam FOCAL            = 1;
    localparam CAM_Z            = 2;
    
    localparam COORD_BITS       = 12;
    localparam INT_BITS         = 16;
    localparam FRAC_BITS        = 16;
    localparam DATA_WIDTH       = INT_BITS + FRAC_BITS; 
       
    localparam VERT_ADDR        = 8;    // Alocă exact numărul de biți necesar pentru vârfuri
    localparam EDGE_ADDR        = 10;   // Alocă exact numărul de biți necesar pentru muchii

    wire rst_n = ~btn0;

    // Semnale de interconectare Control -> Grafica
    wire                        ps_buffer_mode;
    wire                        start_frame;
    wire                        frame_done;
    wire [VERT_ADDR-1:0]        vertex_count;
    wire [EDGE_ADDR-1:0]        edge_count;
    wire [9:0]                  angle;
    wire [2:0]                  rotation_type;

    // Magistrale de Incarcare Geometrie
    wire [VERT_ADDR-1:0]        vb_wr_addr;
    wire [3*DATA_WIDTH-1:0]     vb_wr_data;
    wire                        vb_wr_cs;
    wire                        vb_wr_en;

    wire [EDGE_ADDR-1:0]        eb_wr_addr;
    wire [2*VERT_ADDR-1:0]      eb_wr_data; // 2 x 8biti
    wire                        eb_wr_cs;
    wire                        eb_wr_en;
    
    assign frame_done_out = frame_done;

    // Magistrala de Citire Framebuffer pentru Video Controller

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
        .clk(sys_clk),
        .rst_n(rst_n),
        .sw(sw),

        .ps_buffer_mode(ps_buffer_mode),
        .start_frame(start_frame),
        .vertex_count(vertex_count),
        .edge_count(edge_count),
        .angle(angle),
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
        .clk(sys_clk),
        .rst_n(rst_n),

        .ps_buffer_mode(ps_buffer_mode),
        .start_frame(start_frame),
        .vertex_count(vertex_count),

        .edge_count(edge_count),
        .angle(angle),

        .rotation_type(rotation_type),
        .frame_done(frame_done),
        
        .vb_wr_addr(vb_wr_addr), .vb_wr_data(vb_wr_data), .vb_wr_cs(vb_wr_cs), .vb_wr_en(vb_wr_en),
        .eb_wr_addr(eb_wr_addr), .eb_wr_data(eb_wr_data), .eb_wr_cs(eb_wr_cs), .eb_wr_en(eb_wr_en),
        
        .fb_rd_addr(fb_rd_addr),
        .fb_rd_data(fb_rd_data)
    );

endmodule
