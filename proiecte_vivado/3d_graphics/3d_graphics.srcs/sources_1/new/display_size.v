module display_size(
    input signed [31:0] width,
    input signed [31:0] height,

    output signed [31:0] out_width,
    output signed [31:0] out_height,
    output signed [31:0] aspect_ratio
);

    assign out_width  = width;
    assign out_height = height;

    // Signed cast is optional unless you expect negative values
    assign aspect_ratio = (width != 0) ? (height <<< 16) / width : 32'sd0;

endmodule
