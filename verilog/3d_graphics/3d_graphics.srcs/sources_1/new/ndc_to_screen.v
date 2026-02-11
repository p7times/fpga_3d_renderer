`timescale 1ns / 1ps

module ndc_to_screen(
    input signed [31:0] x_ndc, y_ndc,  // 16.16
    input        [31:0] width, height, // numere intregi
    output       [31:0] screen_x, screen_y
    );
    
    wire signed [32:0] x_plus1 = x_ndc + 32'sh00010000;
    wire signed [32:0] y_inv   = 32'sh00010000 - y_ndc;
    
    wire signed [63:0] x_mul = x_plus1 * width;
    wire signed [63:0] y_mul = y_inv   * height;
    
    assign screen_x = x_mul >>> 17;
    assign screen_y = y_mul >>> 17;
    
    
endmodule
