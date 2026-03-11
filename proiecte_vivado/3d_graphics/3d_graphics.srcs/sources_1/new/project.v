module project(
    input signed [31:0] x, y, z,
    input signed [31:0] fov,
    input signed [31:0] aspect_ratio,
    output signed [31:0] xp, yp
);
    
    // 1. Numitorul: z + fov
    wire signed [31:0] den = z + fov;
    
    // Evitare impartire la zero
    wire signed [31:0] den_safe = (den != 0) ? den : 32'sh0000_0001;
    
    // 2. Numaratorul (Q32.32)
    wire signed [63:0] num_x = fov * x;
    wire signed [63:0] num_y = fov * y;
    
    // 3. Impartirea (Q32.32)
    wire signed [63:0] xp_temp = num_x / den_safe;
    wire signed [63:0] yp_temp = num_y / den_safe;
    
    // 4. Corectare cu aspect ratio
    wire signed [63:0] xp_aspect = (xp_temp * aspect_ratio) >>> 16;

    // Valorile maxime ptr 16.16
    localparam signed [63:0] MAX_16_16 = 64'sh0000_0000_7FFF_FFFF;
    localparam signed [63:0] MIN_16_16 = 64'shFFFF_FFFF_8000_0000;

    // Limiteaza la 32 biti punct-fixat
    assign xp = (xp_aspect > MAX_16_16) ? 32'sh7FFF_FFFF : (xp_aspect < MIN_16_16) ? 32'sh8000_0000 : xp_aspect[31:0];
    assign yp = (yp_temp > MAX_16_16) ? 32'sh7FFF_FFFF : (yp_temp < MIN_16_16) ? 32'sh8000_0000 : yp_temp[31:0];
    
endmodule
