//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : vga_fb_interface
// Autor      : Petru-Andrei BRASOVEANU
// An         : 2026
//------------------------------------------------------------------------------
// Descriere  : Acest modul realizează interfața dintre framebuffer
//              și controllerul de timing VGA.
// 
//              Rolurile principale sunt:
//              1. Conversia adreselor: Traduce coordonatele ecranului 2D (pixel_x, pixel_y)
//                 în adrese liniare 1D destinate citirii din Framebuffer.
//              2. Demultiplexarea datelor: Extrage bitul de pixel corespunzător din 
//                 cuvântul de memorie pe 32 de biți (WORD_BITS).
//              3. Alinierea temporală (Pipeline Delay): Întârzie semnalele de sincronizare 
//                 (hsync, vsync, vde) cu un ciclu de ceas pentru a compensa latența
//                 de citire de tip 1-clock-cycle a memoriei sincrone BRAM.
//              4. Maparea culorilor: Formatează ieșirile pe 4 biți pentru pinii fizici 
//                 VGA ai FPGA-ului (monocrom: alb pe pixel activ, negru în rest).
//              5. Sincronizarea cadrelor: Detectează ultimul pixel activ al cadrului curent
//                 și generează semnalul 'ready_internal' pentru a declanșa procesarea 
//                 următoarei cadre de geometrie în config_block.
//------------------------------------------------------------------------------

`timescale 1ns / 1ps

module vga_fb_interface #(
    parameter WORD_BITS    = 32,
    parameter H_RES        = 640,
    parameter V_RES        = 480,
    parameter FB_WORD_ADDR = $clog2((H_RES*V_RES)/WORD_BITS)
)(
    input  wire                    pixel_clk,
    input  wire                    rst_n,
    
    // Semnale de la video_timing_vga
    input  wire                    hsync_i,
    input  wire                    vsync_i,
    input  wire                    vde_i,
    input  wire [11:0]             pixel_x,
    input  wire [11:0]             pixel_y,
    
    // Interfața cu Framebuffer-ul (top_graphics)
    input  wire [WORD_BITS-1:0]    fb_video_data,
    output wire [FB_WORD_ADDR-1:0] fb_video_addr,
    
    // Semnal intern de control
    output reg                     ready_internal,
    
    // Semnale de ieșire către pinii fizici VGA
    output wire                    hsync_o,
    output wire                    vsync_o,
    output wire [3:0]              vga_red,
    output wire [3:0]              vga_green,
    output wire [3:0]              vga_blue
);

    // 1. Calculul adresei pentru framebuffer
    assign fb_video_addr = (pixel_y * (H_RES / WORD_BITS)) + (pixel_x >> 5);

    // 2. Extragerea bitului corect și pipelining
    reg [4:0] pixel_x_d;
    always @(posedge pixel_clk) begin
        pixel_x_d <= pixel_x[4:0];
    end

    wire pixel_bit = fb_video_data[pixel_x_d];

    // 3. Generare ready_internal pentru config_block
    always @(posedge pixel_clk or negedge rst_n) begin
        if (!rst_n)
            ready_internal <= 0;
        else
            // Ultimul pixel activ: x=H_RES-1, y=V_RES-1
            ready_internal <= (pixel_x == H_RES-1) && (pixel_y == V_RES-1) && vde_i;
    end

    // 4. Întârzieri (Pipeline) pentru sincronizări ca să compenseze latența BRAM
    reg vde_d, hsync_d, vsync_d;
    always @(posedge pixel_clk) begin
        vde_d   <= vde_i;
        hsync_d <= hsync_i;
        vsync_d <= vsync_i;
    end

    // 5. Ieșiri culoare (alb/negru simplu) și sincronizare
    assign vga_red   = (vde_d && pixel_bit) ? 4'hF : 4'h0;
    assign vga_green = (vde_d && pixel_bit) ? 4'hF : 4'h0;
    assign vga_blue  = (vde_d && pixel_bit) ? 4'hF : 4'h0;

    assign hsync_o = hsync_d;
    assign vsync_o = vsync_d;

endmodule // vga_fb_interface
