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

module div_data_q #(
    parameter INT_BITS  = 16,                       // Numar de biti parte intreaga (include semnul) 
    parameter FRAC_BITS = 16,                       // Numar de biti parte fractionara
    parameter DATA_WIDTH = INT_BITS + FRAC_BITS     // Latime date, biti
)(
    input                               clk,        // Semnal de ceas
    input                               rst_n,      // Reset asincron (activ in 0)
    input                               ld,         // Semnal incarcare date       
    input      [DATA_WIDTH-1:0]         deimpartit,
    input      [DATA_WIDTH-1:0]         impartitor, 
    output reg                          done,       // Semnal finalizare ciclu                  
    output reg [DATA_WIDTH-1:0]         cat         // Rezultatul final
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
    reg [DATA_WIDTH-1:0]         abs_d, abs_v;      // Valori absolute pentru calcul


    // ------------------------
    // Logica secventiala (calea de date)
    // ------------------------

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset complet registre interne si iesiri

            P <= 0;        
            A <= 0;        
            B <= 0;          
            count  <= 0;   
            done   <= 0;   
            cat    <= 0;
            sign_q <= 0;

        end

        // Initializare cand ld este activ (puls de incarcare)
        else if (ld) begin
            // Exceptie: impartirea la zero
            if (impartitor == 0) begin
                cat  <= deimpartit[DATA_WIDTH-1] ? MIN : MAX;
                done <= 1;   // terminam instant
            end else begin
                // Pregatirea valorilor absolute si determinarea semnului rezultatului
                abs_d  = deimpartit[DATA_WIDTH-1] ? (~deimpartit + 1'b1) : deimpartit;
                abs_v  = impartitor[DATA_WIDTH-1] ? (~impartitor + 1'b1) : impartitor;
                sign_q <= deimpartit[DATA_WIDTH-1] ^ impartitor[DATA_WIDTH-1];
                
                // Initializare algoritm: P preia bitii semnificativi, A restul
                P <= {{1'b0}, {(INT_BITS-1){1'b0}}, abs_d[DATA_WIDTH-1:FRAC_BITS]};
                A <= {abs_d[FRAC_BITS-1:0], {FRAC_BITS{1'b0}}};
                
                B <= abs_v;   // Incarca divizorul (in modul)
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
                if (A_next[DATA_WIDTH-1]) begin cat <= sign_q ? MIN : MAX; 
                end else             begin cat <= sign_q ? (~A_next + 1'b1) : A_next;
                end

                done <= 1;      // operatia s-a terminat
            end
        end

    end

endmodule // div_data_q

