`timescale 1ns / 1ps

module tb_top_graphics;

    // -------------------------------------------------------------------------
    // Parametri top_graphics (NU ATINGE)
    // -------------------------------------------------------------------------
    
   // parameter real CK_PER       = 13.468; // Ceas 74.25 MHz: frecventa ceasului ptr FPGA PL (perioadă ~13.5 ns)
    parameter real CK_PER       = 10.0;
    parameter INT_BITS          = 16;
    parameter FRAC_BITS         = 12;
    
    parameter DATA_WIDTH        = INT_BITS + FRAC_BITS;
    parameter real SCALE        = 2.0**FRAC_BITS;       // Factor de scalare pentru Q16.16 (2^FRAC_BITS)

    parameter VERT_ADDR         = 8;
    parameter EDGE_ADDR         = 10; 
      
    parameter COORD_BITS        = 12; 
    parameter WORD_BITS         = 32;
    

    // -------------------------------------------------------------------------
    // Parametri modificabili
    // -------------------------------------------------------------------------
    
    parameter H_RES             = 1280;
    parameter V_RES             = 720; 
    
    parameter FOCAL             = 2;        // Distanta focala
    parameter CAM_Z             = 2;        // Distanta camera

    
    parameter ROTATION          = 3'b010;
    
    // -------------------------------------------------------------------------
    // Parametri Calculati Automat (NU ATINGE)
    // -------------------------------------------------------------------------
    
    // Calculează lățimea și înălțimea în format Q16.16 automat pe baza H_RES și V_RES
    // Ex: 320 << 16 devine 32'h0140_0000
    
    localparam [DATA_WIDTH-1:0] SCREEN_WIDTH    = H_RES << FRAC_BITS; 
    localparam [DATA_WIDTH-1:0] SCREEN_HEIGHT   = V_RES << FRAC_BITS;
    
    localparam FB_ADDR_WIDTH                    = $clog2((H_RES*V_RES)/WORD_BITS);


    // -------------------------------------------------------------------------
    // Semnale de interconectare
    // -------------------------------------------------------------------------
    wire                        clk;
    wire                        rst_n;
    
    reg                         buffer_mode;
    reg                         start_frame;
    reg  [VERT_ADDR-1:0]        vertex_count;
    reg  [EDGE_ADDR-1:0]        edge_count;
    reg  [9:0]                  angle;
    reg  [2:0]                  rotation_type;

    wire                        frame_done;
    wire                        busy;

    reg  [VERT_ADDR-1:0]        vb_wr_addr;
    reg  [3*DATA_WIDTH-1:0]     vb_wr_data;
    reg                         vb_wr_cs;
    reg                         vb_wr_en;

    reg  [EDGE_ADDR-1:0]        eb_wr_addr;
    reg  [2*VERT_ADDR-1:0]      eb_wr_data;
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
        
        .VERT_ADDR(VERT_ADDR),
        .EDGE_ADDR(EDGE_ADDR),
        
        .COORD_BITS(COORD_BITS),
        .H_RES(H_RES),
        .V_RES(V_RES),
        
        .FOCAL(FOCAL),
        .CAM_Z(CAM_Z),      
        
        .WORD_BITS(WORD_BITS)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        
        .buffer_mode(buffer_mode),
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
    task data_write_vertex(input [VERT_ADDR-1:0] addr, input signed [DATA_WIDTH-1:0] x, input signed [DATA_WIDTH-1:0] y, input signed [DATA_WIDTH-1:0] z);
        begin
            @(posedge clk);
            vb_wr_en   = 1;
            vb_wr_cs   = 1;
            vb_wr_addr = addr;
            
            vb_wr_data = {x, y, z};
            
            @(posedge clk);
            vb_wr_en   = 0;
            vb_wr_cs   = 0;
        end
    endtask

    task data_write_edge(input [EDGE_ADDR-1:0] addr, input [VERT_ADDR-1:0] idx_a, input [VERT_ADDR-1:0] idx_b);
        begin
            @(posedge clk);
            eb_wr_en   = 1;
            eb_wr_cs   = 1;
            eb_wr_addr = addr;
            
            eb_wr_data = {idx_a, idx_b};
            
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
                3'b000:  $display("[STAT] Tip rotatie:                  Rotatie pe axa X, sens trigonometric");
                3'b001:  $display("[STAT] Tip rotatie:                  Rotatie pe axa X, sens orar");
                3'b010:  $display("[STAT] Tip rotatie:                  Rotatie pe axa Y, sens trigonometric");
                3'b011:  $display("[STAT] Tip rotatie:                  Rotatie pe axa Y, sens orar");
                3'b100:  $display("[STAT] Tip rotatie:                  Rotatie pe axa Z, sens trigonometric");
                3'b101:  $display("[STAT] Tip rotatie:                  Rotatie pe axa Z, sens orar");
                default: $display("[STAT] Tip rotatie:                  Rotatie necunoscuta");
            endcase
        end
    endtask


    // -------------------------------------------------------------------------
    // Export Framebuffer -> Fisier .BMP (Modificat pentru secvente)
    // -------------------------------------------------------------------------
    integer file_id;
    integer y, word_idx, bit_idx;
    reg [31:0] bmp_file_size;
    reg [31:0] WORDS_PER_ROW;
    reg [8*50-1:0] filename_dynamic; // String pentru numele fisierului
    
    task export_framebuffer_to_bmp;
        input integer frame_index; // <-- Parametru nou adaugat
        begin
            WORDS_PER_ROW = H_RES / WORD_BITS;
            bmp_file_size = 54 + (H_RES * V_RES * 3);

            // Generam numele fisierului: ex. "output_frame_000.bmp"
            $sformat(filename_dynamic, "output_frames/output_frame_%03d.bmp", frame_index);

            file_id = $fopen(filename_dynamic, "wb");
            if (!file_id) begin
                $display("[ERORARE] Imposibil de deschis fisierul %s!", filename_dynamic);
                $finish;
            end

            // ... (Liniile cu scrierea Header-ului BMP raman absolut la fel) ...
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
                    fb_rd_addr = (y * WORDS_PER_ROW) + word_idx;
                    @(posedge clk);   
                    @(posedge clk);   
                    for (bit_idx = 0; bit_idx < WORD_BITS; bit_idx = bit_idx+1) begin
                        if (fb_rd_data[bit_idx])
                            $fwrite(file_id, "%c%c%c", 8'hFF, 8'hFF, 8'hFF);
                        else
                            $fwrite(file_id, "%c%c%c", 8'h00, 8'h00, 8'h00);
                    end
                end
            end

            $fclose(file_id);
            $display("[SUCCES] Fisierul '%s' a fost salvat la timpul %0d us.", filename_dynamic, $time / 1000);
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
    // Task automatizat pentru încărcarea vertecșilor din fișier
    // -------------------------------------------------------------------------
task load_vertices;
    input [8*50-1:0] filename;
    output integer total_vertices;
    
    integer file_v;
    integer status;
    reg [DATA_WIDTH-1:0] tmp_x, tmp_y, tmp_z;
    
    // Registru temporar uriaș pentru a citi toată linia concatenată (X, Y, Z împreună)
    reg [(3*DATA_WIDTH)-1:0] combined_vertex;
    
    begin
        total_vertices = 0;
        file_v = $fopen(filename, "r");
        if (file_v == 0) begin
            $display("[EROARE] Nu s-a putut deschide: %s", filename);
            $finish;
        end

        while (!$feof(file_v)) begin
            // Citim un singur bloc hexazecimal (%h) de pe linie
            status = $fscanf(file_v, "%h\n", combined_vertex);
            
            if (status == 1) begin
                // Tăiem blocul în funcție de ordinea XYZ salvată în scriptul Python
                tmp_x = combined_vertex[(3*DATA_WIDTH)-1 : 2*DATA_WIDTH]; // Primii 28 biți
                tmp_y = combined_vertex[(2*DATA_WIDTH)-1 : DATA_WIDTH];   // Următorii 28 biți
                tmp_z = combined_vertex[DATA_WIDTH-1 : 0];               // Ultimii 28 biți
                
                data_write_vertex(total_vertices[VERT_ADDR-1:0], tmp_x, tmp_y, tmp_z);
                total_vertices = total_vertices + 1;
            end
        end
        $fclose(file_v);
        $display("[SUCCES] Incarcare completa: %0d vertecsi din '%s'.", total_vertices, filename);
    end
endtask

    // -------------------------------------------------------------------------
    // Task automatizat pentru încărcarea muchiilor din fișier
    // -------------------------------------------------------------------------
task load_edges;
    input [8*50-1:0] filename;
    output integer total_edges;
    
    integer file_e;
    integer status;
    reg [VERT_ADDR-1:0] tmp_idx_a, tmp_idx_b;
    
    // Registru temporar pentru a citi ambii indici lipiți
    reg [(2*VERT_ADDR)-1:0] combined_edge;
    
    begin
        total_edges = 0;
        file_e = $fopen(filename, "r");
        if (file_e == 0) begin
            $display("[EROARE] Nu s-a putut deschide: %s", filename);
            $finish;
        end

        while (!$feof(file_e)) begin
            // Citim valoarea hexazecimală lipită
            status = $fscanf(file_e, "%h\n", combined_edge);
            
            if (status == 1) begin
                // Presupunând că ordinea în mem este V1 urmat de V2:
                tmp_idx_a = combined_edge[(2*VERT_ADDR)-1 : VERT_ADDR]; // Primul index
                tmp_idx_b = combined_edge[VERT_ADDR-1 : 0];             // Al doilea index
                
                data_write_edge(total_edges[EDGE_ADDR-1:0], tmp_idx_a, tmp_idx_b);
                total_edges = total_edges + 1;
            end
        end
        $fclose(file_e);
        $display("[SUCCES] Incarcare completa: %0d muchii din '%s'.", total_edges, filename);
    end
endtask





    // Variabile pentru stocarea dinamică a numărului de elemente returnate de task-uri
    integer parsed_vertices;
    integer parsed_edges;
    integer i;
    
    // -------------------------------------------------------------------------
    // Scenariu de Testare
    // -------------------------------------------------------------------------
   
    initial begin
        $display("-------------------------------------------------");
        $display("=== START TEST ANIMATIE 3D ===");
        
        // 1. Stare initiala (Idle)
        start_frame   = 0;
        vertex_count  = 0;
        edge_count    = 0;
        fb_rd_addr    = 0;
        rotation_type = ROTATION;        
        angle         = 10'd0; // Incepem de la unghi 0

        vb_wr_en = 0; vb_wr_cs = 0; vb_wr_addr = 0; vb_wr_data = 0;
        eb_wr_en = 0; eb_wr_cs = 0; eb_wr_addr = 0; eb_wr_data = 0;

        // 2. Asteptare reset hardware
        wait(rst_n == 1'b0);
        wait(rst_n == 1'b1);
        @(posedge clk);

        // 3. Incarcarea geometriei (se face o singura data la inceput)
        buffer_mode = 1;
        $display("[INFO] Incarcare geometrie la timpul %0d us.", $time / 1000);
        
        
        
        //load_vertices("vertices_prism_q_16_8.txt", parsed_vertices);
        //load_vertices("vertices_prism.txt", parsed_vertices);
        //load_edges("edges_prism.txt", parsed_edges);
        load_vertices("vertices_unitbv.mem", parsed_vertices);
        load_edges("edges_unitbv.mem", parsed_edges);    
        
        
        vertex_count = parsed_vertices[VERT_ADDR-1:0];          
        edge_count   = parsed_edges[EDGE_ADDR-1:0];     
        
        @(posedge clk);
        buffer_mode = 0; // Cedam controlul nucleului grafic
        repeat(5) @(posedge clk);

        // 4. Bucla de generare cadre (Exemplu: 36 cadre pentru o rotatie completa)
        for (i = 0; i < 720; i = i + 1) begin
            $display("\n[FRAME %0d] Randare unghi: %0d grade", i, angle);

            rotation_type = 3'b010; 

            // Trigger start_frame
            start_frame = 1;
            @(posedge clk);
            start_time_ns = $realtime;
            start_frame = 0;

            // Asteptam terminarea randarii
            @(posedge frame_done);
            end_time_ns = $realtime;

            // Export BMP secvential
            export_framebuffer_to_bmp(i);

            // Incrementam unghiul pentru cadrul urmator
            angle = angle + 10'd1; 
            repeat(10) @(posedge clk);
        end

        // 5. Finalizare
        $display("\n=== ANIMATIE COMPLETA ===");
        $display("=== REZULTATE PERFORMANȚĂ HARDWARE ===");
        $display("[STAT] Frecventa ceas:               %0.3f MHz"       , (1.0 / $itor(CK_PER)) * 1000.0);
        $display("[STAT] Format Q:                     Q%0d.%0d semnat" , INT_BITS, FRAC_BITS);
        $display("[STAT] Focala:                       %0g mm"          , $itor(FOCAL) * 1000);
        $display("[STAT] Offset camera:                %0g m"           , $itor(CAM_Z));
        $display("[STAT] Latime ecran:                 %0d px"          , $itor(SCREEN_WIDTH) / SCALE);
        $display("[STAT] Inaltime ecran:               %0d px"          , $itor(SCREEN_HEIGHT) / SCALE);
        print_rotation_stat(ROTATION);
        $display("[STAT] Timp pur de randare (calcul): %0.2f us"        , frame_time_us);
        $display("[STAT] Cicluri de ceas consumate:    %0d cicluri"     , clk_cycles);
        $display("[STAT] Performanță teoretică:        %0.2f FPS"       , fps);
        $display("=====================================");
           
        #100;
        $display("=== FINAL TEST MODUL TOP ===");
        $display("-------------------------------------------------");
        $finish;
    end

endmodule
