module div_data #(
    parameter N = 32,    // Latime totala Q16.16
    parameter FRAC = 16  // Biti fractionali
)(
    input ck,
    input reset_n,          // Reset asincron activ LOW
    input ld,               // Load initial
    input [N-1:0] deimpartit,
    input [N-1:0] impartitor,
    output reg done,        // Finalizare
    output reg [N-1:0] cat,  
    output reg [N-1:0] rest
);

reg [N:0]   P;      // Rest partial
reg [N-1:0] A;      // Cat
reg [N-1:0] B;      // Divizor
reg [N-1:0] count;  // Contor iteratii
reg sign_q;

reg [N:0] P_next;   // Rest intermediar
reg [N-1:0] A_next; // Cat intermediar
reg [N:0] P_corr;   // Corecție finala

always @(posedge ck or negedge reset_n) begin
    // Verificare reset asincron activ LOW
    if (!reset_n) begin
        // Resetul initializeaza toate registrele
        P <= 0;        // rest parțial
        A <= 0;        // cat
        B <= 0;        // divizor
        count <= 0;    // contor iteratii
        done <= 0;     // semnal ca operatia nu s-a terminat
        cat <= 0; rest <= 0;// iesirile finale (cat si rest)
    end
    // Initializare cand ld este activ (puls de incarcare)
    else if (ld) begin
        // caz special: impartirea la zero
        if (impartitor == 0) begin
            cat <= 0;
            rest <= deimpartit;
            P <= 0;
            A <= 0;
            B <= 0;
            count <= 0;
            done <= 1;   // terminam instant
        end else begin
            P <= 0;           // reseteaza restul parțial
            A <= deimpartit;    // incarca dividendul in registru cat
            B <= impartitor;     // incarca divizorul
            count <= 0;       // reseteaza contorul de iteratii
            done <= 0;        // operatia nu e gata
        end
    end
    // Executa pasii algoritmului non-restoring daca nu e gata
    else if (!done) begin
        // STEP 1: SHIFT LEFT combinat P:A
        // Se muta P cu un bit la stanga si se adauga cel mai semnificativ bit din A
        P_next = {P[N-1:0], A[N-1]};
        A_next = {A[N-2:0], 1'b0}; // shift stanga cat

        // STEP 2: STEP NON-RESTORING
        // Daca P este negativ (bitul N=1) adauga B
        // Daca P este pozitiv scade B
        if (P[N])
            P_next = P_next + B;
        else
            P_next = P_next - B;

        // STEP 3: Determina bitul curent al catului
        // Daca P_next negativ => bit cat = 0, altfel 1
        A_next[0] = ~P_next[N];

        // STEP 4: Commit valori
        P <= P_next;
        A <= A_next;
        count <= count + 1; // incrementeaza contorul de pasi

        // STEP 5: Verifica finalizare
        if (count == N-1) begin
            // Corectie finala pentru rest
            P_corr = P_next[N] ? (P_next + B) : P_next;
            P <= P_corr;
            cat <= A_next;          // cat final
            rest <= P_corr[N-1:0];   // rest final
            done <= 1;             // semnal ca operatia s-a terminat
        end
    end
end

endmodule

