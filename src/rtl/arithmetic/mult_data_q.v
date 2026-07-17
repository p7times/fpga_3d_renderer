//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : mult_data_q
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Calea de Date (Datapath) pentru Multiplicatorul Booth.
//              Realizeaza inmultirea cu rezultat pe DATA_WIDTH si saturatie.
//---------------------------------------------------------------

`timescale 1ns / 1ps

module mult_data_q #(
    parameter INT_BITS   = 16,                          // Numar de biti parte intreaga (include semnul) 
    parameter FRAC_BITS  = 16,                          // Numar de biti parte fractionara
    parameter DATA_WIDTH = INT_BITS + FRAC_BITS         // Latime date, biti
)(
    input                               clk,            // Semnal de ceas
    input                               rst_n,          // Reset asincron (activ in 0)
    input                               ld,             // Semnal incarcare date       
    input      [DATA_WIDTH-1:0]         multiplicand,   // Deinmultit
    input      [DATA_WIDTH-1:0]         multiplier,     // Inmultitor
    output reg                          done,           // Semnal finalizare ciclu    
    output reg                          overflow,       // Flag detectie overflow/underflow       
    output reg [DATA_WIDTH-1:0]         product         // Rezultat final pe precizie simpla (DATA_WIDTH)
);

    // ------------------------
    // Limite reprezentabile in format Q (Saturatie)
    // ------------------------
    localparam [DATA_WIDTH-1:0] MAX = {1'b0, {(DATA_WIDTH-1){1'b1}}};
    localparam [DATA_WIDTH-1:0] MIN = {1'b1, {(DATA_WIDTH-1){1'b0}}}; 


    // ------------------------
    // Registrele interne ptr pipeline
    // ------------------------

    reg [DATA_WIDTH-1:0]         A;                 // Acumulatorul Booth
    reg [DATA_WIDTH-1:0]         Q;                 // Registrul inmultitorului
    reg                          q_minus_1;         // Bitul Q[-1]
    reg [DATA_WIDTH-1:0]         M;                 // Registrul deinmultitului
    reg [$clog2(DATA_WIDTH)-1:0] count;             // Contor iteratii

    reg [DATA_WIDTH:0]           sum;               
    reg [DATA_WIDTH-1:0]         A_next;            
    reg [DATA_WIDTH-1:0]         Q_next;            
    reg                          q_minus_1_next;    

    // ------------------------
    // Fire intermediare pentru aliniere format Q si detectie overflow
    // ------------------------
    
    // Produsul complet combinational de la ultima iteratie (dubla precizie)
    wire [2*DATA_WIDTH-1:0] next_full_prod = {A_next, Q_next};
    
    // Bitii aflati deasupra partii intregi selectate. Sunt folositi pentru a verifica sign-extension.
    wire [INT_BITS:0] next_upper_bits = next_full_prod[2*DATA_WIDTH-1 : DATA_WIDTH + FRAC_BITS - 1];

    // ------------------------
    // Logica secventiala (calea de date)
    // ------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            A         <= 0;
            Q         <= 0;
            q_minus_1 <= 0;
            M         <= 0;
            count     <= 0;
            done      <= 0;
            overflow  <= 0;
            product   <= 0;
        end

        else if (ld) begin
            M         <= multiplicand;
            A         <= 0;                         
            Q         <= multiplier;                
            q_minus_1 <= 1'b0;                      
            count     <= 0;                         
            done      <= 0;   
            overflow  <= 0;                      
        end

        else if (!done) begin
            A         <= A_next;
            Q         <= Q_next;
            q_minus_1 <= q_minus_1_next;
            count     <= count + 1;

            // Verificare finalizare (dupa DATA_WIDTH iteratii)
            if (count == DATA_WIDTH - 1) begin
                // Daca bitii de deasupra ferestrei sunt toti 0 sau toti 1, nu avem overflow
                if (next_upper_bits == 0 || next_upper_bits == {(INT_BITS+1){1'b1}}) begin
                    product <= next_full_prod[DATA_WIDTH + FRAC_BITS - 1 : FRAC_BITS];
                    overflow <= 1'b0;
                end else begin
                    // In caz de overflow/underflow, aplicam saturatia in functie de semnul rezultatului brut
                    product <= next_full_prod[2*DATA_WIDTH-1] ? MIN : MAX;
                    overflow <= 1'b1;
                end
                done <= 1;                       
            end
        end
    end


    // ------------------------
    // Logica combinationala (Booth standard)
    // ------------------------

    always @(*) begin
        case ({Q[0], q_minus_1})
            2'b01:   sum = $signed(A) + $signed(M);
            2'b10:   sum = $signed(A) - $signed(M);
            default: sum = $signed({A[DATA_WIDTH-1], A});
        endcase

        A_next         = sum[DATA_WIDTH:1];
        Q_next         = {sum[0], Q[DATA_WIDTH-1:1]};
        q_minus_1_next = Q[0];
    end

endmodule // mult_data_q
