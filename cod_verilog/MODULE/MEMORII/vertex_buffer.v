//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : vertex_buffer
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Buffer de memorie BRAM pentru incarcare coordonate vertex-uri.
//
//---------------------------------------------------------------

module vertex_buffer #(
    parameter ADDR_WIDTH = 8,                    // latime adrese, biti (10 biti==> max 256 vertex-uri de mapat)
    parameter INT_BITS   = 16,                   // Numar de biti parte intreaga (include semnul) 
    parameter FRAC_BITS  = 16,                   // Numar de biti parte fractionara
    parameter DATA_WIDTH = INT_BITS + FRAC_BITS  // latime date, biti
)(
    input                         clk,    // ceas
    input                         rst_n,  // reset asincron, activ 0
    input                         cs,     // chip select
    input                         wr,     // comanda scriere
    input      [ADDR_WIDTH-1:0]   addr, // adrese
    input      [3*DATA_WIDTH-1:0] dataIn, // date intrare
    output reg [3*DATA_WIDTH-1:0] dataOut // date iesire
    );

    // datele memoriei BRAM - matrice bidimensionala
    reg [3*DATA_WIDTH-1:0] mem [(2**ADDR_WIDTH)-1:0];

    // scriere in memorie
    always @(posedge clk)
    begin
        if (cs & wr)
            mem[addr] <= dataIn;
    end

    // citire din memorie
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            dataOut <= 0;
        else if (cs & (~wr))
            dataOut <= mem[addr];
    end

endmodule
