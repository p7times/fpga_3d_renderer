//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : vertex_buffer
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Buffer de memorie BRAM pentru stocarea vertecsilor 3D.
//              Fiecare locatie contine un vertex complet format din coordonate
//              fixed-point (X, Y, Z), utilizate in pipeline-ul de transformari geometrice.
//
//              Permite acces sincron pentru incarcarea modelelor 3D si procesarea
//              secventiala in cadrul pipeline-ului grafic.
//---------------------------------------------------------------

module vertex_buffer #(
    parameter ADDR_WIDTH = 8,                   // Latime adrese, in biti (8 biti==> max 256 vertecsi de mapat)
    parameter INT_BITS   = 16,                  // Numar de biti parte intreaga (include semnul) 
    parameter FRAC_BITS  = 16,                  // Numar de biti parte fractionara
    parameter DATA_WIDTH = INT_BITS + FRAC_BITS // Latime date, in biti
)(
    input                         clk,          // Semnal de ceas
    input                         rst_n,        // Reset asincron (activ in 0)
    input                         cs,           // Chip select
    input                         wr,           // Comanda scriere/citire
    input      [ADDR_WIDTH-1:0]   addr,         // Adresa unui vertex
    input      [3*DATA_WIDTH-1:0] dataIn,       // Date de intrare: coordonate X,Y,Z ale unui vertex
    output reg [3*DATA_WIDTH-1:0] dataOut       // Date de iesire
);

    // Datele memoriei BRAM - matrice bidimensionala
    reg [3*DATA_WIDTH-1:0] mem [(2**ADDR_WIDTH)-1:0];

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

endmodule // vertex_buffer
