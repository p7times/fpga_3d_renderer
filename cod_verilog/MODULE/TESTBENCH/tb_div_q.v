`timescale 1ns/1ps

module tb_div_q;

    parameter INT_BITS  = 16;
    parameter FRAC_BITS = 16;
    parameter WIDTH = INT_BITS + FRAC_BITS; // Latimea datelor
    parameter PER = 4;                      // Perioada ceasului în ns

    reg              clk = 0;                 
    reg              rst_n = 1;
    reg              start = 0;
    reg  [WIDTH-1:0] op1, op2;       // operanzii de test
    wire [WIDTH-1:0] rezultat;      
    wire             valid;

    integer error_count = 0;

    // ------------------------
    // Ceas
    // ------------------------
    always #(PER/2) clk = ~clk;

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
        .op1     (op1),
        .op2     (op2),
        .rezultat(rezultat),
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

    // ------------------------
    // Secventa de test
    // ------------------------
    initial begin
        $display("=== Start TEST DIV ===");
        $display("------------------------------------------------------");

        rst_n = 0;
        start = 0;
        op1 = 0;
        op2 = 0;
        @(posedge clk);
        @(posedge clk);
        rst_n = 1; 
        @(posedge clk);

        // -------------------------------------------------------
        // 1. Verificare reset
        // -------------------------------------------------------
        if (rezultat !== 0 || valid !== 1'b0) begin
            error_count = error_count + 1;
            $display("EROARE  [RESET]: rezultat=%h valid=%b (asteptate 0/0)", rezultat, valid);
        end else
            $display("OK      [RESET]: rezultat=0 valid=0");

        // -------------------------------------------------------
        // 2. Cazuri normale pozitive
        // 1.0  = 32'h0001_0000
        // 2.0  = 32'h0002_0000
        // 0.5  = 32'h0000_8000
        // -------------------------------------------------------
      //  run_test(32'h0002_0000, 32'h0001_0000, 32'h0002_0000, "2/1=2          ");
     //   run_test(32'h0001_0000, 32'h0002_0000, 32'h0000_8000, "1/2=0.5        ");
    //    run_test(32'h0003_0000, 32'h0002_0000, 32'h0001_8000, "3/2=1.5        ");
    //    run_test(32'h0001_0000, 32'h0001_0000, 32'h0001_0000, "1/1=1          ");
    //    run_test(32'h0000_0000, 32'h0002_0000, 32'h0000_0000, "0/2=0          ");

        // -------------------------------------------------------
        // 3. Cazuri signed
        // -1.0 = 32'hFFFF_0000
        // -2.0 = 32'hFFFE_0000
        // -------------------------------------------------------
      //  run_test(32'hFFFF_0000, 32'h0001_0000, 32'hFFFF_0000, "-1/1=-1        ");
 //       run_test(32'h0001_0000, 32'hFFFF_0000, 32'hFFFF_0000, "1/-1=-1        ");
       // run_test(32'hFFFF_0000, 32'hFFFF_0000, 32'h0001_0000, "-1/-1=1        ");
     //   run_test(32'hFFFE_0000, 32'h0002_0000, 32'hFFFF_0000, "-2/2=-1        ");
     //   run_test(32'hFFFE_0000, 32'hFFFF_0000, 32'h0002_0000, "-2/-1=2        ");

        // -------------------------------------------------------
        // 4. Impartire la zero → saturare
        // -------------------------------------------------------
    //    run_test(32'h0002_0000, 32'h0000_0000, MAX_VAL,       "+x/0=MAX       ");
     //   run_test(32'hFFFF_0000, 32'h0000_0000, MIN_VAL,       "-x/0=MIN       ");
     //   run_test(32'h0000_0000, 32'h0000_0000, MAX_VAL,       "0/0=MAX        ");

        // -------------------------------------------------------
        // 5. Overflow → saturare
        // -------------------------------------------------------
    //    run_test(MAX_VAL,       32'h0000_8000, MAX_VAL,       "MAX/0.5=SAT+   ");
    //    run_test(MIN_VAL,       32'h0000_8000, MIN_VAL,       "MIN/0.5=SAT-   ");
    //    run_test(MIN_VAL,       32'hFFFF_0000, MAX_VAL,       "MIN/-1=SAT+    ");
        
        // -------------------------------------------------------
        // 6. Teste random
        // -------------------------------------------------------
   //     run_test(32'h0005_8000, 32'h0002_0000, 32'h0002_C000, "5.5/2=2.75     ");
    //    run_test(32'h0000_4000, 32'h0000_8000, 32'h0000_8000, "0.25/0.5=0.5   ");
     //   run_test(32'h000A_0000, 32'h0003_0000, 32'h0003_5555, "10/3=3.333     ");
       // run_test(32'hFFFC_0000, 32'h0002_8000, 32'hFFFE_6667, "-4/2.5=-1.6    ");
   //     run_test(32'h0064_0000, 32'h000A_0000, 32'h000A_0000, "100/10=10      ");
    //    run_test(32'h0001_8000, 32'h0000_C000, 32'h0002_0000, "1.5/0.75=2     ");
    //    run_test(32'h0007_0000, 32'h0002_0000, 32'h0003_8000, "7/2=3.5        ");
   //     run_test(32'hFFF9_0000, 32'hFFFF_0000, 32'h0007_0000, "-7/-1=7        ");
    //    run_test(32'h0000_199A, 32'h0000_3333, 32'h0000_8002, "0.1/0.2~0.5    ");
        
        run_test(32'h0003_0000, 32'h7FFF_FFFF, 32'h0000_0006, "3/MAX≈0        "); // EROARE
        

        $display("---------------------------------------------");
        $display("=== TEST DIV terminat cu %0d erori ===", error_count);
        $finish;
     end

endmodule

