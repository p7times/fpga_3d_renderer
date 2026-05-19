`timescale 1ns/1ps

module tb_sin_cos_lut_q;

parameter INT_BITS  = 8;    
parameter FRAC_BITS = 16;
parameter WIDTH     = INT_BITS + FRAC_BITS;     // Numarul total de biti pe care se reprezinta datele
parameter PER = 4;                      // Perioada ceasului în ns

wire                clk;                 
wire                rst_n;
reg              start = 0;
    
reg  [9:0]  angle;
wire [INT_BITS+FRAC_BITS-1:0] sin_out;
wire [INT_BITS+FRAC_BITS-1:0] cos_out;
wire             valid;
wire [2:0] dbg_state;

    // ------------------------
    // Ceas
    // ------------------------
    ck_rst_tb #(
        .CK_SEMIPERIOD(PER/2)
    ) clk_gen (
        .clk(clk),
        .rst_n(rst_n)
    );
    
    // Instantiate DUT
    sin_cos_lut_q #(
        .INT_BITS  (INT_BITS),
        .FRAC_BITS (FRAC_BITS)
    ) uut (
        .clk        (clk),
        .rst_n      (rst_n),
        .start      (start),
        .angle      (angle),
        .valid      (valid),
        .sin_out    (sin_out),
        .cos_out    (cos_out),
        .dbg_state  (dbg_state)
    );

    // Task to display one result
    task check;
        input [9:0]  ang;
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

    initial begin
        $display("=== Start TEST SIN/COS LUT ===");
        $display("------------------------------------------------------");

        start = 0;
        angle = 0;
        repeat (5) @(posedge clk);
        
        // Cardinal angles
        check(10'd0); 
        check(10'd90);
        check(10'd180);
        check(10'd270);
        check(10'd323);
        
        $display("------------------------------------------------------");
        $display("=== TEST SIN/COS LUT terminat ===");
        $finish;
    end

endmodule
