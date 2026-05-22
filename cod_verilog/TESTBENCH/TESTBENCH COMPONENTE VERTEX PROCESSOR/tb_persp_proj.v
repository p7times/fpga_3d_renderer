//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : tb_persp_proj
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Testbench pentru modulul de Proiectie Perspectiva.
//              Verifica calculul coordonatelor proiectate (xp, yp)
//              prin comparatie cu un model de referinta in virgula mobila.
//---------------------------------------------------------------
 
`timescale 1ns/1ps
 
module tb_persp_proj;
 
 
    // ------------------------
    // Parametri de configurare (NU ATINGE)
    // ------------------------
 
    parameter INT_BITS  = 16;               // Biti pentru partea intreaga (semnati)
    parameter FRAC_BITS = 16;               // Biti pentru partea fractionara
    parameter WIDTH     = INT_BITS + FRAC_BITS; // Latime totala cuvant
    parameter PER       = 4;                // Perioada ceasului (4ns => 250MHz)
    parameter ONE       = 1 << FRAC_BITS;  // Reprezentarea valorii 1.0 in Q16.16
 
 
    // ------------------------
    // Parametri modificabili
    // ------------------------
 
    parameter NUM_RAND  = 3000;             // Numarul de teste aleatorii
    parameter THRESHOLD = 5.0 / 65536.0;   // Toleranta acceptata (in unitati reale)
 
 
    // ------------------------
    // Semnale de interfata
    // ------------------------
 
    wire clk;
    wire rst_n;
    reg  start;
 
    reg  [WIDTH-1:0] f, x, y, z;   // Intrari: lungime focala si coordonatele 3D
    wire [WIDTH-1:0] xp, yp;        // Iesiri: coordonate proiectate
    wire valid;                     // Semnal valid de la DUT
    wire [2:0] dbg_state;          // Starea interna a FSM-ului DUT
    wire overflow;                  // Indicator depasire domeniu numeric
 
    // Variabile statistice pentru raportare
    integer error_count = 0;        // Numar de erori detectate
    integer test_count  = 0;        // Numar total de teste rulate
    real    error_rate;             // Rata de eroare procentuala
 
 
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
 
    persp_proj #(
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
 
 
    // ------------------------
    // Task 1: Start operatie
    // ------------------------
 
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
 
 
    // ------------------------
    // Task 2: Test manual cu valori predefinite
    // ------------------------
 
    // Stimuleaza DUT si compara iesirile cu valorile asteptate furnizate explicit
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
 
 
    // ------------------------
    // Task 3: Definirea Modelului de Referinta (Task-ul de calcul)
    // ------------------------
 
    // Calculeaza rezultatul ideal, stimuleaza DUT-ul si compara iesirile
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
 
        // 1. Conversie din Fixed-Point (DUT) in Real (Golden Model)
        rf = $itor($signed(r_f)) / SCALE;
        rx = $itor($signed(r_x)) / SCALE;
        ry = $itor($signed(r_y)) / SCALE;
        rz = $itor($signed(r_z)) / SCALE;
        
        // 2. Calcul model de referinta cu saturatie
        if (rz == 0.0) begin
            // Saturare: semnul determinat de f (z -> 0+)
            exp_xp = (rf >= 0.0) ? 32'h7FFF_FFFF : 32'h8000_0000;
            exp_yp = (rf >= 0.0) ? 32'h7FFF_FFFF : 32'h8000_0000;
        end else begin
            factor   = rf / rz;
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
 
        // 3. Stimulare DUT si asteptare semnal valid
        start_op(r_f, r_x, r_y, r_z);
        wait(valid == 1'b1);
        @(posedge clk); #2;
 
        // 4. Verificare cu toleranta ±THRESHOLD (erori de rotunjire)
        got_xp_s = $signed(xp);
        got_yp_s = $signed(yp);
        
        diff_x = $signed(got_xp_s) - $signed(exp_xp);
        diff_y = $signed(got_yp_s) - $signed(exp_yp);
 
        err_x = $itor(diff_x) / SCALE;
        err_y = $itor(diff_y) / SCALE;
 
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
 
 
    // ------------------------
    // Task: Bucla de teste aleatorii
    // ------------------------
 
    task run_random_tests;
        input integer seed;
        integer i;
        reg [WIDTH-1:0] r_f, r_x, r_y, r_z;
        integer dummy;          // Seed local modificabil
    begin
        dummy = $random(seed);
        $display("--- START %0d TESTE RANDOM (seed=%0d) ---", NUM_RAND, seed);
            
        for (i = 0; i < NUM_RAND; i = i + 1) begin
            r_z = $urandom_range(-50000, 50000); 
            r_f = $urandom_range(-50000, 50000);
            r_x = $urandom_range(-50000, 50000);
            r_y = $urandom_range(-50000, 50000);
             
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
        $display("=== START TEST PROJ ===");
 
        // Initializare si Reset
        start = 0;
        f = 0; x = 0; y = 0; z = 0;
        repeat(5) @(posedge clk);
 
        run_random_tests(402);      // Seed fix => reproductibil
        error_rate = (error_count * 100.0) / test_count;
 
        $display("--------------------------------");
        $display("=== TEST terminat ===");
        $display("Teste totale   = %0d", test_count);
        $display("Erori          = %0d", error_count);
        $display("Threshold      = %f",  THRESHOLD);
        $display("Error rate     = %f %%", error_rate);
        $finish;
    end
 
endmodule

