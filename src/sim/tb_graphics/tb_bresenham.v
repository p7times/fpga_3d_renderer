//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : tb_bresenham
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Testbench pentru Algoritmul Bresenham pentru desenare de linii.
//              Verifica functionalitatea scrierii si citirii din memorie
//              si calcularea punctelor din segment prin comparatie.
//---------------------------------------------------------------
 
`timescale 1ns/1ps
 
module tb_bresenham;
 
 
    // ------------------------
    // Parametri de configurare
    // ------------------------
 
    parameter COORD_BITS = 11;
    parameter H_RES      = 32;          // Rezolutie orizontala mica (ptr simulare)
    parameter V_RES      = 32;          // Rezolutie verticala mica (ptr simulare)
    parameter PER        = 10;          // Perioada ceasului (10ns => 100MHz)
 
 
    // ------------------------
    // Variabile statistice
    // ------------------------
 
    integer errors = 0;                 // Numar de erori detectate
 
 
    // ------------------------
    // Semnale de interfata
    // ------------------------
 
    wire clk, rst_n;
    reg  start;
 
    reg signed [COORD_BITS:0] x0_in, y0_in, x1_in, y1_in;     // Coordonate segment intrare
 
    // Interfata framebuffer (simulata)
    wire [COORD_BITS-1:0] fb_x, fb_y;   // Coordonate pixel catre framebuffer
    wire                  fb_cs;        // Chip select framebuffer
    wire                  fb_wr;        // Write enable framebuffer
    reg                   fb_busy;      // Semnal busy de la framebuffer
 
    wire done;                          // Semnal done de la DUT
    wire [2:0] dbg_state;               // Starea interna a FSM-ului DUT
 
    // Buffere pentru colectarea pixelilor desenati
    integer pixel_log_x [0:4095];
    integer pixel_log_y [0:4095];
    integer pixel_count;
 
 
    // ------------------------
    // Ceas
    // ------------------------
 
    ck_rst_tb #(.CK_SEMIPERIOD(PER/2)) u_ck (
        .clk(clk), .rst_n(rst_n)
    );
 
 
    // ------------------------
    // DUT
    // ------------------------
 
    bresenham #(
        .COORD_BITS(COORD_BITS),
        .H_RES(H_RES),
        .V_RES(V_RES)
    ) dut (
        .clk(clk), .rst_n(rst_n),
        .start(start),
        .x0_in(x0_in), .y0_in(y0_in),
        .x1_in(x1_in), .y1_in(y1_in),
        .fb_x(fb_x), .fb_y(fb_y),
        .fb_cs(fb_cs), .fb_wr(fb_wr),
        .fb_busy(fb_busy),
        .done(done),
        .dbg_state(dbg_state)
    );
 
 
    // ------------------------
    // Simulare framebuffer — inregistreaza pixelii primiti
    // ------------------------
 
    always @(posedge clk) begin
        if (fb_cs && fb_wr && !fb_busy) begin
            pixel_log_x[pixel_count] = fb_x;
            pixel_log_y[pixel_count] = fb_y;
            pixel_count = pixel_count + 1;
 
            // Simuleaza latenta framebuffer (busy 2 cicluri)
            fb_busy <= 1'b1;
        end
    end
 
    // Elibereaza fb_busy dupa 2 cicluri
    reg [1:0] busy_cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            busy_cnt <= 0;
            fb_busy  <= 0;
        end else begin
            if (fb_busy) begin
                if (busy_cnt == 2'd1) begin
                    fb_busy  <= 1'b0;
                    busy_cnt <= 0;
                end else
                    busy_cnt <= busy_cnt + 1;
            end
        end
    end
 
 
    // ------------------------
    // Task 1: Ruleaza o linie si asteapta done
    // ------------------------
 
    task draw_line;
        input signed [COORD_BITS:0] ax, ay, bx, by;
    begin
        pixel_count = 0;
        wait(done == 0);
 
        x0_in = ax; y0_in = ay;
        x1_in = bx; y1_in = by;
        start = 1;
        @(posedge clk); #1;
        start = 0;
 
        wait(done == 1);
        @(posedge clk); #1;
 
        $display("Linie (%0d,%0d)→(%0d,%0d): %0d pixeli desenati",
                  ax, ay, bx, by, pixel_count);
    end
    endtask
 
 
    // ------------------------
    // Task 2: Verifica primul si ultimul pixel (endpoint-uri)
    // ------------------------
 
    task check_endpoints;
        input signed [COORD_BITS:0] ax, ay, bx, by;
    begin
        if (pixel_count == 0) begin
            $display("EROARE: niciun pixel desenat");
            errors = errors + 1;
            disable check_endpoints;
        end
 
        // Primul pixel trebuie sa coincida cu punctul de start
        if (pixel_log_x[0] !== ax || pixel_log_y[0] !== ay) begin
            $display("EROARE start: got(%0d,%0d) exp(%0d,%0d)",
                      pixel_log_x[0], pixel_log_y[0], ax, ay);
            errors = errors + 1;
        end else
            $display("OK start: (%0d,%0d)", pixel_log_x[0], pixel_log_y[0]);
 
        // Ultimul pixel trebuie sa coincida cu punctul de sfarsit
        if (pixel_log_x[pixel_count-1] !== bx ||
            pixel_log_y[pixel_count-1] !== by) begin
            $display("EROARE end: got(%0d,%0d) exp(%0d,%0d)",
                      pixel_log_x[pixel_count-1], pixel_log_y[pixel_count-1], bx, by);
            errors = errors + 1;
        end else
            $display("OK end:   (%0d,%0d)", 
                      pixel_log_x[pixel_count-1], pixel_log_y[pixel_count-1]);
    end
    endtask
 
 
    // ------------------------
    // Task 3: Verifica continuitatea liniei
    //         (fiecare pixel este adiacent cu precedentul)
    // ------------------------
 
    task check_continuity;
        integer i;
        integer dx_step, dy_step;
    begin
        for (i = 1; i < pixel_count; i = i + 1) begin
            dx_step = pixel_log_x[i] - pixel_log_x[i-1];
            dy_step = pixel_log_y[i] - pixel_log_y[i-1];
 
            // Fiecare pas trebuie sa fie maxim 1 pixel in orice directie
            if (dx_step < -1 || dx_step > 1 ||
                dy_step < -1 || dy_step > 1) begin
                $display("EROARE continuitate la pixel %0d: salt (%0d,%0d)",
                          i, dx_step, dy_step);
                errors = errors + 1;
            end
        end
        $display("OK continuitate: %0d pixeli contigui", pixel_count);
    end
    endtask
 
 
    // ------------------------
    // Task 4: Verifica numarul de pixeli asteptat
    //         (exact pentru linii orizontale/verticale)
    // ------------------------
 
    task check_pixel_count;
        input integer exp_count;
    begin
        if (pixel_count !== exp_count) begin
            $display("EROARE numar pixeli: got=%0d exp=%0d",
                      pixel_count, exp_count);
            errors = errors + 1;
        end else
            $display("OK numar pixeli: %0d", pixel_count);
    end
    endtask
 
 
    // ------------------------
    // Subrutina principala
    // ------------------------
 
    initial begin
        start   = 0;
        fb_busy = 0;
        x0_in = 0; y0_in = 0;
        x1_in = 0; y1_in = 0;
        pixel_count = 0;
        repeat(5) @(posedge clk);
 
 
  //      $display("=== TEST 1: Linie orizontala ===");
   //     draw_line(0, 0, 7, 0);
  //      check_endpoints(0, 0, 7, 0);
  //      check_pixel_count(8);       // 8 pixeli: x=0..7
 //       check_continuity;
 
 
  //      $display("=== TEST 2: Linie verticala ===");
 //       draw_line(5, 0, 5, 7);
 //       check_endpoints(5, 0, 5, 7);
 //       check_pixel_count(8);
  //      check_continuity;
 
 
        $display("=== TEST 3: Linie diagonala 45 grade ===");
        draw_line(0, 0, 7, 7);
        check_endpoints(0, 0, 7, 7);
        check_pixel_count(8);
        check_continuity;
 
 
        $display("=== TEST 4: Linie in directie negativa ===");
        draw_line(7, 7, 0, 0);
        check_endpoints(7, 7, 0, 0);
        check_pixel_count(8);
        check_continuity;
 
 
        $display("=== TEST 5: Linie mai abrupta pe Y ===");
        draw_line(0, 0, 3, 7);
        check_endpoints(0, 0, 3, 7);
        check_continuity;
 
 
        $display("=== TEST 6: Punct (linie degenerata) ===");
        draw_line(5, 5, 5, 5);
        check_endpoints(5, 5, 5, 5);
        check_pixel_count(1);       // Un singur pixel
 
 
        $display("=== TEST 7: Linie partial out-of-bounds ===");
        // Incepe in ecran, iese afara; pixelii valizi: x=28..31
        draw_line(28, 5, 35, 5);    // x=35 e in afara H_RES=32
        check_continuity;
        check_pixel_count(4);
 
 
        $display("=== TEST 8: Linie complet out-of-bounds ===");
        draw_line(33, 33, 40, 40);  // Complet in afara ecranului
        check_pixel_count(0);       // Niciun pixel desenat
        $display("OK: linie out-of-bounds ignorata corect");
 
 
        $display("--------------------------------");
        $display("=== BRESENHAM TEST FINALIZAT ===");
        $display("Erori: %0d", errors);
        $finish;
    end
 
endmodule

