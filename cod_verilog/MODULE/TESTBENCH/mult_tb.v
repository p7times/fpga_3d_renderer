`timescale 1ns/1ps

module mult_tb;

parameter WIDTH = 16;        // Latimea datelor
parameter PER = 4;          // Perioada ceasului în ns

reg ck = 0;                 
reg reset_n = 1;
reg start = 0;
reg [WIDTH-1:0] op1, op2;       // operanzii de test
wire [2*WIDTH-1:0] rezultat;    // produs
wire valid;

integer error_count = 0;

// ------------------------
// Ceas
// ------------------------
always #(PER/2) ck = ~ck;

// ------------------------
// Instantiere DUT
// ------------------------
mult_top_level #(.N(WIDTH)) dut (
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
task run_test(input [WIDTH-1:0] deinmultit, input [WIDTH-1:0] inmultitor);
begin
    op1 = deinmultit;
    op2 = inmultitor;
    @(posedge ck);
    start = 1;
    @(posedge ck);
    start = 0;

    //wait(valid);
    @(posedge valid);

    if (rezultat !== op1*op2) begin
    error_count = error_count + 1;
    $display("EROARE: %0d * %0d -> produs = %0d, actual = %0d", op1, op2, rezultat, op1*op2);
    end

    $display("OK: %0d * %0d -> produs = %0d", deinmultit, inmultitor, rezultat);
    $display("Produs actual = %0d", op1 * op2);

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

    $display("DIV_TEST terminat cu %0d erori", error_count);
    $finish;
 end

endmodule

