`timescale 1ns / 1ps

module tb_project;

    // Inputs
    reg signed [31:0] tb_x;
    reg signed [31:0] tb_y;
    reg signed [31:0] tb_z;

    // Dimensiunile ecranului
    reg [31:0] tb_width;
    reg [31:0] tb_height;
    
    // Outputs
    wire signed [31:0] tb_xp;
    wire signed [31:0] tb_yp;
    wire        [31:0] tb_screen_x;
    wire        [31:0] tb_screen_y;

    // Instantiate the design under test
    project proj_inst (
        .x(tb_x),
        .y(tb_y),
        .z(tb_z),
        .xp(tb_xp),
        .yp(tb_yp)
    );
    
    ndc_to_screen screen_inst (
        .x_ndc(tb_xp),
        .y_ndc(tb_yp),
        .width(tb_width),
        .height(tb_height),
        .screen_x(tb_screen_x),
        .screen_y(tb_screen_y)
    );
    
initial begin
    // Vertex 0: (-0.5, -0.5, 1)
    tb_x = 32'shFFFF8000; // -0.5
    tb_y = 32'shFFFF8000; // -0.5
    tb_z = 32'sh00010000; // 1.0
    tb_width = 1280;
    tb_height = 720;
    #10;
   // $display("xp=%h (%f) yp=%h (%f) screen_x=%0d screen_y=%0d", tb_xp, $itor(tb_xp)/65536.0, tb_yp, $itor(tb_yp)/65536.0, tb_screen_x, tb_screen_y);
   // $finish;
    
end



endmodule
