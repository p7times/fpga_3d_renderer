//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : top_graphics
// Autor      : Petru-Andrei BRASOVEANU
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Top-level al pipeline-ului grafic.
//              Instantiaza si conecteaza toate submodulele:
//                  vertex_buffer, edge_buffer, point_buffer,
//                  vertex_processor, bresenham, framebuffer,
//                  master_controller
//
//              Porturile externe sunt impartite in:
//                  - Porturi de control
//                  - Porturi de incarcare date (scriere buffere)
//                  - Port de citire framebuffer
//---------------------------------------------------------------

`timescale 1ns / 1ps

module top_graphics #(
    parameter INT_BITS      = 16,                       // Numar de biti parte intreaga (include semnul)
    parameter FRAC_BITS     = 16,                       // Numar de biti parte fractionara
    parameter DATA_WIDTH    = INT_BITS + FRAC_BITS,     // Latime date coordinate (Q16.16)

    parameter VERT_ADDR     = 8,
    parameter EDGE_ADDR     = 10,
    
    parameter COORD_BITS    = 12,
    parameter H_RES         = 1280,
    parameter V_RES         = 720,
    
    parameter FOCAL         = 1,
    parameter CAM_Z         = 2,
    
    parameter WORD_BITS     = 32,    
    parameter FB_ADDR_WIDTH = $clog2((H_RES*V_RES)/WORD_BITS)
)(

    // ---------------- CONTROL ----------------
    input                       clk,
    input                       rst_n,
    
    input                       buffer_mode,    
    input                       start_frame,
    input  [FB_ADDR_WIDTH-1:0]  fb_rd_addr,
  
    // ---------------- DATE ----------------

    input  [VERT_ADDR-1:0]      vertex_count,
    input  [EDGE_ADDR-1:0]      edge_count,
    
    input  [9:0]                angle,
    input  [DATA_WIDTH-1:0]     focal_in,                  
    input  [DATA_WIDTH-1:0]     camz_in,                 
    input  [1:0]                rotation_type,
    
    input  [3*DATA_WIDTH-1:0]   vb_wr_data,
    input  [2*VERT_ADDR-1:0]    eb_wr_data,


    // ---------------- BUFFER WRITE INTERFACE ----------------
    input  [VERT_ADDR-1:0]      vb_wr_addr,
    input                       vb_wr_cs,
    input                       vb_wr_en,

    input  [EDGE_ADDR-1:0]      eb_wr_addr,
    input                       eb_wr_cs,
    input                       eb_wr_en,
    
    // ---------------- OUTPUT-URI ----------------    
    output                      frame_done,      
    output [WORD_BITS-1:0]      fb_rd_data
);
    
    // ---------------- DEBUG ----------------
    wire [4:0]              dbg_mc_state;   // starea master_controller-ului
    wire [3:0]              dbg_vp_state;   // starea procesorului de vertecsi
    wire [2:0]              dbg_bu_state;   // starea unitatii Bresenham
    wire                    dbg_fb_state;   // starea double-framebuffer-ului
    
    wire [VERT_ADDR-1:0]    dbg_v_idx;      // ce vertex se proceseaza
    wire [EDGE_ADDR-1:0]    dbg_e_idx;      // ce muchie se proceseaza
    
    wire                    dbg_vp_valid;   // semnal finalizare VP
    wire                    dbg_bu_done;    // semnal finalizare BU
    wire                    dbg_overflow;


    // ---------------- VERTEX BUFFER ----------------
    wire [VERT_ADDR-1:0]    vb_addr_mc;
    wire                    vb_cs_mc;
    wire [3*DATA_WIDTH-1:0] vb_data_mc;
    wire [3*DATA_WIDTH-1:0] vb_buffer_mode;

    wire [VERT_ADDR-1:0]    vb_addr = buffer_mode ? vb_wr_addr : vb_addr_mc;
    wire                    vb_cs   = buffer_mode ? vb_wr_cs : vb_cs_mc;  
    wire                    vb_wr   = buffer_mode ? vb_wr_en : 1'b0;
        
    assign vb_buffer_mode = buffer_mode ? vb_wr_data : 0;

    vertex_buffer #(
        .ADDR_WIDTH(VERT_ADDR),
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_vertex_buffer (
        .clk(clk),
        .rst_n(rst_n),
        .cs(vb_cs),
        .wr(vb_wr),
        .addr(vb_addr),
        .dataIn(vb_buffer_mode),
        .dataOut(vb_data_mc)
    );


    // ---------------- EDGE BUFFER ----------------
    wire [EDGE_ADDR-1:0]    eb_addr_mc;
    wire                    eb_cs_mc;
    wire [2*VERT_ADDR-1:0]  eb_data_mc;
    wire [2*VERT_ADDR-1:0]  eb_buffer_mode;

    wire [EDGE_ADDR-1:0]    eb_addr = buffer_mode ? eb_wr_addr : eb_addr_mc;   
    wire                    eb_cs   = buffer_mode ? eb_wr_cs : eb_cs_mc;   
    wire                    eb_wr   = buffer_mode ? eb_wr_en : 1'b0;
    
    assign eb_buffer_mode = buffer_mode ? eb_wr_data : 0;

    edge_buffer #(
        .EDGE_ADDR(EDGE_ADDR),
        .VERT_ADDR(VERT_ADDR)
    ) u_edge_buffer (
        .clk(clk),
        .rst_n(rst_n),
        .cs(eb_cs),
        .wr(eb_wr),
        .addr(eb_addr),
        .dataIn(eb_buffer_mode),
        .dataOut(eb_data_mc)
    );


    // ---------------- POINT BUFFER ----------------
    wire [VERT_ADDR-1:0]    pb_addr;
    wire                    pb_cs, pb_wr;
    wire [2*DATA_WIDTH-1:0] pb_dataIn, pb_dataOut;

    point_buffer #(
        .ADDR_WIDTH(VERT_ADDR),
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_point_buffer (
        .clk(clk),
        .rst_n(rst_n),
        .cs(pb_cs),
        .wr(pb_wr),
        .addr(pb_addr),
        .dataIn(pb_dataIn),
        .dataOut(pb_dataOut)
    );


    // ---------------- VERTEX PROCESSOR ----------------
    wire                    vp_start;
    wire [DATA_WIDTH-1:0]   vp_x, vp_y, vp_z;
    wire [DATA_WIDTH-1:0]   vp_f, vp_w, vp_h, vp_cam_z;
    wire [9:0]              vp_angle;
    wire [1:0]              vp_rotation;
    wire [DATA_WIDTH-1:0]   vp_xs, vp_ys;
    wire                    vp_valid, vp_overflow;

    vertex_processor #(
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_vp (
        .clk(clk),
        .rst_n(rst_n),
        .start(vp_start),
        .rotation(vp_rotation),
        .angle(vp_angle),
        .x(vp_x), .y(vp_y), .z(vp_z),
        .f(vp_f), .w(vp_w), .h(vp_h),
        .cam_z(vp_cam_z),
        .xs(vp_xs), .ys(vp_ys),
        .valid(vp_valid),
        .overflow(vp_overflow),
        .dbg_state(dbg_vp_state)
    );
   

    // ---------------- BU + FRAMEBUFFER ----------------
    wire bu_start;
    wire bu_done;
    wire signed [COORD_BITS-1:0] bu_x0, bu_y0, bu_x1, bu_y1;
    wire fb_busy;
    wire fb_clear;

    wire [COORD_BITS-1:0] fb_x, fb_y;
    wire fb_cs, fb_wr;

    bresenham #(
        .COORD_BITS(COORD_BITS),
        .H_RES(H_RES),
        .V_RES(V_RES)
    ) u_bu (
        .clk(clk),
        .rst_n(rst_n),
        .start(bu_start),
        .x0_in(bu_x0),  .y0_in(bu_y0),
        .x1_in(bu_x1),  .y1_in(bu_y1),
        .fb_x(fb_x),    .fb_y(fb_y),
        .fb_cs(fb_cs),  .fb_wr(fb_wr),
        .fb_busy(fb_busy),
        .done(bu_done),
        .dbg_state(dbg_bu_state)
    );

    framebuffer_dbl #(
        .H_RES(H_RES),
        .V_RES(V_RES),
        .WORD_BITS(WORD_BITS)
    ) u_fb (
        .clk(clk),
        .rst_n(rst_n),
        .cs(fb_cs), .wr(fb_wr), .clear(fb_clear),
        .x_in(fb_x[COORD_BITS-2:0]), .y_in(fb_y[COORD_BITS-2:0]),
        .pixel_in(1'b1),
        .busy(fb_busy),
        .swap(frame_done),         // <-- pulsul care marcheaza finalul randarii
        .rd_address(fb_rd_addr),
        .rd_dataOut(fb_rd_data),
        .dbg_fb_i_state(),        // Debug stare FSM FB1
        .dbg_fb_ii_state(),       // Debug stare FSM FB2
        .dbg_disp_buf(dbg_fb_state)
    );


    // ---------------- MASTER CTRL ----------------
    master_controller #(
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS),
        
        .VERT_ADDR(VERT_ADDR),
        .EDGE_ADDR(EDGE_ADDR),
        
        .FOCAL(FOCAL),
        .CAM_Z(CAM_Z),
        
        .COORD_BITS(COORD_BITS),
        .H_RES(H_RES),
        .V_RES(V_RES)
        
    ) u_mc (
        .clk(clk),
        .rst_n(rst_n),

        .start_frame(start_frame),
        .vertex_count(vertex_count),
        .edge_count(edge_count),
        .angle(angle),
        .focal_in(focal_in),
        .camz_in(camz_in),
        .rotation_type(rotation_type),
       
        .vb_addr(vb_addr_mc),
        .vb_cs(vb_cs_mc),
        .vb_data(vb_data_mc),

        .eb_addr(eb_addr_mc),
        .eb_cs(eb_cs_mc),
        .eb_data(eb_data_mc),

        .pb_addr(pb_addr),
        .pb_cs(pb_cs),
        .pb_wr(pb_wr),
        .pb_dataIn(pb_dataIn),
        .pb_dataOut(pb_dataOut),

        .vp_start(vp_start),
        .vp_x(vp_x), .vp_y(vp_y), .vp_z(vp_z),
        .vp_f(vp_f), .vp_w(vp_w), .vp_h(vp_h),
        .vp_cam_z(vp_cam_z),
        .vp_angle(vp_angle),
        .vp_rotation(vp_rotation),
        .vp_xs(vp_xs), .vp_ys(vp_ys),
        .vp_valid(vp_valid),

        .bu_start(bu_start),
        .bu_x0(bu_x0), .bu_y0(bu_y0),
        .bu_x1(bu_x1), .bu_y1(bu_y1),
        .bu_done(bu_done),

        .fb_clear(fb_clear),
        .fb_busy(fb_busy),

        .dbg_state(dbg_mc_state),
        .dbg_v_idx(dbg_v_idx),
        .dbg_e_idx(dbg_e_idx),
        .frame_done(frame_done)
    );
    
    assign dbg_vp_valid = vp_valid;
    assign dbg_bu_done  = bu_done;
    assign dbg_overflow = vp_overflow;

endmodule // top_graphics
