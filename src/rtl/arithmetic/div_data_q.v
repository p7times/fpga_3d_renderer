//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : div_data_q
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Calea de Date (Datapath) pentru Divizorul Hardware.
//              Realizeaza impartirea numerelor in virgula fixa semnata.
//---------------------------------------------------------------

`timescale 1ns / 1ps

module div_data_q #(
    parameter INT_BITS   = 16,                      // Numar de biti parte intreaga (include semnul) 
    parameter FRAC_BITS  = 16,                      // Numar de biti parte fractionara
    parameter DATA_WIDTH = INT_BITS + FRAC_BITS     // Latime date, biti
)(
    input                               clk,        // Semnal de ceas
    input                               rst_n,      // Reset asincron (activ in 0)
    input                               ld,         // Semnal incarcare date       
    input      [DATA_WIDTH-1:0]         dividend,   // Deimpartit
    input      [DATA_WIDTH-1:0]         divisor,    // Impartitor
    output reg                          done,       // Semnal finalizare ciclu                  
    output reg [DATA_WIDTH-1:0]         quotient    // Rezultatul final
);

    // ------------------------
    // Limite reprezentabile in format Q (Complement de 2)
    // ------------------------

    // MAX: 0 urmat de 1-uri (cel mai mare numar pozitiv)
    // MIN: 1 urmat de 0-uri (cel mai mic numar negativ)
    localparam [DATA_WIDTH-1:0] MAX = {1'b0, {(DATA_WIDTH-1){1'b1}}};
    localparam [DATA_WIDTH-1:0] MIN = {1'b1, {(DATA_WIDTH-1){1'b0}}}; 


    // ------------------------
    // Registrele interne ptr pipeline
    // ------------------------

    reg [DATA_WIDTH:0]           P;                 // Rest partial
    reg [DATA_WIDTH-1:0]         A;                 // Cat
    reg [DATA_WIDTH-1:0]         B;                 // Divizor
    reg [$clog2(DATA_WIDTH)-1:0] count;
    reg [DATA_WIDTH:0]           P_next;            // Rest intermediar
    reg [DATA_WIDTH-1:0]         A_next;            // Cat intermediar

    reg                          sign_q;            // Semnul final al rezultatului
    reg [DATA_WIDTH-1:0]         abs_a, abs_b;      // Valori absolute pentru calcul



    reg [2*DATA_WIDTH-1:0] dividend_scaled;
    
    // ------------------------
    // Logica secventiala (calea de date)
    // ------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset complet registre interne si iesiri
            P           <= 0;        
            A           <= 0;        
            B           <= 0;          
            count       <= 0;   
            done        <= 0;   
            quotient    <= 0;
            sign_q      <= 0;

        end

        // Initializare cand ld este activ (puls de incarcare)
        else if (ld) begin
            // Exceptie: impartirea la zero
            if (divisor == 0) begin
                quotient  <= dividend[DATA_WIDTH-1] ? MIN : MAX;
                done <= 1;   // terminam instant
            end else begin
                // Pregatirea valorilor absolute si determinarea semnului rezultatului
                abs_a  = dividend[DATA_WIDTH-1] ? (~dividend + 1'b1) : dividend;
                abs_b  = divisor[DATA_WIDTH-1] ? (~divisor + 1'b1) : divisor;
                sign_q <= dividend[DATA_WIDTH-1] ^ divisor[DATA_WIDTH-1];

                
                // Initializare algoritm: P preia bitii semnificativi, A restul
                //P <= {{1'b0}, {(INT_BITS-1){1'b0}}, abs_a[DATA_WIDTH-1:FRAC_BITS]};
                //A <= {abs_a[FRAC_BITS-1:0], {FRAC_BITS{1'b0}}};

                dividend_scaled = abs_a << FRAC_BITS;

                P <= {1'b0, dividend_scaled[2*DATA_WIDTH-1:DATA_WIDTH]};
                A <= dividend_scaled[DATA_WIDTH-1:0];


                //$display("P=%h A=%h", P, A);
                B <= abs_b;   // Incarca divizorul (in modul)
                count <= 0;   // Reseteaza contorul de iteratii
                done <= 0;    // Operatia inca nu e gata
            end
        end


        // ------------------------
        // Algoritmul fara restaurare
        // ------------------------

        else if (!done) begin
            // Pasul 1: Shift Left combinat pentru registrele P:A
            // Se muta P cu un bit la stanga si se adauga cel mai semnificativ bit din A
            P_next = {P[DATA_WIDTH-1:0], A[DATA_WIDTH-1]};
            A_next = {A[DATA_WIDTH-2:0], 1'b0};

            // Pasul 2: Operatie Aritmetica bazata pe semnul restului anterior
            if (P[DATA_WIDTH])   P_next = P_next + B;
            else                 P_next = P_next - B;

            // Pasul 3: Determinare bit curent din cat (A_next[0])
            A_next[0] = ~P_next[DATA_WIDTH];

            // Pas 4: Actualizare registre
            P <= P_next;
            A <= A_next;
            count <= count + 1; // incrementeaza contorul de pasi

            // Pas 5: Verificare finalizare (DATA_WIDTH-1 cicluri)
            if (count == DATA_WIDTH -1) begin
                // Conversia inapoi la format semnat si aplicarea saturatiei daca e cazul
                if (A_next[DATA_WIDTH-1]) begin quotient <= sign_q ? MIN : MAX; 
                end else                  begin quotient <= sign_q ? (~A_next + 1'b1) : A_next;
                end
                done <= 1;      // operatia s-a terminat
            end
        end

    end

endmodule // div_data_q

