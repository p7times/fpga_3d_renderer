`timescale 1ns/1ps

module tb_vpu_q;


    // ------------------------
    // Parametri
    // ------------------------

    parameter INT_BITS  = 16;    
    parameter FRAC_BITS = 16;
    parameter WIDTH     = INT_BITS + FRAC_BITS;
    parameter PER       = 4;
    parameter NUM_RAND  = 2000;
    parameter THRESHOLD = 5.0 / 65536.0;
    parameter ONE = 1 << FRAC_BITS;  // = 65536


    // ------------------------
    // Semnale
    // ------------------------

    wire clk;                 
    wire rst_n;

    // Semnale de control
    reg  start;
    wire valid;

    // Datele de intrare
    reg  [2:0] rotation;
    reg  [9:0] angle;
    reg  [WIDTH-1:0] f, x, y, z, w, h;
    
    // Datele de iesire
    wire [WIDTH-1:0] xs, ys;
    wire [3:0]       dbg_state;
    wire             overflow;

    integer error_count = 0;
    integer test_count = 0;
    real    error_rate;


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
    // DUT
    // ------------------------

    vpu_q #(
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .rotation(rotation),
        .angle(angle),
        .f(f), .x(x), .y(y), .z(z), .w(w), .h(h),
        .xs(xs), .ys(ys),
        .valid(valid),
        .overflow(overflow),
        .dbg_state(dbg_state)
    );


    // ------------------------
    // Task 1: Start operatie
    // ------------------------

    task start_op(
        input [2:0] in_rot,
        input [9:0] in_ang,
        input [WIDTH-1:0] in_w,
        input [WIDTH-1:0] in_h,
        input [WIDTH-1:0] in_f,
        input [WIDTH-1:0] in_x,
        input [WIDTH-1:0] in_y,
        input [WIDTH-1:0] in_z
    );
    begin
        angle    = in_ang;
        rotation = in_rot;
        w        = in_w;
        h        = in_h;
        f        = in_f;
        x        = in_x;
        y        = in_y;
        z        = in_z;
        
        start = 1'b1;
        @(posedge clk);
        #1;
        start = 1'b0;
    end
    endtask


    // ------------------------
    // Task 2: Verifica rezultat cu date introduse manual
    // ------------------------

    task run_test(
        input [9:0] in_ang,
        input [2:0] in_rot,
        input [WIDTH-1:0] in_w,
        input [WIDTH-1:0] in_h,

        input [WIDTH-1:0] in_f,
        input [WIDTH-1:0] in_x,
        input [WIDTH-1:0] in_y,
        input [WIDTH-1:0] in_z,

        input [WIDTH-1:0] exp_xs,
        input [WIDTH-1:0] exp_ys,
        input [127:0] test_name
    );
        reg [WIDTH-1:0] got_xs, got_ys;
    begin
        start_op(in_rot, in_ang, in_w, in_h, in_f, in_x, in_y, in_z);

        // asteapta valid (important!)
        wait(valid == 1'b1);
        @(posedge clk);
        #1;

        got_xs = xs;
        got_ys = ys;

        if (got_xs !== exp_xs || got_ys !== exp_ys) begin
            error_count = error_count + 1;
            $display("EROARE [%s]: xs=%h (asteptat %h), ys=%h (asteptat %h)",
                     test_name, got_xs, exp_xs, got_ys, exp_ys);
        end else begin
            $display("OK [%s]: xs=%h ys=%h",
                     test_name, got_xs, got_ys);
        end
    end
    endtask


    // ------------------------
    // Task 3: Definirea Modelului de Referinta (Task-ul de calcul)
    // ------------------------

    task calculate_vpu_gold(
        input [2:0] r_rot, input [9:0] r_ang,
        input real rx, input real ry, input real rz,
        input real rf, input real rw, input real rh,
        output real exp_xs_r, output real exp_ys_r
    );
        real xr, yr, zr, xp, yp;
        real ra, r_sin, r_cos;

        // ETAPA 1: ROTATIE
        ra = (r_ang / 2.0) * (3.14159265 / 180.0); // exprimata in radiani
        r_sin = $sin(ra);
        r_cos = $cos(ra);

        case (r_rot)
            3'b000:  begin xr = rx; yr = ry * r_cos - rz * r_sin; zr = ry * r_sin + rz * r_cos;  end
            3'b001:  begin xr = rx; yr = ry * r_cos + rz * r_sin; zr = -ry * r_sin + rz * r_cos; end
            3'b010:  begin xr = rx * r_cos + rz * r_sin; yr = ry; zr = -rx * r_sin + rz * r_cos; end
            3'b011:  begin xr = rx * r_cos - rz * r_sin; yr = ry; zr = rx * r_sin + rz * r_cos;  end
            3'b100:  begin xr = rx * r_cos - ry * r_sin; yr = rx * r_sin + ry * r_cos; zr = rz;  end
            3'b101:  begin xr = rx * r_cos + ry * r_sin; yr = -rx * r_sin + ry * r_cos; zr = rz; end
            default: begin xr = rx; yr = ry; zr = rz; end
        endcase

        // ETAPA 2: PROIECTIE
        if (zr == 0.0) begin
            // Simulare saturatie la diviziune cu zero
            xp = (rf >= 0.0) ? 32767.0 : -32768.0;
            yp = (rf >= 0.0) ? 32767.0 : -32768.0;
        end else begin
            xp = xr * (rf / zr);
            yp = yr * (rf / zr);
        end

        // --- ETAPA 3: NDC TO SCREEN ---
        exp_xs_r = (xp * rh + rw) / 2.0;
        exp_ys_r = (rh - yp * rh) / 2.0;
    endtask







    // ------------------------
    // Task: un singur test random (intern)
    // ------------------------
task run_one_random;
    input [2:0] r_rot;
    input [9:0] r_ang;
    input [WIDTH-1:0] r_w, r_h, r_f, r_x, r_y, r_z;
    input integer     idx;

    real rrot, ra, rw, rh, rf, rx, ry, rz, factor, exp_xs_r, exp_ys_r;
    real exp_xr_r, exp_yr_r, exp_zr_r;
    real exp_xp_r, exp_yp_r;
    real SCALE, MAX_R, MIN_R;
    
    real err_x, err_y;
    
    reg signed [WIDTH-1:0] exp_xs, exp_ys;
    reg signed [WIDTH-1:0] got_xs_s, got_ys_s;
    integer diff_x, diff_y;
begin
    SCALE =  65536.0;                 // 2^FRAC_BITS
    MAX_R =  2147483647.0 / SCALE;    // +32767.99998...
    MIN_R = -2147483648.0 / SCALE;    // -32768.0

    // ------------------------
    // Conversie fixed-point -> real (cu semn)
    // ------------------------
    rf = $itor($signed(r_f)) / SCALE;
    rw = $itor($signed(r_w)) / SCALE;
    rh = $itor($signed(r_h)) / SCALE;
    ra = (r_ang / 2.0) * (3.14159265 / 180.0); // Unghiul este angle/2 grade

    rf = $itor($signed(r_f)) / SCALE;
    rx = $itor($signed(r_x)) / SCALE;
    ry = $itor($signed(r_y)) / SCALE;
    rz = $itor($signed(r_z)) / SCALE;
    
    // ------------------------
    // Calcul referinta gold
    // ------------------------
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

    // ------------------------
    // Stimulare DUT
    // ------------------------
    start_op(r_rot, r_ang, r_w, r_h, r_f, r_x, r_y, r_z);
    wait(valid == 1'b1);
    @(posedge clk); #2;

    // ------------------------
    // Verificare cu toleranta ±1 LSB (erori de rotunjire)
    // ------------------------
    got_xs_s = $signed(xs);
    got_ys_s = $signed(ys);
    
    diff_x   = $signed(got_xs_s) - $signed(exp_xs);
    diff_y   = $signed(got_ys_s) - $signed(exp_ys);
        
    err_x = $itor(diff_x)/SCALE;
    err_y = $itor(diff_y)/SCALE;

        
    if ((err_x > THRESHOLD) || (err_x < -THRESHOLD) || (err_y > THRESHOLD) || (err_y < -THRESHOLD)) begin
        error_count = error_count + 1;
        $display("EROARE [%0d]: f=%h x=%h y=%h z=%h | xp=%h(exp %h, DIFERENTA=%f) yp=%h(exp %h, DIFERENTA=%f)",
                 idx, r_f, r_x, r_y, r_z,
                 xp, exp_xp, err_x,
                 yp, exp_yp, err_y);
    end else begin
        $display("OK    RANDOM [%0d]: f=%h x=%h y=%h z=%h -> xp=%h yp=%h",
                 idx, r_f, r_x, r_y, r_z, xp, yp);
    end
end
endtask


    // ------------------------
    // Task: ruleaza NUM_RAND teste random
    // ------------------------
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


    // ------------------------
    // Subrutina principala
    // ------------------------

    initial begin
        $display("=== START TEST VERTEX PROCESSING UNIT ===");

        // RESET
        start = 0;
        angle = 0; rotation = 0; w = 0; h = 0; f = 0; x = 0; y = 0; z = 0;
        repeat(5) @(posedge clk);

        // Rezolutie fixa pentru toate testele de mai jos: 320x240
        w = 32'h0780_0000; // 320.0 in Q16.16
        h = 32'h0438_0000; // 240.0 in Q16.16
    
        run_random_tests(402);     // seed fix => reproductibil
        error_rate = (error_count * 100.0) / test_count;

        $display("--------------------------------");
        $display("=== TEST VPU FINALIZAT ===");
        $display("Teste totale   = %0d", test_count);
        $display("Erori          = %0d", error_count);
        $display("Threshold      = %f", THRESHOLD);
        $display("Error rate     = %f %%", error_rate);
        $finish;
    end

endmodule
