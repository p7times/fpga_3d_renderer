`timescale 1ns / 1ps

module tb_project;

    // Inputs
    reg signed [31:0] tb_x;
    reg signed [31:0] tb_y;
    reg signed [31:0] tb_z;
    
    reg signed [31:0] tb_fov;

    // Dimensiunile ecranului
    reg signed [31:0] tb_width;
    reg signed [31:0] tb_height;
    
    // Outputs
    wire signed [31:0] tb_screen_x;
    wire signed [31:0] tb_screen_y;
    wire signed [31:0] aspect_ratio;

    wire signed [31:0] tb_xp;
    wire signed [31:0] tb_yp; 
    
    // Instantiate the design under test
    top_level tb_top_level (
        .coord_x(tb_x),
        .coord_y(tb_y),
        .coord_z(tb_z),
        .fov(tb_fov),
        .width(tb_width),
        .height(tb_height),
        .coord_screen_x(tb_screen_x),
        .coord_screen_y(tb_screen_y),
        .dbg_aspect_ratio(aspect_ratio)  
    );
    
    project tb_project (
        .x(tb_x),
        .y(tb_y),
        .z(tb_z),
        .fov(tb_fov),
        .aspect_ratio(aspect_ratio),
        .xp(tb_xp),
        .yp(tb_yp)
    );
    
    
    
    
initial begin
    
    tb_x = 32'sh0000_199A; // 0.1
    tb_y = 32'shFFFF_E667; // -0.1
    tb_z = 32'sh0001_0000; // 1.0
    tb_fov = 32'sh0000_0ccd; // 0.05 m (50 mm)
    tb_width = 128;
    tb_height = 128;
    #10;
    $display("screen_x=%0d screen_y=%0d", tb_screen_x, tb_screen_y);
    $display("project_x=%0d project_y=%0d", tb_xp, tb_yp);
    
    tb_x = 32'sh000A_0000; // 10.0
    tb_y = 32'shFFF6_0000; // -10.0
    tb_z = 32'sh000A_0000; // 5
    tb_fov = 32'sh0000_0666; // 25 mm
    tb_width = 1280;
    tb_height = 720;
    #10;
    $display("screen_x=%0d screen_y=%0d", tb_screen_x, tb_screen_y);
    $display("project_x=%0d project_y=%0d", tb_xp, tb_yp);
    $finish;
end



endmodule
