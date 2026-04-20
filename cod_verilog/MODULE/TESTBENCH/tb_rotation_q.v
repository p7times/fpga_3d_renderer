`timescale 1ns/1ps

module tb_rotation_q;

// ---------------------------------------------------
// PARAMETRI
// ---------------------------------------------------

parameter INT_BITS  = 16;    
parameter FRAC_BITS = 16;
parameter WIDTH     = INT_BITS + FRAC_BITS;     // Numarul total de biti pe care se reprezinta datele
parameter PER = 4;                              // Perioada ceasului în ns
parameter NUM_RAND  = 3000;
parameter THRESHOLD = 0.0001;
parameter ONE = 1 << FRAC_BITS;  // = 65536


// ---------------------------------------------------
// SEMNALE
// ---------------------------------------------------

wire        clk;                 
wire        rst_n;
reg         start;
reg  [2:0]  rotation;
reg  [WIDTH-1:0] x, y, z;
reg  [9:0]       angle;

wire [WIDTH-1:0] xr, yr, zr;
wire             valid;
wire             overflow;
wire [3:0]       dbg_state;

integer error_count = 0;
integer test_count  = 0;
real error_rate;


// ---------------------------------------------------
// Ceas & Reset (Instanțiere ck_rst_tb)
// ---------------------------------------------------

ck_rst_tb #(
    .CK_SEMIPERIOD(PER/2)
) clk_gen (
    .clk(clk),
    .rst_n(rst_n)
);


// ---------------------------------------------------
// DUT (Device Under Test)
// ---------------------------------------------------

rotation_q #(
    .INT_BITS(INT_BITS),
    .FRAC_BITS(FRAC_BITS)
) dut (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .rotation(rotation),
    .x(x), .y(y), .z(z),
    .angle(angle),
    .xr(xr), .yr(yr), .zr(zr),
    .valid(valid),
    .overflow(overflow),
    .dbg_state(dbg_state)
);


// ---------------------------------------------------
// Task: Pornire operație
// ---------------------------------------------------

task start_op(
    input [2:0]       rot_type,
    input [9:0]       ang,
    input [WIDTH-1:0] in_x,
    input [WIDTH-1:0] in_y,
    input [WIDTH-1:0] in_z
);
begin
    rotation = rot_type;
    angle    = ang;
    x        = in_x;
    y        = in_y;
    z        = in_z;

    start = 1'b1;
    @(posedge clk);
    #1;
    start = 1'b0;
end
endtask


// ---------------------------------------------------
// Task: Un singur test random cu model de referință
// ---------------------------------------------------

task run_one_random;
    input [2:0]       r_rot;
    input [9:0]       r_angle;
    input [WIDTH-1:0] r_x, r_y, r_z;
    input integer     idx;

    real rx, ry, rz, ra, r_sin, r_cos;
    real exp_xr_r, exp_yr_r, exp_zr_r;
    real SCALE;
    
    real err_x, err_y, err_z;
    reg signed [WIDTH-1:0] exp_xr, exp_yr, exp_zr;
    reg signed [WIDTH-1:0] got_xr, got_yr, got_zr;
begin
    SCALE = $pow(2.0, FRAC_BITS);
    
    // Conversie fixed-point -> real
    rx = $itor($signed(r_x)) / SCALE;
    ry = $itor($signed(r_y)) / SCALE;
    rz = $itor($signed(r_z)) / SCALE;
    ra = (r_angle / 2.0) * (3.14159265 / 180.0); // Unghiul este angle/2 grade

    r_sin = $sin(ra);
    r_cos = $cos(ra);

    // Model de referință (Gold) bazat pe tipul rotației
    case (r_rot)
        3'b000: begin // ROT_X_CCW
            exp_xr_r = rx;
            exp_yr_r = ry * r_cos - rz * r_sin;
            exp_zr_r = ry * r_sin + rz * r_cos;
        end
        3'b001: begin // ROT_X_CW
            exp_xr_r = rx;
            exp_yr_r = ry * r_cos + rz * r_sin;
            exp_zr_r = -ry * r_sin + rz * r_cos;
        end
        3'b010: begin // ROT_Y_CCW
            exp_xr_r = rx * r_cos + rz * r_sin;
            exp_yr_r = ry;
            exp_zr_r = -rx * r_sin + rz * r_cos;
        end
        3'b011: begin // ROT_Y_CW
            exp_xr_r = rx * r_cos - rz * r_sin;
            exp_yr_r = ry;
            exp_zr_r = rx * r_sin + rz * r_cos;
        end
        3'b100: begin // ROT_Z_CCW
            exp_xr_r = rx * r_cos - ry * r_sin;
            exp_yr_r = rx * r_sin + ry * r_cos;
            exp_zr_r = rz;
        end
        3'b101: begin // ROT_Z_CW
            exp_xr_r = rx * r_cos + ry * r_sin;
            exp_yr_r = -rx * r_sin + ry * r_cos;
            exp_zr_r = rz;
        end
        default: begin
            exp_xr_r = rx; exp_yr_r = ry; exp_zr_r = rz;
        end
    endcase

    // Conversie referință înapoi în Fixed-Point (cu rotunjire simplă)
    exp_xr = $rtoi(exp_xr_r * SCALE);
    exp_yr = $rtoi(exp_yr_r * SCALE);
    exp_zr = $rtoi(exp_zr_r * SCALE);

    // Stimulare DUT
    start_op(r_rot, r_angle, r_x, r_y, r_z);
    wait(valid == 1'b1);
    @(posedge clk); #1;
    
    got_xr = $signed(xr);  // deja fixed-point, cast direct
    got_yr = $signed(yr);
    got_zr = $signed(zr);

    // Calcul eroare absolută
    err_x = abs(($itor($signed(xr))/SCALE) - exp_xr_r );
    err_y = abs(($itor($signed(yr))/SCALE) - exp_yr_r );
    err_z = abs(($itor($signed(zr))/SCALE) - exp_zr_r );

    if (err_x > THRESHOLD || err_y > THRESHOLD || err_z > THRESHOLD) begin
        error_count = error_count + 1;
        $display("EROARE [%0d]: Rot=%b Ang=%0.1f | In:(%f, %f, %f) | Got:(%h, %h, %h) Exp:(%h, %h, %h)", 
                 idx, r_rot, r_angle/2.0, rx, ry, rz, 
                 got_xr, got_yr, got_zr,
                 exp_xr, exp_yr, exp_zr);         
    end else begin
        $display("OK [%0d]: Rot=%b Ang=%0.1f | In:(%f, %f, %f) | Got:(%h, %h, %h)",
                 idx, r_rot, r_angle/2.0, rx, ry, rz, 
                 got_xr, got_yr, got_zr);
    end
end
endtask


// ---------------------------------------------------
// Task: Rulează set de teste random
// ---------------------------------------------------

task run_random_tests;
    input integer seed;
    integer i;
    reg [WIDTH-1:0] rx, ry, rz;
    reg [9:0]       ra;
    reg [2:0]       rt;
begin
    $display("--- START %0d TESTE RANDOM ---", NUM_RAND);
    for (i = 0; i < NUM_RAND; i = i + 1) begin
        rt = $urandom % 6;          // Tip rotație 0-5
        ra = $urandom % 720;        // Unghi 0-359.5 (pas 0.5)
        rz = $urandom_range(-50000, 50000); 
        rx = $urandom_range(-50000, 50000);
        ry = $urandom_range(-50000, 50000);
        
        run_one_random(rt, ra, rx, ry, rz, i);
        test_count = test_count + 1;
    end
end
endtask


// ---------------------------------------------------
// Flux Principal
// ---------------------------------------------------

initial begin
    $display("=== Start TEST ROTATIE 3D ===");
    $display("------------------------------------------------------");

    start = 0;
    repeat (5) @(posedge clk);
        
    run_random_tests(402);
    error_rate = (error_count * 100.0) / test_count;
    $display("--------------------------------");
    $display("Rezumat: %0d teste, %0d erori", test_count, error_count);
    $display("Rata eroare: %f%%", error_rate);
        
    $display("------------------------------------------------------");
    $display("=== TEST ROTATIE 3D terminat ===");
    $finish;
end

// Funcție utilitară pentru modul real
function real abs;
    input real val;
    begin
        if (val < 0.0)
            abs = -val;
        else
            abs = val;
    end
endfunction

endmodule
