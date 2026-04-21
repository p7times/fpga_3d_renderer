# FPGA 3D Renderer
**Randare 3D în timp real implementată hardware pe FPGA (Verilog).**

## Descriere Proiect
Acest proiect vizează dezvoltarea unui pipeline grafic 3D complet, optimizat pentru execuție hardware. Unitatea centrală, **Vertex Processing Unit (VPU)**, procesează transformările geometrice necesare trecerii de la un model 3D abstract la pixeli pe un monitor. Întreaga logică utilizează aritmetică în virgulă fixă semnată (format Q) pentru a maximiza performanța pe resursele limitate ale unui FPGA.

## Progrese Recente
* **VPU Integration:** Modulul VPU integrează acum întregul flux: Rotație -> Proiecție -> Mapare Ecran.
* **Camera Offset:** Implementat suport pentru `CAMERA_Z`, adăugat post-rotație pentru a simula adâncimea scenei.
* **Validare Procentuală:** Testbench-ul VPU raportează acum rata de eroare (obținută momentan o precizie de ~99.55% cu prag de 0.1 pixeli).

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
* **VPU (Top Level):** Orchestrează toate sub-modulele de mai sus într-o structură de tip pipeline.

## Validare și Testbench-uri
Fiecare modul este însoțit de un testbench dedicat care rulează teste aleatorii (**Random Testing**):
* **Golden Model:** Rezultatele hardware (DUT) sunt comparate în timp real cu un model matematic ideal (`real` în SystemVerilog).
* **Analiza Erorilor:** Monitorizarea diferențelor dintre virgula fixă și virgula mobilă pentru identificarea pierderilor de precizie.
* **Reproductibilitate:** Utilizarea semințelor (`seed`) fixe pentru testele $urandom.

## DE FACUT (Roadmap)
- [ ] **Clip Space:** Implementare parametri de clampare (NEAR și FAR plane) pentru a gestiona valorile $Z$ extreme.
- [ ] **Viewport Saturation:** Limitarea forțată a valorilor $X_s$ și $Y_s$ între 0 și limitele rezoluției (Width/Height).
- [ ] **Pixel Formatting:** Rotunjirea coordonatelor la valori întregi pentru rasterizare.
- [ ] **Parametrizare TB:** Adaptarea testelor random pentru a funcționa corect indiferent de lungimea de bit selectată (`INT_BITS`/`FRAC_BITS`).

---

**Autor:** Petru-Andrei BRASOVEANU 
**An:** 2026 
**Tehnologii:** Verilog, FPGA, Fixed-Point Arithmetic
