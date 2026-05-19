//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : ndc_to_screen_q
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Convertor coordonate NDC (Normalized Device Coordinates) la coordonate ecran (Screen Space).
//
//              Transformari efectuate:
//                  xs = (xp * h + w) / 2
//                  ys = (h - yp * h) / 2
//
//              Reprezentare numerica: virgula fixa semnata (signed fixed-point)
//---------------------------------------------------------------

module ndc_to_screen_q #(
    parameter INT_BITS  = 16,                           // Numar de biti parte intreaga (include semnul) 
    parameter FRAC_BITS = 16                            // Numar de biti parte fractionara
)(
    input                               clk,            // Semnal de ceas
    input                               rst_n,          // Reset asincron (activ in 0)
    input                               start,          // Pornire proces conversie
    input      [INT_BITS+FRAC_BITS-1:0] xp, yp, w, h,   // Datele de intrare (NDC + dimensiuni ecran)
    output reg [INT_BITS+FRAC_BITS-1:0] xs, ys,         // Datele de iesire (coordonate ecran)
    output reg                          valid,          // Flag finalizare conversie
    output reg                          overflow,       // Indicator depasire domeniu numeric (DEBUG)
    output [2:0]                        dbg_state       // Flag stare FSM (DEBUG)
);

    localparam WIDTH = INT_BITS + FRAC_BITS;

    // ------------------------
    // Definitie stari FSM
    // ------------------------

    localparam IDLE         = 3'b000,   // Asteapta semnalul de start
               LOAD         = 3'b001,   // Incarca datele de intrare in registrele interne
               CALC_MULT    = 3'b010,   // Etapa de multiplicare (xp*h, yp*h)
               DONE_MULT    = 3'b011,   // Salvare rezultate multiplicare
               ADD_SUB      = 3'b100,   // Etapa de adunare/scadere (translatie)
               DONE_ADD_SUB = 3'b101,   // Salvare rezultate adunare/scadere
               SHIFT_RIGHT  = 3'b110,   // Impartire la 2 prin deplasare bit cu bit
               DONE         = 3'b111;   // Rezultate finale valide

    reg [2:0] state, next_state;
    assign dbg_state = state;


    // ------------------------
    // Registrele interne ptr pipeline
    // ------------------------

    reg [WIDTH-1:0] reg_xp, reg_yp;     // Coordonate NDC
    reg [WIDTH-1:0] reg_w, reg_h;       // Dimensiuni ecran

    reg [WIDTH-1:0] reg_xph, reg_yph;   // Rezultate multiplicare
    reg [WIDTH-1:0] reg_add;            // Rezultat intermediar: (xp * h) + w
    reg [WIDTH-1:0] reg_sub;            // Rezultat intermediar: h - (yp * h)


    // ------------------------
    // Semnale interfata submodule aritmetice
    // ------------------------

    wire [WIDTH-1:0] mult_xph_result;  
    wire [WIDTH-1:0] mult_yph_result;  
    wire [WIDTH-1:0] add_result;   
    wire [WIDTH-1:0] sub_result;  
    
    wire ovf_add, ovf_sub, ovf_mult_xp, ovf_mult_yp; // Semnale overflow din submodule (DEBUG)
    reg ovf_mult, ovf_add_sub;                       // Acumulatoare overflow intermediare


    // ------------------------
    // Instantiere submodule aritmetice
    // ------------------------

    // Multiplicator pentru axa X: xp * h
    mult_q #(
        .INT_BITS (INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_mult_xp (
        .clk     (clk),
        .rst_n   (rst_n),
        .a       (reg_xp), 
        .b       (reg_h),    
        .overflow(ovf_mult_xp),
        .result  (mult_xph_result)
    );

    // Multiplicator pentru axa Y: yp * h
    mult_q #(
        .INT_BITS (INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_mult_yp (
        .clk     (clk),
        .rst_n   (rst_n),
        .a       (reg_yp),
        .b       (reg_h),
        .overflow(ovf_mult_yp),
        .result  (mult_yph_result)
    );

    // Sumator pentru X: (xp * h) + w
    add_q #(
        .INT_BITS (INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_add (
        .clk     (clk),
        .rst_n   (rst_n),
        .a       (reg_xph),
        .b       (reg_w),
        .overflow(ovf_add),
        .sum     (add_result)
    );

    // Diferenta pentru Y: h - (yp * h): Inversare axa Y (ecran vs cartesian)
    sub_q #(
        .INT_BITS (INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_sub (
        .clk     (clk),
        .rst_n   (rst_n),
        .a       (reg_h),     
        .b       (reg_yph),  
        .overflow(ovf_sub),
        .dif     (sub_result)
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
            IDLE:         next_state = start ? LOAD : IDLE; 
            LOAD:         next_state = CALC_MULT;          
            CALC_MULT:    next_state = DONE_MULT;           
            DONE_MULT:    next_state = ADD_SUB;
            ADD_SUB:      next_state = DONE_ADD_SUB;       
            DONE_ADD_SUB: next_state = SHIFT_RIGHT;
            SHIFT_RIGHT:  next_state = DONE;                
            DONE:         next_state = IDLE;                 
            default:      next_state = IDLE;
        endcase
    end


    // ------------------------
    // Logica FSM - Calea de date
    // ------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset complet registre interne si iesiri

            reg_xp      <= 0;     
            reg_yp      <= 0;
            reg_w       <= 0;
            reg_h       <= 0;

            reg_xph     <= 0;      
            reg_yph     <= 0;
            reg_add     <= 0;
            reg_sub     <= 0;

            xs          <= 0;       
            ys          <= 0;

            ovf_mult    <= 0;      
            ovf_add_sub <= 0;

            valid       <= 1'b0;
            overflow    <= 1'b0;
        end else begin

            case (state)

                // Asteapta semnalul de start
                IDLE: begin
                    valid     <= 1'b0;  // Valid este 1 doar in DONE
                end

                // Incarca datele de intrare in registre
                LOAD: begin
                    reg_xp <= xp;
                    reg_yp <= yp;
                    reg_w  <= w;
                    reg_h  <= h;
                end
                
                // Multiplicarea este efectuata in modulele dedicate
                CALC_MULT: begin
                end
                
                // Salveaza rezultate multiplicare
                DONE_MULT: begin
                    reg_xph <= mult_xph_result; 
                    reg_yph <= mult_yph_result;
                    ovf_mult <= ovf_mult_xp | ovf_mult_yp;
                end

                // Adunare si scadere (in modulele dedicate)
                ADD_SUB: begin
                end

                // Salveaza rezultate adunare/scadere
                DONE_ADD_SUB: begin
                    reg_add <= add_result;
                    reg_sub <= sub_result;
                    ovf_add_sub <= ovf_add | ovf_sub;
                end
                
                // Scalare finala: impartire la 2 (shift aritmetic)
                SHIFT_RIGHT: begin
                    xs <= $signed(reg_add) >>> 1;
                    ys <= $signed(reg_sub) >>> 1;
                end
    
                // Rezultat final disponibil
                DONE: begin
                    overflow <= ovf_mult | ovf_add_sub;
                    valid <= 1'b1; 
                end
            endcase
        end
    end

endmodule
