module proj_data #(
    parameter INT_BITS  = 16,
    parameter FRAC_BITS = 16
)(
    input                               clk,
    input                               rst_n,          // Reset asincron activ LOW
    input                               ld,               
    input [INT_BITS+FRAC_BITS-1:0]      deimpartit,
    input [INT_BITS+FRAC_BITS-1:0]      impartitor,
    output reg                          done,                     
    output reg [INT_BITS+FRAC_BITS-1:0] cat  
);

    localparam WIDTH = INT_BITS + FRAC_BITS;

    // Limitele reprezentabile in format Q
    localparam [WIDTH-1:0] MAX = {1'b0, {(WIDTH-1){1'b1}}};
    localparam [WIDTH-1:0] MIN = {1'b1, {(WIDTH-1){1'b0}}}; 
    // In format Q16.16 acestea corespund valorilor
    // MAX = +32767.99998474121 (7FFF_FFFF)
    // MIN = -32768             (8000_0000)

    reg [WIDTH:0]   P;      // Rest partial
    reg [WIDTH-1:0] A;      // Cat
    reg [WIDTH-1:0] B;      // Divizor
    reg [WIDTH-1:0] count;  // Contor iteratii

    reg [WIDTH:0]   P_next;   // Rest intermediar
    reg [WIDTH-1:0] A_next; // Cat intermediar

    reg             sign_q;       // semn cat  = MSB_deimpartit XOR MSB_impartitor
    reg [WIDTH-1:0] abs_d, abs_v; // Valori absolute

    always @(posedge clk or negedge rst_n) begin
        // Verificare reset asincron activ LOW
        if (!rst_n) begin
            // Resetul initializeaza toate registrele
            P <= 0;          // rest parțial
            A <= 0;          // cat
            B <= 0;          // divizor
            count  <= 0;     // contor iteratii
            done   <= 0;     // semnal ca operatia nu s-a terminat
            cat    <= 0;
            sign_q <= 0;
        end

        // Initializare cand ld este activ (puls de incarcare)
        else if (ld) begin
            // caz special: impartirea la zero
            if (impartitor == 0) begin
                cat  <= deimpartit[WIDTH-1] ? MIN : MAX;
                P <= 0;
                A <= 0;
                B <= 0;
                count <= 0;
                done <= 1;   // terminam instant
            end else begin
                abs_d  = deimpartit[WIDTH-1] ? (~deimpartit + 1'b1) : deimpartit;
                abs_v  = impartitor[WIDTH-1] ? (~impartitor + 1'b1) : impartitor;
                sign_q <= deimpartit[WIDTH-1] ^ impartitor[WIDTH-1];

                //P <= 0;       // reseteaza restul parțial
                //A <= abs_d;   // incarca dividendul (in modul) in registru cat
                
                P <= {{1'b0}, {(INT_BITS-1){1'b0}}, abs_d[WIDTH-1:FRAC_BITS]};
                A <= {abs_d[FRAC_BITS-1:0], {FRAC_BITS{1'b0}}};
                
                B <= abs_v;   // incarca divizorul (in modul)
                count <= 0;   // reseteaza contorul de iteratii
                done <= 0;    // operatia nu e gata
            end
        end

        // Executa pasii algoritmului non-restoring daca nu e gata
        else if (!done) begin
            // STEP 1: SHIFT LEFT combinat P:A
            // Se muta P cu un bit la stanga si se adauga cel mai semnificativ bit din A
            P_next = {P[WIDTH-1:0], A[WIDTH-1]};
            A_next = {A[WIDTH-2:0], 1'b0}; // shift stanga cat

            // STEP 2: STEP NON-RESTORING
            // Daca P este negativ (bitul WIDTH=1) adauga B
            // Daca P este pozitiv scade B
            if (P[WIDTH])
                P_next = P_next + B;
            else
                P_next = P_next - B;

            // STEP 3: Determina bitul curent al catului
            // Daca P_next negativ => bit cat = 0, altfel 1
            A_next[0] = ~P_next[WIDTH];

            // STEP 4: Commit valori
            P <= P_next;
            A <= A_next;
            count <= count + 1; // incrementeaza contorul de pasi

            // STEP 5: Verifica finalizare
            if (count == WIDTH-1) begin
                // Corectie finala pentru rest
                if (A_next[WIDTH-1]) begin
                    cat <= sign_q ? MIN : MAX;
                end else begin
                    cat <= sign_q ? (~A_next + 1'b1) : A_next;
                end

                done <= 1;                                                  // operatia s-a terminat
            end
        end
    end

endmodule

