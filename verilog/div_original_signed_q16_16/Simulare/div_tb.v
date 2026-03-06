`timescale 1ns/1ps

module div_tb;

parameter WIDTH = 16;        // Latimea datelor
parameter PER = 4;          // Perioada ceasului în ns

reg ck = 0;                 
reg reset_n = 1;
reg start = 0;
reg [WIDTH-1:0] op1, op2;       // operanzii de test
wire [2*WIDTH-1:0] rezultat;       // {cat, rest}
wire [WIDTH-1:0] cat, rest;
wire valid;

integer error_count = 0;

// Splitarea rezultatului
assign cat = rezultat[2*WIDTH-1 : WIDTH];
assign rest = rezultat[WIDTH-1  : 0];

// ------------------------
// Ceas
// ------------------------
always #(PER/2) ck = ~ck;

// ------------------------
// Instantiere DUT
// ------------------------
div_top_level #(.N(WIDTH)) dut (
    .ck(ck),
    .reset_n(reset_n),
    .start(start),
    .op1(op1),
    .op2(op2),
    .rezultat(rezultat),
    .valid(valid)
);

// ------------------------
// Simulare
// ------------------------
task run_test(input [WIDTH-1:0] deimpartit, input [WIDTH-1:0] impartitor);
begin
    op1 = deimpartit;
    op2 = impartitor;
    @(posedge ck);
    start = 1;
    @(posedge ck);
    start = 0;

    //wait(valid);
    @(posedge valid);
    
    if (impartitor == 0) begin
        $display("EROARE: %0d / 0 -> cat=%0d rest=%0d", deimpartit, cat, rest);
        
        error_count = error_count + 1;
    end else begin
        $display("OK: %0d / %0d -> cat=%0d rest=%0d", deimpartit, impartitor, cat, rest);
        $display("Rezultat actual: cat=%0d rest=%0d", op1 / op2, op1 % op2);
    end
end
endtask

// ------------------------
// Secventa de test
// ------------------------
initial begin
    reset_n = 0;
    start = 0;
    op1 = 0;
    op2 = 0;
    @(posedge ck);
    reset_n = 1; 

    run_test(0, 12345);
    run_test(65535, 1);
    run_test(65535, 65535);
    run_test(65535, 65534);
    run_test(65535, 2);
    run_test(5, 65535);
    run_test(65534, 65535);
    run_test(32768, 2);
    run_test(32768, 32768);
    run_test(32768, 3);
    run_test(12345, 0);
    run_test(65535, 0);
    run_test(0, 0);
    
    

    $display("DIV_TEST terminat cu %0d erori", error_count);
    $finish;
 end

endmodule

