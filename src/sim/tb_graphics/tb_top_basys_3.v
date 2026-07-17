`timescale 1ns / 1ps

module tb_top_basys_3;

    // -------------------------------------------------------------------
    // Parametri (trebuie sa corespunda cu top_basys_3 / config_block)
    // -------------------------------------------------------------------
    parameter H_RES = 640;
    parameter V_RES = 480;
    parameter NUM_FRAMES_TO_CAPTURE = 20;   // cate cadre exportam ca BMP

    // -------------------------------------------------------------------
    // Semnale fizice (ca pe placa)
    // -------------------------------------------------------------------
    reg         sys_clk;
    reg  [2:0]  sw;
    reg         btn_rst;
    reg         btn_left;
    reg         btn_right;
    reg         btn_up;      // NOU: ajustare FOCAL/CAM_Z (creste)
    reg         btn_down;    // NOU: ajustare FOCAL/CAM_Z (scade)

    wire        hsync, vsync;
    wire [3:0]  vga_red, vga_green, vga_blue;
    wire [3:0]  an;
    wire [6:0]  seg;
    wire        dp;
    wire        rst_led;

    // -------------------------------------------------------------------
    // Ceas de 100 MHz de pe placa (sys_clk)
    // -------------------------------------------------------------------
    initial sys_clk = 0;
    always #5 sys_clk = ~sys_clk;   // 10 ns perioada -> 100 MHz

    // -------------------------------------------------------------------
    // Instantiere DUT (identic cu ce e pe placa)
    // Presupune ca top_basys_3 are acum porturile noi btn_up/btn_down,
    // pasate mai departe catre config_block.
    // -------------------------------------------------------------------
    top_basys_3 uut (
        .sys_clk   (sys_clk),
        .sw        (sw),
        .btn_rst   (btn_rst),
        .btn_left  (btn_left),
        .btn_right (btn_right),
        .btn_up    (btn_up),
        .btn_down  (btn_down),
        .hsync     (hsync),
        .vsync     (vsync),
        .vga_red   (vga_red),
        .vga_green (vga_green),
        .vga_blue  (vga_blue),
        .an        (an),
        .seg       (seg),
        .dp        (dp),
        .rst_led   (rst_led)
    );

    // -------------------------------------------------------------------
    // Acces ierarhic la semnalele interne necesare capturii/debug-ului
    // (pixel_x/pixel_y/vde sunt wire-uri declarate direct in top_basys_3;
    //  frame_done e wire-ul intern intre config_block si top_graphics;
    //  focal/camz sunt noile registre din config_block, utile pt debug)
    // -------------------------------------------------------------------
    // uut.pixel_x, uut.pixel_y, uut.vde, uut.frame_done
    // uut.u_config.focal, uut.u_config.camz   <- ajusteaza numele ierarhic
    //   daca instanta din top_basys_3 se numeste altfel (ex: u_config)

    // -------------------------------------------------------------------
    // Buffer local pentru un cadru capturat (1 bit per pixel: alb/negru)
    // -------------------------------------------------------------------
    reg captured_frame [0:H_RES*V_RES-1];
    integer frame_number;

    // -------------------------------------------------------------------
    // Task: capteaza EXACT un cadru video complet, sincron cu vsync,
    // esantionand pixel_x/pixel_y/vde/vga_red la fiecare ciclu de pixel_clk
    // -------------------------------------------------------------------
    task capture_one_frame;
        begin
            // Asteptam inceputul unui cadru nou (frontul descrescator al vsync
            // marcheaza de regula inceputul impulsului de sincronizare verticala)
            @(negedge vsync);

            // Esantionam continuu pana la urmatorul inceput de cadru
            fork
                begin : sample_loop
                    forever begin
                        @(posedge uut.pixel_clk);
                        if (uut.vde) begin
                            captured_frame[(uut.pixel_y * H_RES) + uut.pixel_x]
                                <= (vga_red != 4'h0) ? 1'b1 : 1'b0;
                        end
                    end
                end
                begin
                    @(negedge vsync);   // urmatorul cadru a inceput -> oprim esantionarea
                    disable sample_loop;
                end
            join
        end
    endtask

    // -------------------------------------------------------------------
    // Task: export BMP din captured_frame (identic ca format cu cel vechi)
    // -------------------------------------------------------------------
    integer file_id, x, y;
    reg [31:0] bmp_file_size;
    reg [8*50-1:0] filename_dynamic;

    task export_captured_frame_to_bmp;
        input integer frame_index;
        begin
            bmp_file_size = 54 + (H_RES * V_RES * 3);
            $sformat(filename_dynamic, "output_frames/board_frame_%03d.bmp", frame_index);

            file_id = $fopen(filename_dynamic, "wb");
            if (!file_id) begin
                $display("[EROARE] Nu pot deschide %s", filename_dynamic);
                $finish;
            end

            $fwrite(file_id, "%c%c", "B", "M");
            $fwrite(file_id, "%c%c%c%c", bmp_file_size[7:0], bmp_file_size[15:8], bmp_file_size[23:16], bmp_file_size[31:24]);
            $fwrite(file_id, "%c%c%c%c", 8'h00, 8'h00, 8'h00, 8'h00);
            $fwrite(file_id, "%c%c%c%c", 8'h36, 8'h00, 8'h00, 8'h00);
            $fwrite(file_id, "%c%c%c%c", 8'h28, 8'h00, 8'h00, 8'h00);
            $fwrite(file_id, "%c%c%c%c", H_RES[7:0], H_RES[15:8], H_RES[23:16], H_RES[31:24]);
            $fwrite(file_id, "%c%c%c%c", V_RES[7:0], V_RES[15:8], V_RES[23:16], V_RES[31:24]);
            $fwrite(file_id, "%c%c", 8'h01, 8'h00);
            $fwrite(file_id, "%c%c", 8'h18, 8'h00);
            $fwrite(file_id, "%c%c%c%c", 8'h00, 8'h00, 8'h00, 8'h00);
            $fwrite(file_id, "%c%c%c%c", 8'h00, 8'h00, 8'h00, 8'h00);
            $fwrite(file_id, "%c%c%c%c", 8'h13, 8'h0B, 8'h00, 8'h00);
            $fwrite(file_id, "%c%c%c%c", 8'h13, 8'h0B, 8'h00, 8'h00);
            $fwrite(file_id, "%c%c%c%c", 8'h00, 8'h00, 8'h00, 8'h00);
            $fwrite(file_id, "%c%c%c%c", 8'h00, 8'h00, 8'h00, 8'h00);

            // BMP scrie randurile de jos in sus
            for (y = V_RES-1; y >= 0; y = y-1) begin
                for (x = 0; x < H_RES; x = x+1) begin
                    if (captured_frame[(y*H_RES)+x])
                        $fwrite(file_id, "%c%c%c", 8'hFF, 8'hFF, 8'hFF);
                    else
                        $fwrite(file_id, "%c%c%c", 8'h00, 8'h00, 8'h00);
                end
            end

            $fclose(file_id);
            $display("[SUCCES] Salvat %s la timpul %0d us.", filename_dynamic, $time/1000);
        end
    endtask

    // -------------------------------------------------------------------
    // Scenariu de testare
    // -------------------------------------------------------------------
    initial begin
        $display("=== START TEST top_basys_3 (capture de pe VGA) ===");

        sw         = 3'b010;   // sw[1:0]=10 -> rotatie axa Z; sw[2]=0 -> ajustam FOCAL (nu CAM_Z)
        btn_rst    = 1'b1;
        btn_left   = 1'b0;
        btn_right  = 1'b1;      // tinut apasat continuu -> rotatie automata, 1 increment/cadru
        btn_up     = 1'b0;
        btn_down   = 1'b0;

        // Puls de reset
        repeat (10) @(posedge sys_clk);
        btn_rst = 1'b0;

        // Asteptam ca sistemul sa se stabilizeze (lock MMCM + incarcare geometrie automata
        // prin config_block, care porneste imediat dupa reset)
        #200000;   // ajusteaza daca modelul are multe vertecsi/muchii si incarcarea dureaza mai mult

        // --- Cadre 0..4: rotatie normala, FOCAL/CAM_Z neschimbate ---
        for (frame_number = 0; frame_number < 5; frame_number = frame_number + 1) begin
            $display("[INFO] Capturez cadrul %0d (baseline) ...", frame_number);
            capture_one_frame;
            export_captured_frame_to_bmp(frame_number);
        end

        // --- Cadre 5..9: tinem btn_up apasat, sw[2]=0 -> creste FOCAL ---
        $display("[INFO] Cresc FOCAL (btn_up, sw[3]=0) ...");
        sw[2]   = 1'b0;
        btn_up  = 1'b1;
        for (frame_number = 5; frame_number < 10; frame_number = frame_number + 1) begin
            $display("[INFO] Capturez cadrul %0d (FOCAL crescut) ...", frame_number);
            capture_one_frame;
            export_captured_frame_to_bmp(frame_number);
        end
        btn_up = 1'b0;

        // --- Cadre 10..14: comutam pe CAM_Z (sw[2]=1), tinem btn_down apasat ---
        $display("[INFO] Scad CAM_Z (btn_down, sw[3]=1) ...");
        sw[2]     = 1'b1;
        btn_down  = 1'b1;
        for (frame_number = 10; frame_number < 15; frame_number = frame_number + 1) begin
            $display("[INFO] Capturez cadrul %0d (CAM_Z scazut) ...", frame_number);
            capture_one_frame;
            export_captured_frame_to_bmp(frame_number);
        end
        btn_down = 1'b0;
        sw[2]    = 1'b0;   // revenim la starea initiala pentru cadrele ramase

        // --- Restul cadrelor: rotatie normala, ca sa completam NUM_FRAMES_TO_CAPTURE ---
        for (frame_number = 15; frame_number < NUM_FRAMES_TO_CAPTURE; frame_number = frame_number + 1) begin
            $display("[INFO] Capturez cadrul %0d (final) ...", frame_number);
            capture_one_frame;
            export_captured_frame_to_bmp(frame_number);
        end

        $display("=== FINAL TEST ===");
        $finish;
    end

endmodule