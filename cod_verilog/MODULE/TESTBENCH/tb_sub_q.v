`timescale 1ns/1ps

module tb_sub_q;

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
wire [WIDTH-1:0]    dif;

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
sub_q #(
    .INT_BITS  (INT_BITS),
    .FRAC_BITS (FRAC_BITS)
) dut (
    .clk      (clk),
    .rst_n    (rst_n),
    .a        (a),
    .b        (b),
    .overflow (overflow),
    .dif      (dif)
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
    input        [WIDTH-1:0] expected_dif,
    input                    expected_overflow,
    input [127:0]            test_name        // string scurt pentru afisaj
);
    reg [WIDTH-1:0] got_dif;
    reg             got_ov;
begin
    a = op_a;
    b = op_b;
    @(posedge clk);
    #1;
    @(posedge clk);
    #1;
    got_dif = dif;
    got_ov = overflow;

    if (got_dif !== expected_dif || got_ov !== expected_overflow) begin
        error_count = error_count + 1;
        $display("EROARE [%s]: a=%h b=%h | dif=%h (asteptat %h) | ov=%b (asteptat %b)",
                 test_name, op_a, op_b, got_dif, expected_dif, got_ov, expected_overflow);
    end else begin
        $display("OK    [%s]: a=%h - b=%h -> dif=%h | overflow=%b",
                 test_name, op_a, op_b, got_dif, got_ov);
    end

end
endtask





task run_one_random_sub;
    input [WIDTH-1:0] r_a, r_b;
    input integer     idx;

    real ra, rb, rdif, SCALE, MAX_R, MIN_R;
    reg signed [WIDTH-1:0] exp_dif;
    integer diff;
begin
    SCALE = 65536.0;
    MAX_R =  2147483647.0 / SCALE;
    MIN_R = -2147483648.0 / SCALE;

    ra   = $itor($signed(r_a)) / SCALE;
    rb   = $itor($signed(r_b)) / SCALE;
    rdif = ra - rb;

    if      (rdif >= MAX_R) exp_dif = 32'h7FFF_FFFF;
    else if (rdif <= MIN_R) exp_dif = 32'h8000_0000;
    else                    exp_dif = $rtoi(rdif * SCALE);

    a = r_a;
    b = r_b;
    @(posedge clk); #1;
    @(posedge clk); #1;

    diff = $signed(dif) - $signed(exp_dif);
    if (diff > 1 || diff < -1) begin
        error_count = error_count + 1;
        $display("EROARE SUB RAND [%0d]: a=%h b=%h | dif=%h (exp %h, d=%0d)",
                 idx, r_a, r_b, dif, exp_dif, diff);
    end else
        $display("OK    SUB RAND [%0d]: a=%h - b=%h -> dif=%h", idx, r_a, r_b, dif);
end
endtask

task run_random_tests_sub;
    input integer seed;
    input integer num;
    integer i, dummy;
    reg [WIDTH-1:0] r_a, r_b;
begin
    dummy = $random(seed);
    $display("--- START %0d TESTE RANDOM SUB (seed=%0d) ---", num, seed);
    for (i = 0; i < num; i = i + 1) begin
        r_a = $random;
        r_b = $random;
        run_one_random_sub(r_a, r_b, i);
    end
    $display("--- SFARSIT TESTE RANDOM SUB: %0d erori ---", error_count);
end
endtask

// ------------------------
// Secventa de test
// ------------------------
initial begin
    $display("=== Start TEST SUB ===");
    $display("------------------------------------------------------");
    
    // --- RESET ---
    a = 0;
    b = 0;
    repeat (5) @(posedge clk);

    // -------------------------------------------------------
    // 1. Verificare reset: imediat dupa dezactivarea resetului
    //    sum si overflow trebuie sa fie 0
    // -------------------------------------------------------
    if (dif !== 0 || overflow !== 1'b0) begin
        error_count = error_count + 1;
        $display("EROARE [RESET]: dif=%h overflow=%b (asteptate 0/0)", dif, overflow);
    end else
        $display("OK    [RESET]: dif=0 overflow=0");

    run_test(32'h0000_0000, 32'h0000_0000, 32'h0000_0000, 1'b0, "0-0=0     ");
    run_test(32'h0001_0000, 32'h0001_0000, 32'h0000_0000, 1'b0, "1-1=0     ");
    run_test(32'hFFFF_0000, 32'hFFFF_0000, 32'h0000_0000, 1'b0, "-1-(-1)=0 "); 
    run_test(32'h0002_0000, 32'h0001_0000, 32'h0001_0000, 1'b0, "2-1=1     ");
    run_test(32'hFFFF_0000, 32'h0001_0000, 32'hFFFE_0000, 1'b0, "-1-1=-2   ");  
    run_test(32'h0001_0000, 32'hFFFF_0000, 32'h0002_0000, 1'b0, "1-(-1)=2  ");
    run_test(MAX_VAL, 32'hFFFF_FFFF, MAX_VAL, 1'b1,             "MAX-(-1)  "); 
    run_test(MAX_VAL, MIN_VAL,       MAX_VAL, 1'b1,             "MAX-MIN   ");  
    run_test(32'h4000_0000, 32'hC000_0000, MAX_VAL, 1'b1,       "half ovf+ ");
    run_test(MIN_VAL, 32'h0000_0001, MIN_VAL, 1'b1,             "MIN-1     ");  
    run_test(MIN_VAL, MAX_VAL,       MIN_VAL, 1'b1,             "MIN-MAX   ");
    run_test(32'hC000_0000, 32'h4000_0000, MIN_VAL, 1'b0,       "half ovf- ");
    run_test(MAX_VAL, 32'h0001_0000, 32'h7FFE_FFFF, 1'b0,       "MAX-1     ");
    run_test(MIN_VAL, 32'hFFFF_0000, 32'h8001_0000, 1'b0,       "MIN-(-1)  ");
    
    run_random_tests_sub(42,  200);
    
    $display("---------------------------------------------");
    $display("=== TEST SUB terminat cu %0d erori ===", error_count);
    $finish;
 end

endmodule

