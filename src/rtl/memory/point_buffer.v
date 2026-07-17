//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : point_buffer
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Buffer de memorie BRAM pentru coordonate de puncte procesate in format fixed-point.
//              Fiecare intrare contine doua coordonate (X, Y) sau rezultate intermediare
//              ale transformarii geometrice.
//
//              Valorile sunt stocate in format signed Q(INT_BITS.FRAC_BITS), permitand reprezentare
//              precisa a coordonatelor sub-pixel.
//
//              Este utilizat ca buffer intermediar intre unitatile de transformare (Vertex Processor)
//              si etapa de rasterizare (Bresenham / scan conversion).
//---------------------------------------------------------------

`timescale 1ns / 1ps

module point_buffer #(
    parameter ADDR_WIDTH = 8,                   // Latime adrese, in biti (10 biti==> max 1024 vertecsi de mapat)
    parameter INT_BITS   = 16,                  // Numar de biti parte intreaga (include semnul)
    parameter FRAC_BITS  = 16,                  // Numar de biti parte fractionara
    parameter DATA_WIDTH = INT_BITS + FRAC_BITS // Latime date, in biti
)(
    input                         clk,          // Semnal de ceas
    input                         rst_n,        // Reset asincron (activ in 0)
    input                         cs,           // Chip select
    input                         wr,           // Comanda scriere/citire
    input      [ADDR_WIDTH-1:0]   addr,         // Adresa unui punct
    input      [2*DATA_WIDTH-1:0] dataIn,       // Date de intrare: [ys | xs] din vertex_processor
    output reg [2*DATA_WIDTH-1:0] dataOut       // Date de iesire
);

    // Datele memoriei BRAM - matrice bidimensionala
    reg [2*DATA_WIDTH-1:0] mem [(2**ADDR_WIDTH)-1:0];

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

endmodule // point_buffer
