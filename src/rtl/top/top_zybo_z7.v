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
    input                       btn_rst,           // Buton Reset
    // input   [FB_WORD_ADDR-1:0]  fb_rd_addr,     // Adresa unui cuvant din framebuffer
  //  input                       ready,
    
    //output  [WORD_BITS-1:0]     fb_rd_data,     // Datele de iesire din framebuffer
   // output                      frame_done_out,  // Status calculare cadru
    
    output [2:0] tmds_data_p, tmds_data_n,  // HDMI diferential
    output        tmds_clk_p,  tmds_clk_n
);


    localparam FOCAL            = 1;
    localparam CAM_Z            = 2;
    
    localparam COORD_BITS       = 12;
    localparam INT_BITS         = 16;
    localparam FRAC_BITS        = 12;
    localparam DATA_WIDTH       = INT_BITS + FRAC_BITS; 
       
    localparam VERT_ADDR        = 8;    // Alocă exact numărul de biți necesar pentru vârfuri
    localparam EDGE_ADDR        = 10;   // Alocă exact numărul de biți necesar pentru muchii



    wire pixel_clk;      // 74.25 MHz
    wire pixel_clk_5x;   // 371.25 MHz pentru TMDS
    wire sys_clk_buf;    // ceas pipeline (ex. 100 MHz)

    wire rst_n = ~btn_rst;

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
    
   // assign frame_done_out = frame_done;

    wire        hsync, vsync, vde;
    wire [11:0] pixel_x, pixel_y;
    wire [FB_WORD_ADDR-1:0] fb_video_addr;
    wire [WORD_BITS-1:0]    fb_video_data;
    wire locked;
    
    // Adresa framebuffer
    assign fb_video_addr = (pixel_y * (H_RES/WORD_BITS)) + (pixel_x >> 5);

    // In top_zybo_z7, genereaza ready automat
    reg ready_internal;
    
    
    // RGB
    reg [4:0] pixel_x_d;
    always @(posedge pixel_clk) pixel_x_d <= pixel_x[4:0];

    wire pixel_bit = fb_video_data[pixel_x_d];
    wire [23:0] rgb_data = pixel_bit ? 24'hFFFFFF : 24'h000000;
    
    
    always @(posedge pixel_clk or negedge rst_n) begin
        if (!rst_n)
            ready_internal <= 0;
        else
            // ultimul pixel activ: x=H_RES-1, y=V_RES-1
            ready_internal <= (pixel_x == H_RES-1) && (pixel_y == V_RES-1) && vde;
    end
    // conectat la config_block in loc de portul extern ready
    
    // vde/hsync/vsync intarziate cu 1 ciclu pentru a compensa latenta BRAM
    reg vde_d, hsync_d, vsync_d;
    always @(posedge pixel_clk) begin
        vde_d   <= vde;
        hsync_d <= hsync;
        vsync_d <= vsync;
    end

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
        .clk(sys_clk_buf),
        .rst_n(rst_n),
        .sw(sw),
        .ready(ready_internal),

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
        .clk(sys_clk_buf),
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
        
        .fb_rd_addr(fb_video_addr),
        .fb_rd_data(fb_video_data)
    );


    // 3. Instantiere Generator de Frecvente
    clk_wiz_0 clock_wizard (
        // Clock out ports
        .clk_out1(sys_clk_buf),     // output PIPELINE  74.256 MHz 
        .clk_out2(pixel_clk),       // output PIXEL     74.256 MHz
        .clk_out3(pixel_clk_5x),    // output TMDS      371.28 MHz
        // Status and control signals
        .reset(btn_rst),            // input reset
        .locked(locked),            // output locked
        // Clock in ports
        .clk_in1(sys_clk)           // input clk_in1 125 MHz
    );
    
    
    // 4. Video timing
    video_timing u_vt (
        .pixel_clk (pixel_clk),
        .rst_n     (rst_n),
        .hsync     (hsync),
        .vsync     (vsync),
        .vde       (vde),
        .pixel_x   (pixel_x),
        .pixel_y   (pixel_y)
    );
    
    
    // 5. RGB2DVI
    rgb2dvi_0 rgb_to_dvi (
      .TMDS_Clk_p(tmds_clk_p),      // output wire TMDS_Clk_p
      .TMDS_Clk_n(tmds_clk_n),      // output wire TMDS_Clk_n
      .TMDS_Data_p(tmds_data_p),    // output wire [2 : 0] TMDS_Data_p
      .TMDS_Data_n(tmds_data_n),    // output wire [2 : 0] TMDS_Data_n
      
      .aRst(~locked),               // input wire aRst
      
      .vid_pData(rgb_data),         // input wire [23 : 0] vid_pData
      .vid_pVDE(vde_d),               // input wire vid_pVDE
      .vid_pHSync(hsync_d),           // input wire vid_pHSync
      .vid_pVSync(vsync_d),           // input wire vid_pVSync
      
      .PixelClk(pixel_clk),          // input wire PixelClk
      .SerialClk(pixel_clk_5x)       // input wire SerialClk
    );
endmodule
