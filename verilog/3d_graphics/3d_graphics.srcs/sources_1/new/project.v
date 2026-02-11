module project(
    input signed [31:0] x, y, z,
    output signed [31:0] xp, yp
);

    // Evitare impartire la zero
    wire signed [31:0] z_safe = (z != 0) ? z : 1;

    localparam signed [31:0] aspect_ratio = 32'sh0000_9000;  // 16/9 in Q16.16
    
    // Scaleaza x and y de 2^16 ori (ptr 16.16 punct-fixat)
    wire signed [63:0] x_div_z = (x <<< 16) / z_safe;

    // Imparte la z
    wire signed [63:0] xp_temp = (x_div_z * aspect_ratio) >>> 16;
    wire signed [63:0] yp_temp = (y <<< 16) / z_safe;

    // Valorile maxime ptr 16.16
    localparam signed [63:0] MAX_16_16 = 64'sh0000_0000_7FFF_FFFF;
    localparam signed [63:0] MIN_16_16 = 64'shFFFF_FFFF_8000_0000;

    // Limiteaza la 32 biti punct-fixat
    assign xp = (xp_temp > MAX_16_16) ? 32'sh7FFF_FFFF : (xp_temp < MIN_16_16) ? 32'sh8000_0000 : xp_temp[31:0];
    assign yp = (yp_temp > MAX_16_16) ? 32'sh7FFF_FFFF : (yp_temp < MIN_16_16) ? 32'sh8000_0000 : yp_temp[31:0];
endmodule
