module ndc_to_screen_q #(
    parameter INT_BITS  = 16,
    parameter FRAC_BITS = 16
)(
    input                               clk,
    input                               rst_n,
    input                               start,
    input      [INT_BITS+FRAC_BITS-1:0] xp, yp, w, h,
    output reg [INT_BITS+FRAC_BITS-1:0] xs, ys,
    output reg                          valid,
    output reg                          overflow,
    output [2:0]                        dbg_state
);

    localparam WIDTH = INT_BITS + FRAC_BITS;

    // Stari FSM
    localparam IDLE         = 3'b000,    // Asteapta semnalul de start
               LOAD         = 3'b001,    // Incarca datele in registrele interne
               CALC_MULT    = 3'b010,    // Calculeaza xp * h si yp * h
               DONE_MULT    = 3'b011,
               ADD_SUB      = 3'b100,    // Calculeaza adunarea/scaderea cu h sau cu w
               DONE_ADD_SUB = 3'b101,
               SHIFT_RIGHT  = 3'b110,    // Impartire la 2, tratata ca arithmetic shift right cu 1 pozitie
               DONE         = 3'b111;    // Pune rezultatele pe iesire

    reg [2:0] state, next_state;
    assign dbg_state = state;

    // Registrele interne ptr valorile de intrare
    reg [WIDTH-1:0] reg_xp, reg_yp, reg_w, reg_h;
    reg [WIDTH-1:0] reg_xph, reg_yph;          // rezultat intermediar xp * h si yp * h dupa CALC_MULT
    reg [WIDTH-1:0] reg_add;                   // rezultat intermediar (xp * h) + w
    reg [WIDTH-1:0] reg_sub;                   // rezultat intermediar h - (yp * h)

    // Outputuri multiplicare
    wire [WIDTH-1:0] mult_xph_result;   // xp * h
    wire [WIDTH-1:0] mult_yph_result;   // yp * h
    wire [WIDTH-1:0] add_result;   
    wire [WIDTH-1:0] sub_result;  
    
    
    wire ovf_add, ovf_sub;             // flaguri overflow (ignorate / debug)
    wire ovf_mult_xp, ovf_mult_yp;

    // Acumulator overflow
    reg ovf_mult;
    reg ovf_add_sub;


    // Instantiere multiplicator xp * h
    mult_q #(
        .INT_BITS (INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_mult_xp (
        .clk     (clk),
        .rst_n   (rst_n),
        .a       (reg_xp),      // incarcat in starea LOAD
        .b       (reg_h),       // incarcat in starea LOAD
        .overflow(ovf_mult_xp),
        .result  (mult_xph_result)
    );

    // Instantiere multiplicator yp * h
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

    // Instantiere sumator (xp * h) + w
    add_q #(
        .INT_BITS (INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_add (
        .clk     (clk),
        .rst_n   (rst_n),
        .a       (reg_xph),     // xp * h, capturat in ADD_SUB
        .b       (reg_w),
        .overflow(ovf_add),
        .sum     (add_result)
    );

    // Instantiere diferenta  h- (yp * h)
    sub_q #(
        .INT_BITS (INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) u_sub (
        .clk     (clk),
        .rst_n   (rst_n),
        .a       (reg_h),       // valoarea h, constanta
        .b       (reg_yph),     // yp * h, capturata in ADD_SUB
        .overflow(ovf_sub),
        .dif     (sub_result)
    );

    // Registru de stare FSM
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end


    // Logica de tranzitie intre stari
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:        next_state = start ? LOAD : IDLE;  // asteapta start
            LOAD:        next_state = CALC_MULT;            // dupa incarcare pornim multiplicarea
            CALC_MULT:   next_state = DONE_MULT;              // registrele mult se actualizeaza 
            DONE_MULT:   next_state = ADD_SUB;
            ADD_SUB:     next_state = DONE_ADD_SUB;          // adunare/scadere aici
            DONE_ADD_SUB: next_state = SHIFT_RIGHT;
            SHIFT_RIGHT: next_state = DONE;                 // dupa care, >>>1
            DONE:        next_state = IDLE;                 // operatia s-a efectuat, revine in IDLE
            default:   
                next_state = IDLE;
        endcase
    end

    // Logica secventiala cale de date:
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset general
            reg_xp      <= 0;
            reg_yp      <= 0;
            reg_w       <= 0;
            reg_h       <= 0;
            reg_xph     <= 0;
            reg_yph     <= 0;
            reg_add     <= 0;
            reg_sub     <= 0;
            ovf_mult    <= 0;
            ovf_add_sub <= 0;
            xs          <= 0;
            ys          <= 0;
            valid       <= 1'b0;
            overflow    <= 1'b0;
        end else begin
            // valori default
            valid     <= 1'b0;  // valid este 1 doar in DONE

            case (state)

                // 1. asteapta start
                IDLE: begin
                    // nu se intampla nimic
                end

                // 2. incarca datele de intrare in registre
                LOAD: begin
                    reg_xp <= xp;
                    reg_yp <= yp;
                    reg_w  <= w;
                    reg_h  <= h;
                end
                
                // 3. mult_q vor efectua operatiile ptr reg_xp/reg_yp
                CALC_MULT: begin
                    // se efectueaza multiplicarea pe frontul pozitiv
                end
                
                DONE_MULT: begin
                    reg_xph <= mult_xph_result; // ptr add_q
                    reg_yph <= mult_yph_result; // ptr sub_q
                    ovf_mult <= ovf_mult_xp | ovf_mult_yp;
                end

                // 4. efectuam adunare si scadere
                ADD_SUB: begin
                end

                DONE_ADD_SUB: begin
                    reg_add <= add_result;
                    reg_sub <= sub_result;
                    ovf_add_sub <= ovf_add | ovf_sub;
                end
                
                // 5. impartirea la 2 este echivalent cu shiftare aritmetica la dreapta cu 1
                SHIFT_RIGHT: begin
                    xs <= $signed(reg_add) >>> 1;
                    ys <= $signed(reg_sub) >>> 1;
                end

                // 6. scrie rezultatele finale
                DONE: begin
                    overflow <= ovf_mult | ovf_add_sub; // shiftarea la dreapta nu poate da overflow, deci
                    // doar flag-urile mult/add/sub conteaza

                    valid <= 1'b1;  // semnal ca rezultatul e valid (1 ciclu)
                end
            endcase
        end
    end

endmodule
