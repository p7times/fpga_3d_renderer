#---------------------------------------------------------------
# Proiect    : Grafica 3D implementata pe FPGA
#
# Autor      : Petru-Andrei BRASOVEANU  
# An         : 2026
#---------------------------------------------------------------
# Descriere  : Genereaza intrarile pentru blocul "case" din
#              modulul sin_cos_lut_q. Format Q0.16 (hexazecimal).
#---------------------------------------------------------------

import math

# Converteste un numar real in format Q0.16 (16 biti fractionari)
def to_q0_16(x):
    # inmultim cu 2^16 si rotunjim la cel mai apropiat intreg
    # & 0xFFFF asigura ca ramanem pe 16 biti (fara overflow)
    return int(round(x * (1 << 16))) & 0xFFFF


# Genereaza reprezentarea unghiului in formatul tau:
# [7:1] = grade intregi, [0] = bit de 0.5
# afisat ca: 8'bxxxxxxx_y
def angle_to_bin8_split(i):
    # i = index:
    # 0 -> 0.5
    # 1 -> 1.0
    # 2 -> 1.5
    # ...

    degrees = (i + 1) // 2   # partea intreaga a unghiului
    half = (i + 1) % 2       # 1 daca e .5, 0 daca e .0

    # reconstruim valoarea pe 8 biti:
    # shiftam gradele la stanga si adaugam bitul fractional
    val = (degrees << 1) | half

    # extragem separat partea intreaga (7 biti) si fractiunea (1 bit)
    int_part = (val >> 1) & 0x7F   # 7 biti pentru grade
    frac_part = val & 0x1          # bitul de 0.5

    # formatare stil Verilog: 8'bxxxxxxx_y
    return f"8'b{int_part:07b}_{frac_part}"


# Parcurgem unghiurile de la 0.5 la 89.5 cu pas de 0.5
for i in range(179):
    angle_deg = 0.5 * (i + 1)

    # calculam sinus si cosinus
    sin_val = to_q0_16(math.sin(math.radians(angle_deg)))
    cos_val = to_q0_16(math.cos(math.radians(angle_deg)))

    # afisare in stil Verilog pentru LUT
    print(f"{angle_to_bin8_split(i)} : begin sin_mag = 16'h{sin_val:04X}; cos_mag = 16'h{cos_val:04X}; end // {angle_deg}")
