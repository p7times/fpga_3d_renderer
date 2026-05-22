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
//              Valorile sunt stocate in format Q(INT_BITS.FRAC_BITS), permitand reprezentare
//              precisa a coordonatelor sub-pixel.
//
//              Este utilizat ca buffer intermediar intre unitatile de transformare (Vertex Processor)
//              si etapa de rasterizare (Bresenham / scan conversion).
//---------------------------------------------------------------

module point_buffer #(
    parameter ADDR_WIDTH = 10,
    parameter INT_BITS   = 16,
    parameter FRAC_BITS  = 16,
    parameter DATA_WIDTH = INT_BITS + FRAC_BITS
)(
    input                         clk,
    input                         rst_n,  // reset asincron, activ 0
    input                         cs,
    input                         wr,
    input      [ADDR_WIDTH-1:0]   addr,
    input      [2*DATA_WIDTH-1:0] dataIn, // [ys | xs] din VPU
    output reg [2*DATA_WIDTH-1:0] dataOut
);

    reg [2*DATA_WIDTH-1:0] mem [(2**ADDR_WIDTH)-1:0];

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
