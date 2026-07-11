`timescale 1ns / 1ps
//
// video_timing_640x480
// Inlocuieste video_timing (1280x720) din proiectul original.
// Genereaza timing standard VGA 640x480 @ 60Hz (pixel clock ~25.175 MHz).
// Iesirile pixel_x/pixel_y/hsync/vsync/vde sunt COMBINATIONALE (assign),
// la fel ca in varianta originala, ca sa ramana compatibile cu registrele
// vde_d/hsync_d/vsync_d din top_basys_3 care compenseaza latenta de 1 ciclu
// a citirii din framebuffer (BRAM).
//
module video_timing_vga #(
    parameter H_ACTIVE  = 640,
    parameter V_ACTIVE  = 480,
    parameter COORD_BITS = 12
)(
    input                        pixel_clk,
    input                        rst_n,

    output                       hsync,
    output                       vsync,
    output                       vde,
    output [COORD_BITS-1:0]      pixel_x,
    output [COORD_BITS-1:0]      pixel_y
);

    // Timing standard 640x480@60Hz (aceleasi valori ca in vga_driver.v)
    localparam H_FP    = 16;
    localparam H_SYNC  = 96;
    localparam H_BP    = 48;
    localparam H_TOTAL = H_ACTIVE + H_FP + H_SYNC + H_BP;

    localparam V_FP    = 10;
    localparam V_SYNC  = 2;
    localparam V_BP    = 33;
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
    wire active       = (h_cnt < H_ACTIVE) && (v_cnt < V_ACTIVE);

    assign hsync = h_sync_area ? H_POL : ~H_POL;
    assign vsync = v_sync_area ? V_POL : ~V_POL;
    assign vde   = active;

    assign pixel_x = {{(COORD_BITS-$clog2(H_TOTAL)){1'b0}}, h_cnt};
    assign pixel_y = {{(COORD_BITS-$clog2(V_TOTAL)){1'b0}}, v_cnt};
endmodule
