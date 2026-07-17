//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : vga_driver
// Autor      : Petru-Andrei BRASOVEANU
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Genereaza timing standard VGA 640x480 @ 60Hz (pixel clock ~25.175 MHz).
// 
//---------------------------------------------------------------

`timescale 1ns / 1ps

module vga_driver #(   
    parameter COORD_BITS    = 12,
    
    // Timing standard 640x480@60Hz (acestea, impreuna cu FPS-ul, determina ceasul)
    parameter H_FP          = 16,
    parameter H_ACTIVE      = 640,
    parameter H_SYNC        = 96,
    parameter H_BP          = 48,
    
    parameter V_FP          = 10,
    parameter V_ACTIVE      = 480,
    parameter V_SYNC        = 2,
    parameter V_BP          = 33
)(
    input                        pixel_clk,
    input                        rst_n,

    output                       hsync,
    output                       vsync,
    output                       vde,
    output [COORD_BITS-1:0]      pixel_x,
    output [COORD_BITS-1:0]      pixel_y
);


    localparam H_TOTAL = H_ACTIVE + H_FP + H_SYNC + H_BP;
    localparam V_TOTAL = V_ACTIVE + V_FP + V_SYNC + V_BP;

    // polaritate negativa, standard pt 640x480@60Hz
    localparam H_POL = 1'b0;
    localparam V_POL = 1'b0;

    reg [$clog2(H_TOTAL)-1:0] h_cnt;
    reg [$clog2(V_TOTAL)-1:0] v_cnt;

    always @(posedge pixel_clk or negedge rst_n) begin
        if (!rst_n) begin
            h_cnt <= 0;
            v_cnt <= 0;
        end else begin
            if (h_cnt == H_TOTAL - 1) begin
                h_cnt <= 0;
                if (v_cnt == V_TOTAL - 1)
                    v_cnt <= 0;
                else
                    v_cnt <= v_cnt + 1'b1;
            end else begin
                h_cnt <= h_cnt + 1'b1;
            end
        end
    end

    wire h_sync_area = (h_cnt >= H_ACTIVE + H_FP) && (h_cnt < H_ACTIVE + H_FP + H_SYNC);
    wire v_sync_area = (v_cnt >= V_ACTIVE + V_FP) && (v_cnt < V_ACTIVE + V_FP + V_SYNC);
    wire active      = (h_cnt < H_ACTIVE) && (v_cnt < V_ACTIVE);

    assign hsync = h_sync_area ? H_POL : ~H_POL;
    assign vsync = v_sync_area ? V_POL : ~V_POL;
    assign vde   = active;

    assign pixel_x = {{(COORD_BITS-$clog2(H_TOTAL)){1'b0}}, h_cnt};
    assign pixel_y = {{(COORD_BITS-$clog2(V_TOTAL)){1'b0}}, v_cnt};

endmodule // vga_driver
