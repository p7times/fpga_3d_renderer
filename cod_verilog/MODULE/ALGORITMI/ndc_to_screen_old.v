module ndc_to_screen(
    input signed [31:0] x_ndc, y_ndc,  // 16.16
    input signed [31:0] width, height, // numere intregi
    output signed [31:0] screen_x, screen_y
    );
    
    wire signed [32:0] x_plus1 = x_ndc + 32'sh00010000;
    wire signed [32:0] y_inv   = 32'sh00010000 - y_ndc;
    
    wire signed [63:0] x_mul = x_plus1 * width;
    wire signed [63:0] y_mul = y_inv   * height;
    
    wire signed [63:0] x_pix = (x_mul >>> 16) >>> 1;
    wire signed [63:0] y_pix = (y_mul >>> 16) >>> 1;
    
    assign screen_x = (x_pix < 0) ? 0 :
                      (x_pix >= width) ? width-1 :
                      x_pix[31:0];

    assign screen_y = (y_pix < 0) ? 0 :
                      (y_pix >= height) ? height-1 :
                      y_pix[31:0];
    
    
endmodule
