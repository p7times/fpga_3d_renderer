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
    parameter FRAC_BITS = 16                        // Numar de biti parte fractionara
)(
    input                               clk,        // Semnal de ceas
    input                               rst_n,      // Reset asincron (activ in 0)
    input                               ld,         // Semnal incarcare date       
    input [INT_BITS+FRAC_BITS-1:0]      deimpartit,
    input [INT_BITS+FRAC_BITS-1:0]      impartitor, 
    output reg                          done,       // Semnal finalizare ciclu                  
    output reg [INT_BITS+FRAC_BITS-1:0] cat         // Rezultatul final
);

    localparam WIDTH = INT_BITS + FRAC_BITS;

    // ------------------------
    // Limite reprezentabile in format Q (Complement de 2)
    // ------------------------

    // MAX: 0 urmat de 1-uri (cel mai mare numar pozitiv)
    // MIN: 1 urmat de 0-uri (cel mai mic numar negativ)
    localparam [WIDTH-1:0] MAX = {1'b0, {(WIDTH-1){1'b1}}};
    localparam [WIDTH-1:0] MIN = {1'b1, {(WIDTH-1){1'b0}}}; 


    // ------------------------
    // Registrele interne ptr pipeline
    // ------------------------

    reg [WIDTH:0]   P;              // Rest partial
    reg [WIDTH-1:0] A;              // Cat
    reg [WIDTH-1:0] B;              // Divizor
   // reg [WIDTH-1:0] count;          // Contor pentru numarul de iteratii (WIDTH iteratii)
    reg [$clog2(WIDTH)-1:0] count;
    reg [WIDTH:0]   P_next;         // Rest intermediar
    reg [WIDTH-1:0] A_next;         // Cat intermediar

    reg             sign_q;         // Semnul final al rezultatului
    reg [WIDTH-1:0] abs_d, abs_v;   // Valori absolute pentru calcul


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
                cat  <= deimpartit[WIDTH-1] ? MIN : MAX;
                done <= 1;   // terminam instant
            end else begin
                // Pregatirea valorilor absolute si determinarea semnului rezultatului
                abs_d  = deimpartit[WIDTH-1] ? (~deimpartit + 1'b1) : deimpartit;
                abs_v  = impartitor[WIDTH-1] ? (~impartitor + 1'b1) : impartitor;
                sign_q <= deimpartit[WIDTH-1] ^ impartitor[WIDTH-1];
                
                // Initializare algoritm: P preia bitii semnificativi, A restul
                P <= {{1'b0}, {(INT_BITS-1){1'b0}}, abs_d[WIDTH-1:FRAC_BITS]};
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
            P_next = {P[WIDTH-1:0], A[WIDTH-1]};
            A_next = {A[WIDTH-2:0], 1'b0};

            // Pasul 2: Operatie Aritmetica bazata pe semnul restului anterior
            if (P[WIDTH])   P_next = P_next + B;
            else            P_next = P_next - B;

            // Pasul 3: Determinare bit curent din cat (A_next[0])
            A_next[0] = ~P_next[WIDTH];

            // Pas 4: Actualizare registre
            P <= P_next;
            A <= A_next;
            count <= count + 1; // incrementeaza contorul de pasi

            // Pas 5: Verificare finalizare (WIDTH-1 cicluri)
            if (count == WIDTH -1) begin
                // Conversia inapoi la format semnat si aplicarea saturatiei daca e cazul
                if (A_next[WIDTH-1]) begin cat <= sign_q ? MIN : MAX; 
                end else             begin cat <= sign_q ? (~A_next + 1'b1) : A_next;
                end

                done <= 1;      // operatia s-a terminat
            end
        end

    end

endmodule

