//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : tb_mult_booth_q
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Testbench pentru multiplicatorul Booth iterativ.
//---------------------------------------------------------------

`timescale 1ns/1ps

module tb_mult_booth_q;

    // ---------------------------------------------------
    // PARAMETRI
    // ---------------------------------------------------
    parameter INT_BITS  = 16;    
    parameter FRAC_BITS = 16;
    parameter WIDTH     = INT_BITS + FRAC_BITS;     // Numarul total de biti (DATA_WIDTH)
    parameter PER       = 4;                        // Perioada ceasului in ns


    // ---------------------------------------------------
    // SEMNALE
    // ---------------------------------------------------
    wire                clk;                 
    wire                rst_n;
    reg  [WIDTH-1:0]    a, b;
    reg                 start;                      // Semnal start operatie
    wire                valid;                      // Flag terminare (rezultat valid)
    wire                overflow;
    wire [WIDTH-1:0]    product;                    // Rezultatul iesirii

    integer error_count = 0;

    // ---------------------------------------------------
    // Ceas (Folosind generatorul tau)
    // ---------------------------------------------------
    ck_rst_tb #(
        .CK_SEMIPERIOD(PER/2)
    ) clk_gen (
        .clk(clk),
        .rst_n(rst_n)
    );

    // ---------------------------------------------------
    // Instantiere DUT (Top Level Booth)
    // ---------------------------------------------------
    mult_top_level_q #(
        .INT_BITS  (INT_BITS),
        .FRAC_BITS (FRAC_BITS)
    ) dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .start    (start),
        .a        (a),
        .b        (b),
        .valid    (valid),
        .overflow (overflow),
        .product  (product)
    );

    // ---------------------------------------------------
    // Constante pentru saturatie (Q16.16 signed)
    // ---------------------------------------------------
    localparam [WIDTH-1:0] MAX_VAL = {1'b0, {(WIDTH-1){1'b1}}};
    localparam [WIDTH-1:0] MIN_VAL = {1'b1, {(WIDTH-1){1'b0}}}; 


    // ---------------------------------------------------
    // Task: run_test
    // Aplicam operanzii, dam puls pe start si asteptam valid.
    // ---------------------------------------------------
    task run_test(
        input signed [WIDTH-1:0] op_a,
        input signed [WIDTH-1:0] op_b,
        input        [WIDTH-1:0] expected_result,
        input [127:0]            test_name
    );
        reg [WIDTH-1:0] got_result;
    begin
        a = op_a;
        b = op_b;
        
        // Handshake: dam puls pe start
        start = 1'b1;
        @(posedge clk);
        start = 1'b0;

        // Asteptam ca FSM-ul sa termine (valid == 1)
        wait(valid == 1'b1);
        @(posedge clk);
        #1; 
        
        got_result = product;

        if (got_result !== expected_result) begin
            error_count = error_count + 1;
            $display("EROARE [%s]: a=%h b=%h | rezultat=%h (asteptat %h)",
                     test_name, op_a, op_b, got_result, expected_result);
        end else begin
            $display("OK    [%s]: a=%h * b=%h -> rezultat=%h",
                     test_name, op_a, op_b, got_result);
        end
    end
    endtask

    // ---------------------------------------------------
    // Task: run_one_random_mult (Versiune Generica)
    // ---------------------------------------------------
    task run_one_random_mult;
        input [WIDTH-1:0] r_a, r_b;
        input integer     idx;

        real ra, rb, rprod, SCALE, MAX_R, MIN_R;
        reg signed [WIDTH-1:0] exp_result;
        integer diff;
    begin
        // Calculeaza SCALE dinamic: 2^FRAC_BITS
        SCALE = 1.0 * (1 << FRAC_BITS);
        
        // Calculeaza limitele de saturatie reale pe baza constantelor locale din TB
        MAX_R = $itor($signed(MAX_VAL)) / SCALE;
        MIN_R = $itor($signed(MIN_VAL)) / SCALE;

        ra    = $itor($signed(r_a)) / SCALE;
        rb    = $itor($signed(r_b)) / SCALE;
        rprod = ra * rb;

        // Logica de verificare saturatie adaptata la WIDTH si FRAC_BITS
        if      (rprod >= MAX_R) exp_result = MAX_VAL;
        else if (rprod <= MIN_R) exp_result = MIN_VAL;
        else                     exp_result = $rtoi(rprod * SCALE);

        a = r_a;
        b = r_b;
        
        // Handshake standard ptr modelul iterativ
        start = 1'b1;
        @(posedge clk);
        start = 1'b0;

        wait(valid == 1'b1);
        @(posedge clk);
        #1;

        diff = $signed(product) - $signed(exp_result);
        
        // Toleranta de +- 1 bit din cauza rotunjirilor real vs fixed-point
        if (diff > 1 || diff < -1) begin
            error_count = error_count + 1;
            $display("EROARE MULT RAND [%0d]: a=%h b=%h | rezultat=%h (exp %h, d=%0d)",
                     idx, r_a, r_b, product, exp_result, diff);
        end else
            $display("OK    MULT RAND [%0d]: a=%h * b=%h -> rezultat=%h", idx, r_a, r_b, product);
    end
    endtask


    // ---------------------------------------------------
    // Task: run_random_tests_mult (Versiune Generica)
    // ---------------------------------------------------
    task run_random_tests_mult;
        input integer seed;
        input integer num;      // num per categorie

        integer i, dummy;
        integer raw_a, raw_b;
        reg [WIDTH-1:0] r_a, r_b;
        integer idx;
        integer dynamic_scale;
    begin
        dummy = $random(seed);
        idx   = 0;
        dynamic_scale = (1 << FRAC_BITS); // Inlocuieste valoarea fixa 65536
        
        $display("--- START %0d TESTE RANDOM MULT (seed=%0d) ---", 3*num, seed);

        // --------------------------------------------------
        // CAT 1: ambii operanzi mici  |val| < 128
        // --------------------------------------------------
        $display("  [CAT1] operanzi mici |a|,|b| < 128");
        for (i = 0; i < num; i = i + 1) begin
            raw_a = $random % (128 * dynamic_scale);   
            raw_b = $random % (128 * dynamic_scale);
            r_a   = raw_a[WIDTH-1:0];
            r_b   = raw_b[WIDTH-1:0];
            run_one_random_mult(r_a, r_b, idx);
            idx = idx + 1;
        end

        // --------------------------------------------------
        // CAT 2: un operand mic, unul intreg aleator
        // --------------------------------------------------
        $display("  [CAT2] un operand mic, unul intreg aleator");
        for (i = 0; i < num; i = i + 1) begin
            raw_a = $random % (4 * dynamic_scale);     
            raw_b = $random;                   
            r_a   = raw_a[WIDTH-1:0];
            r_b   = raw_b[WIDTH-1:0];
            run_one_random_mult(r_a, r_b, idx);
            idx = idx + 1;
        end

        // --------------------------------------------------
        // CAT 3: ambii operanzi subunitari  |val| < 1.0
        // --------------------------------------------------
        $display("  [CAT3] operanzi subunitari |a|,|b| < 1.0");
        for (i = 0; i < num; i = i + 1) begin
            raw_a = $random % dynamic_scale;           
            raw_b = $random % dynamic_scale;
            r_a   = raw_a[WIDTH-1:0];
            r_b   = raw_b[WIDTH-1:0];
            run_one_random_mult(r_a, r_b, idx);
            idx = idx + 1;
        end

        $display("--- SFARSIT TESTE RANDOM MULT: %0d erori ---", error_count);
    end
    endtask

    // ------------------------
    // Secventa de test (Initial Block)
    // ------------------------
    initial begin
        $display("=== Start TEST MULT ITERATIV ===");
        $display("------------------------------------------------------");
        
        // --- RESET ---
        a     = 0;
        b     = 0;
        start = 0;
        repeat (5) @(posedge clk);

        // 1. Verificare reset
        if (product !== 0 || valid !== 1'b0) begin
            error_count = error_count + 1;
            $display("EROARE [RESET]: product=%h valid=%b (asteptate 0/0)", product, valid);
        end else
            $display("OK    [RESET]: product=0 valid=0");
     
        // 2. Teste directionate (Fara parametrul de overflow)
        // Poti decomenta daca vrei sa le folosesti
        // run_test(32'h0000_0000, 32'h0002_0000, 32'h0000_0000, "0*2=0     ");
        // run_test(32'h0001_0000, 32'h0001_0000, 32'h0001_0000, "1*1=1     ");
        // run_test(32'h0002_0000, 32'h0003_0000, 32'h0006_0000, "2*3=6     ");
        // run_test(32'h0000_8000, 32'h0000_8000, 32'h0000_4000, "0.5*0.5   ");
        // run_test(32'h0001_0000, 32'hFFFF_0000, 32'hFFFF_0000, "1*-1=-1   ");
        // run_test(MAX_VAL,       MAX_VAL,       MAX_VAL,       "MAX*MAX   ");
        // run_test(MIN_VAL,       MIN_VAL,       MAX_VAL,       "MIN*MIN   ");

        // 3. Teste Random
        run_random_tests_mult(42, 200); // Am redus numarul la 200/categorie ptr simulari iterative mai rapide (testeaza intai cu putine)
        
        $display("---------------------------------------------");
        $display("=== TEST terminat cu %0d erori ===", error_count);
        $finish;
    end

endmodule
