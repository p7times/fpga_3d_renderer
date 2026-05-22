//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : tb_ndc_to_screen
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Testbench pentru modulul NDC to Screen.
//              Verifica conversia coordonatelor din spatiul normalizat
//              (NDC) in coordonate de ecran prin comparatie cu un
//              model de referinta in virgula mobila.
//---------------------------------------------------------------
 
`timescale 1ns/1ps
 
module tb_ndc_to_screen;
 

    // ------------------------
    // Parametri de configurare (NU ATINGE)
    // ------------------------
 
    parameter INT_BITS  = 16;               // Biti pentru partea intreaga (semnati)
    parameter FRAC_BITS = 16;               // Biti pentru partea fractionara
    parameter WIDTH     = INT_BITS + FRAC_BITS; // Latime totala cuvant
    parameter PER       = 4;                // Perioada ceasului (4ns => 250MHz)
 
 
    // ------------------------
    // Parametri modificabili
    // ------------------------
 
    parameter NUM_RAND  = 2000;             // Numarul de teste aleatorii
    parameter THRESHOLD = 5.0 / 65536.0;   // Toleranta acceptata (in unitati reale)
 
 
    // ------------------------
    // Semnale de interfata
    // ------------------------
 
    wire clk;
    wire rst_n;
    reg  start;
 
    reg  [WIDTH-1:0] xp_in, yp_in, w_in, h_in;  // Intrari: coordonate NDC si dimensiuni ecran
    wire [WIDTH-1:0] xs, ys;                      // Iesiri: coordonate ecran
    wire valid;                                   // Semnal valid de la DUT
    wire overflow;                                // Indicator depasire domeniu numeric
    wire [2:0] dbg_state;                        // Starea interna a FSM-ului DUT
 
    // Variabile statistice pentru raportare
    integer error_count = 0;                      // Numar de erori detectate
    integer test_count  = 0;                      // Numar total de teste rulate
    real    error_rate;                           // Rata de eroare procentuala
 
 
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
 
    ndc_to_screen #(
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .xp(xp_in), .yp(yp_in), .w(w_in), .h(h_in),
        .xs(xs), .ys(ys),
        .valid(valid),
        .overflow(overflow),
        .dbg_state(dbg_state)
    );
 
 
    // ------------------------
    // Task 1: Start operatie
    // ------------------------
 
    task start_op(
        input [WIDTH-1:0] i_xp,
        input [WIDTH-1:0] i_yp,
        input [WIDTH-1:0] i_w,
        input [WIDTH-1:0] i_h
    );
    begin
        xp_in = i_xp;
        yp_in = i_yp;
        w_in  = i_w;
        h_in  = i_h;
 
        start = 1'b1;
        @(posedge clk);
        start = 1'b0;
    end
    endtask
 
 
    // ------------------------
    // Task 2: Definirea Modelului de Referinta (Task-ul de calcul)
    // ------------------------
 
    // Calculeaza rezultatul ideal, stimuleaza DUT-ul si compara iesirile
    task run_one_random;
        input [WIDTH-1:0] r_xp, r_yp, r_w, r_h;
        input integer     idx;
 
        real rxp, ryp, rw, rh, r_xs_exp, r_ys_exp;
        real SCALE, MAX_R, MIN_R;
        
        real err_x, err_y;
        
        reg signed [WIDTH-1:0] exp_xs, exp_ys;
        reg signed [WIDTH-1:0] got_xs_s, got_ys_s;
    begin
        SCALE = 65536.0;                  // 2^FRAC_BITS
        MAX_R =  2147483647.0 / SCALE;    // +32767.99998...
        MIN_R = -2147483648.0 / SCALE;    // -32768.0
 
        // 1. Conversie din Fixed-Point (DUT) in Real (Golden Model)
        rxp = $itor($signed(r_xp)) / SCALE;
        ryp = $itor($signed(r_yp)) / SCALE;
        rw  = $itor($signed(r_w))  / SCALE;
        rh  = $itor($signed(r_h))  / SCALE;
        
        // 2. Calcul model de referinta (formula NDC to Screen)
        r_xs_exp = (rxp * rh + rw) / 2.0;
        r_ys_exp = (rh - ryp * rh) / 2.0;
        
        // 3. Aplicare saturatie (oglindeste comportamentul modulelor add_q/mult_q)
        if      (r_xs_exp >= MAX_R) exp_xs = 32'h7FFF_FFFF;
        else if (r_xs_exp <= MIN_R) exp_xs = 32'h8000_0000;
        else                        exp_xs = $rtoi(r_xs_exp * SCALE);
 
        if      (r_ys_exp >= MAX_R) exp_ys = 32'h7FFF_FFFF;
        else if (r_ys_exp <= MIN_R) exp_ys = 32'h8000_0000;
        else                        exp_ys = $rtoi(r_ys_exp * SCALE);
 
        // 4. Stimulare DUT si asteptare semnal valid
        start_op(r_xp, r_yp, r_w, r_h);    
        wait(valid == 1'b1);
        @(posedge clk); #2;
 
        // 5. Verificare eroare fata de pragul THRESHOLD
        got_xs_s = $signed(xs);
        got_ys_s = $signed(ys);
        
        err_x = $itor(got_xs_s - exp_xs) / SCALE;
        err_y = $itor(got_ys_s - exp_ys) / SCALE;
                  
        if ((err_x > THRESHOLD) || (err_x < -THRESHOLD) || (err_y > THRESHOLD) || (err_y < -THRESHOLD)) begin
            error_count = error_count + 1;
            $display("EROARE [%0d]: xp=%f yp=%f w=%f h=%f | xs=%f(exp %f) ys=%f(exp %f)",
                     idx, rxp, ryp, rw, rh, 
                     $itor(got_xs_s)/SCALE, r_xs_exp, 
                     $itor(got_ys_s)/SCALE, r_ys_exp);
        end else begin
            $display("OK [%0d]: xs=%f ys=%f", idx, $itor(got_xs_s)/SCALE, $itor(got_ys_s)/SCALE);
        end
    end
    endtask
 
 
    // ------------------------
    // Subrutina principala
    // ------------------------
 
    initial begin
        $display("=== START TEST NDC_TO_SCREEN ===");
        
        // Initializare si Reset
        start = 0;
        xp_in = 0; yp_in = 0; w_in = 0; h_in = 0;
        repeat(5) @(posedge clk);
        
        // Rezolutie fixa pentru toate testele de mai jos: 320x240
        w_in = 32'h0780_0000; // 320.0 in Q16.16
        h_in = 32'h0438_0000; // 240.0 in Q16.16
 
        // Test Manual 1: Centru (0, 0) -> Asteptat: xs=160 (00A0), ys=120 (0078)
        run_one_random(32'h0000_0000, 32'h0000_0000, w_in, h_in, 1001);
 
        // Test Manual 2: Dreapta-Sus (1.0, 1.0) -> Asteptat: xs=280 (0118), ys=0 (0000)
        run_one_random(32'h0001_0000, 32'h0001_0000, w_in, h_in, 1002);
 
        // Test Manual 3: Stanga-Jos (-1.0, -1.0) -> Asteptat: xs=40 (0028), ys=240 (00F0)
        run_one_random(32'hFFFF_0000, 32'hFFFF_0000, w_in, h_in, 1003);
 
        // Test Manual 4: Valoare Custom (xp=0.5, yp=-0.25)
        run_one_random(32'h0000_8000, 32'hFFFF_C000, w_in, h_in, 1004);
 
        // Rularea testelor random (xp, yp in [-2, 2] pentru testarea clipping-ului)
        for (integer i = 0; i < NUM_RAND; i = i + 1) begin
            xp_in = $urandom_range(0, 4 << FRAC_BITS) - (2 << FRAC_BITS);
            yp_in = $urandom_range(0, 4 << FRAC_BITS) - (2 << FRAC_BITS);
 
            run_one_random(xp_in, yp_in, w_in, h_in, i);
            test_count = test_count + 1;
        end
        
        test_count = test_count + 4;    // Include cele 4 teste manuale
 
        // Raport final
        error_rate = (error_count * 100.0) / test_count;
        $display("--------------------------------");
        $display("Rezumat: %0d teste rulate", test_count);
        $display("Erori: %0d", error_count);
        $display("Rata eroare: %f%%", error_rate);
        $display("=== TEST FINALIZAT ===");
        $finish;
    end
 
endmodule

