module top_level(
    input signed [31:0] coord_x,
    input signed [31:0] coord_y,
    input signed [31:0] coord_z,
    
    input signed [31:0] fov,

    // Dimensiunile ecranului
    input signed [31:0] width,
    input signed [31:0] height,
    
    // Outputs
    output signed [31:0] coord_screen_x,
    output signed [31:0] coord_screen_y,
    output signed [31:0] dbg_aspect_ratio
    );
    
    wire signed [31:0] x_pro;
    wire signed [31:0] y_pro;
    wire signed [31:0] ratio;
    wire signed [31:0] out_width;
    wire signed [31:0] out_height;
    
    assign dbg_aspect_ratio = ratio;
    
    project proj_inst (
        .x(coord_x),
        .y(coord_y),
        .z(coord_z),
        .fov(fov),
        .aspect_ratio(ratio),
        .xp(x_pro),
        .yp(y_pro)
    );
    
    display_size display_size_inst (
        .width(width),
        .height(height),
        .out_width(out_width),
        .out_height(out_height),
        .aspect_ratio(ratio)
    );
    
    ndc_to_screen screen_inst (
        .x_ndc(x_pro),
        .y_ndc(y_pro),
        .width(out_width),
        .height(out_height),
        .screen_x(coord_screen_x),
        .screen_y(coord_screen_y)
    );

endmodule
