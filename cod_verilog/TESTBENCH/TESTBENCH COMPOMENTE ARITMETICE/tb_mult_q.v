//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : tb_mult_q
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Testbench pentru modulul de inmultire.
//---------------------------------------------------------------

`timescale 1ns/1ps

module tb_mult_q;

    // ---------------------------------------------------
    // PARAMETRI
    // ---------------------------------------------------
    parameter INT_BITS  = 16;    
    parameter FRAC_BITS = 16;
    parameter WIDTH     = INT_BITS + FRAC_BITS;     // Numarul total de biti pe care se reprezinta datele
    parameter PER       = 4;                        // Perioada ceasului în ns


    // ---------------------------------------------------
    // SEMNALE
    // ---------------------------------------------------
    wire                clk;                 
    wire                rst_n;
    reg  [WIDTH-1:0]    a, b;
    wire                overflow;   
    wire [WIDTH-1:0]    result;

    integer error_count = 0;

    // ---------------------------------------------------
    // Ceas
    // ---------------------------------------------------
    ck_rst_tb #(
        .CK_SEMIPERIOD(PER/2)
    ) clk_gen (
        .clk(clk),
        .rst_n(rst_n)
    );

    // ---------------------------------------------------
    // Instantiere DUT
    // ---------------------------------------------------
    mult_q #(
        .INT_BITS  (INT_BITS),
        .FRAC_BITS (FRAC_BITS)
    ) dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .a        (a),
        .b        (b),
        .overflow (overflow),
        .result      (result)
    );

    // ---------------------------------------------------
    // Constante pentru saturatie (Q16.16 signed)
    // ---------------------------------------------------
    localparam [WIDTH-1:0] MAX_VAL = {1'b0, {(WIDTH-1){1'b1}}};
    localparam [WIDTH-1:0] MIN_VAL = {1'b1, {(WIDTH-1){1'b0}}}; 


    // ---------------------------------------------------
    // Task: run_test
    // Aplicam operanzii, asteptam un ciclu de ceas si comparam resultatul
    // cu cel asteptat (cu saturatie)
    // ---------------------------------------------------
    task run_test(
        input signed [WIDTH-1:0] op_a,
        input signed [WIDTH-1:0] op_b,
        input        [WIDTH-1:0] expected_result,
        input                    expected_overflow,
        input [127:0]            test_name        // string scurt pentru afisaj
    );
        reg [WIDTH-1:0] got_result;
        reg             got_ov;
    begin
        a = op_a;
        b = op_b;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;
        got_result = result;
        got_ov = overflow;

        if (got_result !== expected_result || got_ov !== expected_overflow) begin
            error_count = error_count + 1;
            $display("EROARE [%s]: a=%h b=%h | result=%h (asteptat %h) | ov=%b (asteptat %b)",
                     test_name, op_a, op_b, got_result, expected_result, got_ov, expected_overflow);
        end else begin
            $display("OK    [%s]: a=%h * b=%h -> result=%h | overflow=%b",
                     test_name, op_a, op_b, got_result, got_ov);
        end

    end
    endtask

    task run_one_random_mult;
        input [WIDTH-1:0] r_a, r_b;
        input integer     idx;

        real ra, rb, rprod, SCALE, MAX_R, MIN_R;
        reg signed [WIDTH-1:0] exp_result;
        integer diff;
    begin
        SCALE = 65536.0;
        MAX_R =  2147483647.0 / SCALE;
        MIN_R = -2147483648.0 / SCALE;

        ra    = $itor($signed(r_a)) / SCALE;
        rb    = $itor($signed(r_b)) / SCALE;
        rprod = ra * rb;

        if      (rprod >= MAX_R) exp_result = 32'h7FFF_FFFF;
        else if (rprod <= MIN_R) exp_result = 32'h8000_0000;
        else                     exp_result = $rtoi(rprod * SCALE);

        a = r_a;
        b = r_b;
        @(posedge clk); #1;
        @(posedge clk); #1;

        diff = $signed(result) - $signed(exp_result);
        if (diff > 1 || diff < -1) begin
            error_count = error_count + 1;
            $display("EROARE MULT RAND [%0d]: a=%h b=%h | result=%h (exp %h, d=%0d)",
                     idx, r_a, r_b, result, exp_result, diff);
        end else
            $display("OK    MULT RAND [%0d]: a=%h * b=%h -> result=%h", idx, r_a, r_b, result);
    end
    endtask

    task run_random_tests_mult;
        input integer seed;
        input integer num;      // num per categorie => total = 3*num

        integer i, dummy;
        integer raw_a, raw_b;
        reg [WIDTH-1:0] r_a, r_b;
        integer idx;
    begin
        dummy = $random(seed);
        idx   = 0;
        $display("--- START %0d TESTE RANDOM MULT (seed=%0d) ---", 3*num, seed);

        // --------------------------------------------------
        // CAT 1: ambii operanzi mici  |val| < 128
        // produs maxim: 128*128 = 16384 < MAX  => rar overflow
        // testa precizia fractionara
        // --------------------------------------------------
        $display("  [CAT1] operanzi mici |a|,|b| < 128");
        for (i = 0; i < num; i = i + 1) begin
            raw_a = $random % (128 * 65536);   // -128 .. +128 in Q16.16
            raw_b = $random % (128 * 65536);
            r_a   = raw_a[WIDTH-1:0];
            r_b   = raw_b[WIDTH-1:0];
            run_one_random_mult(r_a, r_b, idx);
            idx = idx + 1;
        end

        // --------------------------------------------------
        // CAT 2: un operand mic, unul mare
        // testa ca rezultatele cu overflow sunt saturate corect
        // --------------------------------------------------
        $display("  [CAT2] un operand mic, unul intreg aleator");
        for (i = 0; i < num; i = i + 1) begin
            raw_a = $random % (4 * 65536);     // |a| < 4
            raw_b = $random;                   // b intreg aleator
            r_a   = raw_a[WIDTH-1:0];
            r_b   = raw_b[WIDTH-1:0];
            run_one_random_mult(r_a, r_b, idx);
            idx = idx + 1;
        end

        // --------------------------------------------------
        // CAT 3: ambii operanzi subunitari  |val| < 1.0
        // produs < 1.0  => niciodata overflow, testeaza
        // precizia fractionara pura
        // --------------------------------------------------
        $display("  [CAT3] operanzi subunitari |a|,|b| < 1.0");
        for (i = 0; i < num; i = i + 1) begin
            raw_a = $random % 65536;           // 0 .. 0.9999 in Q16.16
            raw_b = $random % 65536;
            r_a   = raw_a[WIDTH-1:0];
            r_b   = raw_b[WIDTH-1:0];
            run_one_random_mult(r_a, r_b, idx);
            idx = idx + 1;
        end

        $display("--- SFARSIT TESTE RANDOM MULT: %0d erori ---", error_count);
    end
    endtask


    // ------------------------
    // Secventa de test
    // ------------------------
    initial begin
        $display("=== Start TEST MULT ===");
        $display("------------------------------------------------------");
        
        // --- RESET ---
        a = 0;
        b = 0;
        repeat (5) @(posedge clk);

        // -------------------------------------------------------
        // 1. Verificare reset: imediat dupa dezactivarea resetului
        //    sum si overflow trebuie sa fie 0
        // -------------------------------------------------------
        if (result !== 0 || overflow !== 1'b0) begin
            error_count = error_count + 1;
            $display("EROARE [RESET]: result=%h overflow=%b (asteptate 0/0)", result, overflow);
        end else
            $display("OK    [RESET]: result=0 overflow=0");
     
            // -------------------------------------------------------
        // 2. Cazuri fara overflow
        // -------------------------------------------------------
    //    run_test(32'h0000_0000, 32'h0002_0000, 32'h0000_0000, 1'b0, "0*2=0     ");
    //    run_test(32'h0001_0000, 32'h0001_0000, 32'h0001_0000, 1'b0, "1*1=1     ");
    //    run_test(32'h0002_0000, 32'h0003_0000, 32'h0006_0000, 1'b0, "2*3=6     ");
    //    run_test(32'h0000_8000, 32'h0000_8000, 32'h0000_4000, 1'b0, "0.5*0.5   ");
    //    run_test(32'h0001_0000, 32'hFFFF_0000, 32'hFFFF_0000, 1'b0, "1*-1=-1   ");
    //    run_test(32'hFFFF_0000, 32'hFFFF_0000, 32'h0001_0000, 1'b0, "-1*-1=1   ");
    //    run_test(32'hFFFE_0000, 32'h0003_0000, 32'hFFFA_0000, 1'b0, "-2*3=-6   ");
    //    run_test(MAX_VAL,       32'h0002_0000, MAX_VAL, 1'b1,       "MAX*2     ");
    //    run_test(MAX_VAL,       MAX_VAL,       MAX_VAL, 1'b1,       "MAX*MAX   ");
    //    run_test(MIN_VAL,       MIN_VAL,       MAX_VAL, 1'b1,       "MIN*MIN   ");
    //    run_test(32'h0100_0000, 32'h0100_0000, MAX_VAL, 1'b1,       "256*256   ");
    //    run_test(MAX_VAL,       32'hFFFE_0000, MIN_VAL, 1'b1,       "MAX*-2    ");
    //    run_test(MIN_VAL,       32'h0002_0000, MIN_VAL, 1'b1,       "MIN*2     ");
    //    run_test(32'h0100_0000, 32'hFF00_0000, MIN_VAL, 1'b1,       "256*-256  ");
    //    run_test(MIN_VAL, 32'hFFFF_0000, MAX_VAL, 1'b1,             "MIN*-1    ");

        run_random_tests_mult(42,  200);
        //run_test(32'hffff_3a97, 32'h759b_c3eb, 32'ha54f_052f, 1'b0, "xp");
        //run_test(32'hffff_3a97, 32'hd841_18b0, 32'h1ea6_2a8b, 1'b0, "yp");
        
        $display("---------------------------------------------");
        $display("=== TEST terminat cu %0d erori ===", error_count);
        $finish;
     end

endmodule

