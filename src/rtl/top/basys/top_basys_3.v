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
//              1. config_block  - Gestioneaza starile, memoriile si datele de intrare.
//              2. top_graphics  - Nucleul grafic care proceseaza si randeaza modelul 3D.
//              3. clk_wiz_0     - Genereaza semnalele de ceas (sistem, pixel si TMDS).
//              4. video_timing  - Controleaza timpii de sincronizare pentru rezolutia setata.
//
//              De asemenea, modulul calculeaza adresele pentru citirea din 
//              framebuffer pe baza coordonatelor curente (pixel_x, pixel_y) 
//              si implementeaza o intarziere logica (pipeline delay) a semnalelor 
//              de sincronizare (vde, hsync, vsync) pentru a compensa latenta 
//              de citire din memoria BRAM.
//---------------------------------------------------------------

module top_basys_3 #(
   
    // --- PARAMETRI MODEL 3D ---
    parameter NUM_VERTICES = 137,
    parameter NUM_EDGES    = 264,
    
    parameter VERT_FILE    = "vertices_teapot.mem",
    parameter EDGE_FILE    = "edges_teapot.mem",
    
    // --- PARAMETRI ECRAN ---
    parameter WORD_BITS     = 32,
    parameter H_RES         = 640,
    parameter V_RES         = 480,
    parameter FB_WORD_ADDR  = $clog2((H_RES*V_RES)/WORD_BITS)

)(
    input                       sys_clk,        // Ceas 100 MHz de pe FPGA
    input   [3:0]               sw,             // Switch-uri FPGA
    input                       btn_rst,        // Buton Reset
    
    output                      hsync,
    output                      vsync,
    output       [3:0]          vga_red,
    output       [3:0]          vga_green,
    output       [3:0]          vga_blue,
 
    output                      rst_led         // LED aprins cat timp reset e apasat
);


    localparam FOCAL            = 2;
    localparam CAM_Z            = 2;
    
    localparam COORD_BITS       = 12;
    localparam INT_BITS         = 16;
    localparam FRAC_BITS        = 12;
    localparam DATA_WIDTH       = INT_BITS + FRAC_BITS; 
       
    localparam VERT_ADDR        = 8;            // Alocă exact numărul de biți necesar pentru vârfuri
    localparam EDGE_ADDR        = 10;           // Alocă exact numărul de biți necesar pentru muchii



    wire pixel_clk;      // 25.175 MHz
    wire sys_clk_buf;    // acelasi clock, folosit pt pipeline-ul de grafica

    wire rst_n = ~btn_rst;
    assign rst_led = btn_rst;
    assign sys_clk_buf = pixel_clk;

    // Semnale de interconectare Control -> Grafica
    wire                        buffer_mode;
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
    
    wire        hsync_i, vsync_i, vde;
    wire [11:0] pixel_x, pixel_y;
    wire [FB_WORD_ADDR-1:0] fb_video_addr;
    wire [WORD_BITS-1:0]    fb_video_data;
    
    // Adresa framebuffer
    assign fb_video_addr = (pixel_y * (H_RES/WORD_BITS)) + (pixel_x >> 5);

    // In top_zybo_z7, genereaza ready automat
    reg ready_internal;
    
    
    // RGB
    reg [4:0] pixel_x_d;
    always @(posedge pixel_clk) pixel_x_d <= pixel_x[4:0];

    wire pixel_bit = fb_video_data[pixel_x_d];
    
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
        hsync_d <= hsync_i;
        vsync_d <= vsync_i;
    end

    // Iesire culoare directa (fara encoder TMDS): alb pe linii, negru in rest,
    // blancat in afara zonei active
    assign vga_red   = (vde_d && pixel_bit) ? 4'hF : 4'h0;
    assign vga_green = (vde_d && pixel_bit) ? 4'hF : 4'h0;
    assign vga_blue  = (vde_d && pixel_bit) ? 4'hF : 4'h0;
 
    assign hsync = hsync_d;
    assign vsync = vsync_d;


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

        .buffer_mode(buffer_mode),
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

        .buffer_mode(buffer_mode),
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
        .clk_out1(pixel_clk),     // output PIPELINE  74.256 MHz 
        .reset(btn_rst),            // input reset
        .clk_in1(sys_clk)           // input clk_in1 125 MHz
    );
    
    // 4. Video timing
    video_timing_vga #(
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
    

    
endmodule // top_basys_3
