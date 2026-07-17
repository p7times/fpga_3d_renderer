//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : config_block
// Autor      : Petru-Andrei BRASOVEANU  
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Bloc de configurare si incarcare automata a 
//              geometriei din memorii ROM interne (fisiere .mem)
//              catre acceleratorul grafic 3D. Gestioneaza animatia
//              prin incrementarea unghiului si controlul cadrelor.
//---------------------------------------------------------------

`timescale 1ns / 1ps

module config_block #(
    parameter INT_BITS      = 16,                       // Numar de biti parte intreaga (include semnul)
    parameter FRAC_BITS     = 16,                       // Numar de biti parte fractionara
    parameter DATA_WIDTH    = INT_BITS + FRAC_BITS,     // Latime date coordinate (Q16.16)

    parameter VERT_ADDR     = 12,                        // Latime adrese vertex buffer
    parameter EDGE_ADDR     = 10,                       // Latime adrese edge buffer
    
    // Parametri pentru forma geometrica incarcata
    parameter NUM_VERTICES  = 8,                        // Numar de varfuri
    parameter NUM_EDGES     = 12,                       // Numar de muchii
    parameter VERT_FILE     = "vertices.mem",           // Fisier initializare varfuri
    parameter EDGE_FILE     = "edges.mem",              // Fisier initializare muchii

    parameter COORD_BITS    = 12,
    parameter H_RES         = 1280,
    parameter V_RES         = 720,
    
    parameter FOCAL         = 1,
    parameter CAM_Z         = 2,
    
    parameter WORD_BITS     = 32    
)(
    input                           clk,                    // Semnal de ceas
    input                           rst_n,                  // Reset asincron (activ in 0)
    input [2:0]                     sw,                     // Switch-uri fizice placa
    
    // Butoane pentru control model
    input                           btn_up,                 // ex: btnU, momentan nefolosit
    input                           btn_down,               // ex: btnD, momentan nefolosit
    input                           btn_left,               // Buton pentru CCW
    input                           btn_right,              // Buton pentru CW
    
    // Semnale de control catre top_graphics
    output reg                      buffer_mode,            // Control mod magistrala (1 = Config, 0 = Hardware)
    output reg                      start_frame,            // Impuls pornire cadru nou
    output reg [VERT_ADDR-1:0]      vertex_count,           // Numarul total de varfuri transmise
    output reg [EDGE_ADDR-1:0]      edge_count,             // Numarul total de muchii transmise
    output reg [9:0]                angle,                  // Unghiul curent de rotatie
    output reg [DATA_WIDTH-1:0]     focal,                  // Distanta focala curenta
    output reg [DATA_WIDTH-1:0]     camz,                   // Distanta fata de camera
    output     [1:0]                rotation_type,          // Tipul axei de rotatie (X, Y, Z)
    input                           ready,
    input                           frame_done,             // Flag terminare randare cadru
    
    // Interfata de scriere catre Vertex Buffer (top_graphics)
    output reg [3*DATA_WIDTH-1:0]   vb_wr_data,
    output reg [VERT_ADDR-1:0]      vb_wr_addr,
    output reg                      vb_wr_en,
    output reg                      vb_wr_cs,
    
    // Interfata de scriere catre Edge Buffer (top_graphics)
    output reg [EDGE_ADDR-1:0]      eb_wr_addr,
    output reg [2*VERT_ADDR-1:0]    eb_wr_data,
    output reg                      eb_wr_en,
    output reg                      eb_wr_cs
   
);

    localparam [DATA_WIDTH-1:0] STEP = 1 << (FRAC_BITS - 4);  // pas mic, A SE AJUSTA
    
    // Mapare switch-uri pentru axa de rotatie (00 = X, 01 = Y, 10 = Z)
    assign rotation_type = sw[1:0];
    
    wire [2:0] dbg_config_state;// Monitorizare stare curenta FSM
    // -------------------------------------------------------------------------
    // 1. Definire Memorii Interne (ROM) si initializare din fisiere
    // -------------------------------------------------------------------------
    reg [3*DATA_WIDTH-1:0] rom_vertices [(2**VERT_ADDR)-1:0];
    reg [2*VERT_ADDR-1:0]  rom_edges    [(2**EDGE_ADDR)-1:0];

    initial begin
        $readmemh(VERT_FILE, rom_vertices);
        $readmemh(EDGE_FILE, rom_edges);
    end


    // -------------------------------------------------------------------------
    // 2. Definitie stari FSM
    // -------------------------------------------------------------------------
    localparam INIT             = 3'b000,   // 0.Starea initiala de reset/pregatire
               LOAD_VERT        = 3'b001,   // 1.Incarcare secventiala varfuri din ROM
               LOAD_EDGE        = 3'b010,   // 2.Incarcare secventiala muchii din ROM
               FINISH_LOAD      = 3'b011,   // 3.Cedare control magistrale catre HW 3D
               WAIT_SETTLE      = 3'b100,   // 4.Asteptare 8 cicli pentru stabilizare semnale
               START_FRAME      = 3'b101,   // 5.Trigger impuls pornire pipeline grafic
               FRAME_DONE       = 3'b110,   // 6.Asteptare semnal frame_done de la rasterizator
               READING_FRAME    = 3'b111;   // 7.Calcul unghi nou pentru urmatorul cadru

    reg [2:0] state, next_state;
    assign dbg_config_state = state;

    // Contor intern pentru baleierea adreselor din ROM
    localparam CNT_BITS = (VERT_ADDR > EDGE_ADDR) ? VERT_ADDR : EDGE_ADDR;
    reg [CNT_BITS-1:0] init_counter; 


    // -------------------------------------------------------------------------
    // FSM Bloc 1: Tranzitia starilor (Calea de control secventiala)
    // -------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= INIT;
        else        state <= next_state;
    end


    // -------------------------------------------------------------------------
    // FSM Bloc 2: Calcul starea urmatoare (Logica combinationala)
    // -------------------------------------------------------------------------
    always @(*) begin
        case (state)
            INIT:           next_state = LOAD_VERT;        
            LOAD_VERT:      next_state = (init_counter == NUM_VERTICES - 1) ? LOAD_EDGE : LOAD_VERT;          
            LOAD_EDGE:      next_state = (init_counter == NUM_EDGES - 1)    ? FINISH_LOAD : LOAD_EDGE;        
            FINISH_LOAD:    next_state = WAIT_SETTLE;
            WAIT_SETTLE:    next_state = (init_counter == 10'd7) ? START_FRAME : WAIT_SETTLE;               
            START_FRAME:    next_state = FRAME_DONE;        
            FRAME_DONE:     next_state = frame_done ? READING_FRAME : FRAME_DONE;        
            READING_FRAME:  next_state = ready ? START_FRAME : READING_FRAME;       
            default:        next_state = INIT;
        endcase
    end


    // -------------------------------------------------------------------------
    // FSM Bloc 3: Calea de date (Logica secventiala pentru registre)
    // -------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset complet al tuturor registrelor de iesire si interne
            start_frame     <= 1'b0;
            buffer_mode     <= 1'b1;
            vertex_count    <= NUM_VERTICES[VERT_ADDR-1:0];
            edge_count      <= NUM_EDGES   [EDGE_ADDR-1:0];
            angle           <= 10'd0;
            focal           <= FOCAL << FRAC_BITS;
            camz            <= CAM_Z << FRAC_BITS;
            
            vb_wr_addr      <= 0;
            vb_wr_data      <= 0;
            vb_wr_en        <= 1'b0;
            vb_wr_cs        <= 1'b0;
            
            eb_wr_addr      <= 0;
            eb_wr_data      <= 0;
            eb_wr_en        <= 1'b0;
            eb_wr_cs        <= 1'b0;
            
            init_counter   <= 0;
        end else begin
            // Valori implicite automate pentru semnalele de tip impuls (Stil industrial/sigur)
            vb_wr_en    <= 1'b0;
            vb_wr_cs    <= 1'b0;
            eb_wr_en    <= 1'b0;
            eb_wr_cs    <= 1'b0;
            start_frame <= 1'b0;

            case (state)
                INIT: begin
                    buffer_mode <= 1'b1; // Se izoleaza top_graphics, preluam controlul memoriei
                    init_counter   <= 0;
                end

                LOAD_VERT: begin
                    vb_wr_addr <= init_counter[VERT_ADDR-1:0];
                    vb_wr_data <= rom_vertices[init_counter[VERT_ADDR-1:0]];
                    vb_wr_cs   <= 1'b1;
                    vb_wr_en   <= 1'b1;
                    
                    if (init_counter == NUM_VERTICES - 1) begin
                        init_counter <= 0;  // Resetam contorul pentru a incepe incarcarea muchiilor
                    end else begin
                        init_counter <= init_counter + 1;
                    end
                end

                LOAD_EDGE: begin
                    eb_wr_addr <= init_counter;
                    eb_wr_data <= rom_edges[init_counter];
                    eb_wr_cs   <= 1'b1;
                    eb_wr_en   <= 1'b1;
                    
                    if (init_counter == NUM_EDGES - 1) begin
                        init_counter <= 0;
                    end else begin
                        init_counter <= init_counter + 1;
                    end
                end

                FINISH_LOAD: begin
                    buffer_mode <= 1'b0; // Cedam controlul magistralelor catre Master Controller-ul hardware
                    init_counter   <= 0;
                end
                
                WAIT_SETTLE: begin // Incrementeaza pana la 7 (asigura exact 8 cicli de ceas de pauza)
                    if (init_counter == 10'd7) begin
                        init_counter <= 0;  // Reset pentru urmatoarele utilizari
                    end else begin
                        init_counter <= init_counter + 1;
                    end
                end

                START_FRAME: begin
                    start_frame <= 1'b1;    // Generam impulsul de 1 ciclu de ceas pentru start rasterizare
                end

                FRAME_DONE: begin
                    if (frame_done) begin
                        // Rotatie manuala in functie de butoane
                        if (btn_left) begin
                            angle <= (angle == 0) ? 10'd719 : angle - 1; // CCW
                        end else if (btn_right) begin
                            angle <= (angle >= 719) ? 10'd0 : angle + 1; // CW
                        end
                         // Ajustare focal/camz, selectata prin sw[3]
                        if (sw[2] == 1'b0) begin
                            if (btn_up)
                                focal <= focal + STEP;
                            else if (btn_down && focal > STEP)
                                focal <= focal - STEP;
                        end else begin
                            if (btn_up)
                                camz <= (camz > STEP) ? camz - STEP : camz;
                            else if (btn_down)
                                camz <= camz + STEP;
                        end                                                                                                           
                    end                   
                end

                READING_FRAME: begin
                end     
            endcase
        end
    end

endmodule // config_block
