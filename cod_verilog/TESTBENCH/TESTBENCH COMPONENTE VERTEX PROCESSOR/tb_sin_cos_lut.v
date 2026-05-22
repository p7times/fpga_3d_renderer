//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : tb_sin_cos_lut
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Testbench pentru modulul Sin/Cos LUT (Look-Up-Table).
//              Verifica valorile sinusului si cosinusului returnate
//              de tabela de cautare pentru unghiuri cardinale si custom.
//---------------------------------------------------------------
 
`timescale 1ns/1ps
 
module tb_sin_cos_lut;
 
 
    // ------------------------
    // Parametri de configurare
    // ------------------------
 
    parameter INT_BITS  = 8;                    // Biti pentru partea intreaga (semnati)
    parameter FRAC_BITS = 16;                   // Biti pentru partea fractionara
    parameter WIDTH     = INT_BITS + FRAC_BITS; // Latime totala cuvant
    parameter PER       = 4;                    // Perioada ceasului (4ns => 250MHz)
 
 
    // ------------------------
    // Semnale de interfata
    // ------------------------
 
    wire clk;
    wire rst_n;
    reg  start = 0;
        
    reg  [9:0]                    angle;        // Unghiul de intrare (in pasi de 0.5 grade)
    wire [INT_BITS+FRAC_BITS-1:0] sin_out;      // Valoarea sin(angle) in Q8.16
    wire [INT_BITS+FRAC_BITS-1:0] cos_out;      // Valoarea cos(angle) in Q8.16
    wire valid;                                 // Semnal valid de la DUT
    wire [2:0] dbg_state;                       // Starea interna a FSM-ului DUT
 
 
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
 
    sin_cos_lut #(
        .INT_BITS  (INT_BITS),
        .FRAC_BITS (FRAC_BITS)
    ) uut (
        .clk       (clk),
        .rst_n     (rst_n),
        .start     (start),
        .angle     (angle),
        .valid     (valid),
        .sin_out   (sin_out),
        .cos_out   (cos_out),
        .dbg_state (dbg_state)
    );
 
 
    // ------------------------
    // Task: Interogare LUT si afisare rezultat
    // ------------------------
 
    task check;
        input [9:0] ang;
    begin
        angle = ang;
        
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        
        wait(valid === 1'b1);
        @(posedge clk); #1;
        
        $display("angle=%0.1f° | sin=%h | cos=%h", ang/2.0, sin_out, cos_out);
    end
    endtask
 
 
    // ------------------------
    // Subrutina principala
    // ------------------------
 
    initial begin
        $display("=== Start TEST SIN/COS LUT ===");
        $display("------------------------------------------------------");
 
        start = 0;
        angle = 0;
        repeat (5) @(posedge clk);
        
        // Unghiuri cardinale si un unghi custom
        check(10'd0);   //   0.0°
        check(10'd90);  //  45.0°
        check(10'd180); //  90.0°
        check(10'd270); // 135.0°
        check(10'd323); // 161.5°
        
        $display("------------------------------------------------------");
        $display("=== TEST SIN/COS LUT terminat ===");
        $finish;
    end
 
endmodule

