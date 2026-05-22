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
//              reprezentand conectivitatea geometrica a modelelor 3D.
//
//              Este utilizat in etapa de constructie a topologiei obiectului,
//              permitand acces rapid la relatiile dintre varfuri pentru generarea
//              segmentelor de muchii in pipeline-ul de rasterizare.
//---------------------------------------------------------------

module edge_buffer #(
    parameter EDGE_COUNT = 10,            // biti addr: 10 => 1024 muchii
    parameter VERT_ADDR  = 8              // biti per index vertex (= ADDR_WIDTH din vertex_buffer)
)(
    input                        clk,
    input                        rst_n,  // reset asincron, activ 0
    input                        cs,
    input                        wr,
    input      [EDGE_COUNT-1:0]  addr,
    input      [2*VERT_ADDR-1:0] dataIn,  // [idx_B | idx_A]
    output reg [2*VERT_ADDR-1:0] dataOut
);
    reg [2*VERT_ADDR-1:0] mem [(2**EDGE_COUNT)-1:0];

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
