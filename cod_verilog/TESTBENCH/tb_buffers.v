//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : tb_buffers
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Testbench pentru Point Buffer, Edge Buffer si Vertex Buffer.
//              Verifica functionalitatea de baza (scriere si citire) a
//              memoriilor interne in care se stocheaza primitivele 3D
//              (varfuri brute, muchii mapate prin index, puncte proiectate pe ecran).
//---------------------------------------------------------------

`timescale 1ns/1ps

module tb_buffers;

    // ------------------------
    // Parametri de configurare
    // ------------------------
    
    parameter ADDR_WIDTH = 4;                                           // Latimea adresei (16 locatii maxim, rapid ptr simulare)
    parameter INT_BITS   = 16;                                          // Partea intreaga a formatului Q16.16
    parameter FRAC_BITS  = 16;                                          // Partea fractionara a formatului Q16.16
    parameter DATA_WIDTH = INT_BITS + FRAC_BITS;                        // Latime cuvant date = 32 biti
    parameter VERT_ADDR  = ADDR_WIDTH;                                  // Latimea indexului catre vertex-uri
    parameter PER        = 10;                                          // Perioada ceasului simularii (10ns)


    // ------------------------
    // Semnale de interfata
    // ------------------------

    // Comenzi Generale
    integer errors = 0;                                                 // Contor de erori
    
    // Semnale Vertex Buffer (stocheaza coordonate x, y, z in format Q16.16)
    reg                     vb_cs, vb_wr;
    reg  [ADDR_WIDTH-1:0]   vb_addr;
    reg  [3*DATA_WIDTH-1:0] vb_dataIn;                                  // Date impachetate: {z, y, x} (96 biti total)
    wire [3*DATA_WIDTH-1:0] vb_dataOut;

    // Semnale Edge Buffer (stocheaza 2 indecsi catre Vertex Buffer per muchie)
    reg                     eb_cs, eb_wr;
    reg  [ADDR_WIDTH-1:0]   eb_addr;
    reg  [2*VERT_ADDR-1:0]  eb_dataIn;                                  // Date impachetate: {idx_b, idx_a} (ex: 8 biti ptr adrese de 4)
    wire [2*VERT_ADDR-1:0]  eb_dataOut;

    // Semnale Point Buffer (stocheaza rezultatul final mapat pe ecran 2D, x si y)
    reg                     pb_cs, pb_wr;
    reg  [ADDR_WIDTH-1:0]   pb_addr;
    reg  [2*DATA_WIDTH-1:0] pb_dataIn;                                  // Date impachetate: {ys, xs} (64 biti total)
    wire [2*DATA_WIDTH-1:0] pb_dataOut;


    // ------------------------
    // Generator de Ceas
    // ------------------------

    wire clk;
    wire rst_n;

    ck_rst_tb #(
        .CK_SEMIPERIOD(PER/2)
    ) u_ck_rst (
        .clk(clk),
        .rst_n(rst_n)
    );


    // ------------------------
    // Instantiere DUT-uri
    // ------------------------
    
    vertex_buffer #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .INT_BITS  (INT_BITS),
        .FRAC_BITS (FRAC_BITS)
    ) u_vb (
        .clk    (clk),
        .rst_n  (rst_n),
        .cs     (vb_cs),
        .wr     (vb_wr),
        .addr   (vb_addr),
        .dataIn (vb_dataIn),
        .dataOut(vb_dataOut)
    );

    edge_buffer #(
        .EDGE_COUNT(ADDR_WIDTH),
        .VERT_ADDR (VERT_ADDR)
    ) u_eb (
        .clk    (clk),
        .rst_n  (rst_n),
        .cs     (eb_cs),
        .wr     (eb_wr),
        .addr   (eb_addr),
        .dataIn (eb_dataIn),
        .dataOut(eb_dataOut)
    );

    point_buffer #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .INT_BITS  (INT_BITS),
        .FRAC_BITS (FRAC_BITS)
    ) u_pb (
        .clk    (clk),
        .rst_n  (rst_n),
        .cs     (pb_cs),
        .wr     (pb_wr),
        .addr   (pb_addr),
        .dataIn (pb_dataIn),
        .dataOut(pb_dataOut)
    );


    // ------------------------
    // Task-uri: Vertex Buffer
    // ------------------------
    
    // Scrie un set (X, Y, Z) la adresa data
    task write_vertex(
        input [ADDR_WIDTH-1:0] addr,
        input [DATA_WIDTH-1:0] x,
        input [DATA_WIDTH-1:0] y,
        input [DATA_WIDTH-1:0] z
    );
    begin
        vb_addr   <= addr;
        vb_dataIn <= {z, y, x};
        vb_cs     <= 1'b1;
        vb_wr     <= 1'b1;
        @(posedge clk); #1;
        vb_cs     <= 1'b0;
        vb_wr     <= 1'b0;
    end
    endtask

    // Citeste un set (X, Y, Z) si il compara cu valoarea asteptata
    task read_vertex(
        input [ADDR_WIDTH-1:0] addr,
        input [DATA_WIDTH-1:0] exp_x,
        input [DATA_WIDTH-1:0] exp_y,
        input [DATA_WIDTH-1:0] exp_z
    );
        reg [DATA_WIDTH-1:0] got_x, got_y, got_z;
    begin
        vb_addr <= addr;
        vb_cs   <= 1'b1;
        vb_wr   <= 1'b0;
        @(posedge clk); #1;
        vb_cs   <= 1'b0;
        @(posedge clk); #1; // Asteapta latenta interna a memoriei (1 ciclu)

        got_x = vb_dataOut[  DATA_WIDTH-1:0          ];
        got_y = vb_dataOut[2*DATA_WIDTH-1:DATA_WIDTH ];
        got_z = vb_dataOut[3*DATA_WIDTH-1:2*DATA_WIDTH];

        if (got_x !== exp_x || got_y !== exp_y || got_z !== exp_z) begin
            $display("EROARE vertex[%0d]: got x=%h y=%h z=%h | exp x=%h y=%h z=%h",
                      addr, got_x, got_y, got_z, exp_x, exp_y, exp_z);
            errors = errors + 1;
        end else begin
            $display("OK vertex[%0d]: x=%h y=%h z=%h", addr, got_x, got_y, got_z);
        end
    end
    endtask


    // ------------------------
    // Task-uri: Edge Buffer
    // ------------------------
    
    // Scrie indecsii punctelor ce formeaza o muchie (A si B)
    task write_edge(
        input [ADDR_WIDTH-1:0] addr,
        input [VERT_ADDR-1:0]  idx_a,
        input [VERT_ADDR-1:0]  idx_b
    );
    begin
        eb_addr   <= addr;
        eb_dataIn <= {idx_b, idx_a};
        eb_cs     <= 1'b1;
        eb_wr     <= 1'b1;
        @(posedge clk); #1;
        eb_cs     <= 1'b0;
        eb_wr     <= 1'b0;
    end
    endtask

    // Citeste o muchie definita si o compara cu parametrii de referinta
    task read_edge(
        input [ADDR_WIDTH-1:0] addr,
        input [VERT_ADDR-1:0]  exp_a,
        input [VERT_ADDR-1:0]  exp_b
    );
        reg [VERT_ADDR-1:0] got_a, got_b;
    begin
        eb_addr <= addr;
        eb_cs   <= 1'b1;
        eb_wr   <= 1'b0;
        @(posedge clk); #1;
        eb_cs   <= 1'b0;
        @(posedge clk); #1;

        got_a = eb_dataOut[  VERT_ADDR-1:0        ];
        got_b = eb_dataOut[2*VERT_ADDR-1:VERT_ADDR];

        if (got_a !== exp_a || got_b !== exp_b) begin
            $display("EROARE edge[%0d]: got (%0d,%0d) | exp (%0d,%0d)",
                      addr, got_a, got_b, exp_a, exp_b);
            errors = errors + 1;
        end else begin
            $display("OK edge[%0d]: (%0d, %0d)", addr, got_a, got_b);
        end
    end
    endtask


    // ------------------------
    // Task-uri: Point Buffer
    // ------------------------
    
    // Scrie coordonatele 2D (Xs, Ys) mapate catre ecran de la iesirea din Vertex Processor
    task write_point(
        input [ADDR_WIDTH-1:0] addr,
        input [DATA_WIDTH-1:0] xs,
        input [DATA_WIDTH-1:0] ys
    );
    begin
        pb_addr   <= addr;
        pb_dataIn <= {ys, xs};
        pb_cs     <= 1'b1;
        pb_wr     <= 1'b1;
        @(posedge clk); #1;
        pb_cs     <= 1'b0;
        pb_wr     <= 1'b0;
    end
    endtask

    // Citeste punctul si il compara cu rezultatul proiectat valid
    task read_point(
        input [ADDR_WIDTH-1:0] addr,
        input [DATA_WIDTH-1:0] exp_xs,
        input [DATA_WIDTH-1:0] exp_ys
    );
        reg [DATA_WIDTH-1:0] got_xs, got_ys;
    begin
        pb_addr <= addr;
        pb_cs   <= 1'b1;
        pb_wr   <= 1'b0;
        @(posedge clk); #1;
        pb_cs   <= 1'b0;
        @(posedge clk); #1;

        got_xs = pb_dataOut[  DATA_WIDTH-1:0          ];
        got_ys = pb_dataOut[2*DATA_WIDTH-1:DATA_WIDTH ];

        if (got_xs !== exp_xs || got_ys !== exp_ys) begin
            $display("EROARE point[%0d]: got xs=%h ys=%h | exp xs=%h ys=%h",
                      addr, got_xs, got_ys, exp_xs, exp_ys);
            errors = errors + 1;
        end else begin
            $display("OK point[%0d]: xs=%h ys=%h", addr, got_xs, got_ys);
        end
    end
    endtask


    // ------------------------
    // Subrutina Principala de Testare
    // ------------------------
    
    initial begin
        // Init la nivel zero logic
        vb_cs = 0; vb_wr = 0; vb_addr = 0; vb_dataIn = 0;
        eb_cs = 0; eb_wr = 0; eb_addr = 0; eb_dataIn = 0;
        pb_cs = 0; pb_wr = 0; pb_addr = 0; pb_dataIn = 0;
        repeat(3) @(posedge clk);

        $display("=== TEST 1: VERTEX BUFFER ===");
        write_vertex(0, 32'h00010000, 32'h00020000, 32'h00030000); // x=1.0,  y=2.0, z=3.0
        write_vertex(1, 32'hFFFF0000, 32'h00008000, 32'h00014000); // x=-1.0, y=0.5, z=1.25
        write_vertex(2, 32'h00000000, 32'h00000000, 32'h00010000); // x=0,    y=0,   z=1.0
        
        read_vertex(0, 32'h00010000, 32'h00020000, 32'h00030000);
        read_vertex(1, 32'hFFFF0000, 32'h00008000, 32'h00014000);
        read_vertex(2, 32'h00000000, 32'h00000000, 32'h00010000);

        // Test CS inactiv (protectie memorie)
        vb_addr   = 3; 
        vb_dataIn = {3{32'hDEADBEEF}};
        vb_cs     = 1'b0; // Dezactivat
        vb_wr     = 1'b1; // Comanda data degeaba
        @(posedge clk); #1;
        read_vertex(3, 32'hx, 32'hx, 32'hx); // Valoare nedefinita dovedeste ca scrierea nu a functionat


        $display("\n=== TEST 2: EDGE BUFFER ===");
        write_edge(0, 4'd0, 4'd1); // Muchie de la Vertex 0 la Vertex 1
        write_edge(1, 4'd1, 4'd2); // Muchie de la Vertex 1 la Vertex 2
        write_edge(2, 4'd2, 4'd0); // Muchie de la Vertex 2 la Vertex 0 (inchide un triunghi)
        
        read_edge(0, 4'd0, 4'd1);
        read_edge(1, 4'd1, 4'd2);
        read_edge(2, 4'd2, 4'd0);


        $display("\n=== TEST 3: POINT BUFFER ===");
        write_point(0, 32'h00A00000, 32'h00780000); // xs=160.0, ys=120.0 (Centrul ecranului 320x240)
        write_point(1, 32'h00000000, 32'h00000000); // xs=0,     ys=0     (Coltul ecranului)
        write_point(2, 32'h01400000, 32'h00F00000); // xs=320.0, ys=240.0 (Limita opusa)
        
        read_point(0, 32'h00A00000, 32'h00780000);
        read_point(1, 32'h00000000, 32'h00000000);
        read_point(2, 32'h01400000, 32'h00F00000);


        $display("--------------------------------");
        if (errors > 0)
            $display("=== BUFFERS TEST FINALIZAT: ESUAT cu %0d erori ===", errors);
        else
            $display("=== BUFFERS TEST FINALIZAT: SUCCES! (0 erori) ===");
        $display("--------------------------------");
        
        $finish;
    end

endmodule
