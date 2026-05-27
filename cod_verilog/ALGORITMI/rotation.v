//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : rotation
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Modul de rotatie 3D pentru transformarea unui
//              punct (x, y, z) utilizand matrici de rotatie 3x3.
//
//              Modulul suporta rotatii fata de axele X, Y si Z,
//              atat in sens trigonometric (CCW), cat si in sens
//              orar (CW), selectate prin semnalul 'rotation'.
//
//              Fluxul de calcul implementat:
//
//                  1. Obtine valorile sin(angle) si cos(angle)
//                     dintr-un LUT dedicat
//
//                  2. Construieste matricea de rotatie 3x3
//                     corespunzatoare axei si sensului selectat
//
//                  3. Efectueaza inmultirea matrice-vector:
//
//                         |xr|   |a b c|   |x|
//                         |yr| = |d e f| * |y|
//                         |zr|   |g h i|   |z|
//
//                  4. Calculeaza produsele partiale prin
//                     multiplicatoare fixed-point dedicate
//
//                  5. Realizeaza suma termenilor in doua etape
//                     pipeline pentru reducerea latentei si
//                     cresterea frecventei maxime de operare
//
//              Arhitectura este secventiala, controlata prin FSM,
//              iar operatiile aritmetice sunt implementate cu
//              submodule dedicate pentru:
//                  - LUT sin/cos
//                  - multiplicare fixed-point
//                  - adunare fixed-point
//
//              Include detectie overflow pentru depanare.
//
//              Reprezentare numerica:
//                  signed fixed-point (Q INT_BITS.FRAC_BITS)
//---------------------------------------------------------------

module rotation #(
    parameter INT_BITS  = 16,                           // Numar de biti parte intreaga (include semnul) 
    parameter FRAC_BITS = 16,                           // Numar de biti parte fractionara
    parameter DATA_WIDTH = INT_BITS + FRAC_BITS         // Latime date, biti
)(
    input                               clk,            // Semnal de ceas
    input                               rst_n,          // Reset asincron (activ in 0)
    input                               start,          // Pornire calcul rotatie
    input      [2:0]                    rotation,       // Flag selectare tip de rotatie
    input      [DATA_WIDTH-1:0]         x, y, z,        // Datele de intrare 
    input      [9:0]                    angle,          // Unghiul de rotatie
    output reg [DATA_WIDTH-1:0]         xr, yr, zr,     // Datele de iesire (coordonatele 3D rotite)
    output reg                          valid,          // Flag finalizare conversie
    output reg                          overflow,       // Indicator depasire domeniu numeric (DEBUG)
    output     [3:0]                    dbg_state       // Flag stare FSM (DEBUG)
);
    
    localparam [DATA_WIDTH-1:0] ONE  = {{(INT_BITS-1){1'b0}}, 1'b1, {FRAC_BITS{1'b0}}};
    localparam [DATA_WIDTH-1:0] ZERO = {DATA_WIDTH{1'b0}};


    // ------------------------
    // Codificarea scenariilor de rotatie
    // ------------------------
 
    localparam [2:0] ROT_X_CCW = 3'b000,   // Axa X, sens trigonometric
                     ROT_X_CW  = 3'b001,   // Axa X, sens orar
                     ROT_Y_CCW = 3'b010,   // Axa Y, sens trigonometric
                     ROT_Y_CW  = 3'b011,   // Axa Y, sens orar
                     ROT_Z_CCW = 3'b100,   // Axa Z, sens trigonometric
                     ROT_Z_CW  = 3'b101;   // Axa Z, sens orar


    // ------------------------
    // Definitie stari FSM
    // ------------------------

    localparam IDLE           = 4'b0000,  // Asteapta semnalul de start
               START_LUT      = 4'b0001,
               WAIT_LUT       = 4'b0010,
               DONE_LUT       = 4'b0011,
               LOAD           = 4'b0100,  // Incarca datele in registrele interne
               CALC_MULT      = 4'b0101,  // Multiplicatoarele calculeaza (latenta 2 ciclu)
               WAIT_MULT      = 4'b0110,
               DONE_MULT      = 4'b0111,  // Salveaza rezultatele multiplicatoarelor
               CALC_SUM_FIRST = 4'b1000,  // Prima etapa de sumare: ax+by, dx+ey, gx+hy
               DONE_SUM_FIRST = 4'b1001,  // Salveaza rezultatele primei etape
               CALC_SUM_FINAL = 4'b1010,  // A doua etapa de sumare: +cz, +fz, +iz
               DONE           = 4'b1011;  // Rezultate finale valide

    reg [3:0] state, next_state;
    assign dbg_state = state;


    // ------------------------
    // Registrele interne ptr pipeline
    // ------------------------

    // Datele de intrare
    reg [DATA_WIDTH-1:0] reg_x, reg_y, reg_z;

    // Elementele matricei de rotatie 3x3
    // | a  b  c |   | x |   | a*x + b*y + c*z |   | xr |
    // | d  e  f | * | y | = | d*x + e*y + f*z | = | yr |
    // | g  h  i |   | z |   | g*x + h*y + i*z |   | zr |
    reg [DATA_WIDTH-1:0] reg_a, reg_b, reg_c;
    reg [DATA_WIDTH-1:0] reg_d, reg_e, reg_f;
    reg [DATA_WIDTH-1:0] reg_g, reg_h, reg_i;

    // Registre de pipeline: rezultate multiplicatoare
    reg [DATA_WIDTH-1:0] reg_ax, reg_by, reg_cz;
    reg [DATA_WIDTH-1:0] reg_dx, reg_ey, reg_fz;
    reg [DATA_WIDTH-1:0] reg_gx, reg_hy, reg_iz; 

    // Registre de pipeline: rezultate prima etapa de sumare
    reg [DATA_WIDTH-1:0] reg_ax_by, reg_dx_ey, reg_gx_hy;

    // ------------------------
    // Interfata LUT
    // ------------------------

    reg              lut_start;     // Puls de start (1 ciclu)
    wire             lut_valid;     // Semnal rezultat valid
    // ------------------------
    // Interfata submodule
    // ------------------------

    // LUT sin/cos (combinational)
    reg  [DATA_WIDTH-1:0] reg_sin, reg_cos, reg_neg_sin;
    wire [DATA_WIDTH-1:0] lut_sin, lut_cos;    
    
    // Negari combinationale (complement fata de 2)
    wire [DATA_WIDTH-1:0] neg_sin = ~lut_sin + 1'b1;

    // Multiplicatoare (output registrat, latenta 1 ciclu)
    wire [DATA_WIDTH-1:0] mult_ax_result, mult_by_result, mult_cz_result;
    wire [DATA_WIDTH-1:0] mult_dx_result, mult_ey_result, mult_fz_result;
    wire [DATA_WIDTH-1:0] mult_gx_result, mult_hy_result, mult_iz_result;
    wire             ovf_ax, ovf_by, ovf_cz;
    wire             ovf_dx, ovf_ey, ovf_fz;
    wire             ovf_gx, ovf_hy, ovf_iz;
 
    // Sumatoare prima etapa (output registrat, latenta 1 ciclu)
    wire [DATA_WIDTH-1:0] sum_ax_by_result, sum_dx_ey_result, sum_gx_hy_result;
    wire             ovf_ax_by, ovf_dx_ey, ovf_gx_hy;
 
    // Sumatoare finale (output registrat, latenta 1 ciclu)
    wire [DATA_WIDTH-1:0] res_xr, res_yr, res_zr;
    wire             ovf_xr, ovf_yr, ovf_zr;

    reg ovf_mult, ovf_add_first;      // Acumulatoare overflow intermediare


    // ------------------------
    // Instantiere submodule aritmetice
    // ------------------------

    // LUT
    sin_cos_lut #(
        .INT_BITS (INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_sin_cos_lut (
        .clk       (clk),
        .rst_n     (rst_n),
        .start     (lut_start),
        .angle     (angle),
        .sin_out   (lut_sin),
        .cos_out   (lut_cos),
        .valid     (lut_valid),
        .dbg_state ()
    );


    // 9 Multiplicatoare pentru produsele matricei
    mult_q #(
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_mult_ax (
        .clk(clk),
        .rst_n(rst_n),
        .a(reg_a), 
        .b(reg_x),
        .overflow(ovf_ax), 
        .result(mult_ax_result)
    );

    mult_q #(.INT_BITS(INT_BITS), .FRAC_BITS(FRAC_BITS)) u_mult_by
        (.clk(clk), .rst_n(rst_n), .a(reg_b), .b(reg_y), .overflow(ovf_by), .result(mult_by_result));
    mult_q #(.INT_BITS(INT_BITS), .FRAC_BITS(FRAC_BITS)) u_mult_cz
        (.clk(clk), .rst_n(rst_n), .a(reg_c), .b(reg_z), .overflow(ovf_cz), .result(mult_cz_result));
 
    mult_q #(.INT_BITS(INT_BITS), .FRAC_BITS(FRAC_BITS)) u_mult_dx
        (.clk(clk), .rst_n(rst_n), .a(reg_d), .b(reg_x), .overflow(ovf_dx), .result(mult_dx_result));
    mult_q #(.INT_BITS(INT_BITS), .FRAC_BITS(FRAC_BITS)) u_mult_ey
        (.clk(clk), .rst_n(rst_n), .a(reg_e), .b(reg_y), .overflow(ovf_ey), .result(mult_ey_result));
    mult_q #(.INT_BITS(INT_BITS), .FRAC_BITS(FRAC_BITS)) u_mult_fz
        (.clk(clk), .rst_n(rst_n), .a(reg_f), .b(reg_z), .overflow(ovf_fz), .result(mult_fz_result));
 
    mult_q #(.INT_BITS(INT_BITS), .FRAC_BITS(FRAC_BITS)) u_mult_gx
        (.clk(clk), .rst_n(rst_n), .a(reg_g), .b(reg_x), .overflow(ovf_gx), .result(mult_gx_result));
    mult_q #(.INT_BITS(INT_BITS), .FRAC_BITS(FRAC_BITS)) u_mult_hy
        (.clk(clk), .rst_n(rst_n), .a(reg_h), .b(reg_y), .overflow(ovf_hy), .result(mult_hy_result));
    mult_q #(.INT_BITS(INT_BITS), .FRAC_BITS(FRAC_BITS)) u_mult_iz
        (.clk(clk), .rst_n(rst_n), .a(reg_i), .b(reg_z), .overflow(ovf_iz), .result(mult_iz_result));
 
    // 3 Sumatoare prima etapa: (ax+by), (dx+ey), (gx+hy)
    add_q #(.INT_BITS(INT_BITS), .FRAC_BITS(FRAC_BITS)) u_add_ax_by
        (.clk(clk), .rst_n(rst_n), .a(reg_ax), .b(reg_by), .overflow(ovf_ax_by), .sum(sum_ax_by_result));
    add_q #(.INT_BITS(INT_BITS), .FRAC_BITS(FRAC_BITS)) u_add_dx_ey
        (.clk(clk), .rst_n(rst_n), .a(reg_dx), .b(reg_ey), .overflow(ovf_dx_ey), .sum(sum_dx_ey_result));
    add_q #(.INT_BITS(INT_BITS), .FRAC_BITS(FRAC_BITS)) u_add_gx_hy
        (.clk(clk), .rst_n(rst_n), .a(reg_gx), .b(reg_hy), .overflow(ovf_gx_hy), .sum(sum_gx_hy_result));
 
    // 3 Sumatoare finale: (ax+by)+cz, (dx+ey)+fz, (gx+hy)+iz
    add_q #(.INT_BITS(INT_BITS), .FRAC_BITS(FRAC_BITS)) u_add_ax_by_cz
        (.clk(clk), .rst_n(rst_n), .a(reg_ax_by), .b(reg_cz), .overflow(ovf_xr), .sum(res_xr));
    add_q #(.INT_BITS(INT_BITS), .FRAC_BITS(FRAC_BITS)) u_add_dx_ey_fz
        (.clk(clk), .rst_n(rst_n), .a(reg_dx_ey), .b(reg_fz), .overflow(ovf_yr), .sum(res_yr));
    add_q #(.INT_BITS(INT_BITS), .FRAC_BITS(FRAC_BITS)) u_add_gx_hy_iz
        (.clk(clk), .rst_n(rst_n), .a(reg_gx_hy), .b(reg_iz), .overflow(ovf_zr), .sum(res_zr));

    // ------------------------
    // Logica FSM - Calea de control
    // ------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= IDLE;
        else        state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE:           next_state = start ? START_LUT : IDLE;
            START_LUT:      next_state = WAIT_LUT; 
            WAIT_LUT:       next_state = lut_valid ? DONE_LUT : WAIT_LUT;
            DONE_LUT:       next_state = LOAD;          
            LOAD:           next_state = CALC_MULT;                         
            CALC_MULT:      next_state = WAIT_MULT;
            WAIT_MULT:      next_state = DONE_MULT;                                                    
            DONE_MULT:      next_state = CALC_SUM_FIRST;    
            CALC_SUM_FIRST: next_state = DONE_SUM_FIRST;
            DONE_SUM_FIRST: next_state = CALC_SUM_FINAL;
            CALC_SUM_FINAL: next_state = DONE;                          
            DONE:           next_state = IDLE;                         
            default:        next_state = IDLE;
        endcase
    end

    // ------------------------
    // Logica FSM - Calea de date
    // ------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset complet registre interne si iesiri

            reg_x <= 0; reg_y <= 0; reg_z <= 0;

            reg_sin <= 0; reg_cos <= 0; reg_neg_sin <=0;

            reg_a <= 0; reg_b <= 0; reg_c <= 0;
            reg_d <= 0; reg_e <= 0; reg_f <= 0;
            reg_g <= 0; reg_h <= 0; reg_i <= 0;
 
            reg_ax <= 0; reg_by <= 0; reg_cz <= 0;
            reg_dx <= 0; reg_ey <= 0; reg_fz <= 0;
            reg_gx <= 0; reg_hy <= 0; reg_iz <= 0;
 
            reg_ax_by <= 0; reg_dx_ey <= 0; reg_gx_hy <= 0;
 
            xr       <= 0;
            yr       <= 0;
            zr       <= 0;

            ovf_mult <= 0; ovf_add_first <= 0;

            lut_start <= 1'b0;
            valid    <= 1'b0;
            overflow <= 1'b0;
        end else begin
            
            case (state)

                // Asteapta semnalul de start
                IDLE: begin
                   lut_start <= 1'b0;
                   valid     <= 1'b0;  // Valid este 1 doar in DONE
                end

                START_LUT: begin
                   lut_start <= 1'b1;
                end

                WAIT_LUT: begin
                    lut_start <= 1'b0;
                end
                
                DONE_LUT: begin
                    reg_sin <= lut_sin;
                    reg_cos <= lut_cos;
                    reg_neg_sin <= neg_sin;
                end

                // Incarca datele de intrare in registre
                LOAD: begin
                // Incarca coordonatele si construieste matricea de rotatie.
                    
                    reg_x         <= x;
                    reg_y         <= y;
                    reg_z         <= z;

                    case (rotation)
 
                        ROT_X_CCW: begin            //  [ 1,    0,      0   ]
                            reg_a <= ONE;           //  [ 0,   cos,   -sin  ]
                            reg_b <= ZERO;          //  [ 0,   sin,    cos  ]
                            reg_c <= ZERO;
                            reg_d <= ZERO;
                            reg_e <= reg_cos;
                            reg_f <= reg_neg_sin;
                            reg_g <= ZERO;
                            reg_h <= reg_sin;
                            reg_i <= reg_cos;
                        end
 
                        ROT_X_CW: begin             //  [ 1,    0,      0   ]
                            reg_a <= ONE;           //  [ 0,   cos,    sin  ]
                            reg_b <= ZERO;          //  [ 0,  -sin,    cos  ]
                            reg_c <= ZERO;
                            reg_d <= ZERO;
                            reg_e <= reg_cos;
                            reg_f <= reg_sin;
                            reg_g <= ZERO;
                            reg_h <= reg_neg_sin;
                            reg_i <= reg_cos;
                        end
 
                        ROT_Y_CCW: begin            //  [ cos,   0,   sin  ]
                            reg_a <= reg_cos;       //  [  0,    1,    0   ]
                            reg_b <= ZERO;          //  [-sin,   0,   cos  ]
                            reg_c <= reg_sin;
                            reg_d <= ZERO;
                            reg_e <= ONE;
                            reg_f <= ZERO;
                            reg_g <= reg_neg_sin;
                            reg_h <= ZERO;
                            reg_i <= reg_cos;
                        end
 
                        ROT_Y_CW: begin             //  [ cos,   0,  -sin  ]
                            reg_a <= reg_cos;       //  [  0,    1,    0   ]
                            reg_b <= ZERO;          //  [ sin,   0,   cos  ]
                            reg_c <= reg_neg_sin;
                            reg_d <= ZERO;
                            reg_e <= ONE;
                            reg_f <= ZERO;
                            reg_g <= reg_sin;
                            reg_h <= ZERO;
                            reg_i <= reg_cos;
                        end
 
                        ROT_Z_CCW: begin            //  [ cos,  -sin,   0  ]
                            reg_a <= reg_cos;       //  [ sin,   cos,   0  ]
                            reg_b <= reg_neg_sin;   //  [  0,     0,    1  ]
                            reg_c <= ZERO;
                            reg_d <= reg_sin;
                            reg_e <= reg_cos;
                            reg_f <= ZERO;
                            reg_g <= ZERO;
                            reg_h <= ZERO;
                            reg_i <= ONE;
                        end
 
                        ROT_Z_CW: begin             //  [ cos,   sin,   0  ]
                            reg_a <= reg_cos;       //  [-sin,   cos,   0  ]
                            reg_b <= reg_sin;       //  [  0,     0,    1  ]
                            reg_c <= ZERO;
                            reg_d <= reg_neg_sin;
                            reg_e <= reg_cos;
                            reg_f <= ZERO;
                            reg_g <= ZERO;
                            reg_h <= ZERO;
                            reg_i <= ONE;
                        end
 
                        default: begin              // Scenariu invalid: matrice identitate
                            reg_a <= ONE;  reg_b <= ZERO; reg_c <= ZERO;
                            reg_d <= ZERO; reg_e <= ONE;  reg_f <= ZERO;
                            reg_g <= ZERO; reg_h <= ZERO; reg_i <= ONE;
                        end
 
                    endcase

                end
                
                // Multiplicatoarele isi inregistreaza rezultatele in acest ciclu.
                // Rezultatele vor fi disponibile pe wire-uri la inceputul lui DONE_MULT.
                CALC_MULT: begin
                    // (nimic - submodulele lucreaza autonom)
                end
                
                WAIT_MULT: begin
                end

                                // Captura rezultatele celor 9 multiplicatoare in registrele de pipeline.
                DONE_MULT: begin
                    reg_ax <= mult_ax_result;
                    reg_by <= mult_by_result;
                    reg_cz <= mult_cz_result;
 
                    reg_dx <= mult_dx_result;
                    reg_ey <= mult_ey_result;
                    reg_fz <= mult_fz_result;
 
                    reg_gx <= mult_gx_result;
                    reg_hy <= mult_hy_result;
                    reg_iz <= mult_iz_result;
    
                    ovf_mult <= ovf_ax | ovf_by | ovf_cz |
                                ovf_dx | ovf_ey | ovf_fz |
                                ovf_gx | ovf_hy | ovf_iz;
                end
 
                // Sumatoarele primei etape isi inregistreaza rezultatele in acest ciclu.
                CALC_SUM_FIRST: begin
                    // (nimic - submodulele lucreaza autonom)
                end
 
                // Captura sumele partiale (ax+by), (dx+ey), (gx+hy).
                // Termenii cz, fz, iz sunt deja stabili in reg_cz, reg_fz, reg_iz.
                DONE_SUM_FIRST: begin
                    reg_ax_by <= sum_ax_by_result;
                    reg_dx_ey <= sum_dx_ey_result;
                    reg_gx_hy <= sum_gx_hy_result;

                    ovf_add_first <= ovf_ax_by | ovf_dx_ey | ovf_gx_hy;
                end
 
                // Sumatoarele finale isi inregistreaza rezultatele in acest ciclu.
                CALC_SUM_FINAL: begin
                    // (nimic - submodulele lucreaza autonom)
                end
 
                // Captura rezultatele finale si semnaleaza terminarea calculului.
                DONE: begin
                    xr <= res_xr;
                    yr <= res_yr;
                    zr <= res_zr;
                    overflow <= ovf_mult | ovf_add_first |
                                ovf_xr    | ovf_yr    | ovf_zr;
                    valid <= 1'b1;
                end
            endcase
        end
    end

endmodule // rotation
