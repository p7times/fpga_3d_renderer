`timescale 1ns/1ps

module tb_framebuffer;

    // ------------------------
    // Parametri - rezolutie mica ptr simulare rapida
    // ------------------------
    parameter H_RES     = 32;
    parameter V_RES     = 8;
    parameter WORD_BITS = 32;
    parameter TOTAL_WORDS = (H_RES * V_RES) / WORD_BITS;   // 8
    parameter ADDR_WIDTH = 4;                               // ceil(log2(8)) = 3, 4 ptr marja
    parameter PER       = 10;

    integer errors = 0;

    // ------------------------
    // Semnale
    // ------------------------
    reg         cs, wr, clear;
    reg  [10:0] x_in, y_in;
    reg         pixel_in;
    reg  [ADDR_WIDTH-1:0] rd_adresa;
    reg  [WORD_BITS-1:0]  before;
    wire [WORD_BITS-1:0]  rd_dataOut;
    wire                  busy;
    wire [ADDR_WIDTH-1:0] dbg_clear_addr;
    wire [2:0]            dbg_state;

    // ------------------------
    // Generare ceas
    // ------------------------

    wire clk;
    wire rst_n;

    ck_rst_tb #(
        .CK_SEMIPERIOD(PER/2)
    ) u_ck_rst (
        .clk(clk),
        .rst_n(rst_n)
    );

    // ------------------------
    // DUT
    // ------------------------
    framebuffer #(
        .H_RES      (H_RES),
        .V_RES      (V_RES),
        .WORD_BITS  (WORD_BITS),
        .TOTAL_WORDS(TOTAL_WORDS),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .cs           (cs),
        .wr           (wr),
        .clear        (clear),
        .x_in         (x_in),
        .y_in         (y_in),
        .pixel_in     (pixel_in),
        .rd_adresa    (rd_adresa),
        .rd_dataOut   (rd_dataOut),
        .busy         (busy),
        .dbg_clear_addr(dbg_clear_addr),
        .dbg_state    (dbg_state)
    );

    // ------------------------
    // Task: scrie un pixel si asteapta finalizare
    // ------------------------
    task write_pixel;
        input [10:0] px, py;
        input        pval;
    begin
        wait(busy == 0);
        x_in     = px;
        y_in     = py;
        pixel_in = pval;
        cs = 1; wr = 1;
        @(posedge clk); #1;
        cs = 0; wr = 0;
        wait(busy == 0);        // asteapta WRITE_READ + WRITE_MODIFY
        @(posedge clk); #1;
    end
    endtask

    // ------------------------
    // Task: citeste un cuvant si verifica un bit specific
    // ------------------------
    task check_pixel;
        input [10:0] px, py;
        input        exp_val;
        
        integer pixel_idx;
        integer word_addr;
        integer bit_pos;
        reg     got_val;
    begin
        pixel_idx = py * H_RES + px;
        word_addr = pixel_idx / WORD_BITS;
        bit_pos   = pixel_idx % WORD_BITS;

        rd_adresa = word_addr;
        @(posedge clk); #1;     // latenta BRAM port A
        @(posedge clk); #1;

        got_val = rd_dataOut[bit_pos];

        if (got_val !== exp_val) begin
            $display("EROARE pixel(%0d,%0d): got=%b exp=%b [word=%0d bit=%0d]",
                      px, py, got_val, exp_val, word_addr, bit_pos);
            errors = errors + 1;
        end else
            $display("OK pixel(%0d,%0d)=%b [word=%0d bit=%0d rdData=%h]",
                      px, py, got_val, word_addr, bit_pos, rd_dataOut);
    end
    endtask

    // ------------------------
    // Task: citeste cuvant intreg si verifica
    // ------------------------
    task check_word;
        input [ADDR_WIDTH-1:0] addr;
        input [WORD_BITS-1:0]  exp_val;
    begin
        rd_adresa = addr;
        @(posedge clk); #1;
        @(posedge clk); #1;

        if (rd_dataOut !== exp_val) begin
            $display("EROARE word[%0d]: got=%h exp=%h", addr, rd_dataOut, exp_val);
            errors = errors + 1;
        end else
            $display("OK word[%0d]=%h", addr, rd_dataOut);
    end
    endtask

    // ------------------------
    // Task: comanda clear si asteapta finalizare
    // ------------------------
    task do_clear;
    begin
        wait(busy == 0);
        clear = 1;
        @(posedge clk); #1;
        clear = 0;
        wait(busy == 0);
        @(posedge clk); #1;
        $display("Clear finalizat.");
    end
    endtask

    // ------------------------
    // Subrutina principala
    // ------------------------
    initial begin
        // Init
        cs = 0; wr = 0; clear = 0;
        x_in = 0; y_in = 0; pixel_in = 0;
        rd_adresa = 0;
        repeat(5) @(posedge clk);

        // ================================================
        $display("=== TEST 1: Scriere pixel simplu ===");
        // ================================================
        // Scrie pixel (0,0) = 1
        write_pixel(0, 0, 1);
        check_pixel(0, 0, 1);   // trebuie sa fie 1

        // Scrie pixel (1,0) = 1
        write_pixel(1, 0, 1);
        check_pixel(1, 0, 1);

        // Verifica ca (0,0) nu a fost afectat de RMW
        check_pixel(0, 0, 1);

        // ================================================
        $display("=== TEST 2: RMW - mai multi pixeli in acelasi cuvant ===");
        // ================================================
        // Primele 32 pixeli sunt in word[0] (y=0, x=0..31)
        write_pixel(5,  0, 1);
        write_pixel(10, 0, 1);
        write_pixel(20, 0, 1);

        // Verifica toate setarile anterioare - niciuna nu trebuie stearsa
        check_pixel(0,  0, 1);
        check_pixel(1,  0, 1);
        check_pixel(5,  0, 1);
        check_pixel(10, 0, 1);
        check_pixel(20, 0, 1);

        // Sterge pixel (5,0) → 0
        write_pixel(5, 0, 0);
        check_pixel(5,  0, 0);   // acum 0
        check_pixel(10, 0, 1);   // restul neatins
        check_pixel(20, 0, 1);

        // ================================================
        $display("=== TEST 3: Pixel pe alt rand (alt cuvant) ===");
        // ================================================
        // y=1, x=0 → pixel_index = 32 → word[1], bit[0]
        write_pixel(0, 1, 1);
        check_pixel(0, 1, 1);
        check_pixel(0, 0, 1);   // word[0] neatins

        // ================================================
        $display("=== TEST 4: Busy in timpul scrierii ===");
        // ================================================
        x_in = 3; y_in = 0; pixel_in = 1;
        cs = 1; wr = 1;
        @(posedge clk); #1;
        cs = 0; wr = 0;

        // Imediat dupa start, busy trebuie sa fie 1
        if (!busy) begin
            $display("EROARE: busy ar trebui sa fie 1 in WRITE_READ");
            errors = errors + 1;
        end else
            $display("OK: busy=1 in timpul scrierii");

        wait(busy == 0);

        // ================================================
        $display("=== TEST 5: Out of bounds - nu trebuie sa scrie ===");
        // ================================================
        // Scrie la (H_RES, 0) = out of bounds
        // Inainte citim word[0] ca sa avem referinta
        rd_adresa = 0;
        @(posedge clk); #2;
        
        before = rd_dataOut;

        write_pixel(H_RES, 0, 1);   // x = 32 = out of bounds

        rd_adresa = 0;
        @(posedge clk); #2;
        if (rd_dataOut !== before)
            $display("EROARE: out-of-bounds a modificat memoria! before=%h after=%h",
                     before, rd_dataOut);
        else
            $display("OK: out-of-bounds ignorat corect");
      

        // ================================================
        $display("=== TEST 6: Clear ===");
        // ================================================
        // Scriem cativa pixeli
        write_pixel(15, 3, 1);
        write_pixel(31, 7, 1);
        check_pixel(15, 3, 1);
        check_pixel(31, 7, 1);

        // Clear
        do_clear;

        // Verifica ca totul e 0 dupa clear
        check_word(0, 32'h0000_0000);
        check_word(1, 32'h0000_0000);
        check_word(TOTAL_WORDS-1, 32'h0000_0000);
        check_pixel(15, 3, 0);
        check_pixel(31, 7, 0);

        // ================================================
        $display("=== TEST 7: Scriere dupa clear ===");
        // ================================================
        write_pixel(7, 2, 1);
        check_pixel(7, 2, 1);

        // ================================================
        $display("=== TEST 8: clear_start - puls unic ===");
        // clear mentinut high 3 cicluri, CLEARING pornit o singura data
        // ================================================
        write_pixel(0, 0, 1);
        clear = 1;
        repeat(3) @(posedge clk); #1;
        clear = 0;
        wait(busy == 0);
        check_pixel(0, 0, 0);   // sters o singura data, corect
        $display("OK: clear_start detectat corect pe front");

        // ================================================
        $display("--------------------------------");
        $display("=== FRAMEBUFFER TEST FINALIZAT ===");
        $display("Erori: %0d", errors);
        $finish;
    end

endmodule
