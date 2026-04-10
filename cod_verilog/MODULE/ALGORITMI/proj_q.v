module proj_q #(
    parameter INT_BITS  = 16,
    parameter FRAC_BITS = 16
)(
    input                               clk,
    input                               rst_n,
    input                               start,
    input  [INT_BITS+FRAC_BITS-1:0]     f, x, y, z,
    output reg [INT_BITS+FRAC_BITS-1:0] xp, yp,
    output reg                          valid,
    output reg                          overflow,
    output [2:0]                        dbg_state
);

    localparam WIDTH = INT_BITS + FRAC_BITS;

    // Stari FSM
    localparam IDLE      = 3'b000,    // Asteapta semnalul de start
               LOAD      = 3'b001,    // Incarca datele in registrele interne
               START_DIV = 3'b010,    // Trimite puls de start catre divizor
               CALC_DIV  = 3'b011,    // Asteapta finalizarea impartirii f/z
               DONE_DIV  = 3'b100,
               CALC_PROJ = 3'b101,    // Asteapta rezultatul multiplicarii (1 ciclu)
               DONE      = 3'b110;    // Pune rezultatele pe iesire

    reg [2:0] state, next_state;

    // Registrele interne ce retin valorile de intrare
    reg [WIDTH-1:0] reg_f, reg_x, reg_y, reg_z;
    reg [WIDTH-1:0] reg_fz;          // rezultat intermediar f/z

    // Interfata cu divizorul
    reg              div_start;     // Semnal de start (puls 1 ciclu)
    wire [WIDTH-1:0] div_result;    // Rezultat impartire
    wire             div_valid;     // Semnal ca rezultatul este gata
    
    assign dbg_state = state;
    
    // Interfata cu multiplicatoarele
    // mult_xp : (f/z) * x
    // mult_yp : (f/z) * y
    wire [WIDTH-1:0] mult_xp_result, mult_yp_result;
    wire             ovf_xp, ovf_yp;   // overflow flags (ignorate / debug)

    // Instantiere divizor
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

    // Instantiere multiplicator ptr xp = (f/z) * x
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

    // Instantiere multiplicator ptr yp = (f/z) * y
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
            IDLE:      next_state = start ? LOAD : IDLE;                // asteapta start
            LOAD:      next_state = START_DIV;                          // dupa incarcare pornim divizorul
            START_DIV: next_state = CALC_DIV;                           // pulsul de start a fost transmis
            CALC_DIV:  next_state = div_valid ? DONE_DIV : CALC_DIV;    // asteapta rezultatul divizorului
            DONE_DIV:  next_state = CALC_PROJ;
            CALC_PROJ: next_state = DONE;                               // 1 ciclu ptr multiplicator
            DONE:      next_state = IDLE;                               // operatia s-a efectuat, revine in IDLE
            default:   
                next_state = IDLE;
        endcase
    end

    // Logica secventiala
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset general
            reg_f     <= 0;
            reg_x     <= 0;
            reg_y     <= 0;
            reg_z     <= 0;
            reg_fz    <= 0;
            div_start <= 1'b0;
            xp        <= 0;
            yp        <= 0;
            valid     <= 1'b0;
            overflow  <= 1'b0;
        end else begin
            // valori default
            div_start <= 1'b0;  // implicit nu dam start
            valid     <= 1'b0;  // valid este 1 doar in DONE

            case (state)

                // 1. asteapta start
                IDLE: begin
                    // nu facem nimic
                end

                // 2. incarca datele de intrare in registre
                LOAD: begin
                    reg_f  <= f;
                    reg_x  <= x;
                    reg_y  <= y;
                    reg_z  <= z;
                end
                
                // 3. pornim divizorul (puls de 1 ciclu)
                START_DIV: begin
                    div_start <= 1'b1;
                end

                // 4. asteptam rezultatul divizorului
                CALC_DIV: begin
                    // captureaza rezultatul cand e gata
                end
                
                DONE_DIV: begin
                    reg_fz <= div_result;
                end

                // 5. asteapta rezultatul multiplicarii (latenta 1 ciclu)
                CALC_PROJ: begin
                    // nimic – latenta multiplicatorului se consuma
                end

                // 6. scrie rezultatele finale
                DONE: begin
                    xp    <= mult_xp_result;
                    yp    <= mult_yp_result;
                    overflow <= ovf_xp | ovf_yp;
                    valid <= 1'b1;  // semnal ca rezultatul e valid (1 ciclu)
                end
            endcase
        end
    end

endmodule
