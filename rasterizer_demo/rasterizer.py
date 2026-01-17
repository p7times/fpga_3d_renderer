# ==========================================================
# Importăm doar Tkinter, pentru a crea fereastra și a desena
# ==========================================================
from tkinter import Tk, Canvas


# ==========================================================
# --- CORDIC constants ---
# Aceste unghiuri sunt pre-calculate: arctan(2^-i) pentru i=0..14
# Folosite în algoritmul CORDIC pentru a aproxima sin/cos prin rotații succesive.
# ==========================================================
CORDIC_ANGLES = [
    0.7853981633974483, 0.4636476090008061, 0.24497866312686414,
    0.12435499454676144, 0.06241880999595735, 0.031239833430268277,
    0.015623728620476831, 0.007812341060101111, 0.0039062301319669718,
    0.0019531225164788188, 0.0009765621895593195, 0.0004882812111948983,
    0.00024414062014936177, 0.00012207031189367021, 0.00006103515617420877
]

# Factor de scalare specific CORDIC pentru 15 iterații.
# Compensează micșorarea rezultatului cauzată de rotațiile succesive.
CORDIC_K = 0.6072529350088814


# ==========================================================
# --- CORDIC algorithm ---
# Calculează cos(angle) și sin(angle) doar cu adunări și înmulțiri.
# Nu folosește funcții trigonometrice, doar rotații iterative.
# ==========================================================
def cordic(angle, iterations=15):
    """Returnează (cos(angle), sin(angle)) folosind algoritmul CORDIC."""
    x, y, z = CORDIC_K, 0.0, angle  # vector inițial, z = unghiul de rotit
    power_of_two = 1.0               # folosit pentru 2^-i la fiecare pas

    for i in range(iterations):
        di = 1.0 if z >= 0 else -1.0   # direcția rotației (în sens orar/antiorar)
        # Aplica rotația CORDIC
        x_new = x - di * y * power_of_two
        y_new = y + di * x * power_of_two
        z -= di * CORDIC_ANGLES[i]     # reduce unghiul rămas
        x, y = x_new, y_new
        power_of_two *= 0.5            # scade factorul la fiecare iterație
    return x, y


# ==========================================================
# --- Încărcare OBJ ---
# Citește un fișier .obj simplu și extrage coordonatele vârfurilor și fețele.
# ==========================================================
def load_obj(filename):
    vertices, faces = [], []
    with open(filename) as f:
        for line in f:
            if line.startswith("v "):  # Linie de tip "v x y z" -> un vertex
                x, y, z = map(float, line.strip().split()[1:4])
                vertices.append([x, y, z])
            elif line.startswith("f "):  # Linie de tip "f i j k" -> o față
                parts = line.strip().split()
                # OBJ indexează de la 1, Python de la 0 → scădem 1
                face = [int(p.split("/")[0]) - 1 for p in parts[1:]]
                faces.append(face)
    return vertices, faces


# ==========================================================
# --- Extrage muchii unice din fețe ---
# Fiecare față are mai multe laturi; se extrag perechi de indici unici (a, b)
# ==========================================================
def get_edges(faces):
    edges = set()
    for face in faces:
        n = len(face)
        for i in range(n):
            a, b = face[i], face[(i + 1) % n]  # conectează fiecare punct cu următorul
            edges.add(tuple(sorted((a, b))))    # se sortează ca să se elimine duplicatele
    return list(edges)


# ==========================================================
# --- Proiecție 3D → 2D ---
# Transformă coordonatele 3D în coordonate 2D de ecran (perspectivă simplă).
# ==========================================================

CAM_X = 0.0 # deplasare camera pe X
CAM_Y = 0.0 # deplasare camera pe Y

def project(v, width, height, scale, z_offset):
    x, y, z = v
    x -= CAM_X
    y -= CAM_Y
    z += z_offset       # adaugă offsetul camerei (camera "departe")
    if z <= 0.1:
        z = 0.1         # evită divizarea la 0 (punct prea aproape)
    factor = scale / z  # factor de perspectivă (cu cât mai departe, cu atât mai mic)
    # întoarce poziția 2D pe ecran
    return x * factor + width / 2, -y * factor + height / 2


# ==========================================================
# --- Rotire pe axa Y ---
# Folosește CORDIC pentru a calcula cos/sin și rotește punctul (x, y, z)
# ==========================================================
def rotate_y(v, angle):
    x, y, z = v

    # Asigură că unghiul rămâne în intervalul [-pi, pi]
    if angle > 3.14159:
        angle -= 6.28318
    elif angle < -3.14159:
        angle += 6.28318

    # Pentru stabilitatea CORDIC, se reflectă unghiul în [-pi/2, pi/2]
    flip = False
    if angle > 1.5708:
        angle -= 3.14159
        flip = True
    elif angle < -1.5708:
        angle += 3.14159
        flip = True

    # Se calculează cos și sin prin CORDIC
    c, s = cordic(angle)
    if flip:
        # Dacă a fost reflectat, se inversează semnele pentru a reface cadranul
        c, s = -c, -s

    # Rotirea propriu-zisă pe axa Y:
    # noul x este afectat de z, noul z este afectat de x
    x_new = x * c + z * s
    z_new = -x * s + z * c
    return [x_new, y, z_new]


# ==========================================================
# --- Configurare principală ---
# Se încarcă modelul, se calculează muchiile, se inițializează Tkinter
# ==========================================================
vertices, faces = load_obj("model.obj")
edges = get_edges(faces)

WIDTH, HEIGHT = 800, 600   # dimensiunea ferestrei
SCALE = 1000                # scalare a modelului (mărime)
Z_OFFSET = 8               # distanța camerei față de model

root = Tk()
root.title("Raster 3D")
canvas = Canvas(root, width=WIDTH, height=HEIGHT, bg="black")
canvas.pack(fill="both", expand=True)

angle = 0.0  # unghiul de rotație inițial


# ==========================================================
# --- Funcția de randare (redesenare continuă a scenei) ---
# Se apelează periodic, actualizează rotația și redesenează liniile
# ==========================================================
def render():
    global angle
    canvas.delete("all")  # șterge tot ce era desenat

    # Obține dimensiunile actuale ale ferestrei (pentru redimensionare)
    width = canvas.winfo_width()
    height = canvas.winfo_height()

    # 1️⃣ rotește toate vârfurile modelului după axa Y
    rotated = [rotate_y(v, angle) for v in vertices]

    # 2️⃣ proiectează vârfurile în coordonate 2D
    projected = [project(v, width, height, SCALE, Z_OFFSET) for v in rotated]

    # 3️⃣ desenează fiecare muchie între două vârfuri
    for a, b in edges:
        x1, y1 = projected[a]
        x2, y2 = projected[b]
        canvas.create_line(x1, y1, x2, y2, fill="white")

    # 4️⃣ crește unghiul pentru următorul frame (rotație constantă)
    angle += 0.04
    if angle > 6.28318:
        angle -= 6.28318  # resetează unghiul după o rotație completă (2π)

    # 5️⃣ programează apelul următor (aprox. 60 FPS)
    root.after(16, render)


# ==========================================================
# --- Pornirea randării ---
# ==========================================================
render()
root.mainloop()
