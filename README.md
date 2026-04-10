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
- testbench ptr adunare, cu testare random (doar ptr lungime fixa Q16.16)
- scadere in format Q, lungime biti parametrizabili, cu detectie overflow saturare
- testbench ptr scadere, cu testare random (doar ptr lungime fixa Q16.16)
- inmultire in format Q, lungime biti parametrizabili, cu detectie overflow saturare
- testbench ptr inmultire, cu testare random (doar ptr lungime fixa Q16.16)
- impartire in format Q, lungime biti parametrizabili, cu FSM
- testbench ptr impartire, cu testare random (doar ptr lungime fixa Q16.16)

- modul proiectie xp = (f/z) * x, yp = (f/z) * x, implementat cu FSM, detectie overflow
- testbench ptr proiectie, cu testare random (doar ptr lungime fixa Q16.16) (CONTINE ERORI)

