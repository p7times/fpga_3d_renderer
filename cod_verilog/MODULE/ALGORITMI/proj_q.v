//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : proj_q
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Modul de Proiectie Perspectiva (Perspective Projection)
//
//              Calculeaza coordonatele xp si yp in spatiul NDC:
//                  xp = x * (f / z)
//                  yp = y * (f / z)
//
//              Reprezentare numerica: virgula fixa semnata (signed fixed-point)
//---------------------------------------------------------------

module proj_q #(
    parameter INT_BITS  = 16,                       // Numar de biti parte intreaga (include semnul) 
    parameter FRAC_BITS = 16                        // Numar de biti parte fractionara
)(
    input                               clk,        // Semnal de ceas
    input                               rst_n,      // Reset asincron (activ in 0)
    input                               start,      // Pornire calcul proiectie
    input      [INT_BITS+FRAC_BITS-1:0] f, x, y, z, // Datele de intrare (distanta focala + coordonate 3D)
    output reg [INT_BITS+FRAC_BITS-1:0] xp, yp,     // Datele de iesire (coordonatele 2D proiectate)
    output reg                          valid,      // Flag finalizare conversie
    output reg                          overflow,   // Indicator depasire domeniu numeric (DEBUG)
    output [2:0]                        dbg_state   // Flag stare FSM (DEBUG)
);

    localparam WIDTH = INT_BITS + FRAC_BITS;

    // ------------------------
    // Definitie stari FSM
    // ------------------------

    localparam IDLE      = 3'b000,  // Asteapta semnalul de start
               LOAD      = 3'b001,  // Incarca datele in registrele interne
               START_DIV = 3'b010,  // Trimite puls de start catre divizor
               CALC_DIV  = 3'b011,  // Asteapta rezultatul divizorului (f/z)
               DONE_DIV  = 3'b100,  // Salveaza rezultatul divizarii
               CALC_PROJ = 3'b101,  // Asteapta rezultatul multiplicarilor (f/z)*x si (f/z)*y
               DONE      = 3'b110;  // Rezultate finale valide

    reg [2:0] state, next_state;
    assign dbg_state = state;


    // ------------------------
    // Registrele interne ptr pipeline
    // ------------------------

    reg [WIDTH-1:0] reg_f, reg_x, reg_y, reg_z;  // Datele de intrare
    reg [WIDTH-1:0] reg_fz;                      // Rezultat intermediar f/z


    // ------------------------
    // Interfata divizor
    // ------------------------

    reg              div_start;     // Puls de start (1 ciclu)
    wire [WIDTH-1:0] div_result;    // Rezultat impartire
    wire             div_valid;     // Semnal rezultat valid
    
    
    // ------------------------
    // Interfata multiplicatoare
    // ------------------------

    // mult_xp : (f/z) * x
    // mult_yp : (f/z) * y
    wire [WIDTH-1:0] mult_xp_result, mult_yp_result;
    wire             ovf_xp, ovf_yp;   // Flaguri overflow (DEBUG)


    // ------------------------
    // Instantiere submodule aritmetice
    // ------------------------

    // Divizor pentru raport distanta focala-profunzime Z
    div_top_level_q #(
        .INT_BITS (INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_div (
        .clk     (clk),
        .rst_n   (rst_n),
        .start   (div_start),
        .op1     (reg_f),
        .op2     (reg_z),
        .rezultat(div_result),
        .valid   (div_valid)
    );

    // Multiplicator axa X: xp = (f/z) * x
    mult_q #(
        .INT_BITS (INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_mult_xp (
        .clk     (clk),
        .rst_n   (rst_n),
        .a       (reg_fz),
        .b       (reg_x),
        .overflow(ovf_xp),
        .result  (mult_xp_result)
    );

    // Multiplicator axa Y: = (f/z) * y
    mult_q #(
        .INT_BITS (INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_mult_yp (
        .clk     (clk),
        .rst_n   (rst_n),
        .a       (reg_fz),
        .b       (reg_y),
        .overflow(ovf_yp),
        .result  (mult_yp_result)
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
            IDLE:      next_state = start ? LOAD : IDLE;               
            LOAD:      next_state = START_DIV;                         
            START_DIV: next_state = CALC_DIV;                          
            CALC_DIV:  next_state = div_valid ? DONE_DIV : CALC_DIV;    
            DONE_DIV:  next_state = CALC_PROJ;
            CALC_PROJ: next_state = DONE;                          
            DONE:      next_state = IDLE;                         
            default:   next_state = IDLE;
        endcase
    end


    // ------------------------
    // Logica FSM - Calea de date
    // ------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset complet registre interne si iesiri

            reg_f     <= 0;
            reg_x     <= 0;
            reg_y     <= 0;
            reg_z     <= 0;

            reg_fz    <= 0;
            
            xp        <= 0;
            yp        <= 0;
            
            div_start <= 1'b0;
            valid     <= 1'b0;
            overflow  <= 1'b0;
        end else begin
            
            case (state)

                // Asteapta semnalul de start
                IDLE: begin
                   div_start <= 1'b0;  // Divizorul ramane oprit
                   valid     <= 1'b0;  // Valid este 1 doar in DONE
                end

                // Incarca datele de intrare in registre
                LOAD: begin
                    reg_f  <= f;
                    reg_x  <= x;
                    reg_y  <= y;
                    reg_z  <= z;
                end
                
                // Pornim divizorul (puls de 1 ciclu)
                START_DIV: begin
                    div_start <= 1'b1;
                end

                // Asteptam rezultatul divizorului
                CALC_DIV: begin
                    div_start <= 1'b0; // ptr a nu porni accidental dividerul din nou
                end
                
                // Stocare rezultat divizor
                DONE_DIV: begin
                    reg_fz <= div_result;
                end

                // Stare de asteptare pentru latenta multiplicatoarelor
                CALC_PROJ: begin
                end

                // Rezultat final disponibil
                DONE: begin
                    xp       <= mult_xp_result;
                    yp       <= mult_yp_result;
                    overflow <= ovf_xp | ovf_yp;
                    valid    <= 1'b1;
                end
            endcase
        end
    end

endmodule
