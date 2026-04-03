`timescale 1ns/1ps

module tb_add_q;

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
reg                 clk   = 0;                 
reg                 rst_n = 1;
reg  [WIDTH-1:0]    a, b;
wire                overflow;   
wire [WIDTH-1:0]    sum;

integer error_count = 0;

// ---------------------------------------------------
// Ceas
// ---------------------------------------------------
always #(PER/2) clk = ~clk;

// ---------------------------------------------------
// Instantiere DUT
// ---------------------------------------------------
add_q #(
    .INT_BITS  (INT_BITS),
    .FRAC_BITS (FRAC_BITS)
) dut (
    .clk      (clk),
    .rst_n    (rst_n),
    .a        (a),
    .b        (b),
    .overflow (overflow),
    .sum      (sum)
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
    input        [WIDTH-1:0] expected_sum,
    input                    expected_overflow,
    input [127:0]            test_name        // string scurt pentru afisaj
);
    reg [WIDTH-1:0] got_sum;
    reg             got_ov;
begin
    a = op_a;
    b = op_b;
    @(posedge clk);
    #1;
    @(posedge clk);
    #1;
    got_sum = sum;
    got_ov = overflow;

    if (got_sum !== expected_sum || got_ov !== expected_overflow) begin
        error_count = error_count + 1;
        $display("EROARE [%s]: a=%h b=%h | sum=%h (asteptat %h) | ov=%b (asteptat %b)",
                 test_name, op_a, op_b, got_sum, expected_sum, got_ov, expected_overflow);
    end else begin
        $display("OK    [%s]: a=%h + b=%h -> sum=%h | overflow=%b",
                 test_name, op_a, op_b, got_sum, got_ov);
    end

end
endtask

// ------------------------
// Secventa de test
// ------------------------
initial begin
    $display("=== Start TEST ADD ===");
    $display("------------------------------------------------------");
    
    // --- RESET ---
    rst_n = 0;
    a = 0;
    b = 0;
    @(posedge clk);
    @(posedge clk);
    rst_n = 1; 
    @(posedge clk);

    // -------------------------------------------------------
    // 1. Verificare reset: imediat dupa dezactivarea resetului
    //    sum si overflow trebuie sa fie 0
    // -------------------------------------------------------
    if (sum !== 0 || overflow !== 1'b0) begin
        error_count = error_count + 1;
        $display("EROARE [RESET]: sum=%h overflow=%b (asteptate 0/0)", sum, overflow);
    end else
        $display("OK    [RESET]: sum=0 overflow=0");
 


    run_test(32'h0001_0000, 32'h0001_0000, 32'h0002_0000, 1'b0, "1+1=2     ");
    run_test(32'h0000_0000, 32'h0000_0000, 32'h0000_0000, 1'b0, "0+0       ");
    run_test(32'hFFFF_0000, 32'h0001_0000, 32'h0000_0000, 1'b0, "-1+1=0    ");
    run_test(32'hFFFF_0000, 32'hFFFF_0000, 32'hFFFE_0000, 1'b0, "-1+-1=-2  ");
    run_test(32'h0000_8000, 32'hFFFF_8000, 32'h0000_0000, 1'b0, "0.5-0.5=0 ");
    run_test(MAX_VAL, 32'h0000_0001, MAX_VAL, 1'b1,             "MAX+1->MAX");
    run_test(MAX_VAL, MAX_VAL,       MAX_VAL, 1'b1,             "MAX+MAX   ");
    run_test(32'h4000_0000, 32'h4000_0001, MAX_VAL, 1'b1,       "1/2MAX ovf");
    run_test(MIN_VAL, 32'hFFFF_FFFF, MIN_VAL, 1'b1,             "MIN-1->MIN");
    run_test(MIN_VAL, MIN_VAL,       MIN_VAL, 1'b1,             "MIN+MIN   ");
    run_test(32'hC000_0000, 32'hC000_0000, MIN_VAL, 1'b0,       "-1/2 ovf  ");
    run_test(MAX_VAL, MIN_VAL, 32'hFFFF_FFFF, 1'b0,             "MAX+MIN   ");
    run_test(MIN_VAL, MAX_VAL, 32'hFFFF_FFFF, 1'b0,             "MIN+MAX   ");

    $display("---------------------------------------------");
    $display("=== TEST ADD terminat cu %0d erori ===", error_count);
    $finish;
 end

endmodule

