
//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : tb_master_controller
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Testbench pentru Master Controller.
//---------------------------------------------------------------

`timescale 1ns / 1ps

module tb_top_integration;

    // -------------------------------------------------------------------------
    // Parametrii Globali ai Sistemului
    // -------------------------------------------------------------------------
    parameter INT_BITS     = 16;
    parameter FRAC_BITS    = 16;
    parameter DATA_WIDTH   = 32; // INT_BITS + FRAC_BITS (Q16.16)
    parameter COORD_BITS   = 12; // Pentru Bresenham (-2048 .. 2047)
    parameter H_RES        = 1920;
    parameter V_RES        = 1080;
    
    // Dimensiuni BRAM
    parameter VERT_ADDR    = 8;  // max 256 varfuri
    parameter EDGE_COUNT   = 10; // max 1024 muchii
    parameter POINT_ADDR   = 10; // max 1024 puncte transformate
    
    localparam FB_TOTAL_WORDS = (H_RES * V_RES) / 32;
    localparam FB_ADDR_WIDTH  = 16; // $clog2(64800) = 16



    // Q16.16 scaling: 0.5 = 32'h0000_8000

    localparam signed [31:0] P =  32'h0000_8000;
    localparam signed [31:0] N = -32'h0000_8000;

    // -------------------------------------------------------------------------
    // Semnale de Stimul / Interconectare
    // -------------------------------------------------------------------------
    wire clk;
    wire rst_n;
    
    // 1. Vertex Buffer
    reg  vb_cs, vb_wr;
    reg  [VERT_ADDR-1:0]    vb_addr;
    reg  [3*DATA_WIDTH-1:0] vb_dataIn;
    wire [3*DATA_WIDTH-1:0] vb_dataOut;

    // 2. Vertex Processor
    reg  vp_start;
    reg  [2:0] vp_rotation;
    reg  [9:0] vp_angle;
    reg  [DATA_WIDTH-1:0] vp_f, vp_w, vp_h, vp_cam_z;
    wire [DATA_WIDTH-1:0] vp_xs, vp_ys;
    wire vp_valid, vp_overflow;

    // 3. Point Buffer
    reg  pb_cs, pb_wr;
    reg  [POINT_ADDR-1:0]   pb_addr;
    reg  [2*DATA_WIDTH-1:0] pb_dataIn;
    wire [2*DATA_WIDTH-1:0] pb_dataOut;

    // 4. Edge Buffer
    reg  eb_cs, eb_wr;
    reg  [EDGE_COUNT-1:0]  eb_addr;
    reg  [2*VERT_ADDR-1:0] eb_dataIn;
    wire [2*VERT_ADDR-1:0] eb_dataOut;

    // 5. Bresenham Unit
    reg  bu_start;
    reg  signed [COORD_BITS-1:0] bu_x0, bu_y0, bu_x1, bu_y1;
    wire bu_done;
    
    // Legaturi intre Bresenham si Framebuffer
    wire [COORD_BITS-1:0] bres_fb_x, bres_fb_y;
    wire bres_fb_cs, bres_fb_wr;
    wire fb_busy; 

    // 6. Framebuffer
    reg  fb_clear;
    reg  [FB_ADDR_WIDTH-1:0] hdmi_rd_addr;
    wire [31:0] hdmi_rd_data;


    // -------------------------------------------------------------------------
    // Instanțierea Modulelor (Units Under Test)
    // -------------------------------------------------------------------------

    vertex_buffer #(
        .ADDR_WIDTH(VERT_ADDR), .INT_BITS(INT_BITS), .FRAC_BITS(FRAC_BITS)
    ) u_vertex_buffer (
        .clk(clk), .rst_n(rst_n), .cs(vb_cs), .wr(vb_wr),
        .addr(vb_addr), .dataIn(vb_dataIn), .dataOut(vb_dataOut)
    );

    vertex_processor #(
        .INT_BITS(INT_BITS), .FRAC_BITS(FRAC_BITS)
    ) u_vertex_processor (
        .clk(clk), .rst_n(rst_n), .start(vp_start),
        .rotation(vp_rotation), .angle(vp_angle),
        .f(vp_f), .w(vp_w), .h(vp_h), .cam_z(vp_cam_z),
        // Conectam intrarile XYZ la datele citite din Vertex Buffer!
        .z(vb_dataOut[3*DATA_WIDTH-1 : 2*DATA_WIDTH]),
        .y(vb_dataOut[2*DATA_WIDTH-1 : 1*DATA_WIDTH]),
        .x(vb_dataOut[1*DATA_WIDTH-1 : 0]),
        .xs(vp_xs), .ys(vp_ys),
        .valid(vp_valid), .overflow(vp_overflow), .dbg_state()
    );

    point_buffer #(
        .ADDR_WIDTH(POINT_ADDR), .INT_BITS(INT_BITS), .FRAC_BITS(FRAC_BITS)
    ) u_point_buffer (
        .clk(clk), .rst_n(rst_n), .cs(pb_cs), .wr(pb_wr),
        .addr(pb_addr), .dataIn(pb_dataIn), .dataOut(pb_dataOut)
    );

    edge_buffer #(
        .EDGE_COUNT(EDGE_COUNT), .VERT_ADDR(VERT_ADDR)
    ) u_edge_buffer (
        .clk(clk), .rst_n(rst_n), .cs(eb_cs), .wr(eb_wr),
        .addr(eb_addr), .dataIn(eb_dataIn), .dataOut(eb_dataOut)
    );

    bresenham #(
        .COORD_BITS(COORD_BITS), .H_RES(H_RES), .V_RES(V_RES)
    ) u_bresenham (
        .clk(clk), .rst_n(rst_n), .start(bu_start),
        .x0_in(bu_x0), .y0_in(bu_y0), .x1_in(bu_x1), .y1_in(bu_y1),
        .fb_x(bres_fb_x), .fb_y(bres_fb_y),
        .fb_cs(bres_fb_cs), .fb_wr(bres_fb_wr),
        .fb_busy(fb_busy), .done(bu_done), .dbg_state()
    );

    framebuffer #(
        .H_RES(H_RES), .V_RES(V_RES), .WORD_BITS(32)
    ) u_framebuffer (
        .clk(clk), .rst_n(rst_n), .cs(bres_fb_cs), .wr(bres_fb_wr),
        .clear(fb_clear), .x_in(bres_fb_x[10:0]), .y_in(bres_fb_y[10:0]),
        .pixel_in(1'b1), // Pixel alb
        .rd_adresa(hdmi_rd_addr), .rd_dataOut(hdmi_rd_data),
        .busy(fb_busy), .dbg_clear_addr(), .dbg_state()
    );

    // -------------------------------------------------------------------------
    // Generare Ceas
    // -------------------------------------------------------------------------

    ck_rst_tb #(
        .CK_SEMIPERIOD(5)
    ) u_ck_rst (
        .clk(clk),
        .rst_n(rst_n)
    );

    // -------------------------------------------------------------------------
    // Scenariu de Testare (Simulare Master Controller)
    // -------------------------------------------------------------------------
    integer timeout;
    integer v_idx;
    integer e_idx;

    // --- Declaratii variabile (obligatoriu la inceputul blocului) ---
        integer f_out, px, py;
        integer pixel_idx, word_addr, bit_offset;
        integer filesize;
        reg [31:0] current_word;
        reg pixel_val;
        
    initial begin

        
        // Initializare semnale de control
        vb_cs = 0; vb_wr = 0; vb_addr = 0; vb_dataIn = 0;
        pb_cs = 0; pb_wr = 0; pb_addr = 0; pb_dataIn = 0;
        eb_cs = 0; eb_wr = 0; eb_addr = 0; eb_dataIn = 0;
        vp_start = 0; bu_start = 0; fb_clear = 0; hdmi_rd_addr = 0;
        
        // Parametri geometrici constanti
        vp_f     = 32'h0001_0000; // 1.0
        vp_w     = 32'h0780_0000; // 1920.0
        vp_h     = 32'h0438_0000; // 1080.0
        vp_cam_z = 32'h0001_8000; // 1.5
        vp_rotation = 3'b010; vp_angle = 80;

        // Asteptare sincronizare reset din ck_rst_tb
        $display("Asteptare secventa de reset...");
        wait (rst_n == 1'b0); // Asteptam ca resetul sa devina activ
        wait (rst_n == 1'b1); // Asteptam ca resetul sa fie eliberat
        @(posedge clk);
        $display("Reset eliberat. Incepere test...");

        // =====================================================================
        // ETAPA 1: Incarcare Model 3D in Memoriile BRAM
        // =====================================================================
        $display("--- ETAPA 1: Incarcare geometrie ---");
                
            // v0: (-0.5, -0.5, -0.5)
            vb_cs = 1; vb_wr = 1; vb_addr = 0;
            vb_dataIn = {N, N, N};
            @(posedge clk);
            
            // v1: (-0.5, +0.5, -0.5)
            vb_addr = 1;
            vb_dataIn = {N, P, N};
            @(posedge clk);
            
            // v2: (+0.5, +0.5, -0.5)
            vb_addr = 2;
            vb_dataIn = {N, P, P};
            @(posedge clk);
            
            // v3: (+0.5, -0.5, -0.5)
            vb_addr = 3;
            vb_dataIn = {N, N, P};
            @(posedge clk);
            
            // v4: (-0.5, -0.5, +0.5)
            vb_addr = 4;
            vb_dataIn = {P, N, N};
            @(posedge clk);
            
            // v5: (-0.5, +0.5, +0.5)
            vb_addr = 5;
            vb_dataIn = {P, P, N};
            @(posedge clk);
            
            // v6: (+0.5, +0.5, +0.5)
            vb_addr = 6;
            vb_dataIn = {P, P, P};
            @(posedge clk);
            
            // v7: (+0.5, -0.5, +0.5)
            vb_addr = 7;
            vb_dataIn = {P, N, P};
            @(posedge clk);
            
            vb_cs = 0; vb_wr = 0;

        $display("--- Incarcare Edge Buffer (CubeMesh) ---");

            eb_cs = 1; eb_wr = 1;
            
            // Front face (0,1,2,3)
            eb_addr = 0; eb_dataIn = {8'd1, 8'd0}; @(posedge clk);
            eb_addr = 1; eb_dataIn = {8'd2, 8'd1}; @(posedge clk);
            eb_addr = 2; eb_dataIn = {8'd3, 8'd2}; @(posedge clk);
            eb_addr = 3; eb_dataIn = {8'd0, 8'd3}; @(posedge clk);
            
            // Back face (4,5,6,7)
            eb_addr = 4; eb_dataIn = {8'd5, 8'd4}; @(posedge clk);
            eb_addr = 5; eb_dataIn = {8'd6, 8'd5}; @(posedge clk);
            eb_addr = 6; eb_dataIn = {8'd7, 8'd6}; @(posedge clk);
            eb_addr = 7; eb_dataIn = {8'd4, 8'd7}; @(posedge clk);
            
            // Left face
            eb_addr = 8;  eb_dataIn = {8'd5, 8'd1}; @(posedge clk);
            eb_addr = 9;  eb_dataIn = {8'd0, 8'd4}; @(posedge clk);
            
            // Right face
            eb_addr = 10; eb_dataIn = {8'd6, 8'd2}; @(posedge clk);
            eb_addr = 11; eb_dataIn = {8'd3, 8'd7}; @(posedge clk);
            
            eb_cs = 0; eb_wr = 0;
            
        // =====================================================================
        // ETAPA 2: Procesarea Tuturor Vertecșilor (Vertex Processing Loop)
        // =====================================================================
        $display("--- ETAPA 2: Transformari Geometrice ---");
        for (v_idx = 0; v_idx < 8; v_idx = v_idx + 1) begin
            // 2.1. Citire din Vertex Buffer
            vb_cs = 1; vb_wr = 0; vb_addr = v_idx;
            @(posedge clk); // Setam adresa
            @(posedge clk); // Asteptam 1 ciclu latenta BRAM
            vb_cs = 0;

            // 2.2. Pornire transformari
            vp_start = 1;
            @(posedge clk); vp_start = 0;
            
            // 2.3. Asteptare finalizare
            while (vp_valid == 0) @(posedge clk);
            
            // 2.4. Scriere rezultate in Point Buffer
            pb_cs = 1; pb_wr = 1; pb_addr = v_idx;
            pb_dataIn = {vp_ys, vp_xs}; // Format {Y, X}
            @(posedge clk);
            pb_cs = 0; pb_wr = 0;
            $display("[t=%0t] Varful %0d transformat si stocat in Point Buffer.", $time, v_idx);
        end

        // =====================================================================
        // ETAPA 3: Rasterizare Muchii (Edge Drawing Loop)
        // =====================================================================
        $display("--- ETAPA 3: Rasterizare ---");
        
        for (e_idx = 0; e_idx < 12; e_idx = e_idx + 1) begin
        
            // -------------------------------------------------------------
            // 3.1. Citire muchie
            // -------------------------------------------------------------
            eb_cs = 1; eb_wr = 0; eb_addr = e_idx;
            @(posedge clk);
            @(posedge clk); // latenta BRAM
            eb_cs = 0;
        
            // -------------------------------------------------------------
            // 3.2. Citire punct A
            // -------------------------------------------------------------
            pb_cs = 1; pb_wr = 0;
            pb_addr = eb_dataOut[7:0]; // idx_A
            @(posedge clk);
            @(posedge clk);
        
            bu_x0 = $signed(pb_dataOut[31:16]);
            bu_y0 = $signed(pb_dataOut[63:48]);
        
            // -------------------------------------------------------------
            // 3.3. Citire punct B
            // -------------------------------------------------------------
            pb_addr = eb_dataOut[15:8]; // idx_B
            @(posedge clk);
            @(posedge clk);
        
            bu_x1 = $signed(pb_dataOut[31:16]);
            bu_y1 = $signed(pb_dataOut[63:48]);
        
            pb_cs = 0;
        
            // -------------------------------------------------------------
            // 3.4. Pornire Bresenham
            // -------------------------------------------------------------
            $display("[EDGE %0d] (%0d,%0d) -> (%0d,%0d)",
                     e_idx, bu_x0, bu_y0, bu_x1, bu_y1);
        
            bu_start = 1;
            @(posedge clk);
            bu_start = 0;
        
            // -------------------------------------------------------------
            // 3.5. Asteptare finalizare linie
            // -------------------------------------------------------------
            timeout = 0;
            while (bu_done == 0 && timeout < 10000) begin
                @(posedge clk);
                timeout = timeout + 1;
            end
        
            if (timeout >= 10000)
                $display("EROARE: Timeout la muchia %0d", e_idx);
            else
                $display("OK: Muchia %0d desenata", e_idx);
        
        end 

        // =====================================================================
        // FINALIZARE
        // =====================================================================
        repeat(10) @(posedge clk);
        $display("=== TOATE ETAPELE AU FOST PARCURSE CU SUCCES ===");
        
        // =====================================================================
        // EXPORT IMAGINE (.BMP)
        // =====================================================================
        $display("Generare fisier imagine frame.bmp ...");
        
        filesize = 54 + (3 * H_RES * V_RES); 
        f_out = $fopen("frame.bmp", "wb");

        // --- Scriere Header BMP (14 Bytes) ---
        $fwrite(f_out, "%c%c", 8'h42, 8'h4D); 
        $fwrite(f_out, "%c%c%c%c", filesize[7:0], filesize[15:8], filesize[23:16], filesize[31:24]);
        $fwrite(f_out, "%c%c%c%c", 8'h00, 8'h00, 8'h00, 8'h00);
        $fwrite(f_out, "%c%c%c%c", 8'h36, 8'h00, 8'h00, 8'h00);

        // --- Scriere DIB Header (40 Bytes) ---
        $fwrite(f_out, "%c%c%c%c", 8'h28, 8'h00, 8'h00, 8'h00);
        $fwrite(f_out, "%c%c%c%c", H_RES[7:0], H_RES[15:8], H_RES[23:16], H_RES[31:24]);
        $fwrite(f_out, "%c%c%c%c", V_RES[7:0], V_RES[15:8], V_RES[23:16], V_RES[31:24]);
        $fwrite(f_out, "%c%c", 8'h01, 8'h00);
        $fwrite(f_out, "%c%c", 8'h18, 8'h00);
        $fwrite(f_out, "%c%c%c%c", 8'h00, 8'h00, 8'h00, 8'h00);
        $fwrite(f_out, "%c%c%c%c", 8'h00, 8'h00, 8'h00, 8'h00);
        $fwrite(f_out, "%c%c%c%c", 8'h13, 8'h0B, 8'h00, 8'h00);
        $fwrite(f_out, "%c%c%c%c", 8'h13, 8'h0B, 8'h00, 8'h00);
        $fwrite(f_out, "%c%c%c%c", 8'h00, 8'h00, 8'h00, 8'h00);
        $fwrite(f_out, "%c%c%c%c", 8'h00, 8'h00, 8'h00, 8'h00);

        // --- Scriere Date Pixeli ---
        for (py = V_RES - 1; py >= 0; py = py - 1) begin
            for (px = 0; px < H_RES; px = px + 1) begin
                pixel_idx = py * H_RES + px;
                word_addr = pixel_idx / 32;
                bit_offset = pixel_idx % 32;

                current_word = u_framebuffer.mem[word_addr];
                pixel_val = (current_word & (1 << bit_offset)) ? 1'b1 : 1'b0;

                if (pixel_val)
                    $fwrite(f_out, "%c%c%c", 8'hFF, 8'hFF, 8'hFF);
                else
                    $fwrite(f_out, "%c%c%c", 8'h00, 8'h00, 8'h00);
            end
        end
        
        $fclose(f_out);
        $display("Imagine salvata cu succes (frame.bmp)!");
        $finish;
    end

endmodule