//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : framebuffer_dbl
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Wrapper peste 2 instante de "framebuffer" (nemodificat), care implementeaza
//              double buffering:
//              - se scrie mereu in bufferul "din spate" (write_buf = ~disp_buf)
//              - se citeste mereu bufferul "din fata" (disp_buf), afisat catre VGA/HDMI
//              - la fiecare puls pe "swap", disp_buf se inverseaza: bufferul tocmai
//              completat devine noul "front", iar urmatoarea desenare merge in celalalt.
//
//          "swap" trebuie conectat la semnalul care marcheaza finalul randarii unui
//          cadru (ex: frame_done din master_controller), NU la vsync direct - vezi
//          nota de mai jos despre limitari.
//---------------------------------------------------------------

`timescale 1ns / 1ps

module framebuffer_dbl #(
    parameter H_RES       = 1280,
    parameter V_RES       = 720,
    parameter WORD_BITS   = 32,
    parameter FB_ADDR_WIDTH = $clog2((H_RES * V_RES) / WORD_BITS)
)(
    input                        clk,
    input                        rst_n,

    // --- Interfata de SCRIERE (de la BU/rasterizator) - merge in bufferul din spate ---
    input                        cs,
    input                        wr,
    input                        clear,
    input  [10:0]                x_in,
    input  [10:0]                y_in,
    input                        pixel_in,
    output                       busy,       // busy-ul bufferului tinta curent (din spate)

    // --- Puls care marcheaza finalul unui cadru: swap disp_buf <-> write_buf ---
    input                        swap,

    // --- Interfata de CITIRE (catre VGA/HDMI) - citeste bufferul din fata ---
    input  [FB_ADDR_WIDTH-1:0]   rd_address,
    output [WORD_BITS-1:0]       rd_dataOut,
    
    output     [2:0]             dbg_fb_i_state,        // Debug stare FSM FB1
    output     [2:0]             dbg_fb_ii_state,       // Debug stare FSM FB2

    // --- Debug: care buffer e afisat curent (0 sau 1) ---
    output                       dbg_disp_buf
);

    // -------------------------------------------------------------------
    // Selectie buffer: disp_buf = bufferul afisat acum (citit de VGA)
    // Bufferul scris e mereu opusul (~disp_buf).
    // -------------------------------------------------------------------
    reg disp_buf;
    wire write_buf = ~disp_buf;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            disp_buf <= 1'b0;
        else if (swap)
            disp_buf <= ~disp_buf;
    end

    assign dbg_disp_buf = disp_buf;

    // -------------------------------------------------------------------
    // Demultiplexare semnale de scriere catre cele 2 instante fizice
    // -------------------------------------------------------------------
    wire cs0    = (write_buf == 1'b0) ? cs    : 1'b0;
    wire wr0    = (write_buf == 1'b0) ? wr    : 1'b0;
    wire clear0 = (write_buf == 1'b0) ? clear : 1'b0;

    wire cs1    = (write_buf == 1'b1) ? cs    : 1'b0;
    wire wr1    = (write_buf == 1'b1) ? wr    : 1'b0;
    wire clear1 = (write_buf == 1'b1) ? clear : 1'b0;

    wire busy0, busy1;
    wire [WORD_BITS-1:0] rd_dataOut0, rd_dataOut1;

    // busy expus in exterior = busy-ul bufferului tinta curent (din spate)
    assign busy = (write_buf == 1'b0) ? busy0 : busy1;

    // rd_dataOut expus in exterior = bufferul afisat curent (din fata)
    assign rd_dataOut = (disp_buf == 1'b0) ? rd_dataOut0 : rd_dataOut1;

    // -------------------------------------------------------------------
    // Cele 2 instante fizice, nemodificate
    // -------------------------------------------------------------------
    framebuffer #(
        .H_RES(H_RES), .V_RES(V_RES), .WORD_BITS(WORD_BITS)
    ) u_fb0 (
        .clk(clk), .rst_n(rst_n),
        .cs(cs0), .wr(wr0), .clear(clear0),
        .x_in(x_in), .y_in(y_in), .pixel_in(pixel_in),
        .rd_address(rd_address), .rd_dataOut(rd_dataOut0),
        .busy(busy0),
        .dbg_clear_addr(), .dbg_state(dbg_fb_i_state)
    );

    framebuffer #(
        .H_RES(H_RES), .V_RES(V_RES), .WORD_BITS(WORD_BITS)
    ) u_fb1 (
        .clk(clk), .rst_n(rst_n),
        .cs(cs1), .wr(wr1), .clear(clear1),
        .x_in(x_in), .y_in(y_in), .pixel_in(pixel_in),
        .rd_address(rd_address), .rd_dataOut(rd_dataOut1),
        .busy(busy1),
        .dbg_clear_addr(), .dbg_state(dbg_fb_ii_state)
    );

endmodule // framebuffer_dbl
