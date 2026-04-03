`timescale 1ns/1ps

module tb_sin_cos_lut_q;

parameter INT_BITS  = 8;    
parameter FRAC_BITS = 16;
parameter WIDTH     = INT_BITS + FRAC_BITS;     // Numarul total de biti pe care se reprezinta datele
parameter PER       = 4;                        // Perioada ceasului în ns

reg  [9:0]  angle;
wire [INT_BITS+FRAC_BITS-1:0] sin_out;
wire [INT_BITS+FRAC_BITS-1:0] cos_out;

    // Instantiate DUT
    sin_cos_lut_q #(
        .INT_BITS  (INT_BITS),
        .FRAC_BITS (FRAC_BITS)
    ) uut (
        .angle   (angle),
        .sin_out (sin_out),
        .cos_out (cos_out)
    );

    // Task to display one result
    task check;
        input [9:0]  ang;
        begin
            angle = ang;
            #10;
            $display("angle=%0.1f° | sin=%h | cos=%h", ang/2.0, sin_out, cos_out);
        end
    endtask

    initial begin
        $display("=== Start TEST SIN/COS LUT ===");
        $display("------------------------------------------------------");

        // Cardinal angles
        check(10'd0); 
        check(10'd90);
        check(10'd180);
        check(10'd270);
        
        $display("------------------------------------------------------");
        $display("=== TEST SIN/COS LUT terminat ===");
        $finish;
    end

endmodule
