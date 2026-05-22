# Grafica 3D, implementata pe FPGA
**Randare 3D în timp real implementată hardware pe FPGA (Verilog).**

## Descriere proiect
Proiectul implementează un pipeline grafic 3D hardware orientat pe FPGA, cu procesare completă a geometriei și rasterizării în timp real. Sistemul transformă modele 3D în pixeli afișabili pe ecran folosind aritmetică în virgulă fixă semnată (format Q), optimizată pentru resurse hardware.

Arhitectura este modulară, separând clar etapele de transformare geometrică, rasterizare și afișare, pentru a permite paralelizare și control determinist al fluxului de date.

## Progrese recente

- **Structură de buffere implementată:**
  - Vertex Buffer
  - Edge Buffer
  - Point Buffer
  - Framebuffer (memorie finală de imagine)

- **Rasterizare hardware:**
  - algoritm Bresenham implementat în logică hardware
  - generare incrementală de pixeli pentru muchii
  - integrare directă cu framebuffer write path

- **Validare și testare:**
  - testbench-uri dedicate pentru fiecare modul
  - testare random cu seed determinist (`$urandom`)

## Module Implementate

### Primitive Aritmetice (Parametrizabile)
Toate modulele suportă lungime de bit configurabilă și includ logică de detecție overflow:
* **Adunare/Scădere Q:** Cu saturare și flag de overflow.
* **Înmulțire Q:** Gestionare automată a punctului fix după produs.
* **Împărțire Q:** Implementare secvențială bazată pe FSM.
* **Utilitare:** Modulul `clk_rst_tb` (Sursa: Prof. Dr. Ing. Dan Nicula) pentru generarea semnalelor de ceas și reset în simulare.

### Pipeline Geometric
* **Rotation Unit:** Rotație 3D pe axele X, Y sau Z folosind funcții trigonometrice precalculate.
* **Projection Unit:** Transformare perspectivă (împărțire la Z) implementată cu FSM.
* **NDC to Screen:** Maparea coordonatelor normalizate pe rezoluția ecranului (ex: 320x240).
* **Vertex Processor (Top Level):** Orchestrează toate sub-modulele de mai sus într-o structură de tip pipeline.

### Buffere grafice
- **Vertex Buffer:** stochează vertecși transformați
- **Edge Buffer:** definește conexiuni pentru rasterizare
- **Point Buffer:** puncte intermediare pentru pipeline
- **Framebuffer:** imagine finală (32 pixeli per word, bit-packed)

### Rasterizare
- **Bresenham line generator (hardware):**
  - FSM determinist
  - generare incrementală de pixeli
  - scriere directă în framebuffer

## Validare și Testbench-uri
Fiecare modul este însoțit de un testbench dedicat care rulează teste aleatorii (**Random Testing**):
* **Golden Model:** Rezultatele hardware (DUT) sunt comparate în timp real cu un model matematic ideal.
* **Analiza Erorilor:** Monitorizarea diferențelor dintre virgula fixă și virgula mobilă pentru identificarea pierderilor de precizie.
* **Reproductibilitate:** Utilizarea semințelor (`seed`) fixe pentru testele $urandom.

## DE FACUT (Roadmap)
- [ ] **Clip Space:** Implementare parametri de clampare (NEAR și FAR plane) pentru a gestiona valorile $Z$ extreme.
- [ ] **Parametrizare TB:** Adaptarea testelor random pentru a funcționa corect indiferent de lungimea de bit selectată (`INT_BITS`/`FRAC_BITS`).
- [ ] **Master Controller** Orchestrarea completă a pipeline-ului grafic, cu sincronizare între VP, rasterizer și framebuffer.
- [ ] **HDMI Controller**   Generare semnal video sincron (VGA/HDMI), citire framebuffer în timp real și timing pentru display
- [ ] **AXI Slave Interface** Încărcare modele `.obj`, mapare vertex-uri în Vertex Buffer și configurare runtime a pipeline-ului din CPU/host
- [ ] **Documentație completă** Diagramă arhitectură sistem, specificații module, descriere FSM-uri și pipeline geometric complet, detalii aritmetică Q-format

---

**Autor:** Petru-Andrei BRASOVEANU 
**An:** 2026 
**Tehnologii:** Verilog, FPGA, Fixed-Point Arithmetic


