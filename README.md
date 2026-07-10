# Grafică 3D, implementată pe FPGA
**Randare 3D în timp real implementată hardware pe FPGA (Verilog).**

## Descriere proiect
Acest proiect implementează un pipeline pentru grafica 3D, optimizat pentru arhitectura FPGA (testat pe seria Xilinx Zynq-7000 / xc7z010). Sistemul transformă modelele 3D în pixeli afișabili în timp real, utilizând exclusiv aritmetică în virgulă fixă (format Q) semnată, pentru un consum minim de resurse hardware și latență scăzută.

Arhitectura modulară separă clar etapele de transformare geometrică, rasterizare și control al memoriei, permițând paralelizarea fluxului de date și un control complet determinist.

![3D Wireframe Render Output](output.gif)

*Fig 1. Vizualizarea wireframe a modelului 3D, obținută prin conversia directă a dump-ului de memorie din Framebuffer în format .bmp*

---

## Progrese recente

- **Multiplicatoare iterative:** Procesorul de vertecși folosește multiplicatoare de tip iterativ (folosind algoritmul Booth pentru numere întregi). Aceasta a determinat scăderea drastică a numărului de DSP-uri folosite, în detrimentul unui timp de procesare crescut.

---

## Structură Repository

```text
├── src/                # Codul sursă Verilog (Modulele hardware)
├── generare_lut/       # Codul Python pentru calcularea valorilor LUT-ului sin și cos
├── hdmi_demo/          # Prototip implementat în C a pipeline-ului 3D
├── vivado/             # Fișierele de rulare a proiectului în mediul de dezvoltare Vivado
└── rgb2dvi/            # IP-ul RGB2DVI, utilizat pentru serializarea datelor RGB
```

---

## Arhitectura Sistemului

### 1. Primitive Aritmetice Custom (Format Q)
Toate modulele suportă lungime de bit parametrizabilă și includ logică dedicată pentru gestionarea limitelor numerice:
* **Q-Adder/Subtractor:** Implementare cu saturare hardware și semnalizare pentru overflow.
* **Q-Multiplier:** Gestionare automată a alinierii punctului fix după efectuarea produsului, folosind algoritmul iterativ de multiplicare Booth a numerelor întregi.
* **Q-Divider:** Implementare secvențială, bazată pe o mașină de stări (FSM) pentru economisirea resurselor logice (LUTs).

### 2. Pipeline Geometric (Vertex Processing)
* **Rotation Unit:** Aplică rotații 3D (Pitch, Yaw, Roll) folosind funcții trigonometrice precalculate.
* **Projection Unit:** Execută transformarea de perspectivă bazată pe FSM.
* **NDC to Screen:** Mapează coordonatele din spațiul normalizat (NDC) pe rezoluția fizică a framebuffer-ului.
* **Vertex Processor (Top Level):** Orchestrează modulele de mai sus într-un flux de tip pipeline continuu.

### 3. Arhitectura de Memorie
* **Vertex Buffer:** Definește vertecșii modelului 3D, precedând etapa de transformări geometrice.
* **Edge Buffer:** Definește muchiile (conexiunile dintre vertecși) pentru etapa de rasterizare.
* **Point Buffer:** Stochează vertecșii transformați și proiectați.
* **Framebuffer:** Memorie video compactată (bit-packed, 32 pixeli per cuvânt de memorie) pentru stocarea imaginii finale. Citit sincron de video controller-ul pe domeniul `pixel_clk`.

### 4. Rasterizare
* **Bresenham Line Generator:** Implementare hardware a algoritmului Bresenham. Unitate FSM complet deterministă care generează incremental pixelii segmentelor de dreaptă și scrie direct în Framebuffer.

### 5. Control și Sincronizare
* **Master Controller:** Gestionează FSM-ul global al pipeline-ului grafic, sincronizează Vertex Processor-ul cu Rasterizer-ul și buffer-ele, și gestionează semnalele de control (`busy`, `frame_done`).
* **Configuration Block:** Bloc FSM sintetizabil care înlocuiește testbench-ul în fluxul hardware real. Inițializează geometria din ROM-uri interne, gestionează animația continuă și sincronizează pornirea cadrelor noi cu semnalul `ready` primit de la video controller.
* **Top Graphics:** Wrapper structural curat care interconectează toate blocurile IP interne și expune magistralele externe.

### 6. Ieșire Video HDMI
* **Video Timing Generator:** Modul hardware care generează semnalele de sincronizare (`hsync`, `vsync`, `vde`) și coordonatele pixel curente conform standardului 720p (1650×750 total, 74.25 MHz pixel clock).
* **Clock Wizard (MMCM):** Generează frecvențele necesare din oscilatorul de 125 MHz al plăcii: `74.25 MHz` (pixel clock), `371.25 MHz` (TMDS serializer), `74.25 MHz` (pipeline grafic).
* **RGB2DVI (Digilent IP):** Serializează datele RGB pe interfața TMDS diferențială pentru transmisie HDMI.

---

## Utilizare Resurse Hardware

| Resursă | Utilizare |
|---------|-----------|
| LUT     | 16%       |
| FF      | 13%       |
| BRAM    | 58%       |
| DSP     | 3%        |
| IO      | 14%       |
| BUFG    | 13%       |
| MMCM    | 50%       |

**Timing:** WNS = 2.034 ns — toate constrângerile respectate. 
**Putere:** 0.492 W total on-chip. 
**Target:** Xilinx xc7z010clg400-1 (Zybo Z7-10)

---

## Validare și Testbench-uri

Fiecare modul a fost verificat independent prin simulări cu stimuli aleatori (**Random Testing**):
* **Golden Model Comparison:** Rezultatele hardware (DUT) sunt comparate ciclu cu ciclu cu un model matematic ideal scris în Verilog comportamental.
* **Analiza Erorilor (Precision Loss):** Sistemul monitorizează și loghează automat deviațiile (delta) dintre reprezentarea hardware în virgulă fixă și rezultatele teoretice în virgulă mobilă.
* **Export BMP secvențial:** Testbench-ul generează automat 360 de cadre `.bmp` pentru validarea vizuală a animației complete (rotație 360°).
* **Reproductibilitate:** Utilizarea de seed-uri fixe pentru testele bazate pe `$urandom` asigură reproductibilitatea edge-case-urilor.
* *(Mulțumiri: Atât modulul `clk_rst_tb`, utilizat pentru generarea mediului de test, cât și proiectarea memoriilor SRAM au fost preluate din Cartea de Învățătură a Prof. Dr. Ing. Dan Nicula).*

---

## Roadmap / TODO

### 1. Fundație, I/O și Siguranța Datelor
- [ ] **Data Safety:** Implementarea detecției și tratării complete a cazurilor de **Underflow** (și Overflow) pe tot lanțul aritmetic. Esențial înainte de a adăuga calcule complexe de rasterizare.
- [ ] **Interfață VGA (BASYS 3):** Implementarea modulului de sincronizare VGA (HSYNC, VSYNC), compatibil cu BASYS 3. 
- [ ] **Arhitectura Framebuffer-ului:** Stabilirea rezoluției și color depth-ului astfel încât să încapă în BRAM-ul de pe Basys 3.

### 2. Procesarea Geometriei (Vertex Pipeline)
- [ ] **Z-Clipping (Clip Space):** Adăugarea parametrilor de clampare (planul NEAR și planul FAR) pentru a evita artefactele vizuale cauzate de valorile extreme pe axa Z și diviziunea cu zero în perspectiva 3D.
- [ ] **Back-Face Culling:** Implementarea unui modul hardware care calculează produsul vectorial 2D al vârfurilor (orientarea triunghiului) și aruncă fețele care nu sunt îndreptate spre cameră (economisește timp de procesare).

### 3. Randare Fețe Solide (Rasterization Pipeline)
- [ ] **Setup Triunghi (Bounding Box):** Modul care primește cele 3 vârfuri 2D și determină dreptunghiul minim încadrator (X_min, X_max, Y_min, Y_max).
- [ ] **Rasterizator (Pineda Edge Equations):** Parcurgerea pixelilor din Bounding Box și evaluarea ecuațiilor de muchie pentru a determina dacă un pixel se află în interiorul triunghiului. 
- [ ] **Flat Shading (Iluminare):** Calcularea unui coeficient de luminozitate pe baza normalei feței 3D și aplicarea acestuia peste culoarea de bază a triunghiului.

### 4. Managementul Adâncimii (Depth Resolution)
- [ ] **Strategia de Adâncime (Decizie arhitecturală):** Deoarece un Z-buffer tradițional s-ar putea să nu încapă în BRAM-ul rămas pe Basys 3 alături de Framebuffer, trebuie implementată o soluție:
  - *Opțiunea A:* Z-buffer la rezoluție redusă (ex: 160x120) sau cu precizie foarte mică (4-bit/8-bit Z-depth).
  - *Opțiunea B:* Painter's Algorithm (Z-Sorting) - sortarea hardware a triunghiurilor de la cel mai îndepărtat la cel mai apropiat înainte de rasterizare (necesită un buffer pentru indicii fețelor).

### 5. Documentație și Cleanup
- [ ] **Actualizare documentație Vertex Processor:** Modificare subsecțiuni pentru multiplicarea iterativă + utilizare resurse FPGA (LUTs, DSP-uri, BRAM utilizat).
- [ ] **Documentare Pipeline Nou:** Adăugarea schemelor bloc (RTL) pentru noile module de Rasterizare și Culling.

---


