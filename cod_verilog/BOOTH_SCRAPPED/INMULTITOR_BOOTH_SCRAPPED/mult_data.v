module mult_data #(
    parameter N = 16
)(
    input ck,
    input reset_n,            // Reset asincron activ LOW
    input ld,                 // Load initial
    input [N-1:0] deinmultit,
    input [N-1:0] inmultitor,
    output reg done,          // Finalizare
    output reg [2*N-1:0] produs
);

reg [N:0] P;         // MSB produs
reg [N-1:0] A;       // LSB produs
reg [N-1:0] B;       // Inmultitor
reg BS;              // bit suplimentar Booth
reg [N-1:0] count;   // Contor iteratii, ce numara de la 0-(N-1), dar setat pe N biti ptr siguranta
reg [N-1:0] A_shift; // registru auxiliar pentru shift

always @(posedge ck or negedge reset_n) begin
    // Verificare reset asincron activ LOW
    if (!reset_n) begin
        // Resetul initializeaza toate registrele
        P <= 0;        // rest parțial
        A <= 0;        // deinmultit
        B <= 0;        // inmultitor
        BS <= 0;       // bitul Booth
        count <= 0;    // contor iteratii
        done <= 0;     // semnal ca operatia nu s-a terminat
        produs <= 0;   // produsul final
    end
    // Initializare cand ld este activ (puls de incarcare)
    else if (ld) begin
        // Incarcare date initiale
        P <= 0;         
        A <= deinmultit;  
        B <= inmultitor;  
        BS <= 0;
        count <= 0;       // reseteaza contorul de iteratii
        done <= 0;        // operatia nu e gata
    end
    // Executa pasii algoritmului non-restoring daca nu e gata
    else if (!done) begin
        if (count < N) begin
            // Pas Booth
            case ({A[0], BS})
                2'b01: P <= P + B;
                2'b10: P <= P - B;
            endcase

            // Shift dreapta cu semn
            {P, A, BS} <= {{P[N], P}, A} >>> 1;
            count <= count + 1;
        end else begin
            // Algoritmul s-a terminat
            produs <= {P, A};
            done <= 1;
        end
    end
end

endmodule

