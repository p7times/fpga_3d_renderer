//---------------------------------------------------------------
// Proiect    : Grafica 3D implementata pe FPGA
//
// Autor      : Petru-Andrei BRASOVEANU 
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Vertex Processing Unit (VPU), sau Unitate de Procesare Vertex-uri
//              Aceasta proceseaza calculele geometrice Rotatie - Proiectie - Mapare pe Ecran
//
//              Reprezentare numerica: virgula fixa semnata (signed fixed-point)
//---------------------------------------------------------------

module vpu_q #(
    parameter INT_BITS  = 16,                             // Numar de biti parte intreaga (include semnul) 
    parameter FRAC_BITS = 16                              // Numar de biti parte fractionara
)(
    input                               clk,              // Semnal de ceas
    input                               rst_n,            // Reset asincron (activ in 0)
    input                               start,            // Pornire proces conversie
    
    input      [2:0]                    rotation,         // Flag selectare tip de rotatie
    input      [9:0]                    angle,            // Unghiul de rotatie

    input      [INT_BITS+FRAC_BITS-1:0] f, x, y, z, w, h, cam_z, // Datele de intrare (NDC + dimensiuni ecran)

    output reg [INT_BITS+FRAC_BITS-1:0] xs, ys,           // Datele de iesire (coordonate ecran)
    output reg                          valid,            // Flag finalizare conversie
    output reg                          overflow,         // Indicator depasire domeniu numeric (DEBUG)
    output     [3:0]                    dbg_state         // Flag stare FSM (DEBUG)
);

    localparam WIDTH = INT_BITS + FRAC_BITS;

    // ------------------------
    // Definitie stari FSM
    // ------------------------

    localparam IDLE       = 4'b0000,   // Asteapta semnalul de start
               LOAD       = 4'b0001,   // Incarca datele de intrare in registrele interne
               START_ROT  = 4'b0010,
               CALC_ROT   = 4'b0011,   // Se calculeaza etapa de rotatie
               DONE_ROT   = 4'b0100,   // Salvare rezultate rotatie
               START_PROJ = 4'b0101,
               CALC_PROJ  = 4'b0110,   // Se calculeaza etapa de proiectie
               DONE_PROJ  = 4'b0111,   // Salvare rezultate proiectie
               START_NDC  = 4'b1000,
               CALC_NDC   = 4'b1001,   // Se calculeaza etapa de mapare pe ecran
               DONE       = 4'b1010;   // Rezultate finale valide

    reg [3:0] state, next_state;
    assign dbg_state = state;


    // ------------------------
    // Registrele interne ptr pipeline
    // ------------------------
    
    // Registre de intrare
    reg [WIDTH-1:0] reg_x, reg_y, reg_z, reg_f, reg_w, reg_h, reg_cam_z;
    reg [9:0] reg_angle;
    reg [2:0] reg_rotation;

    // Registre intermediare
    reg [WIDTH-1:0] reg_xr, reg_yr, reg_zr; // Dupa rotatie
    reg [WIDTH-1:0] reg_xp, reg_yp;         // Dupa proiectie

    reg ovf_rot_r, ovf_proj_r;  // Acumulatoare overflow intermediare

    
    // ------------------------
    // Semnale interfata submodule aritmetice
    // ------------------------ 
    
    reg rot_start, proj_start, ndc_start;     // Pulsuri de start (1 ciclu)
    wire rot_valid, proj_valid, ndc_valid;    // Semnale rezultat valid
    
    // Iesiri wire din submodule
    wire [WIDTH-1:0] xr_w, yr_w, zr_w;
    wire [WIDTH-1:0] xp_w, yp_w;
    wire [WIDTH-1:0] xs_w, ys_w;

    wire ovf_rot_w, ovf_proj_w, ovf_ndc_w; // Semnale overflow din submodule (DEBUG)

    


    // ------------------------
    // Instantiere submodule aritmetice
    // ------------------------

    // Submodul pentru calcul rotatie
    rotation_q #(
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_rotation_q (
        .clk(clk),
        .rst_n(rst_n),
        .start(rot_start),
        .rotation(reg_rotation),
        .x(reg_x), .y(reg_y), .z(reg_z),
        .angle(reg_angle),
        .xr(xr_w), .yr(yr_w), .zr(zr_w),
        .valid(rot_valid),
        .overflow(ovf_rot_w),
        .dbg_state()
    );

    // Submodul pentru calcul proiectie
    proj_q #(
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_proj_q (
        .clk(clk),
        .rst_n(rst_n),
        .start(proj_start),
        .f(reg_f), .x(reg_xr), .y(reg_yr), .z(reg_zr),
        .xp(xp_w), .yp(yp_w),
        .valid(proj_valid),
        .overflow(ovf_proj_w),
        .dbg_state()
    );

    // Submodul pentru calcul mapare pe ecran
    ndc_to_screen_q #(
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_ndc_to_screen_q (
        .clk(clk),
        .rst_n(rst_n),
        .start(ndc_start),
        .xp(reg_xp), .yp(reg_yp), .w(reg_w), .h(reg_h),
        .xs(xs_w), .ys(ys_w),
        .valid(ndc_valid),
        .overflow(ovf_ndc_w),
        .dbg_state()
    );


    // ------------------------
    // Logica FSM - Calea de control
    // ------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= IDLE;
        else        state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE:       next_state = start ? LOAD : IDLE; 
            LOAD:       next_state = START_ROT;   
            START_ROT:  next_state = CALC_ROT;        
            CALC_ROT:   next_state = rot_valid ? DONE_ROT : CALC_ROT;           
            DONE_ROT:   next_state = START_PROJ;
            START_PROJ: next_state = CALC_PROJ; 
            CALC_PROJ:  next_state = proj_valid ? DONE_PROJ : CALC_PROJ;       
            DONE_PROJ:  next_state = START_NDC;
            START_NDC:  next_state = CALC_NDC;
            CALC_NDC:   next_state = ndc_valid ? DONE : CALC_NDC;                
            DONE:       next_state = IDLE;                 
            default:    next_state = IDLE;
        endcase
    end


    // ------------------------
    // Logica FSM - Calea de date
    // ------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset complet registre interne si iesiri

            reg_x        <= 0; reg_y    <= 0; reg_z  <= 0;
            reg_f        <= 0; reg_w    <= 0; reg_h  <= 0;
            reg_angle    <= 0; reg_rotation <= 0;
            reg_cam_z    <= 0;
            reg_xr       <= 0; reg_yr  <= 0; reg_zr <= 0;
            reg_xp       <= 0; reg_yp  <= 0;

            ovf_rot_r    <= 0; ovf_proj_r <= 0;

            xs          <= 0;       
            ys          <= 0;

            rot_start   <= 1'b0;
            proj_start  <= 1'b0;
            ndc_start   <= 1'b0;

            valid       <= 1'b0;
            overflow    <= 1'b0;
        end else begin

            case (state)

                // Asteapta semnalul de start
                IDLE: begin
                    valid      <= 1'b0;  // Valid este 1 doar in DONE
                    rot_start  <= 1'b0;
                    proj_start <= 1'b0;
                    ndc_start  <= 1'b0;
                end

                // Incarca datele de intrare in registre
                LOAD: begin
                    reg_x        <= x;
                    reg_y        <= y;
                    reg_z        <= z;
                    reg_f        <= f;
                    reg_w        <= w;
                    reg_h        <= h;
                    reg_angle    <= angle;
                    reg_rotation <= rotation;   
                    reg_cam_z    <= cam_z;                
                end
                
                START_ROT: begin
                    rot_start    <= 1'b1;   // Puls 1 ciclu catre rotation_q
                end

                CALC_ROT: begin
                    rot_start    <= 1'b0;   // ptr a nu porni accidental submodulul din nou
                end
                
                DONE_ROT: begin
                    reg_xr     <= xr_w;
                    reg_yr     <= yr_w;
                    reg_zr     <= zr_w + reg_cam_z; // translatie camera pe Z
                    ovf_rot_r  <= ovf_rot_w;
                end

                START_PROJ: begin
                    proj_start <= 1'b1;     // Puls 1 ciclu catre proj_q
                end

                CALC_PROJ: begin
                    proj_start <= 1'b0;     // ptr a nu porni accidental submodulul din nou
                end

                DONE_PROJ: begin
                    reg_xp      <= xp_w;
                    reg_yp      <= yp_w;
                    ovf_proj_r  <= ovf_proj_w;
                end
                
                START_NDC: begin
                    ndc_start   <= 1'b1;    // Puls 1 ciclu catre ndc_to_screen_q
                end
                

                CALC_NDC: begin
                    ndc_start   <= 1'b0;    // ptr a nu porni accidental submodulul din nou
                end
    
                // Rezultat final disponibil
                DONE: begin 
                    xs       <= xs_w;
                    ys       <= ys_w;

                    overflow <= ovf_rot_r | ovf_proj_r | ovf_ndc_w;
                    valid <= 1'b1; 
                end
            endcase
        end
    end

endmodule
