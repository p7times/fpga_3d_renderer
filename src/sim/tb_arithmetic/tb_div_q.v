//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : tb_div_q
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Testbench pentru modulul de impartire.
//---------------------------------------------------------------

`timescale 1ns/1ps

module tb_div_q;

    parameter INT_BITS  = 16;
    parameter FRAC_BITS = 16;
    parameter WIDTH = INT_BITS + FRAC_BITS; // Latimea datelor
    parameter PER = 4;                      // Perioada ceasului în ns
    
    parameter real THRESHOLD = 0.5 / (2.0**FRAC_BITS);

    wire                clk;                 
    wire                rst_n;
    reg              start = 0;
    reg  [WIDTH-1:0] op1, op2;       // operanzii de test
    wire [WIDTH-1:0] rezultat;      
    wire             valid;

    integer error_count = 0;

    // ------------------------
    // Ceas
    // ------------------------
    ck_rst_tb #(
        .CK_SEMIPERIOD(PER/2)
    ) clk_gen (
        .clk(clk),
        .rst_n(rst_n)
    );

    // ------------------------
    // Instantiere DUT
    // ------------------------
    div_top_level_q #(
        .INT_BITS  (INT_BITS),
        .FRAC_BITS (FRAC_BITS)
    ) dut (
        .clk     (clk),
        .rst_n   (rst_n),
        .start   (start),
        .a     (op1),
        .b     (op2),
        .quotient(rezultat),
        .valid   (valid)
    );

    // ---------------------------------------------------
    // Constante pentru saturatie (Q16.16 signed)
    // ---------------------------------------------------
    localparam [WIDTH-1:0] MAX_VAL = {1'b0, {(WIDTH-1){1'b1}}};
    localparam [WIDTH-1:0] MIN_VAL = {1'b1, {(WIDTH-1){1'b0}}}; 

    // ------------------------
    // Simulare
    // ------------------------
    task run_test(
        input [WIDTH-1:0] op_a,
        input [WIDTH-1:0] op_b,
        input [WIDTH-1:0] expected_result,
        input [127:0]     test_name
    );
        reg [WIDTH-1:0] got_result;
        begin
            op1 = op_a;
            op2 = op_b;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid === 1'b1);
            @(posedge clk); #1;
            got_result = rezultat;

            if (got_result !== expected_result) begin
                error_count = error_count + 1;
                $display("EROARE  [%s]: op1=%h / op2=%h | result=%h (asteptat %h)",
                         test_name, op_a, op_b, got_result, expected_result);
            end else begin
                $display("OK      [%s]: op1=%h / op2=%h -> result=%h",
                         test_name, op_a, op_b, got_result);
            end
        end
    endtask
    
    task run_one_random_div;
        input [WIDTH-1:0] r_a, r_b;
        input integer idx;
    
        real ra, rb, rquot, SCALE, MAX_R, MIN_R;
        real err;
        reg signed [WIDTH-1:0] exp_result;
        reg signed [WIDTH-1:0] got_result_s;
        integer diff;
    begin

        SCALE = $itor(1 << FRAC_BITS);         
        MAX_R = (2.0**(WIDTH-1) - 1.0) / SCALE;
        MIN_R = -(2.0**(WIDTH-1)) / SCALE;
        
        ra = $itor($signed(r_a)) / SCALE;
        rb = $itor($signed(r_b)) / SCALE;
    
        if (rb == 0.0) begin
            exp_result = (ra >= 0.0) ? MAX_VAL : MIN_VAL;
        end else begin
            rquot = ra / rb;
            if      (rquot >= MAX_R) exp_result = MAX_VAL;
            else if (rquot <= MIN_R) exp_result = MIN_VAL;
            else                     exp_result = $rtoi(rquot * SCALE);
        end
    
        op1 = r_a;
        op2 = r_b;
        @(posedge clk);
        start = 1'b1;
        @(posedge clk);
        start = 1'b0;
    
        wait(valid === 1'b1);
        @(posedge clk); #1;
    
        got_result_s = $signed(rezultat);
        diff = $signed(got_result_s) - $signed(exp_result);
    
        // Eroare exprimata in unitati reale, ca in tb_proj
        err = $itor(diff) / SCALE;
    
        if (err > THRESHOLD || err < -THRESHOLD) begin
            error_count = error_count + 1;
            $display("EROARE DIV RAND [%0d]: a=%h b=%h | result=%h (exp %h, err=%f)",
                     idx, r_a, r_b, rezultat, exp_result, err);
        end else
            $display("OK    DIV RAND [%0d]: a= %h / b= %h -> result= %h",
                     idx, r_a, r_b, rezultat, err);
    end
    endtask
        
    task run_random_tests_div;
        input integer seed;
        input integer num;
        integer i, dummy;
        reg [WIDTH-1:0] r_a, r_b;
    begin
        dummy = $random(seed);
        $display("--- START %0d TESTE RANDOM DIV (seed=%0d) ---", num, seed);
        for (i = 0; i < num; i = i + 1) begin
            r_a = $random;
            r_b = $random;
            run_one_random_div(r_a, r_b, i);
        end
        $display("--- SFARSIT TESTE RANDOM DIV: %0d erori ---", error_count);
    end
    endtask

    // ------------------------
    // Secventa de test
    // ------------------------
    initial begin
        $display("=== Start TEST DIV ===");
        $display("------------------------------------------------------");

        start = 0;
        op1 = 0;
        op2 = 0;
        repeat (5) @(posedge clk);

        // -------------------------------------------------------
        // 1. Verificare reset
        // -------------------------------------------------------
        if (rezultat !== 0 || valid !== 1'b0) begin
            error_count = error_count + 1;
            $display("EROARE  [RESET]: rezultat=%h valid=%b (asteptate 0/0)", rezultat, valid);
        end else
            $display("OK      [RESET]: rezultat=0 valid=0");
        
        
       //run_test(28'h0001_000, 28'h0001_000, 28'h0001_000, "");
       //run_test(32'hFFFF_0000,32'h0000_0000, 32'h8000_0000,"-1/0=MIN");
       //run_test(32'h0005_0000,32'h0000_0000, 32'h7FFF_FFFF,"5/0=MAX");
       //run_test(32'h0000_0001,32'h7FFF_FFFF, 32'h0000_0001,"RES/MAX=RES");
       //run_test(32'h0000_0000,32'h0000_0000, 32'h0000_0000,"0/0");
       run_random_tests_div(42, 2000);

        $display("---------------------------------------------");
        $display("=== TEST DIV terminat cu %0d erori ===", error_count);
        $finish;
     end

endmodule

