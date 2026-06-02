//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : tb_vp
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Testbench pentru Vertex Processor.
//              Verifica functionalitatea etapelor de Rotatie, Proiectie
//              si Mapare prin comparatie cu un model de referinta (Golden Model).
//---------------------------------------------------------------

`timescale 1ns/1ps

module tb_vp;


    // ------------------------
    // Parametri de configurare (NU ATINGE)
    // ------------------------

    parameter PER           = 8;                    // Perioada ceasului (8ns => 125MHz)   
    parameter INT_BITS      = 16;                   // Biti pentru partea intreaga (semnati)
    parameter FRAC_BITS     = 16;                   // Biti pentru partea fractionara
    parameter DATA_WIDTH    = INT_BITS + FRAC_BITS; // Latime totala cuvant
    parameter MAX_R         = 32'h7111_1111;        // Valoare maxima pentru saturatie
    parameter MIN_R         = 32'h8000_0000;        // Valoare minima pentru saturatie
    parameter real SCALE    = 2.0**FRAC_BITS;       // Factor de scalare pentru Q16.16 (2^FRAC_BITS)
        
        
    // ------------------------
    // Parametri modificabili
    // ------------------------
    
    parameter NUM_RAND      = 2000;                 // Numarul de teste aleatorii
    parameter THRESHOLD     = 2;                    // Toleranta acceptata pentru erori (pixeli)
    
    // Constante geometrice in format Q16.16  
    parameter CAMERA_Z      = 32'h0001_8000;        // Distanta camera = 1.5
    parameter FOCAL_LENGHT  = 32'h0000_0666;        // Lungime focala = 0.05 (aprox 50mm)
    parameter SCREEN_WIDTH  = 32'h0140_0000;        // Latime ecran = 320.0
    parameter SCREEN_HEIGHT = 32'h00f0_0000;        // Inaltime ecran = 240.0

    // Setari pentru precizia datelor generate aleatoriu
    integer precision_x_int  = 4;
    integer precision_x_frac = 16;
    
    integer precision_y_int  = 4;
    integer precision_y_frac = 16;
    
    integer precision_z_int  = 4;
    integer precision_z_frac = 16;
    
    
    // ------------------------
    // Semnale de interfata
    // ------------------------

    wire clk, rst_n;                 
    reg  start;                                     // Semnal start catre DUT
    wire valid;                                     // Semnal valid de la DUT

    // Registre pentru intrarile DUT
    reg [2:0]       rotation;                       // Tipul de rotatie (X, Y, Z)
    reg [9:0]       angle;                          // Unghiul de rotatie
    reg [DATA_WIDTH-1:0] f, x, y, z, w, h;          // Parametrii geometrici
    reg [DATA_WIDTH-1:0] cam_z;                     // Pozitia camerei
    
    // Fire pentru iesirile DUT
    wire [DATA_WIDTH-1:0] xs, ys;                   // Coordonate ecran rezultate
    wire [3:0]       dbg_state;                     // Starea interna a FSM-ului DUT
    wire             overflow;                      // Indicator depasire domeniu numeric

    // Variabile statistice pentru raportare
    integer error_count = 0;                        // Numar de erori detectate
    integer overflow_count = 0;                     // Numar de cazuri cu overflow
    integer test_count = 0;                         // Numar total de teste rulate
    real    error_rate;                             // Rata de eroare procentuala
    
    

    // ------------------------
    // Ceas
    // ------------------------

    ck_rst_tb #(
        .CK_SEMIPERIOD(PER/2)
    ) clk_gen (
        .clk(clk),
        .rst_n(rst_n)
    );


    // ------------------------
    // DUT
    // ------------------------

    vertex_processor #(
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .rotation(rotation),
        .angle(angle),
        .f(f), .x(x), .y(y), .z(z), .w(w), .h(h),
        .cam_z(cam_z),
        .xs(xs), .ys(ys),
        .valid(valid),
        .overflow(overflow),
        .dbg_state(dbg_state)
    );


    // ------------------------
    // Task 1: Start operatie
    // ------------------------
    
    // Lanseaza un ciclu de procesare prin activarea semnalului start
    task start_op(
        input [2:0] in_rot, input [9:0] in_ang,
        input [DATA_WIDTH-1:0] in_w, in_h, in_f, in_x, in_y, in_z, in_cam_z
    );
    begin
        // initializam datele de intrare
        angle    = in_ang;
        rotation = in_rot;
        w        = in_w; 
        h        = in_h;
        f        = in_f;
        x        = in_x;
        y        = in_y;
        z        = in_z;
        cam_z    = in_cam_z;
        
        start = 1'b1;       // Activeaza start
        @(posedge clk); #1;
        start = 1'b0;       // Dezactiveaza start dupa un ciclu
    end
    endtask


    // ------------------------
    // Task 2: Definirea Modelului de Referinta (Task-ul de calcul)
    // ------------------------

    // Calculeaza rezultatul ideal folosind aritmetica 'real' (floating point)
    task calculate_vp_gold(
        input [2:0] r_rot, input [9:0] r_ang,
        input real rx, input real ry, input real rz,
        input real rf, input real rw, input real rh,
        input real r_cam_z,
        output real exp_xs_r, output real exp_ys_r
    );
        real xr, yr, zr, xp, yp;
        real ra, r_sin, r_cos;
    begin
        

        // ETAPA 1: ROTATIE
        ra = (r_ang / 2.0) * (3.14159265 / 180.0); // exprimata in radiani
        r_sin = $sin(ra); r_cos = $cos(ra);

        case (r_rot)
            3'b000:  begin xr = rx; yr = ry * r_cos - rz * r_sin; zr = ry * r_sin + rz * r_cos;  end
            3'b001:  begin xr = rx; yr = ry * r_cos + rz * r_sin; zr = -ry * r_sin + rz * r_cos; end
            3'b010:  begin xr = rx * r_cos + rz * r_sin; yr = ry; zr = -rx * r_sin + rz * r_cos; end
            3'b011:  begin xr = rx * r_cos - rz * r_sin; yr = ry; zr = rx * r_sin + rz * r_cos;  end
            3'b100:  begin xr = rx * r_cos - ry * r_sin; yr = rx * r_sin + ry * r_cos; zr = rz;  end
            3'b101:  begin xr = rx * r_cos + ry * r_sin; yr = -rx * r_sin + ry * r_cos; zr = rz; end
            default: begin xr = rx; yr = ry; zr = rz; end
        endcase
        
        zr = zr + r_cam_z;  // Translatie pe axa Z (pozitia camerei)
        
        // ETAPA 2: PROIECTIE
        if (zr == 0.0) begin
            xp = (rf >= 0.0) ? MAX_R : MIN_R;
            yp = (rf >= 0.0) ? MAX_R : MIN_R;
        end else begin
            xp = xr * (rf / zr);    // Formula proiectie X
            yp = yr * (rf / zr);    // Formula proiectie Y
        end

        // --- ETAPA 3: NDC TO SCREEN ---
        exp_xs_r = (xp * rh + rw) / 2.0;    // Mapare X pe latime
        exp_ys_r = (rh - yp * rh) / 2.0;    // Mapare Y cu inversare (axa Y ecran e in jos)
    end
    endtask


    // ------------------------
    // Task: Generator numere in virgula fixa
    // ------------------------
    
    // Produce o valoare aleatorie incadrata in bitii de precizie specificati
    task rand_fp;
        input integer               rand_int_bits;
        input integer               rand_frac_bits;
        output reg [DATA_WIDTH-1:0] result;
    
        reg signed [31:0]      raw;
        integer                rand_max;
    begin

        rand_max = 1 << (rand_int_bits + rand_frac_bits - 1);
        raw      = $random % rand_max;   // Generare valoare bruta cu semn
        
        // Aliniere la formatul Q16.16: se shifteaza pentru a umple partea fractionara
        result = $signed(raw) << (FRAC_BITS - rand_frac_bits);
    end
    endtask
    

    // ------------------------
    // Task 3: Un singur test random (intern)
    // ------------------------

    // Ruleaza o singura iteratie: calculeaza gold, ruleaza DUT, compara
    task run_one_random;
        input [2:0] r_rot;
        input [9:0] r_ang;
        input [DATA_WIDTH-1:0] r_w, r_h, r_f, r_x, r_y, r_z;
        input [DATA_WIDTH-1:0] r_cam_z;
        input integer idx;

        real rw_r, rh_r, rf_r, rx_r, ry_r, rz_r, ex_xs, ex_ys, r_cam_z_r;
        reg signed [DATA_WIDTH-1:0] v_exp_xs, v_exp_ys;
      
        integer diff_x, diff_y;
        real err_x, err_y;
    begin

        // 1. Conversie din Fixed-Point (DUT) in Real (Golden Model)
        r_cam_z_r = $itor($signed(r_cam_z)) / SCALE;
        rf_r      = $itor($signed(r_f))     / SCALE;
        rx_r      = $itor($signed(r_x))     / SCALE;
        ry_r      = $itor($signed(r_y))     / SCALE;
        rz_r      = $itor($signed(r_z))     / SCALE;
        rw_r      = $itor($signed(r_w))     / SCALE;
        rh_r      = $itor($signed(r_h))     / SCALE;
       
        
        // 2. Calcul model de referinta
        calculate_vp_gold(r_rot, r_ang, rx_r, ry_r, rz_r, rf_r, rw_r, rh_r, r_cam_z_r, ex_xs, ex_ys);

        // 3. Conversie inapoi in Fixed-Point pentru comparatie directa
        v_exp_xs = $rtoi(ex_xs * SCALE);
        v_exp_ys = $rtoi(ex_ys * SCALE);


        // 4. Stimulare DUT si asteptare semnal valid
        start_op(r_rot, r_ang, r_w, r_h, r_f, r_x, r_y, r_z, r_cam_z);
        wait(valid == 1'b1);
        @(posedge clk); #2;


        // 5. Verificare eroare fata de pragul THRESHOLD      
        diff_x   = $signed(xs) - $signed(v_exp_xs);
        diff_y   = $signed(ys) - $signed(v_exp_ys);
            
        err_x = $itor(diff_x)/SCALE;    // Eroare X in unitati reale (pixeli)
        err_y = $itor(diff_y)/SCALE;    // Eroare Y in unitati reale (pixeli)
        
        $display("--------------------------------");
        $display("TEST NR. %0d: Rot = %0d Ang = %0.1f | f = %h x = %h y = %h z = %h", 
                    idx, r_rot, r_ang, r_f, r_x, r_y, r_z);
        
        if (overflow) begin
            $display("SKIP [%0d]: Overflow detectat", idx);
            overflow_count = overflow_count + 1;
        end else if ((err_x > THRESHOLD) || (err_x < -THRESHOLD) || (err_y > THRESHOLD) || (err_y < -THRESHOLD)) begin
            error_count = error_count + 1;
            $display("EROARE: xs=%h(exp %h, DIFERENTA=%f pixeli)",  xs, v_exp_xs, (err_x < 0 ? -err_x : err_x));
            $display("        ys=%h(exp %h, DIFERENTA=%f pixeli)",  ys, v_exp_ys, (err_y < 0 ? -err_y : err_y));
        end else begin
            $display("OK [%0d]: ScreenX=%h ScreenY=%h", idx, xs, ys);
        end
    end
    endtask


    // ------------------------
    // Task: Bucla de teste aleatorii
    // ------------------------
    task run_random_tests;
        input integer seed;
        integer i;
        reg [DATA_WIDTH-1:0] rf_t, rx_t, ry_t, rz_t, rw_t, rh_t;
        reg [9:0] ang_t;
        reg [2:0] rot_t;
    begin
        $display("--- START TESTE RANDOM ---");
            
        for (i = 0; i < NUM_RAND; i = i + 1) begin
            // Initializare parametri fixi ptr ecran
            rw_t = SCREEN_WIDTH;
            rh_t = SCREEN_HEIGHT;
            rf_t = FOCAL_LENGHT;
            
            // Generare unghi si tip rotatie
            rot_t = $urandom % 6;
            ang_t = $urandom % 720;
            
            // Generare coordonate Vertex aleatorii
            rand_fp(precision_x_int, precision_x_frac, rx_t); 
            rand_fp(precision_y_int, precision_y_frac, ry_t);
            rand_fp(precision_z_int, precision_z_frac, rz_t);   

            run_one_random(rot_t, ang_t, rw_t, rh_t, rf_t, rx_t, ry_t, rz_t, CAMERA_Z, i);
            test_count = test_count + 1;
        end

        $display("--- SFARSIT TESTE RANDOM (seed=%0d) ---", seed);
    end
    endtask


    // ------------------------
    // Subrutina principala
    // ------------------------

    integer file_out; // Descriptorul de fisier
    
    initial begin
        
        
        // Deschide fisierul pentru scriere
        file_out = $fopen("rezultate_test_vp.txt", "w");
    
        // Verifică dacă fișierul a fost deschis corect
        if (file_out == 0) begin
            $display("EROARE: Nu s-a putut crea fisierul de iesire!");
            $finish;
        end
    
        $display("=== START TEST VERTEX PROCESSOR ===");

        // Initializare semnale si registre
        start = 0; cam_z = CAMERA_Z;
        h = 0; w = 0; f = 0; angle = 0; rotation = 0; x = 0; y = 0; z = 0;
        
        repeat(5) @(posedge clk);
    
        // Rularea testelor
        run_random_tests(1);  // seed fix => reproductibil
        
        // Calcul statistici finale
        error_rate = (error_count * 100.0) / (test_count - overflow_count);

        // Scriem in fisier folosind $fdisplay
        $fdisplay(file_out, "------------------------------------------");
        $fdisplay(file_out, "=== TEST VP FINALIZAT ===");
        $fdisplay(file_out, "Frecventa ceas = %0d MHz", (1/ $itor(PER)) * 1000);
        $fdisplay(file_out, "Format Q       = Q%0d.%0d semnat", INT_BITS, FRAC_BITS);
        $fdisplay(file_out, "Focala         = %0g mm", ($itor(FOCAL_LENGHT) / SCALE) * 1000);
        $fdisplay(file_out, "Latime ecran   = %0d px", $itor(SCREEN_WIDTH) / SCALE);
        $fdisplay(file_out, "Inaltime ecran = %0d px", $itor(SCREEN_HEIGHT) / SCALE);
        $fdisplay(file_out, "Biti random X  = %0d INT, %0d FRAC", precision_x_int, precision_x_frac);
        $fdisplay(file_out, "Biti random Y  = %0d INT, %0d FRAC", precision_y_int, precision_y_frac);
        $fdisplay(file_out, "Biti random Z  = %0d INT, %0d FRAC", precision_z_int, precision_z_frac);
        $fdisplay(file_out, "");
        $fdisplay(file_out, "Prag eroare    = %g pixeli", THRESHOLD);
        $fdisplay(file_out, "Teste totale   = %0d", test_count);
        $fdisplay(file_out, "Erori          = %0d", error_count);
        $fdisplay(file_out, "Overflow-uri   = %0d", overflow_count);
        $fdisplay(file_out, "RATA DE ERORI  = %f %%", error_rate);
        $fdisplay(file_out, "------------------------------------------");
    
        // Recomandat: lasa si display-urile normale ca sa vezi rezultatul si in consola simulatorului
        $display("=== REZULTATE EXPORTATE IN rezultate_test_vp.txt ===");
    
        // Inchide fisierul
        $fclose(file_out);  
        $finish;
    end

endmodule
