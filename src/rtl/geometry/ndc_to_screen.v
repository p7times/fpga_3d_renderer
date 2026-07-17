//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : ndc_to_screen
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Convertor coordonate NDC (Normalized Device
//              Coordinates) in coordonate ecran (Screen Space).
//
//              Modulul realizeaza maparea coordonatelor proiectate
//              in spatiul ecran utilizand aritmetica fixed-point
//              semnata si o arhitectura secventiala bazata pe FSM.
//
//              Transformari efectuate:
//                  xs = (xp * h + w) / 2
//                  ys = (h - yp * h) / 2
//
//              Functionalitati:
//                - conversie NDC -> Screen Space
//                - inversare axa Y pentru coordonate ecran
//                - detectie overflow numeric
//                - pipeline secvential pentru operatii aritmetice
//
//              Reprezentare numerica:
//                signed fixed-point Q(INT_BITS).(FRAC_BITS)
//---------------------------------------------------------------

`timescale 1ns / 1ps

module ndc_to_screen #(
    parameter INT_BITS  = 16,                           // Numar de biti parte intreaga (include semnul) 
    parameter FRAC_BITS = 16,                           // Numar de biti parte fractionara
    parameter DATA_WIDTH = INT_BITS + FRAC_BITS         // Latime date, biti
)(
    input                               clk,            // Semnal de ceas
    input                               rst_n,          // Reset asincron (activ in 0)
    input                               start,          // Pornire proces conversie
    input      [DATA_WIDTH-1:0]         xp, yp, w, h,   // Datele de intrare (NDC + dimensiuni ecran)
    output reg [DATA_WIDTH-1:0]         xs, ys,         // Datele de iesire (coordonate ecran)
    output reg                          valid,          // Flag finalizare conversie
    output reg                          overflow,       // Indicator depasire domeniu numeric (DEBUG)
    output     [3:0]                    dbg_state       // Flag stare FSM (DEBUG)
);

    // ------------------------
    // Definitie stari FSM
    // ------------------------

    localparam IDLE         = 4'b0000,   // Asteapta semnalul de start
               LOAD         = 4'b0001,   // Incarca datele de intrare in registrele interne
               START_MULT   = 4'b0010,   // Etapa de multiplicare (xp*h, yp*h)
               WAIT_MULT    = 4'b0011,   // Asteapta rezultatele iterative
               DONE_MULT    = 4'b0100,   // Salvare rezultate multiplicare
               ADD_SUB      = 4'b0101,   // Etapa de adunare/scadere (translatie)
               DONE_ADD_SUB = 4'b0110,   // Salvare rezultate adunare/scadere
               SHIFT_RIGHT  = 4'b0111,   // Impartire la 2 prin deplasare bit cu bit
               DONE         = 4'b1000;   // Rezultate finale valide

    reg [3:0] state, next_state;
    assign dbg_state = state;


    // ------------------------
    // Registrele interne ptr pipeline
    // ------------------------

    reg [DATA_WIDTH-1:0] reg_xp, reg_yp;     // Coordonate NDC
    reg [DATA_WIDTH-1:0] reg_w, reg_h;       // Dimensiuni ecran

    reg [DATA_WIDTH-1:0] reg_xph, reg_yph;   // Rezultate multiplicare
    reg [DATA_WIDTH-1:0] reg_add;            // Rezultat intermediar: (xp * h) + w
    reg [DATA_WIDTH-1:0] reg_sub;            // Rezultat intermediar: h - (yp * h)


    // ------------------------
    // Semnale interfata submodule aritmetice
    // ------------------------

    reg                   mult_start;        // Semnal start pentru inmultitoare
    wire                  mult_xp_valid;     // Validare inmultitor X
    wire                  mult_yp_valid;     // Validare inmultitor Y
    
    wire [DATA_WIDTH-1:0] mult_xph_result;  
    wire [DATA_WIDTH-1:0] mult_yph_result;  
    wire [DATA_WIDTH-1:0] add_result;   
    wire [DATA_WIDTH-1:0] sub_result;  
    
    wire ovf_add, ovf_sub, ovf_mult_xp, ovf_mult_yp; // Semnale overflow din submodule (DEBUG)
    reg  ovf_mult, ovf_add_sub;                      // Acumulatoare overflow intermediare


    // ------------------------
    // Instantiere submodule aritmetice
    // ------------------------

    // Multiplicator iterativ pentru axa X: xp * h
    mult_top_level_q #(
        .INT_BITS (INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_mult_xp (
        .clk     (clk),
        .rst_n   (rst_n),
        .start   (mult_start),
        .a       (reg_xp), 
        .b       (reg_h),    
        .overflow(ovf_mult_xp),
        .product (mult_xph_result),
        .valid   (mult_xp_valid)
    );

    // Multiplicator iterativ pentru axa Y: yp * h
    mult_top_level_q #(
        .INT_BITS (INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_mult_yp (
        .clk     (clk),
        .rst_n   (rst_n),
        .start   (mult_start),
        .a       (reg_yp),
        .b       (reg_h),
        .overflow(ovf_mult_yp),
        .product (mult_yph_result),
        .valid   (mult_yp_valid)
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
            LOAD:         next_state = START_MULT;          
            START_MULT:   next_state = WAIT_MULT;
            WAIT_MULT:    next_state = (mult_xp_valid & mult_yp_valid) ? DONE_MULT : WAIT_MULT;         
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
            
            mult_start  <= 1'b0;
            valid       <= 1'b0;
            overflow    <= 1'b0;
        end else begin

            case (state)

                // Asteapta semnalul de start
                IDLE: begin
                    mult_start  <= 1'b0;
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
                START_MULT: begin
                    mult_start <= 1'b1; // Trigger ambele inmultitoare
                end
                
                WAIT_MULT: begin
                    mult_start <= 1'b0; // Coboram pulsul in ciclul urmator
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

endmodule // ndc_to_screen
