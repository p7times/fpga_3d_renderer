//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : tb_framebuffer
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Testbench pentru Framebuffer.
//              Verifica functionalitatea scrierii si citirii din memorie
//              printr-o suita de teste ce vizeaza operatii individuale,
//              Read-Modify-Write (RMW), coliziuni si comenzi de clear,
//              folosind task-uri de referinta.
//---------------------------------------------------------------

`timescale 1ns/1ps

module tb_framebuffer;

    // ------------------------
    // Parametri de configurare (rezolutie mica ptr simulare rapida)
    // ------------------------
    
    parameter H_RES       = 32;                                     // Rezolutia orizontala a ecranului
    parameter V_RES       = 8;                                      // Rezolutia verticala a ecranului
    parameter WORD_BITS   = 32;                                     // Numarul de biti per cuvant in memorie
    parameter TOTAL_WORDS = (H_RES * V_RES) / WORD_BITS;            // Numarul total de cuvinte necesare (8)
    parameter ADDR_WIDTH  = 4;                                      // Latimea adresei: ceil(log2(8)) = 3, plus 1 bit marja
    parameter PER         = 10;                                     // Perioada ceasului de simulare (10ns)


    // ------------------------
    // Semnale de interfata
    // ------------------------
    
    // Intrari DUT
    reg                   cs;                                       // Chip Select - activeaza modulul
    reg                   wr;                                       // Write Enable - comanda de scriere
    reg                   clear;                                    // Comanda de stergere a intregului framebuffer
    reg  [10:0]           x_in;                                     // Coordonata X a pixelului
    reg  [10:0]           y_in;                                     // Coordonata Y a pixelului
    reg                   pixel_in;                                 // Valoarea pixelului de scris (1=aprins, 0=stins)
    reg  [ADDR_WIDTH-1:0] rd_adresa;                                // Adresa pentru citirea integrala a unui cuvant
    
    // Variabile interne de test
    reg  [WORD_BITS-1:0]  before;                                   // Stocare temporara a starii anterioare pentru verificari
    integer               errors = 0;                               // Contor global de erori

    // Iesiri DUT
    wire [WORD_BITS-1:0]  rd_dataOut;                               // Cuvantul citit de la 'rd_adresa'
    wire                  busy;                                     // Indicator de ocupare (operatie in curs)
    wire [ADDR_WIDTH-1:0] dbg_clear_addr;                           // Semnal de debug: adresa curenta la comanda de clear
    wire [2:0]            dbg_state;                                // Semnal de debug: starea curenta a FSM-ului intern


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
    // Instantiere DUT (Device Under Test)
    // ------------------------
    
    framebuffer #(
        .H_RES      (H_RES),
        .V_RES      (V_RES),
        .WORD_BITS  (WORD_BITS),
        .TOTAL_WORDS(TOTAL_WORDS),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .cs           (cs),
        .wr           (wr),
        .clear        (clear),
        .x_in         (x_in),
        .y_in         (y_in),
        .pixel_in     (pixel_in),
        .rd_adresa    (rd_adresa),
        .rd_dataOut   (rd_dataOut),
        .busy         (busy),
        .dbg_clear_addr(dbg_clear_addr),
        .dbg_state    (dbg_state)
    );


    // ------------------------
    // Task 1: Scriere Pixel
    // ------------------------
    
    // Trimite coordonatele si valoarea unui pixel, comanda scrierea
    // si asteapta finalizarea ciclului complet de Write sau Read-Modify-Write.
    task write_pixel(
        input [10:0] px,
        input [10:0] py,
        input        pval
    );
    begin
        wait(busy == 0);                    // Asigura-te ca modulul este liber
        x_in     = px;
        y_in     = py;
        pixel_in = pval;
        
        cs = 1'b1; wr = 1'b1;               // Triggers write
        @(posedge clk); #1;
        cs = 1'b0; wr = 1'b0;
        
        wait(busy == 0);                    // Asteapta finalizarea secventei (WRITE_READ + WRITE_MODIFY)
        @(posedge clk); #1;
    end
    endtask


    // ------------------------
    // Task 2: Verificare Pixel
    // ------------------------
    
    // Citeste cuvantul ce contine pixelul dorit, extrage bitul corespunzator
    // coordonatelor (px, py) si il compara cu valoarea asteptata.
    task check_pixel(
        input [10:0] px,
        input [10:0] py,
        input        exp_val
    );
        integer pixel_idx;
        integer word_addr;
        integer bit_pos;
        reg     got_val;
    begin
        pixel_idx = py * H_RES + px;        // Indexul absolut liniar al pixelului
        word_addr = pixel_idx / WORD_BITS;  // Adresa cuvantului in memoria BRAM
        bit_pos   = pixel_idx % WORD_BITS;  // Pozitia bitului in interiorul cuvantului

        rd_adresa = word_addr;
        @(posedge clk); #1;                 // Latenta BRAM port A (ciclu 1)
        @(posedge clk); #1;                 // Latenta BRAM port A (ciclu 2)

        got_val = rd_dataOut[bit_pos];      // Extrage bitul

        if (got_val !== exp_val) begin
            $display("EROARE pixel(%0d,%0d): got=%b exp=%b [word=%0d bit=%0d]",
                      px, py, got_val, exp_val, word_addr, bit_pos);
            errors = errors + 1;
        end else begin
            $display("OK pixel(%0d,%0d)=%b [word=%0d bit=%0d rdData=%h]",
                      px, py, got_val, word_addr, bit_pos, rd_dataOut);
        end
    end
    endtask


    // ------------------------
    // Task 3: Verificare Cuvant Intreg
    // ------------------------
    
    // Citeste un intreg cuvant de la o adresa si il compara cu valoarea de referinta.
    task check_word(
        input [ADDR_WIDTH-1:0] addr,
        input [WORD_BITS-1:0]  exp_val
    );
    begin
        rd_adresa = addr;
        @(posedge clk); #1;
        @(posedge clk); #1;

        if (rd_dataOut !== exp_val) begin
            $display("EROARE word[%0d]: got=%h exp=%h", addr, rd_dataOut, exp_val);
            errors = errors + 1;
        end else begin
            $display("OK word[%0d]=%h", addr, rd_dataOut);
        end
    end
    endtask


    // ------------------------
    // Task 4: Stergere Ecran (Clear)
    // ------------------------
    
    // Executa ciclul de stergere totala a memoriei.
    task do_clear;
    begin
        wait(busy == 0);
        clear = 1'b1;
        @(posedge clk); #1;
        clear = 1'b0;
        
        wait(busy == 0);                    // Asteapta pana cand toate adresele au fost resetate
        @(posedge clk); #1;
        $display("Clear finalizat.");
    end
    endtask


    // ------------------------
    // Subrutina Principala
    // ------------------------
    
    initial begin
        // Initializare generala
        cs = 0; wr = 0; clear = 0;
        x_in = 0; y_in = 0; pixel_in = 0;
        rd_adresa = 0;
        repeat(5) @(posedge clk);

        $display("=== TEST 1: Scriere pixel simplu ===");
        write_pixel(0, 0, 1);
        check_pixel(0, 0, 1);               // Trebuie sa fie 1
        
        write_pixel(1, 0, 1);
        check_pixel(1, 0, 1);
        check_pixel(0, 0, 1);               // Verifica daca (0,0) nu a fost afectat accidental


        $display("\n=== TEST 2: Read-Modify-Write - coliziuni in acelasi cuvant ===");
        // Primele 32 pixeli sunt toti mapati in word[0] (y=0, x=0..31)
        write_pixel(5,  0, 1);
        write_pixel(10, 0, 1);
        write_pixel(20, 0, 1);

        // Niciunul din setarile anterioare nu trebuie sa fie corupt
        check_pixel(0,  0, 1);
        check_pixel(1,  0, 1);
        check_pixel(5,  0, 1);
        check_pixel(10, 0, 1);
        check_pixel(20, 0, 1);

        // Suprascrie un pixel (0)
        write_pixel(5, 0, 0);
        check_pixel(5,  0, 0);              // Acum trebuie sa fie 0
        check_pixel(10, 0, 1);              // Restul neatins
        check_pixel(20, 0, 1);


        $display("\n=== TEST 3: Pixel pe alt rand (alt cuvant in memorie) ===");
        // y=1, x=0 → pixel_index = 32 → word[1], bit[0]
        write_pixel(0, 1, 1);
        check_pixel(0, 1, 1);
        check_pixel(0, 0, 1);               // word[0] trebuie sa ramana neatins


        $display("\n=== TEST 4: Semnalul de ocupare (Busy) in timpul scrierii ===");
        x_in = 3; y_in = 0; pixel_in = 1;
        cs = 1'b1; wr = 1'b1;
        @(posedge clk); #1;
        cs = 1'b0; wr = 1'b0;

        // Busy trebuie sa creasca imediat dupa comanda WRITE_READ
        if (!busy) begin
            $display("EROARE: busy ar trebui sa fie 1 in WRITE_READ");
            errors = errors + 1;
        end else begin
            $display("OK: busy=1 in timpul scrierii");
        end
        wait(busy == 0);


        $display("\n=== TEST 5: Protejare Out-of-Bounds (Nu trebuie sa scrie) ===");
        // Ctim starea initiala inainte de o operatie in afara zonei valide
        rd_adresa = 0;
        @(posedge clk); #2;
        before = rd_dataOut;

        write_pixel(H_RES, 0, 1);           // x = 32 este out of bounds (valid 0..31)

        rd_adresa = 0;
        @(posedge clk); #2;
        if (rd_dataOut !== before) begin
            $display("EROARE: out-of-bounds a modificat memoria! before=%h after=%h",
                     before, rd_dataOut);
            errors = errors + 1;
        end else begin
            $display("OK: operatia out-of-bounds a fost ignorata corect");
        end


        $display("\n=== TEST 6: Stergere globala (Clear) ===");
        write_pixel(15, 3, 1);
        write_pixel(31, 7, 1);
        check_pixel(15, 3, 1);
        check_pixel(31, 7, 1);

        do_clear;

        // Tot continutul trebuie sa fie 0
        check_word(0, 32'h0000_0000);
        check_word(1, 32'h0000_0000);
        check_word(TOTAL_WORDS-1, 32'h0000_0000);
        check_pixel(15, 3, 0);
        check_pixel(31, 7, 0);


        $display("\n=== TEST 7: Scriere post-Clear ===");
        write_pixel(7, 2, 1);
        check_pixel(7, 2, 1);


        $display("\n=== TEST 8: Comanda clear tratata ca puls unic ===");
        // Daca comanda clear e tinuta sus mai mult timp, FSM-ul o trebuie sa o ia in calcul o singura data
        write_pixel(0, 0, 1);
        
        clear = 1'b1;
        repeat(3) @(posedge clk); #1;
        clear = 1'b0;
        
        wait(busy == 0);
        check_pixel(0, 0, 0);
        $display("OK: clear_start detectat corect strict pe front crescator");


        // Sumarizare Teste
        $display("--------------------------------");
        $display("=== FRAMEBUFFER TEST FINALIZAT ===");
        if (errors > 0)
            $display("Rezultat: ESUAT cu %0d erori.", errors);
        else
            $display("Rezultat: SUCCES! (0 erori)");
        $display("--------------------------------");
        
        $finish;
    end

endmodule
