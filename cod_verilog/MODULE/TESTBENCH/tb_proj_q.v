`timescale 1ns/1ps

module tb_proj_q;

// ---------------------------------------------------
// PARAMETRI
// ---------------------------------------------------
parameter INT_BITS  = 16;    
parameter FRAC_BITS = 16;
parameter WIDTH     = INT_BITS + FRAC_BITS;
parameter PER       = 4;
parameter NUM_RAND  = 3000;
parameter THRESHOLD = 5.0 / 65536.0;
parameter ONE = 1 << FRAC_BITS;  // = 65536
// ---------------------------------------------------
// SEMNALE
// ---------------------------------------------------
wire                clk;                 
wire                rst_n;
reg start;

reg  [WIDTH-1:0] f, x, y, z;
wire [WIDTH-1:0] xp, yp;
wire valid;
wire [2:0] dbg_state;
wire overflow;
integer error_count = 0;
integer test_count = 0;
real error_rate;

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
// DUT
// ---------------------------------------------------
proj_q #(
    .INT_BITS(INT_BITS),
    .FRAC_BITS(FRAC_BITS)
) dut (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .f(f), .x(x), .y(y), .z(z),
    .xp(xp), .yp(yp),
    .valid(valid),
    .overflow(overflow),
    .dbg_state(dbg_state)
);

// ---------------------------------------------------
// Task: start operatie
// ---------------------------------------------------
task start_op(
    input [WIDTH-1:0] in_f,
    input [WIDTH-1:0] in_x,
    input [WIDTH-1:0] in_y,
    input [WIDTH-1:0] in_z
);
begin
    f = in_f;
    x = in_x;
    y = in_y;
    z = in_z;

    start = 1'b1;
    @(posedge clk);
    start = 1'b0;
end
endtask

// ---------------------------------------------------
// Task: asteapta valid + verifica rezultat
// ---------------------------------------------------
task run_test(
    input [WIDTH-1:0] in_f,
    input [WIDTH-1:0] in_x,
    input [WIDTH-1:0] in_y,
    input [WIDTH-1:0] in_z,
    input [WIDTH-1:0] exp_xp,
    input [WIDTH-1:0] exp_yp,
    input [127:0] test_name
);
    reg [WIDTH-1:0] got_xp, got_yp;
begin
    start_op(in_f, in_x, in_y, in_z);

    // asteapta valid (important!)
    wait(valid == 1'b1);
    @(posedge clk);
    #1;

    got_xp = xp;
    got_yp = yp;

    if (got_xp !== exp_xp || got_yp !== exp_yp) begin
        error_count = error_count + 1;
        $display("EROARE [%s]: xp=%h (asteptat %h), yp=%h (asteptat %h)",
                 test_name, got_xp, exp_xp, got_yp, exp_yp);
    end else begin
        $display("OK [%s]: xp=%h yp=%h",
                 test_name, got_xp, got_yp);
    end
end
endtask


// ---------------------------------------------------
// Task: un singur test random (intern)
// ---------------------------------------------------
task run_one_random;
    input [WIDTH-1:0] r_f, r_x, r_y, r_z;
    input integer     idx;

    real rf, rx, ry, rz, factor, exp_xp_r, exp_yp_r;
    real SCALE, MAX_R, MIN_R;
    
    real err_x, err_y;
    
    reg signed [WIDTH-1:0] exp_xp, exp_yp;
    reg signed [WIDTH-1:0] got_xp_s, got_yp_s;
    integer diff_x, diff_y;
begin
    SCALE = 65536.0;                  // 2^FRAC_BITS
    MAX_R =  2147483647.0 / SCALE;    // +32767.99998...
    MIN_R = -2147483648.0 / SCALE;    // -32768.0

    // --------------------------------------------------
    // Conversie fixed-point -> real (cu semn)
    // --------------------------------------------------
    rf = $itor($signed(r_f)) / SCALE;
    rx = $itor($signed(r_x)) / SCALE;
    ry = $itor($signed(r_y)) / SCALE;
    rz = $itor($signed(r_z)) / SCALE;
    
    // --------------------------------------------------
    // Calcul referinta gold
    // --------------------------------------------------
    if (rz == 0.0) begin
        // Saturare: semn determinat de f (z -> 0+)
        exp_xp = (rf >= 0.0) ? 32'h7FFF_FFFF : 32'h8000_0000;
        exp_yp = (rf >= 0.0) ? 32'h7FFF_FFFF : 32'h8000_0000;
    end else begin
        factor    = rf / rz;
        //exp_xp_r  = factor * rx;
       // exp_yp_r  = factor * ry;
       exp_xp_r = (rf * rx) / rz;
       exp_yp_r = (rf * ry) / rz;

        // Saturare xp
        if      (exp_xp_r >= MAX_R) exp_xp = 32'h7FFF_FFFF;
        else if (exp_xp_r <= MIN_R) exp_xp = 32'h8000_0000;
        else                        exp_xp = $rtoi(exp_xp_r * SCALE);

        // Saturare yp
        if      (exp_yp_r >= MAX_R) exp_yp = 32'h7FFF_FFFF;
        else if (exp_yp_r <= MIN_R) exp_yp = 32'h8000_0000;
        else                        exp_yp = $rtoi(exp_yp_r * SCALE);
    end

    // --------------------------------------------------
    // Stimulare DUT
    // --------------------------------------------------
    start_op(r_f, r_x, r_y, r_z);
    wait(valid == 1'b1);
    @(posedge clk); #2;

    // --------------------------------------------------
    // Verificare cu toleranta ±1 LSB (erori de rotunjire)
    // --------------------------------------------------
    got_xp_s = $signed(xp);
    got_yp_s = $signed(yp);
    
    diff_x   = $signed(got_xp_s) - $signed(exp_xp);
    diff_y   = $signed(got_yp_s) - $signed(exp_yp);
        

    err_x = $itor(diff_x)/SCALE;
    err_y = $itor(diff_y)/SCALE;


        
    if ((err_x > THRESHOLD) || (err_x < -THRESHOLD) || (err_y > THRESHOLD) || (err_y < -THRESHOLD)) begin
        error_count = error_count + 1;
        $display("EROARE RANDOM [%0d]: f=%h x=%h y=%h z=%h | xp=%h(exp %h, DIFERENTA=%f) yp=%h(exp %h, DIFERENTA=%f)",
                 idx, r_f, r_x, r_y, r_z,
                 xp, exp_xp, err_x,
                 yp, exp_yp, err_y);
    end else begin
        $display("OK    RANDOM [%0d]: f=%h x=%h y=%h z=%h -> xp=%h yp=%h",
                 idx, r_f, r_x, r_y, r_z, xp, yp);
    end
end
endtask

// ---------------------------------------------------
// Task: ruleaza NUM_RAND teste random
// ---------------------------------------------------
task run_random_tests;
    input integer seed;
    integer i;
    reg [WIDTH-1:0] r_f, r_x, r_y, r_z;
    integer dummy; // seed local modificabil
begin
    dummy = $random(seed);
    $display("--- START %0d TESTE RANDOM (seed=%0d) ---", NUM_RAND, seed);
        
    for (i = 0; i < NUM_RAND; i = i + 1) begin
     // $random actualizeaza seed-ul automat la fiecare apel
     // primul apel seteaza seed-ul
        
       r_z = $urandom_range(-50000, 50000); 
       //r_z = $random; 
       r_f = $urandom_range(-50000, 50000);
    //   r_f = $random; 
       r_x = $urandom_range(-50000, 50000);
   //  r_x = $random;
       r_y = $urandom_range(-50000, 50000);
    //   r_y = $random;
         
       run_one_random(r_f, r_x, r_y, r_z, i);
       test_count = test_count + 1;
    end

    $display("--- SFARSIT TESTE RANDOM: %0d erori ---", error_count);
end
endtask


// ---------------------------------------------------
// TESTE
// ---------------------------------------------------
initial begin
    $display("=== START TEST PROJ ===");

    // RESET
    start = 0;
    f = 0; x = 0; y = 0; z = 0;
    repeat(5) @(posedge clk);

    run_random_tests(402);     // seed fix => reproductibil
    error_rate = (error_count * 100.0) / test_count;

    $display("--------------------------------");
    $display("=== TEST terminat ===");
    $display("Teste totale   = %0d", test_count);
    $display("Erori          = %0d", error_count);
    $display("Threshold      = %f", THRESHOLD);
    $display("Error rate     = %f %%", error_rate);
    
   // $display("--------------------------------");
   // $display("=== TEST terminat cu %0d erori, marja de eroare ===", error_count);
    $finish;
end

endmodule
