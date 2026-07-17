//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : edge_buffer
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Buffer de memorie BRAM pentru stocarea index-urilor de muchii.
//              Fiecare locatie memoreaza o pereche de indici de varfuri (idx_A, idx_B),
//              reprezentand o muchie a modelelului 3D.
//
//              Este utilizat in etapa de constructie a topologiei obiectului,
//              permitand acces rapid la relatiile dintre varfuri pentru generarea
//              segmentelor de muchii in pipeline-ul de rasterizare.
//---------------------------------------------------------------

`timescale 1ns / 1ps

module edge_buffer #(
    parameter EDGE_ADDR  = 10,              // Latime adrese muchii, in biti (10 biti==> max 1024 muchii de mapat)
    parameter VERT_ADDR  = 8                // Latimea adresei de memorie a unui vertex, in biti (= ADDR_WIDTH din vertex_buffer)
)(
    input                        clk,       // Semnal de ceas
    input                        rst_n,     // Reset asincron (activ in 0)
    input                        cs,        // Chip select
    input                        wr,        // Comanda scriere/citire
    input      [EDGE_ADDR-1:0]  addr,       // Adresa unei muchii
    input      [2*VERT_ADDR-1:0] dataIn,    // Date de intrare: [idx_B | idx_A]
    output reg [2*VERT_ADDR-1:0] dataOut    // Date de iesire
);

    // Datele memoriei BRAM - matrice bidimensionala
    reg [2*VERT_ADDR-1:0] mem [(2**EDGE_ADDR)-1:0];

    // Scriere in memorie
    always @(posedge clk)
    begin
        if (cs & wr)
            mem[addr] <= dataIn;
    end

    // Citire din memorie
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            dataOut <= 0;
        else if (cs & (~wr))
            dataOut <= mem[addr];
    end

endmodule // edge_buffer
