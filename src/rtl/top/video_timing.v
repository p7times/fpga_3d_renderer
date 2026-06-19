//---------------------------------------------------------------
// Universitatea Transilvania din Brasov
// Facultatea IESC
//
// Proiect    : Grafica 3D implementata pe FPGA
// Modul      : video_timing
// Autor      : Petru-Andrei BRASOVEANU
// An         : 2026
//---------------------------------------------------------------
// Descriere  : Acest modul genereaza semnalele de temporizare video necesare
//              pentru controlul unui ecran. El mentine evidenta pozitiei 
//              curente a pixelului pe ecran folosind doua contoare (orizontal 
//              si vertical) si genereaza semnalele de sincronizare (hsync, 
//              vsync) conform standardului video. Semnalul 'vde' devine activ 
//              doar in zona vizibila a ecranului. Parametrii predefiniti 
//              corespund rezolutiei 1280x720 (720p).
//---------------------------------------------------------------

module video_timing #(
    // Parametri pentru temporizarea orizontala (masurati in pixeli)
    parameter H_ACTIVE = 1280, // Zona vizibila pe orizontala
    parameter H_FP     = 110,  // Front porch orizontal
    parameter H_SYNC   = 40,   // Pulsul de sincronizare orizontala
    parameter H_BP     = 220,  // Back porch orizontal
    
    // Parametri pentru temporizarea verticala (masurati in linii)
    parameter V_ACTIVE = 720,  // Zona vizibila pe verticala
    parameter V_FP     = 5,    // Front porch vertical
    parameter V_SYNC   = 5,    // Pulsul de sincronizare verticala
    parameter V_BP     = 20    // Back porch vertical
)(
    input              pixel_clk,  // Ceasul de pixel (frecventa depinde de rezolutie)
    input              rst_n,      // Reset asincron activ pe zero logic
    
    output reg         hsync,      // Semnalul de sincronizare orizontala
    output reg         vsync,      // Semnalul de sincronizare verticala
    output reg         vde,        // Video Data Enable (1 cand pixelul este vizibil)
    output reg  [11:0] pixel_x,    // Coordonata X curenta (coloana)
    output reg  [11:0] pixel_y     // Coordonata Y curenta (randul)
);

    // Calculul dimensiunilor totale ale cadrului (inclusiv perioadele de blanking)
    localparam H_TOTAL = H_ACTIVE + H_FP + H_SYNC + H_BP; // Total pixeli pe linie: 1650
    localparam V_TOTAL = V_ACTIVE + V_FP + V_SYNC + V_BP; // Total linii pe cadru: 750

    // Registre interne pentru numararea pixelilor si a liniilor
    reg [11:0] h_cnt;
    reg [11:0] v_cnt;

    // Contorul orizontal parcurge toti pixelii de pe o linie
    always @(posedge pixel_clk or negedge rst_n) begin
        if (!rst_n) 
            h_cnt <= 0;
        else if (h_cnt == H_TOTAL - 1) 
            h_cnt <= 0; // Se reseteaza la sfarsitul liniei
        else 
            h_cnt <= h_cnt + 1; // Se incrementeaza la fiecare ciclu de ceas
    end

    // Contorul vertical se incrementeaza doar cand s-a terminat o linie completa
    always @(posedge pixel_clk or negedge rst_n) begin
        if (!rst_n) 
            v_cnt <= 0;
        else if (h_cnt == H_TOTAL - 1) begin
            if (v_cnt == V_TOTAL - 1) 
                v_cnt <= 0; // Se reseteaza la sfarsitul cadrului (dupa ultima linie)
            else 
                v_cnt <= v_cnt + 1; // Trece la linia urmatoare
        end
    end

    // Generarea semnalelor de iesire (pipeline pe un ciclu de ceas)
    always @(posedge pixel_clk) begin
        // hsync este activ pe durata pulsului H_SYNC (dupa zona activa si front porch)
        hsync   <= (h_cnt >= H_ACTIVE + H_FP) && (h_cnt < H_ACTIVE + H_FP + H_SYNC);
        
        // vsync este activ pe durata pulsului V_SYNC (dupa zona activa si front porch)
        vsync   <= (v_cnt >= V_ACTIVE + V_FP) && (v_cnt < V_ACTIVE + V_FP + V_SYNC);
        
        // Datele video sunt valide doar cat timp ne aflam in interiorul rezolutiei active
        vde     <= (h_cnt < H_ACTIVE) && (v_cnt < V_ACTIVE);
        
        // Actualizarea coordonatelor pentru exterior
        pixel_x <= h_cnt;
        pixel_y <= v_cnt;
    end

endmodule // video_timing
