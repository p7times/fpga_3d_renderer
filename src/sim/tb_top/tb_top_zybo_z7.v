`timescale 1ns / 1ps

module tb_top_zybo_z7;

    // =========================================================
    // PARAMETRI (sincronizați cu instanțierea DUT)
    // =========================================================
    parameter real CK_PER   = 13.468; // Ceas 74.25 MHz (perioadă ~13.5 ns)

    parameter NUM_VERTICES  = 16;
    parameter NUM_EDGES     = 24;
    parameter WORD_BITS     = 32;

    parameter H_RES         = 320;
    parameter V_RES         = 240;

    localparam FB_ADDR_WIDTH = $clog2((H_RES*V_RES)/WORD_BITS);

    // =========================================================
    // CLOCK / RESET
    // =========================================================
    wire clk;
    wire rst_n;

    ck_rst_tb #(
        .CK_SEMIPERIOD(CK_PER/2)
    ) u_ck_rst (
        .clk  (clk),
        .rst_n(rst_n)
    );

    // =========================================================
    // DUT I/O
    // =========================================================
    reg  [3:0] sw;
    reg        btn_rst;
    reg        ready;
    
    // ADĂUGAT: Registru pentru a controla adresa de citire din Framebuffer
    reg  [FB_ADDR_WIDTH-1:0] fb_rd_addr; 
    wire [WORD_BITS-1:0]     fb_rd_data;
    wire                     frame_done_out;

    // =========================================================
    // INSTANȚIERE DUT
    // =========================================================
    top_zybo_z7 #(
        .NUM_VERTICES(NUM_VERTICES),
        .NUM_EDGES(NUM_EDGES),
        
        .WORD_BITS(WORD_BITS),
        .H_RES(H_RES),
        .V_RES(V_RES)
    ) dut (
        .sys_clk(clk),
        .sw(sw),
        .btn_rst(btn_rst),
        .ready(ready),
        .fb_rd_addr(fb_rd_addr),
        .fb_rd_data(fb_rd_data),
        .frame_done_out(frame_done_out)
    );

    // =========================================================
    // TASK: EXPORT FRAMEBUFFER CĂTRE BMP
    // =========================================================
    integer frame_index;
    integer file_id;
    integer y, word_idx, bit_idx;
    reg [31:0] bmp_file_size;
    reg [31:0] WORDS_PER_ROW;
    
    task export_framebuffer_to_bmp;
        input integer idx;
        reg [8*50-1:0] filename;
        begin
            WORDS_PER_ROW = H_RES / WORD_BITS;
            bmp_file_size = 54 + (H_RES * V_RES * 3);
            
            $sformat(filename, "output_frames_top/frame_%03d.bmp", idx);

            file_id = $fopen(filename, "wb");
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
                    @(posedge clk);   // fb_rd_data valid acum <- un ciclu extra
                    
                    for (bit_idx = 0; bit_idx < WORD_BITS; bit_idx = bit_idx+1) begin
                        if (fb_rd_data[bit_idx])
                            $fwrite(file_id, "%c%c%c", 8'hFF, 8'hFF, 8'hFF);
                        else
                            $fwrite(file_id, "%c%c%c", 8'h00, 8'h00, 8'h00);
                    end
                end
            end

            $fclose(file_id);
            $display("[SUCCES] Fisierul '%s' a fost salvat la timpul %0d us.",filename, $time / 1000);
        end
    endtask

    
    // =========================================================
    // MAIN CONTROL FLOW (Reset -> Wait -> Export)
    // =========================================================
    initial begin
        $display("-------------------------------------------------");
        $display("=== START TEST MODUL TOP_ZYBO_Z7 ===");
        // 1. Inițializare semnale (Activare Reset)
        btn_rst = 1;
        frame_index = 0; 
        ready = 0;
        sw = 4'b0001;
        fb_rd_addr = 0;

        wait(rst_n == 1'b0);
        wait(rst_n == 1'b1);
        @(posedge clk);
        
        // 2. Eliberare Reset
        btn_rst = 0; 
        $display("[%0t] [TB] Reset eliberat. Se asteapta generarea frame-ului...", $time);

        // 3. Așteptare finalizare randare
        // Se bazează pe semnalul expus pe portul modulului DUT
        repeat(360) begin
            @(posedge frame_done_out);
            $display("[%0t] [TB] Frame done detectat. Începe extragerea BMP...", $time);
            
            repeat(5) @(posedge clk);
            export_framebuffer_to_bmp(frame_index);
            $display("[%0t] [TB] Simulare încheiată cu succes.", $time);
            
            frame_index = frame_index + 1;
            ready = 1;
            @(posedge clk);
            ready = 0;
        end
        
        // PENTRU A CONVERTI FRAME-URILE INTR-UN GIF
        // DESCHIDE TERMINALUL IN DIRECTORUL XSIM SI RULEAZA URMATOAREA COMANDA:
        
        // ffmpeg -framerate 60 -i output_frames_top/frame_%03d.bmp -vf "scale=320:240" output.gif

        $finish;
    end

endmodule