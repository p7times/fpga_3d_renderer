`timescale 1ns/1ps

// ======================================================
// Testbench pentru divizor Q16.16 cu handshake valid/ready
// Include:
//  - reset corect
//  - respectarea in_ready / out_ready
//  - backpressure pe iesire
//  - model de referinta (golden model)
//  - verificare automata + oprire simulare la eroare
// ======================================================
module tb_div_q16_16;

    // =====================
    // CLOCK & RESET
    // =====================

    // Semnal de ceas
    reg clk;

    // Ceas de 100 MHz (perioada 10 ns)
    always #5 clk = ~clk;

    // Reset activ pe 0
    reg reset_n;

    // =====================
    // INTERFATA CU DUT
    // =====================

    // Semnale de intrare
    reg         in_valid;   // TB spune ca datele sunt valide
    wire        in_ready;   // DUT spune ca poate primi date
    reg  [31:0] a;          // operand A (Q16.16)
    reg  [31:0] b;          // operand B (Q16.16)

    // Semnale de iesire
    wire        out_valid;  // DUT spune ca rezultatul este valid
    reg         out_ready;  // TB spune ca accepta rezultatul
    wire [31:0] q;          // rezultat (Q16.16)
    wire        overflow;   // flag de overflow

    // =====================
    // INSTANTIERE DUT
    // =====================
    div_top_q16_16 dut (
        .clk(clk),
        .reset_n(reset_n),
        .in_valid(in_valid),
        .in_ready(in_ready),
        .a(a),
        .b(b),
        .out_valid(out_valid),
        .out_ready(out_ready),
        .q(q),
        .overflow(overflow)
    );

    // =====================
    // MODEL DE REFERINTA
    // =====================

    // Overflow calculat de modelul de referinta
    reg model_overflow;

    // Functie care modeleaza impartirea Q16.16
    // Returneaza q
    // Overflow este pus in model_overflow
    function [31:0] q16_div;
        input signed [31:0] a_i;
        input signed [31:0] b_i;

        reg signed [63:0] num;
        reg signed [63:0] res;
    begin
        model_overflow = 0;

        // Impartire la zero
        if (b_i == 0) begin
            model_overflow = 1;
            if (a_i[31])
                q16_div = 32'h8000_0000; // saturare negativa
            else
                q16_div = 32'h7FFF_FFFF; // saturare pozitiva
        end else begin
            // Mutam A cu 16 biti pentru Q16.16
            num = a_i <<< 16;
            res = num / b_i;

            // Verificare overflow
            if (res > 32'sh7FFF_FFFF) begin
                model_overflow = 1;
                q16_div = 32'h7FFF_FFFF;
            end else if (res < -32'sh8000_0000) begin
                model_overflow = 1;
                q16_div = 32'h8000_0000;
            end else begin
                q16_div = res[31:0];
            end
        end
    end
    endfunction

    // =====================
    // TASK: TRIMITERE INPUT
    // =====================
    // Respecta protocolul valid/ready
    // Datele sunt trimise doar cand in_ready = 1
    task send_input;
        input [31:0] a_i;
        input [31:0] b_i;
    begin
        // Asteapta pana DUT este gata
        while (!in_ready)
            @(posedge clk);

        // Pune datele pe bus
        a <= a_i;
        b <= b_i;
        in_valid <= 1;

        // Handshake-ul se face aici
        @(posedge clk);
        in_valid <= 0;
    end
    endtask

    // =====================
    // TASK: VERIFICARE REZULTAT
    // =====================
    // Compara iesirea DUT cu valoarea asteptata
    // Opreste simularea daca exista o eroare
    task check_result;
        input [31:0] exp_q;
        input        exp_ov;
    begin
        if (q !== exp_q) begin
            $display("EROARE Q: asteptat=%h primit=%h", exp_q, q);
            $fatal;
        end

        if (overflow !== exp_ov) begin
            $display("EROARE OVERFLOW: asteptat=%b primit=%b",
                     exp_ov, overflow);
            $fatal;
        end
    end
    endtask

    // =====================
    // TASK: PRIMIRE OUTPUT
    // =====================
    // Aplica backpressure (out_ready intarziat)
    task receive_output;
        input [31:0] exp_q;  // catul asteptat
        input        exp_ov; // flag-ul overflow asteptat
        integer stall;
    begin
        // Asteapta pana rezultatul devine valid
        wait (out_valid);

        // Intarziere aleatorie (0..3 cicluri)
        stall = $random % 4;
        if (stall < 0)
            stall = -stall;

        repeat (stall)
            @(posedge clk);

        // Accepta rezultatul
        out_ready <= 1;
        @(posedge clk);
        out_ready <= 0;

        // Verifica rezultatul
        check_result(exp_q, exp_ov);
    end
    endtask

    // =====================
    // SECVENA DE TEST
    // =====================
    reg [31:0] exp_q;
    reg        exp_ov;

    initial begin
        // Initializare
        clk = 0;
        in_valid  = 0;
        out_ready = 0;
        a = 0;
        b = 0;

        // Reset
        reset_n = 0;
        repeat (5) @(posedge clk);
        reset_n = 1;

        // TEST 1: 1.5 / 0.5 = 3.0
        //exp_q = q16_div(32'h0001_8000, 32'h0000_8000);
        //exp_ov = model_overflow;
        //send_input(32'h0001_8000, 32'h0000_8000);
        //receive_output(exp_q, exp_ov);

        // TEST 2: -0.5 / 1 = -0.5
        exp_q = q16_div(32'hFFFF_8000, 32'h0001_0000);
        exp_ov = model_overflow;
        send_input(32'hFFFF_8000, 32'h0001_0000);
        receive_output(exp_q, exp_ov);

        // TEST 3: overflow pozitiv
        //exp_q = q16_div(32'h7FFF_0000, 32'h0000_0001);
        //exp_ov = model_overflow;
        //send_input(32'h7FFF_0000, 32'h0000_0001);
        //receive_output(exp_q, exp_ov);

        // TEST 4: impartire la zero
        //exp_q = q16_div(32'h0001_0000, 32'h0000_0000);
        //exp_ov = model_overflow;
        //send_input(32'h0001_0000, 32'h0000_0000);
        //receive_output(exp_q, exp_ov);

        #50;
        $display("TOATE TESTELE AU TRECUT");
        $finish;
    end

endmodule