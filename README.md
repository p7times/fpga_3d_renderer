# fpga_3d_renderer
Randare 3D, implementata pe FPGA

Progrese:

- sin_cos_lut_q este acum de tip FSM, actualizat testbench
- adaugat generator ceas
- modul rotation_q 

Module implementate:

- modul clk_rst_tb de la dmnul profesor Nicula Dan
- adunare in format Q, lungime biti parametrizabili, cu detectie overflow saturare
- testbench ptr adunare, cu testare random (doar ptr lungime fixa Q16.16)
- scadere in format Q, lungime biti parametrizabili, cu detectie overflow saturare
- testbench ptr scadere, cu testare random (doar ptr lungime fixa Q16.16)
- inmultire in format Q, lungime biti parametrizabili, cu detectie overflow saturare
- testbench ptr inmultire, cu testare random (doar ptr lungime fixa Q16.16)
- impartire in format Q, lungime biti parametrizabili, cu FSM
- testbench ptr impartire, cu testare random (doar ptr lungime fixa Q16.16)

- modul proiectie, implementat cu FSM, detectie overflow
- testbench ptr proiectie, cu testare random (doar ptr lungime fixa Q16.16) (CONTINE ERORI PRECIZIE)

- modul conversie sist. coord. NDC -> sist. coord. monitor, implementat cu FSM, detectie overflow
- testbench ptr NDC_to_screen, cu testare random (doar ptr lungime fixa Q16.16)

- modul rotatie 3D + testbench

- modul vpu 3D

DE FACUT:

- implementare parametri de clampare (valori z foarte mici sau foarte mari) - clip space
- saturare valori monitor intre latime si lungime 
- aproximare xs/ys ptr coordonate pixeli
- vezi cum ai putea implementa testele random ptr lungimi parametrizabile
