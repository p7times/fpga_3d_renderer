`timescale 1ns / 1ps

module tb_top_graphics;

    // -------------------------------------------------------------------------
    // Parametri top_graphics (NU ATINGE)
    // -------------------------------------------------------------------------
    
    parameter CK_PER            = 8; // Ceas 125 MHz: frecventa ceasului ptr FPGA PL (perioadă 8 ns)
    parameter INT_BITS          = 16;
    parameter FRAC_BITS         = 16;
    parameter DATA_WIDTH        = INT_BITS + FRAC_BITS;
    parameter real SCALE        = 2.0**FRAC_BITS;       // Factor de scalare pentru Q16.16 (2^FRAC_BITS)

    parameter VERT_COUNT        = 8;
    parameter EDGE_COUNT        = 10;   
    parameter COORD_BITS        = 12; 
    parameter WORD_BITS         = 32;
    

    // -------------------------------------------------------------------------
    // Parametri modificabili
    // -------------------------------------------------------------------------
    
    parameter H_RES             = 1280;
    parameter V_RES             = 720; 
    
    parameter CAM_Z             = 32'h0002_0000;        // Distanta camera = 1.5
    parameter FOCAL             = 32'h0001_0000;        // Lungime focala = 0.5 (aprox 500mm)
    parameter ROTATION          = 3'b011;
    
    // -------------------------------------------------------------------------
    // Parametri Calculati Automat (NU ATINGE)
    // -------------------------------------------------------------------------
    
    // Calculează lățimea și înălțimea în format Q16.16 automat pe baza H_RES și V_RES
    // Ex: 320 << 16 devine 32'h0140_0000
    localparam [DATA_WIDTH-1:0] SCREEN_WIDTH  = H_RES << FRAC_BITS; 
    localparam [DATA_WIDTH-1:0] SCREEN_HEIGHT = V_RES << FRAC_BITS;
    
    localparam FB_ADDR_WIDTH        = $clog2((H_RES*V_RES)/WORD_BITS);

    localparam signed [DATA_WIDTH-1:0] P      =  32'h0000_8000; //  0.5
    localparam signed [DATA_WIDTH-1:0] N      = -32'h0000_8000; // -0.5

    // -------------------------------------------------------------------------
    // Semnale de interconectare
    // -------------------------------------------------------------------------
    wire                        clk;
    wire                        rst_n;
    
    reg                         ps_buffer_mode;
    reg                         start_frame;
    reg  [VERT_COUNT-1:0]       vertex_count;
    reg  [EDGE_COUNT-1:0]       edge_count;
    reg  [9:0]                  angle;
    reg  [2:0]                  rotation_type;

    wire                        frame_done;
    wire                        busy;

    reg  [VERT_COUNT-1:0]       vb_wr_addr;
    reg  [3*DATA_WIDTH-1:0]     vb_wr_data;
    reg                         vb_wr_cs;
    reg                         vb_wr_en;

    reg  [EDGE_COUNT-1:0]       eb_wr_addr;
    reg  [2*EDGE_COUNT-1:0]     eb_wr_data;
    reg                         eb_wr_cs;
    reg                         eb_wr_en;

    reg  [FB_ADDR_WIDTH-1:0]    fb_rd_addr;
    wire [WORD_BITS-1:0]        fb_rd_data;


    // -------------------------------------------------------------------------
    // Instantiere Module
    // -------------------------------------------------------------------------
    ck_rst_tb #(
        .CK_SEMIPERIOD(CK_PER/2)
    ) u_ck_rst (
        .clk  (clk),
        .rst_n(rst_n)
    );

    top_graphics #(
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS),
        .VERT_COUNT(VERT_COUNT),
        .EDGE_COUNT(EDGE_COUNT),
        .COORD_BITS(COORD_BITS),
        .H_RES(H_RES),
        .V_RES(V_RES),
        .WORD_BITS(WORD_BITS)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        
        .ps_buffer_mode(ps_buffer_mode),
        .start_frame(start_frame),
        .frame_done(frame_done),

        .vertex_count(vertex_count),
        .edge_count(edge_count),
        
        .angle(angle),
        .rotation_type(rotation_type),
        .busy(busy),
        
        .vb_wr_addr(vb_wr_addr),
        .vb_wr_cs(vb_wr_cs),
        .vb_wr_en(vb_wr_en),
        .vb_wr_data(vb_wr_data),
        .eb_wr_addr(eb_wr_addr),
        .eb_wr_cs(eb_wr_cs),
        .eb_wr_en(eb_wr_en),
        .eb_wr_data(eb_wr_data),
        .fb_rd_addr(fb_rd_addr),
        .fb_rd_data(fb_rd_data)
    );


    // -------------------------------------------------------------------------
    // Task-uri pentru scriere date
    // -------------------------------------------------------------------------
    task data_write_vertex(input [VERT_COUNT-1:0] addr, input signed [DATA_WIDTH-1:0] x, input signed [DATA_WIDTH-1:0] y, input signed [DATA_WIDTH-1:0] z);
        begin
            @(posedge clk);
            vb_wr_en   = 1;
            vb_wr_cs   = 1;
            vb_wr_addr = addr;
            vb_wr_data = {z, y, x};
            @(posedge clk);
            vb_wr_en   = 0;
            vb_wr_cs   = 0;
        end
    endtask

    task data_write_edge(input [EDGE_COUNT-1:0] addr, input [VERT_COUNT-1:0] idx_a, input [VERT_COUNT-1:0] idx_b);
        begin
            @(posedge clk);
            eb_wr_en   = 1;
            eb_wr_cs   = 1;
            eb_wr_addr = addr;
            eb_wr_data = {idx_b, idx_a};
            @(posedge clk);
            eb_wr_en   = 0;
            eb_wr_cs   = 0;
        end
    endtask

    // -------------------------------------------------------------------------
    // Afisare tip rotatie
    // -------------------------------------------------------------------------
    
    task print_rotation_stat;
        input [2:0] rot;
        begin
            case (rot)
                3'b000: $display("[STAT] Tip rotatie: Rotatie pe axa X, sens trigonometric");
                3'b001: $display("[STAT] Tip rotatie: Rotatie pe axa X, sens orar");
                3'b010: $display("[STAT] Tip rotatie: Rotatie pe axa Y, sens trigonometric");
                3'b011: $display("[STAT] Tip rotatie: Rotatie pe axa Y, sens orar");
                3'b100: $display("[STAT] Tip rotatie: Rotatie pe axa Z, sens trigonometric");
                3'b101: $display("[STAT] Tip rotatie: Rotatie pe axa Z, sens orar");
                default: $display("[STAT] Tip rotatie: Rotatie necunoscuta");
            endcase
        end
    endtask


    // -------------------------------------------------------------------------
    // Export Framebuffer -> Fisier .BMP
    // -------------------------------------------------------------------------
    integer file_id;
    integer y, word_idx, bit_idx;
    reg [31:0] bmp_file_size;
    reg [31:0] WORDS_PER_ROW;
    
    task export_framebuffer_to_bmp;
        begin
            WORDS_PER_ROW = H_RES / WORD_BITS;
            bmp_file_size = 54 + (H_RES * V_RES * 3);

            file_id = $fopen("output_frame.bmp", "wb");
            if (!file_id) begin
                $display("[ERORARE] Imposibil de deschis fisierul bitmap!");
                $finish;
            end

            // 1. BMP FILE HEADER
            $fwrite(file_id, "%c%c", "B", "M");                         
            $fwrite(file_id, "%c%c%c%c", bmp_file_size[7:0], bmp_file_size[15:8], bmp_file_size[23:16], bmp_file_size[31:24]); 
            $fwrite(file_id, "%c%c%c%c", 8'h00, 8'h00, 8'h00, 8'h00);   
            $fwrite(file_id, "%c%c%c%c", 8'h36, 8'h00, 8'h00, 8'h00);   

            // 2. BITMAP INFO HEADER
            $fwrite(file_id, "%c%c%c%c", 8'h28, 8'h00, 8'h00, 8'h00);   
            $fwrite(file_id, "%c%c%c%c", H_RES[7:0], H_RES[15:8], H_RES[23:16], H_RES[31:24]); 
            $fwrite(file_id, "%c%c%c%c", V_RES[7:0], V_RES[15:8], V_RES[23:16], V_RES[31:24]); 
            $fwrite(file_id, "%c%c",     8'h01, 8'h00);                 
            $fwrite(file_id, "%c%c",     8'h18, 8'h00);                 
            $fwrite(file_id, "%c%c%c%c", 8'h00, 8'h00, 8'h00, 8'h00);   
            $fwrite(file_id, "%c%c%c%c", 8'h00, 8'h00, 8'h00, 8'h00);   
            $fwrite(file_id, "%c%c%c%c", 8'h13, 8'h0B, 8'h00, 8'h00);   
            $fwrite(file_id, "%c%c%c%c", 8'h13, 8'h0B, 8'h00, 8'h00);   
            $fwrite(file_id, "%c%c%c%c", 8'h00, 8'h00, 8'h00, 8'h00);   
            $fwrite(file_id, "%c%c%c%c", 8'h00, 8'h00, 8'h00, 8'h00);   

            // 3. PIXEL DATA
            for (y = V_RES-1; y >= 0; y = y-1) begin
                for (word_idx = 0; word_idx < WORDS_PER_ROW; word_idx = word_idx+1) begin
                    
                    // Seteaza adresa
                    fb_rd_addr = (y * WORDS_PER_ROW) + word_idx;
                    @(posedge clk);   // framebuffer latcheaza adresa
                    @(posedge clk);   // fb_rd_data valid acum ← un ciclu extra
                    
                    for (bit_idx = 0; bit_idx < WORD_BITS; bit_idx = bit_idx+1) begin
                        if (fb_rd_data[bit_idx])
                            $fwrite(file_id, "%c%c%c", 8'hFF, 8'hFF, 8'hFF);
                        else
                            $fwrite(file_id, "%c%c%c", 8'h00, 8'h00, 8'h00);
                    end
                end
            end

            $fclose(file_id);
            $display("[SUCCES] Fisierul 'output_frame.bmp' a fost salvat la timpul %0d us.", $time / 1000);
        end
    endtask


    // Variabile pentru calculul dinamic al timpului
    real start_time_ns;
    real end_time_ns;
    real frame_time_us;
    real fps;
    
    // Contorizare cicluri de ceas hardware active
    integer clk_cycles = 0;
    always @(posedge clk) begin
        if (busy) clk_cycles = clk_cycles + 1;
    end

    





    // -------------------------------------------------------------------------
    // Scenariu de Testare
    // -------------------------------------------------------------------------
    initial begin
        $display("-------------------------------------------------");
        $display("=== START TEST MODUL TOP ===");
        start_frame   = 0;
        vertex_count  = 0;
        edge_count    = 0;
        fb_rd_addr    = 0;
        

        // --- AICI INTEGRĂM PARAMETRII NOI ---
        rotation_type = ROTATION;       
        angle         = 10'd35;        // Unghi de 80 grade

        vb_wr_en = 0; vb_wr_cs = 0; vb_wr_addr = 0; vb_wr_data = 0;
        eb_wr_en = 0; eb_wr_cs = 0; eb_wr_addr = 0; eb_wr_data = 0;

        wait(rst_n == 1'b0);
        wait(rst_n == 1'b1);
        
        
        @(posedge clk);
        ps_buffer_mode = 1;
        $display("Sistemul a iesit din reset. Incepe incarcarea geometriei la timpul %0d us.", $time / 1000);

        // 1. Incarcare Vertecși (Format Q16.16)
        data_write_vertex(8'd0, N, N, N); // v0: (-0.5, -0.5, -0.5)
        data_write_vertex(8'd1, N, P, N); // v1: (-0.5, +0.5, -0.5)
        data_write_vertex(8'd2, P, P, N); // v2: (+0.5, +0.5, -0.5)
        data_write_vertex(8'd3, P, N, N); // v3: (+0.5, -0.5, -0.5)
        data_write_vertex(8'd4, N, N, P); // v4: (-0.5, -0.5, +0.5)
        data_write_vertex(8'd5, N, P, P); // v5: (-0.5, +0.5, +0.5)
        data_write_vertex(8'd6, P, P, P); // v6: (+0.5, +0.5, +0.5)
        data_write_vertex(8'd7, P, N, P); // v7: (+0.5, -0.5, +0.5)

        // 2. Incarcare Muchii (Edge Topologies)
        // Front face (0,1,2,3)
        data_write_edge(10'd0, 10'd0, 10'd1);
        data_write_edge(10'd1, 10'd1, 10'd2);
        data_write_edge(10'd2, 10'd2, 10'd3);
        data_write_edge(10'd3, 10'd3, 10'd0);
        // Back face (4,5,6,7)
        data_write_edge(10'd4, 10'd4, 10'd5);
        data_write_edge(10'd5, 10'd5, 10'd6);
        data_write_edge(10'd6, 10'd6, 10'd7);
        data_write_edge(10'd7, 10'd7, 10'd4);
        // Left face
        data_write_edge(10'd8, 10'd1, 10'd5);
        data_write_edge(10'd9, 10'd4, 10'd0);
        // Right face
        data_write_edge(10'd10, 10'd2, 10'd6);
        data_write_edge(10'd11, 10'd7, 10'd3);

        // Configurăm pachetul hardware-ului
        @(posedge clk);
        vertex_count = 8'b0000_1000;
        edge_count   = 10'b00_0000_1100;
        
        @(posedge clk);
        ps_buffer_mode = 0;
        repeat(5) @(posedge clk);
        
        
        $display("Pornire impuls start_frame la timpul %0d us.", $time / 1000);
        start_frame  = 1;
        start_time_ns = $realtime; // Salvează exact momentul de pornire (în ns)
        @(posedge clk);
        start_frame  = 0;


        @(posedge frame_done);
        end_time_ns = $realtime; // Salvează momentul finalizării (în ns)       

        // Calcule statistice dinamice
        frame_time_us = (end_time_ns - start_time_ns) / 1000.0; // ns în us
        fps = 1000000.0 / frame_time_us;
        
        $display("=== REZULTATE PERFORMANȚĂ HARDWARE ===");
        $display("[STAT] Frecventa ceas:               %0d MHz", (1/ $itor(CK_PER)) * 1000);
        $display("[STAT] Format Q:                     Q%0d.%0d semnat", INT_BITS, FRAC_BITS);
        $display("[STAT] Focala:                       %0g mm", ($itor(FOCAL) / SCALE) * 1000);
        $display("[STAT] Offset camera:                %0g m", ($itor(CAM_Z) / SCALE));
        $display("[STAT] Latime ecran:                 %0d px", $itor(SCREEN_WIDTH) / SCALE);
        $display("[STAT] Inaltime ecran:               %0d px", $itor(SCREEN_HEIGHT) / SCALE);
        print_rotation_stat(ROTATION);
        $display("[STAT] Timp pur de randare (calcul): %0.2f us", frame_time_us);
        $display("[STAT] Cicluri de ceas consumate:    %0d cicluri", clk_cycles);
        $display("[STAT] Performanță teoretică:        %0.2f FPS", fps);
        $display("=====================================");
        
        
        $display("[STATUS] Semnal frame_done detectat. Incepe exportul cadrelor BMP la timpul %0d us.", $time / 1000);
        
        export_framebuffer_to_bmp();

        #100;
        $display("=== FINAL TEST MODUL TOP ===");
        $display("-------------------------------------------------");
        $finish;
    end


endmodule