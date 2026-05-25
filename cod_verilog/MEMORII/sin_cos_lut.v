//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : sin_cos_lut
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Generator sin/cos bazat pe LUT cu rezolutie de 0.5 grade.
//              Implementeaza calcul trigonometric rapid prin tabel precalculat pentru
//              intervalul 0..89.5 grade, combinat cu reducerea unghiului pe cadrane
//              si exploatarea simetriei functiilor sinus si cosinus.
//
//              Include FSM multi-stadiu pentru:
//              - detectia cadranului
//              - reducerea unghiului la primul cadran
//              - acces LUT
//              - scalare la format fixed-point
//              - aplicare semn in functie de cadran
//
//              Optimizat pentru implementare hardware fara multiplicari complexe.
//---------------------------------------------------------------

module sin_cos_lut #(
    parameter INT_BITS  = 2,                        // Minim 2 biti (1 semn + 1 parte intreaga pentru valoarea "1.0")
    parameter FRAC_BITS = 16,                       // Numar de biti parte fractionara
    parameter DATA_WIDTH = INT_BITS + FRAC_BITS     // Latime date, biti
)(
    input                                clk,       // Semnal de ceas
    input                                rst_n,     // Reset asincron (activ in 0)
    input                                start,     // Pornire proces citire
    input       [9:0]                    angle,     // [9:1] grade intregi, [0] jumatate de grad (0..719)  
    output reg                           valid,     // Flag finalizare citire   
    output reg  [DATA_WIDTH-1:0]         sin_out,    
    output reg  [DATA_WIDTH-1:0]         cos_out,
    output      [2:0]                    dbg_state  // Flag stare FSM (DEBUG)
);

    // ------------------------
    // Constante in format Q 
    // ------------------------

    localparam [DATA_WIDTH-1:0] POS_ONE = {{(INT_BITS-1){1'b0}}, 1'b1, {FRAC_BITS{1'b0}}};
    localparam [DATA_WIDTH-1:0] NEG_ONE = ~POS_ONE + 1'b1;
    localparam [DATA_WIDTH-1:0] ZERO    = {DATA_WIDTH{1'b0}};


    // ------------------------
    // Definitie stari FSM
    // ------------------------

    localparam S_IDLE         = 3'b000,  
               S_LOAD         = 3'b001,  
               S_QUAD         = 3'b010,
               S_FOLD         = 3'b011,
               S_READ_LUT     = 3'b100, 
               S_SCALE        = 3'b101,
               S_DONE         = 3'b110;   

    reg [2:0] state, next_state;
    assign dbg_state = state;


    // ------------------------
    // Registrele interne ptr pipeline
    // ------------------------

    reg [9:0] reg_angle;

    // Observatie despre limita superioara: angle <= 10'b101100111_1 e echivalent cu angle <= 359.5 
    reg [1:0] QUAD;
    reg [7:0] FOLD_ANGLE;  // unghi redus la primul cadran, [7:1] = grade intregi, [0]=0.5, max=89.5

    // Magnitudini extrase din LUT (unsigned Q0.16) 
    reg [15:0] sin_mag;    
    reg [15:0] cos_mag;   
    
    reg [DATA_WIDTH-1:0] sin_scaled, cos_scaled; 



    // ------------------------
    // Logica FSM - Calea de control
    // ------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= S_IDLE;
        else        state <= next_state;
    end

    always @(*) begin
        case (state)
            S_IDLE:       next_state = start ? S_LOAD : S_IDLE; 
            S_LOAD:       next_state = S_QUAD;          
            S_QUAD:       next_state = S_FOLD;           
            S_FOLD:       next_state = S_READ_LUT;
            S_READ_LUT:   next_state = S_SCALE;       
            S_SCALE:      next_state = S_DONE;
            S_DONE:       next_state = S_IDLE;                 
            default:      next_state = S_IDLE;
        endcase
    end

    // ------------------------
    // Logica FSM - Calea de date
    // ------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset complet registre interne si iesiri

            QUAD       <= 0;     
            FOLD_ANGLE <= 0;
            
            reg_angle <= 0;
            sin_mag    <= 0;
            cos_mag    <= 0;

            sin_scaled <= 0;      
            cos_scaled <= 0;

            sin_out    <= 0;
            cos_out    <= 0;

            valid      <= 1'b0;
        end else begin

            case (state)

                // Asteapta semnalul de start
                S_IDLE: begin
                    valid     <= 1'b0;  // Valid este 1 doar in DONE
                end

                // Incarca datele de intrare in registre
                S_LOAD: begin
                    reg_angle <= angle;
                end
                
                // 1. Detectie Cadran
                // Impartim cercul de 360 grade in 4 zone de cate 90 grade
                S_QUAD: begin
                    if      (reg_angle >= 10'b100001110_0) QUAD <= 2'b11; // unghiul e cuprins intre 270 - 359.5
                    else if (reg_angle >= 10'b010110100_0) QUAD <= 2'b10; // unghiul e cuprins intre 180 - 269.5
                    else if (reg_angle >= 10'b001011010_0) QUAD <= 2'b01; // unghiul e cuprins intre 90  - 179.5
                    else                                   QUAD <= 2'b00; // altfel, e cuprins intre 0   - 89.5
                end
                
                // 2. Reducem unghiul la primul cadran
                // OBSERVATIE: Unghiurile "cardinale" (0, 90, 180, 270) teoretic nu se afla intr-un cadran specific.
                // Unghiurile cardinale sunt tratate separat mai tarziu ! 
                S_FOLD: begin
                    case (QUAD)
                        2'b00  : FOLD_ANGLE <= reg_angle[7:0];                         // Cadran I            
                        2'b01  : FOLD_ANGLE <= (10'b010110100_0 - reg_angle) & 8'hFF;  // Cadran II (180 - unghi, sau 10110100_0)
                        2'b10  : FOLD_ANGLE <= (reg_angle - 10'b010110100_0) & 8'hFF;  // Cadran III (unghi - 180)
                        2'b11  : FOLD_ANGLE <= (10'b101101000_0 - reg_angle) & 8'hFF;  // Cadran IV (360 - unghi, sau 101101000_0)
                        default: FOLD_ANGLE <= 8'b0000000_0;
                    endcase
                end

                // 3. LUT (Look-Up Table)
                // Contine valorile precalculate pentru Sinus si Cosinus intre 0 si 89.5 grade
                // Valorile sunt stocate in format Q0.16 (doar partea fractionara)
                S_READ_LUT: begin
                    case (FOLD_ANGLE)
                        8'b0000000_1 : begin sin_mag = 16'h023C; cos_mag = 16'hFFFE; end // 0.5
                        8'b0000001_0 : begin sin_mag = 16'h0478; cos_mag = 16'hFFF6; end // 1.0
                        8'b0000001_1 : begin sin_mag = 16'h06B4; cos_mag = 16'hFFEA; end // 1.5
                        8'b0000010_0 : begin sin_mag = 16'h08EF; cos_mag = 16'hFFD8; end // 2.0
                        8'b0000010_1 : begin sin_mag = 16'h0B2B; cos_mag = 16'hFFC2; end // 2.5
                        8'b0000011_0 : begin sin_mag = 16'h0D66; cos_mag = 16'hFFA6; end // 3.0
                        8'b0000011_1 : begin sin_mag = 16'h0FA1; cos_mag = 16'hFF86; end // 3.5
                        8'b0000100_0 : begin sin_mag = 16'h11DC; cos_mag = 16'hFF60; end // 4.0
                        8'b0000100_1 : begin sin_mag = 16'h1416; cos_mag = 16'hFF36; end // 4.5
                        8'b0000101_0 : begin sin_mag = 16'h1650; cos_mag = 16'hFF07; end // 5.0
                        8'b0000101_1 : begin sin_mag = 16'h1889; cos_mag = 16'hFED2; end // 5.5
                        8'b0000110_0 : begin sin_mag = 16'h1AC2; cos_mag = 16'hFE99; end // 6.0
                        8'b0000110_1 : begin sin_mag = 16'h1CFB; cos_mag = 16'hFE5B; end // 6.5
                        8'b0000111_0 : begin sin_mag = 16'h1F33; cos_mag = 16'hFE18; end // 7.0
                        8'b0000111_1 : begin sin_mag = 16'h216A; cos_mag = 16'hFDCF; end // 7.5
                        8'b0001000_0 : begin sin_mag = 16'h23A1; cos_mag = 16'hFD82; end // 8.0
                        8'b0001000_1 : begin sin_mag = 16'h25D7; cos_mag = 16'hFD30; end // 8.5
                        8'b0001001_0 : begin sin_mag = 16'h280C; cos_mag = 16'hFCD9; end // 9.0
                        8'b0001001_1 : begin sin_mag = 16'h2A41; cos_mag = 16'hFC7D; end // 9.5
                        8'b0001010_0 : begin sin_mag = 16'h2C74; cos_mag = 16'hFC1C; end // 10.0
                        8'b0001010_1 : begin sin_mag = 16'h2EA7; cos_mag = 16'hFBB7; end // 10.5
                        8'b0001011_0 : begin sin_mag = 16'h30D9; cos_mag = 16'hFB4C; end // 11.0
                        8'b0001011_1 : begin sin_mag = 16'h330A; cos_mag = 16'hFADC; end // 11.5
                        8'b0001100_0 : begin sin_mag = 16'h353A; cos_mag = 16'hFA68; end // 12.0
                        8'b0001100_1 : begin sin_mag = 16'h3769; cos_mag = 16'hF9EF; end // 12.5
                        8'b0001101_0 : begin sin_mag = 16'h3996; cos_mag = 16'hF970; end // 13.0
                        8'b0001101_1 : begin sin_mag = 16'h3BC3; cos_mag = 16'hF8ED; end // 13.5
                        8'b0001110_0 : begin sin_mag = 16'h3DEF; cos_mag = 16'hF865; end // 14.0
                        8'b0001110_1 : begin sin_mag = 16'h4019; cos_mag = 16'hF7D9; end // 14.5
                        8'b0001111_0 : begin sin_mag = 16'h4242; cos_mag = 16'hF747; end // 15.0
                        8'b0001111_1 : begin sin_mag = 16'h446A; cos_mag = 16'hF6B0; end // 15.5
                        8'b0010000_0 : begin sin_mag = 16'h4690; cos_mag = 16'hF615; end // 16.0
                        8'b0010000_1 : begin sin_mag = 16'h48B5; cos_mag = 16'hF575; end // 16.5
                        8'b0010001_0 : begin sin_mag = 16'h4AD9; cos_mag = 16'hF4D0; end // 17.0
                        8'b0010001_1 : begin sin_mag = 16'h4CFB; cos_mag = 16'hF427; end // 17.5
                        8'b0010010_0 : begin sin_mag = 16'h4F1C; cos_mag = 16'hF378; end // 18.0
                        8'b0010010_1 : begin sin_mag = 16'h513B; cos_mag = 16'hF2C5; end // 18.5
                        8'b0010011_0 : begin sin_mag = 16'h5358; cos_mag = 16'hF20E; end // 19.0
                        8'b0010011_1 : begin sin_mag = 16'h5574; cos_mag = 16'hF151; end // 19.5
                        8'b0010100_0 : begin sin_mag = 16'h578F; cos_mag = 16'hF090; end // 20.0
                        8'b0010100_1 : begin sin_mag = 16'h59A7; cos_mag = 16'hEFCA; end // 20.5
                        8'b0010101_0 : begin sin_mag = 16'h5BBE; cos_mag = 16'hEEFF; end // 21.0
                        8'b0010101_1 : begin sin_mag = 16'h5DD3; cos_mag = 16'hEE30; end // 21.5
                        8'b0010110_0 : begin sin_mag = 16'h5FE6; cos_mag = 16'hED5C; end // 22.0
                        8'b0010110_1 : begin sin_mag = 16'h61F8; cos_mag = 16'hEC83; end // 22.5
                        8'b0010111_0 : begin sin_mag = 16'h6407; cos_mag = 16'hEBA6; end // 23.0
                        8'b0010111_1 : begin sin_mag = 16'h6614; cos_mag = 16'hEAC4; end // 23.5
                        8'b0011000_0 : begin sin_mag = 16'h6820; cos_mag = 16'hE9DE; end // 24.0
                        8'b0011000_1 : begin sin_mag = 16'h6A29; cos_mag = 16'hE8F3; end // 24.5
                        8'b0011001_0 : begin sin_mag = 16'h6C31; cos_mag = 16'hE804; end // 25.0
                        8'b0011001_1 : begin sin_mag = 16'h6E36; cos_mag = 16'hE710; end // 25.5
                        8'b0011010_0 : begin sin_mag = 16'h7039; cos_mag = 16'hE617; end // 26.0
                        8'b0011010_1 : begin sin_mag = 16'h723A; cos_mag = 16'hE51A; end // 26.5
                        8'b0011011_0 : begin sin_mag = 16'h7439; cos_mag = 16'hE419; end // 27.0
                        8'b0011011_1 : begin sin_mag = 16'h7635; cos_mag = 16'hE313; end // 27.5
                        8'b0011100_0 : begin sin_mag = 16'h782F; cos_mag = 16'hE209; end // 28.0
                        8'b0011100_1 : begin sin_mag = 16'h7A27; cos_mag = 16'hE0FA; end // 28.5
                        8'b0011101_0 : begin sin_mag = 16'h7C1C; cos_mag = 16'hDFE7; end // 29.0
                        8'b0011101_1 : begin sin_mag = 16'h7E0F; cos_mag = 16'hDED0; end // 29.5
                        8'b0011110_0 : begin sin_mag = 16'h8000; cos_mag = 16'hDDB4; end // 30.0
                        8'b0011110_1 : begin sin_mag = 16'h81EE; cos_mag = 16'hDC94; end // 30.5
                        8'b0011111_0 : begin sin_mag = 16'h83DA; cos_mag = 16'hDB6F; end // 31.0
                        8'b0011111_1 : begin sin_mag = 16'h85C2; cos_mag = 16'hDA47; end // 31.5
                        8'b0100000_0 : begin sin_mag = 16'h87A9; cos_mag = 16'hD91A; end // 32.0
                        8'b0100000_1 : begin sin_mag = 16'h898C; cos_mag = 16'hD7E9; end // 32.5
                        8'b0100001_0 : begin sin_mag = 16'h8B6D; cos_mag = 16'hD6B3; end // 33.0
                        8'b0100001_1 : begin sin_mag = 16'h8D4C; cos_mag = 16'hD57A; end // 33.5
                        8'b0100010_0 : begin sin_mag = 16'h8F27; cos_mag = 16'hD43C; end // 34.0
                        8'b0100010_1 : begin sin_mag = 16'h9100; cos_mag = 16'hD2FA; end // 34.5
                        8'b0100011_0 : begin sin_mag = 16'h92D6; cos_mag = 16'hD1B4; end // 35.0
                        8'b0100011_1 : begin sin_mag = 16'h94A9; cos_mag = 16'hD06A; end // 35.5
                        8'b0100100_0 : begin sin_mag = 16'h9679; cos_mag = 16'hCF1C; end // 36.0
                        8'b0100100_1 : begin sin_mag = 16'h9846; cos_mag = 16'hCDCA; end // 36.5
                        8'b0100101_0 : begin sin_mag = 16'h9A11; cos_mag = 16'hCC73; end // 37.0
                        8'b0100101_1 : begin sin_mag = 16'h9BD8; cos_mag = 16'hCB19; end // 37.5
                        8'b0100110_0 : begin sin_mag = 16'h9D9C; cos_mag = 16'hC9BB; end // 38.0
                        8'b0100110_1 : begin sin_mag = 16'h9F5D; cos_mag = 16'hC859; end // 38.5
                        8'b0100111_0 : begin sin_mag = 16'hA11B; cos_mag = 16'hC6F3; end // 39.0
                        8'b0100111_1 : begin sin_mag = 16'hA2D6; cos_mag = 16'hC589; end // 39.5
                        8'b0101000_0 : begin sin_mag = 16'hA48E; cos_mag = 16'hC41B; end // 40.0
                        8'b0101000_1 : begin sin_mag = 16'hA642; cos_mag = 16'hC2AA; end // 40.5
                        8'b0101001_0 : begin sin_mag = 16'hA7F3; cos_mag = 16'hC135; end // 41.0
                        8'b0101001_1 : begin sin_mag = 16'hA9A1; cos_mag = 16'hBFBC; end // 41.5
                        8'b0101010_0 : begin sin_mag = 16'hAB4C; cos_mag = 16'hBE3F; end // 42.0
                        8'b0101010_1 : begin sin_mag = 16'hACF3; cos_mag = 16'hBCBE; end // 42.5
                        8'b0101011_0 : begin sin_mag = 16'hAE97; cos_mag = 16'hBB3A; end // 43.0
                        8'b0101011_1 : begin sin_mag = 16'hB038; cos_mag = 16'hB9B2; end // 43.5
                        8'b0101100_0 : begin sin_mag = 16'hB1D5; cos_mag = 16'hB827; end // 44.0
                        8'b0101100_1 : begin sin_mag = 16'hB36F; cos_mag = 16'hB698; end // 44.5
                        8'b0101101_0 : begin sin_mag = 16'hB505; cos_mag = 16'hB505; end // 45.0
                        8'b0101101_1 : begin sin_mag = 16'hB698; cos_mag = 16'hB36F; end // 45.5
                        8'b0101110_0 : begin sin_mag = 16'hB827; cos_mag = 16'hB1D5; end // 46.0
                        8'b0101110_1 : begin sin_mag = 16'hB9B2; cos_mag = 16'hB038; end // 46.5
                        8'b0101111_0 : begin sin_mag = 16'hBB3A; cos_mag = 16'hAE97; end // 47.0
                        8'b0101111_1 : begin sin_mag = 16'hBCBE; cos_mag = 16'hACF3; end // 47.5
                        8'b0110000_0 : begin sin_mag = 16'hBE3F; cos_mag = 16'hAB4C; end // 48.0
                        8'b0110000_1 : begin sin_mag = 16'hBFBC; cos_mag = 16'hA9A1; end // 48.5
                        8'b0110001_0 : begin sin_mag = 16'hC135; cos_mag = 16'hA7F3; end // 49.0
                        8'b0110001_1 : begin sin_mag = 16'hC2AA; cos_mag = 16'hA642; end // 49.5
                        8'b0110010_0 : begin sin_mag = 16'hC41B; cos_mag = 16'hA48E; end // 50.0
                        8'b0110010_1 : begin sin_mag = 16'hC589; cos_mag = 16'hA2D6; end // 50.5
                        8'b0110011_0 : begin sin_mag = 16'hC6F3; cos_mag = 16'hA11B; end // 51.0
                        8'b0110011_1 : begin sin_mag = 16'hC859; cos_mag = 16'h9F5D; end // 51.5
                        8'b0110100_0 : begin sin_mag = 16'hC9BB; cos_mag = 16'h9D9C; end // 52.0
                        8'b0110100_1 : begin sin_mag = 16'hCB19; cos_mag = 16'h9BD8; end // 52.5
                        8'b0110101_0 : begin sin_mag = 16'hCC73; cos_mag = 16'h9A11; end // 53.0
                        8'b0110101_1 : begin sin_mag = 16'hCDCA; cos_mag = 16'h9846; end // 53.5
                        8'b0110110_0 : begin sin_mag = 16'hCF1C; cos_mag = 16'h9679; end // 54.0
                        8'b0110110_1 : begin sin_mag = 16'hD06A; cos_mag = 16'h94A9; end // 54.5
                        8'b0110111_0 : begin sin_mag = 16'hD1B4; cos_mag = 16'h92D6; end // 55.0
                        8'b0110111_1 : begin sin_mag = 16'hD2FA; cos_mag = 16'h9100; end // 55.5
                        8'b0111000_0 : begin sin_mag = 16'hD43C; cos_mag = 16'h8F27; end // 56.0
                        8'b0111000_1 : begin sin_mag = 16'hD57A; cos_mag = 16'h8D4C; end // 56.5
                        8'b0111001_0 : begin sin_mag = 16'hD6B3; cos_mag = 16'h8B6D; end // 57.0
                        8'b0111001_1 : begin sin_mag = 16'hD7E9; cos_mag = 16'h898C; end // 57.5
                        8'b0111010_0 : begin sin_mag = 16'hD91A; cos_mag = 16'h87A9; end // 58.0
                        8'b0111010_1 : begin sin_mag = 16'hDA47; cos_mag = 16'h85C2; end // 58.5
                        8'b0111011_0 : begin sin_mag = 16'hDB6F; cos_mag = 16'h83DA; end // 59.0
                        8'b0111011_1 : begin sin_mag = 16'hDC94; cos_mag = 16'h81EE; end // 59.5
                        8'b0111100_0 : begin sin_mag = 16'hDDB4; cos_mag = 16'h8000; end // 60.0
                        8'b0111100_1 : begin sin_mag = 16'hDED0; cos_mag = 16'h7E0F; end // 60.5
                        8'b0111101_0 : begin sin_mag = 16'hDFE7; cos_mag = 16'h7C1C; end // 61.0
                        8'b0111101_1 : begin sin_mag = 16'hE0FA; cos_mag = 16'h7A27; end // 61.5
                        8'b0111110_0 : begin sin_mag = 16'hE209; cos_mag = 16'h782F; end // 62.0
                        8'b0111110_1 : begin sin_mag = 16'hE313; cos_mag = 16'h7635; end // 62.5
                        8'b0111111_0 : begin sin_mag = 16'hE419; cos_mag = 16'h7439; end // 63.0
                        8'b0111111_1 : begin sin_mag = 16'hE51A; cos_mag = 16'h723A; end // 63.5
                        8'b1000000_0 : begin sin_mag = 16'hE617; cos_mag = 16'h7039; end // 64.0
                        8'b1000000_1 : begin sin_mag = 16'hE710; cos_mag = 16'h6E36; end // 64.5
                        8'b1000001_0 : begin sin_mag = 16'hE804; cos_mag = 16'h6C31; end // 65.0
                        8'b1000001_1 : begin sin_mag = 16'hE8F3; cos_mag = 16'h6A29; end // 65.5
                        8'b1000010_0 : begin sin_mag = 16'hE9DE; cos_mag = 16'h6820; end // 66.0
                        8'b1000010_1 : begin sin_mag = 16'hEAC4; cos_mag = 16'h6614; end // 66.5
                        8'b1000011_0 : begin sin_mag = 16'hEBA6; cos_mag = 16'h6407; end // 67.0
                        8'b1000011_1 : begin sin_mag = 16'hEC83; cos_mag = 16'h61F8; end // 67.5
                        8'b1000100_0 : begin sin_mag = 16'hED5C; cos_mag = 16'h5FE6; end // 68.0
                        8'b1000100_1 : begin sin_mag = 16'hEE30; cos_mag = 16'h5DD3; end // 68.5
                        8'b1000101_0 : begin sin_mag = 16'hEEFF; cos_mag = 16'h5BBE; end // 69.0
                        8'b1000101_1 : begin sin_mag = 16'hEFCA; cos_mag = 16'h59A7; end // 69.5
                        8'b1000110_0 : begin sin_mag = 16'hF090; cos_mag = 16'h578F; end // 70.0
                        8'b1000110_1 : begin sin_mag = 16'hF151; cos_mag = 16'h5574; end // 70.5
                        8'b1000111_0 : begin sin_mag = 16'hF20E; cos_mag = 16'h5358; end // 71.0
                        8'b1000111_1 : begin sin_mag = 16'hF2C5; cos_mag = 16'h513B; end // 71.5
                        8'b1001000_0 : begin sin_mag = 16'hF378; cos_mag = 16'h4F1C; end // 72.0
                        8'b1001000_1 : begin sin_mag = 16'hF427; cos_mag = 16'h4CFB; end // 72.5
                        8'b1001001_0 : begin sin_mag = 16'hF4D0; cos_mag = 16'h4AD9; end // 73.0
                        8'b1001001_1 : begin sin_mag = 16'hF575; cos_mag = 16'h48B5; end // 73.5
                        8'b1001010_0 : begin sin_mag = 16'hF615; cos_mag = 16'h4690; end // 74.0
                        8'b1001010_1 : begin sin_mag = 16'hF6B0; cos_mag = 16'h446A; end // 74.5
                        8'b1001011_0 : begin sin_mag = 16'hF747; cos_mag = 16'h4242; end // 75.0
                        8'b1001011_1 : begin sin_mag = 16'hF7D9; cos_mag = 16'h4019; end // 75.5
                        8'b1001100_0 : begin sin_mag = 16'hF865; cos_mag = 16'h3DEF; end // 76.0
                        8'b1001100_1 : begin sin_mag = 16'hF8ED; cos_mag = 16'h3BC3; end // 76.5
                        8'b1001101_0 : begin sin_mag = 16'hF970; cos_mag = 16'h3996; end // 77.0
                        8'b1001101_1 : begin sin_mag = 16'hF9EF; cos_mag = 16'h3769; end // 77.5
                        8'b1001110_0 : begin sin_mag = 16'hFA68; cos_mag = 16'h353A; end // 78.0
                        8'b1001110_1 : begin sin_mag = 16'hFADC; cos_mag = 16'h330A; end // 78.5
                        8'b1001111_0 : begin sin_mag = 16'hFB4C; cos_mag = 16'h30D9; end // 79.0
                        8'b1001111_1 : begin sin_mag = 16'hFBB7; cos_mag = 16'h2EA7; end // 79.5
                        8'b1010000_0 : begin sin_mag = 16'hFC1C; cos_mag = 16'h2C74; end // 80.0
                        8'b1010000_1 : begin sin_mag = 16'hFC7D; cos_mag = 16'h2A41; end // 80.5
                        8'b1010001_0 : begin sin_mag = 16'hFCD9; cos_mag = 16'h280C; end // 81.0
                        8'b1010001_1 : begin sin_mag = 16'hFD30; cos_mag = 16'h25D7; end // 81.5
                        8'b1010010_0 : begin sin_mag = 16'hFD82; cos_mag = 16'h23A1; end // 82.0
                        8'b1010010_1 : begin sin_mag = 16'hFDCF; cos_mag = 16'h216A; end // 82.5
                        8'b1010011_0 : begin sin_mag = 16'hFE18; cos_mag = 16'h1F33; end // 83.0
                        8'b1010011_1 : begin sin_mag = 16'hFE5B; cos_mag = 16'h1CFB; end // 83.5
                        8'b1010100_0 : begin sin_mag = 16'hFE99; cos_mag = 16'h1AC2; end // 84.0
                        8'b1010100_1 : begin sin_mag = 16'hFED2; cos_mag = 16'h1889; end // 84.5
                        8'b1010101_0 : begin sin_mag = 16'hFF07; cos_mag = 16'h1650; end // 85.0
                        8'b1010101_1 : begin sin_mag = 16'hFF36; cos_mag = 16'h1416; end // 85.5
                        8'b1010110_0 : begin sin_mag = 16'hFF60; cos_mag = 16'h11DC; end // 86.0
                        8'b1010110_1 : begin sin_mag = 16'hFF86; cos_mag = 16'h0FA1; end // 86.5
                        8'b1010111_0 : begin sin_mag = 16'hFFA6; cos_mag = 16'h0D66; end // 87.0
                        8'b1010111_1 : begin sin_mag = 16'hFFC2; cos_mag = 16'h0B2B; end // 87.5
                        8'b1011000_0 : begin sin_mag = 16'hFFD8; cos_mag = 16'h08EF; end // 88.0
                        8'b1011000_1 : begin sin_mag = 16'hFFEA; cos_mag = 16'h06B4; end // 88.5
                        8'b1011001_0 : begin sin_mag = 16'hFFF6; cos_mag = 16'h0478; end // 89.0
                        8'b1011001_1 : begin sin_mag = 16'hFFFE; cos_mag = 16'h023C; end // 89.5
                        default      : begin sin_mag = 16'h0000; cos_mag = 16'h0000; end
                    endcase
                end

                // 4. Scalare si Aplicare Semn
                // Ajustam precizia LUT-ului (16 biti) la precizia parametrului FRAC_BITS 
                S_SCALE: begin
                    // Scalare sin_mag/cos_mag de la 16 biti -> FRAC_BITS biti
                    // integer bit e mereu 0 (valorile LUT sunt strict intre 0 si 1)
                    
                    // FRAC_BITS >= 16: extindem la dreapta
                    // FRAC_BITS < 16: taiem din bitii mai putin semnificativi
                    if (FRAC_BITS >= 16) begin
                        sin_scaled = {{(INT_BITS){1'b0}}, sin_mag, {(FRAC_BITS-16){1'b0}}};
                        cos_scaled = {{(INT_BITS){1'b0}}, cos_mag, {(FRAC_BITS-16){1'b0}}};
                    end else begin
                        sin_scaled = {{(INT_BITS){1'b0}}, sin_mag[15:16-FRAC_BITS]};
                        cos_scaled = {{(INT_BITS){1'b0}}, cos_mag[15:16-FRAC_BITS]};
                    end
                end
    
                // Rezultat final disponibil
                S_DONE: begin
                    // Aplicare semn din QUAD
                    // sin_neg = QUAD[1]
                    // cos_neg = QUAD[1] ^ QUAD[0]
                    // Cazurile cardinale au valori exacte si nu trec prin LUT
                    case (reg_angle[9:0])
                        10'b000000000_0: begin sin_out = ZERO;    cos_out = POS_ONE; end  //   0 deg
                        10'b001011010_0: begin sin_out = POS_ONE; cos_out = ZERO;    end  //  90 deg
                        10'b010110100_0: begin sin_out = ZERO;    cos_out = NEG_ONE; end  // 180 deg
                        10'b100001110_0: begin sin_out = NEG_ONE; cos_out = ZERO;    end  // 270 deg
                        default: begin
                            // Sinus e negativ in Cadranele III si IV (QUAD[1] == 1)
                            sin_out = QUAD[1]           ? (~sin_scaled + 1) :  sin_scaled;
                            // Cosinus e negativ in Cadranele II si III (QUAD[1] XOR QUAD[0])
                            cos_out = (QUAD[1]^QUAD[0]) ? (~cos_scaled + 1) :  cos_scaled;  
                        end
                    endcase
                    valid <= 1'b1; 
                end
            endcase
        end
    end

endmodule // sin_cos_lut
