# fpga_3d_renderer
Randare 3D, implementata pe FPGA

Progrese:

- afisare cu succes benzi de culoare (steaguri)
- generare de puncte individuale pe ecran si setarea corecta a rezolutiei
- desenarea liniilor intre 2 puncte folosind aalgoritmul Bresenham
- schimbarea sistemului de coordonate din NDC in Screen
- proiectia cu succes a punctelor
- 2 structuri: Vertices & Faces
- corpul se roteste cu succes in jurul axei Y 360 de grade


Module implementate:

- adunare in format Q, lungime biti parametrizabili, cu detectie overflow saturare
- testbench ptr modulul adunare
- scadere in format Q, lungime biti parametrizabili, cu detectie overflow saturare
- testbench ptr modulul scadere
- inmultire in format Q, lungime biti parametrizabili, cu detectie overflow saturare
- testbench ptr modulul inmultire
