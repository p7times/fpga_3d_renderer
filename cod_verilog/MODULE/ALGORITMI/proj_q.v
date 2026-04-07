module proj_q #(
    parameter INT_BITS  = 16,
    parameter FRAC_BITS = 16
)(
    input                               clk,
    input                               rst_n,
    input                               start,
    input  [INT_BITS+FRAC_BITS-1:0]     f, x, y, z,
    output reg [INT_BITS+FRAC_BITS-1:0] xp, yp,
    output reg                          valid
);

    localparam WIDTH = INT_BITS + FRAC_BITS;

    // Stari FSM
    localparam IDLE      = 3'd0,    // Asteapta start
               LOAD      = 3'd1,    // Incarca datele in registre
               CALC_DIV  = 3'd2,    // Modulul de impartire calculeaza f/z
               DONE_DIV  = 3'd3,    // Impartirea s-a efectuat
               CALC_PROJ = 3'd4,    // Se inmulteste f/z cu x, respectiv cu y
               DONE      = 3'd5;    // Calculul s-a efectuat

    reg [2:0] state, next_state;

    // Registre interne
    reg [WIDTH-1:0] reg_f, reg_x, reg_y, reg_z;
    reg [WIDTH-1:0] reg_fz;          // rezultat f/z

    // Semnale catre/de la modulul div
    reg              div_start;
    wire [WIDTH-1:0] div_result;
    wire             div_valid;

    // Semnale catre/de la modulele mult
    // mult_xp : (f/z) * x
    // mult_yp : (f/z) * y
    wire [WIDTH-1:0] mult_xp_result, mult_yp_result;
    wire             ovf_xp, ovf_yp;   // overflow flags (ignorate / debug)

    // Instantiere div
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

    // Instantiere mult xp
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

    // Instantiere mult yp
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

    // FSM - registru de stare
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end


    // FSM - logica de tranzitie
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:      next_state = start ? LOAD : IDLE;
            LOAD:      next_state = CALC_DIV;
            CALC_DIV:  next_state = div_valid ? DONE_DIV : CALC_DIV;
            DONE_DIV:  next_state = CALC_PROJ;
            CALC_PROJ: next_state = DONE;
            DONE:      next_state = IDLE;
            default:   next_state = IDLE;
        endcase
    end

    // FSM - logica de iesire / actiuni
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_f     <= 0;
            reg_x     <= 0;
            reg_y     <= 0;
            reg_z     <= 0;
            reg_fz    <= 0;
            div_start <= 1'b0;
            xp        <= 0;
            yp        <= 0;
            valid     <= 1'b0;
        end else begin
            // valori default
            div_start <= 1'b0;
            valid     <= 1'b0;

            case (state)
                // 1. IDLE
                IDLE: begin
                    // nu facem nimic, asteptam start
                end

                // 2. LOAD
                LOAD: begin
                    reg_f  <= f;
                    reg_x  <= x;
                    reg_y  <= y;
                    reg_z  <= z;
                    div_start <= 1'b1;   // pulsam start catre div
                end

                // 3. CALC_DIV
                // div_start a fost puls de 1 tact; asteptam div_valid
                CALC_DIV: begin
                    // nimic – doar asteptam div_valid
                end

                // 4. DONE_DIV
                // stocam f/z; modulele mult primesc reg_fz si
                // vor produce rezultatul peste UN tact (CALC_PROJ)
                DONE_DIV: begin
                    reg_fz <= div_result;
                end

                // 5. CALC_PROJ
                // mult_q are latenta de 1 tact (registru la iesire)
                // deja am dat a=reg_fz, b=reg_x/y -> rezultatul
                // apare la sfarsitul acestui tact in mult_xp_result
                CALC_PROJ: begin
                    // nimic – latenta multiplicatorului se consuma
                end

                // 6. DONE
                DONE: begin
                    xp    <= mult_xp_result;
                    yp    <= mult_yp_result;
                    valid <= 1'b1;
                end
            endcase
        end
    end

endmodule
