#include <SDL2/SDL.h>  // Biblioteca SDL2 pentru fereastră, randare și evenimente
#include <math.h>      // Funcții matematice: cosf, sinf, abs
#include <stdio.h>     // Input/output standard: fopen, fgets, sscanf, printf
#include <stdlib.h>    // Memorie dinamică: malloc, realloc, free, exit

/* ===============================
   TIPURI DE DATE
   =============================== */

// Vector 3D sau punct în spațiul 3D
typedef struct { 
    float x, y, z; // Coordonatele X, Y, Z ale punctului
} Vec3;

// Muchie între două vârfuri
typedef struct { 
    int a, b; // Indicii celor două vârfuri din vectorul de vârfuri
} Edge;

// Framebuffer software pentru a scrie pixeli înainte de a trimite la SDL
typedef struct {
    Uint32 *pixels; // Buffer de pixeli (ARGB 32-bit)
    int width, height; // Dimensiunea bufferului
} Framebuffer;

/* ===============================
   ROTIRE PE AXA Y
   =============================== */

// Rotire punct 3D în jurul axei Y
static inline Vec3 rotate_y(Vec3 v, float angle) {
    float c = cosf(angle); // Cosinusul unghiului
    float s = sinf(angle); // Sinusul unghiului
    Vec3 r;
    r.x = v.x * c + v.z * s;  // Formula de rotire pe Y pentru X
    r.y = v.y;                // Y nu se schimbă
    r.z = -v.x * s + v.z * c; // Formula de rotire pe Y pentru Z
    return r;                 // Returnează vectorul rotit
}


/* ===============================
   PROIECȚIE 3D -> 2D
   =============================== */

// Transformă un punct 3D în coordonate de ecran 2D folosind perspectivă simplă
static inline void project(Vec3 v, int w, int h, float scale, float zoff, int *sx, int *sy) {
    float z = v.z + zoff;       // Ajustăm distanța camerei (offset pe Z)
    if (z < 0.1f) z = 0.1f;    // Evităm diviziunea la 0 sau valori negative

    float f = scale / z;        // Factor de scalare în funcție de distanța la cameră

    *sx = (int)(v.x * f + w * 0.5f); // Coordonată X pe ecran (centrată)
    *sy = (int)(-v.y * f + h * 0.5f); // Coordonată Y pe ecran (inversare axă Y)
}

/* ===============================
   BRESENHAM
   =============================== */

// Algoritm clasic Bresenham pentru trasarea unei linii între doi pixeli
void draw_line(Framebuffer *fb, int x0, int y0, int x1, int y1, Uint32 color) {
    int dx = abs(x1 - x0), sx = x0 < x1 ? 1 : -1; // Distanță pe X și direcție
    int dy = -abs(y1 - y0), sy = y0 < y1 ? 1 : -1; // Distanță pe Y și direcție
    int err = dx + dy, e2;

    while (1) {
        // Dacă pixelul este în interiorul bufferului, îl scriem
        if (x0 >= 0 && x0 < fb->width && y0 >= 0 && y0 < fb->height)
            fb->pixels[y0 * fb->width + x0] = color;

        if (x0 == x1 && y0 == y1) break; // Am ajuns la destinație

        e2 = 2 * err;
        if (e2 >= dy) { err += dy; x0 += sx; } // Salt pe X
        if (e2 <= dx) { err += dx; y0 += sy; } // Salt pe Y
    }
}

/* ===============================
   ÎNCĂRCARE OBJ MINIMALĂ
   =============================== */

// Vectori dinamici pentru vârfuri și muchii
Vec3 *verts = NULL; 
Edge *edges = NULL;
int vcount = 0, ecount = 0;

// Funcție care încarcă un fișier .obj simplu (wireframe)
void load_obj(const char *name) {
    FILE *f = fopen(name, "r"); // Deschidem fișierul
    if (!f) { puts("model.obj not found"); exit(1); }

    char line[256]; // Buffer pentru citirea unei linii
    int face[32], n; // Temporar pentru fețe

    while (fgets(line, sizeof(line), f)) {
        if (line[0] == 'v' && line[1] == ' ') { // Linie v = vârf
            verts = realloc(verts, sizeof(Vec3) * (vcount + 1)); // Realocăm vectorul
            sscanf(line, "v %f %f %f", &verts[vcount].x, &verts[vcount].y, &verts[vcount].z);
            vcount++; // Creștem contorul de vârfuri
        } else if (line[0] == 'f') { // Linie f = față
            n = 0; 
            char *p = line + 2;
            while (*p) { 
                face[n++] = atoi(p) - 1; // OBJ index începe de la 1, noi scădem 1
                while (*p && *p != ' ') p++; // Salt peste număr
                while (*p == ' ') p++;       // Salt peste spații
            }
            // Generăm muchiile feței
            for (int i = 0; i < n; i++) {
                edges = realloc(edges, sizeof(Edge) * (ecount + 1));
                edges[ecount++] = (Edge){ face[i], face[(i + 1) % n] }; // Muchie i→i+1 (mod n)
            }
        }
    }
    fclose(f); // Închidem fișierul
}

/* ===============================
   MAIN
   =============================== */

int main() {
    load_obj("model.obj"); // Încărcăm modelul

    SDL_Init(SDL_INIT_VIDEO); // Inițializăm SDL

    int w = 800, h = 600; // Dimensiuni inițiale fereastră
    SDL_Window *win = SDL_CreateWindow("3D Viewer",
                                       SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
                                       w, h, SDL_WINDOW_RESIZABLE); // Fereastră redimensionabilă

    SDL_Renderer *renderer = SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED); // Renderer hardware
    SDL_Texture *texture = SDL_CreateTexture(renderer,
                                             SDL_PIXELFORMAT_ARGB8888,
                                             SDL_TEXTUREACCESS_STREAMING,
                                             w, h); // Textură pentru buffer software

    Framebuffer fb = { .pixels = malloc(sizeof(Uint32) * w * h), .width = w, .height = h }; // Buffer software
    int prev_w = w, prev_h = h; // Dimensiuni anterioare pentru resize

    float angle = 0.0f; // Unghi de rotație
    int running = 1;    // Flag loop principal

    while (running) { // Loop principal
        SDL_Event e;
        while (SDL_PollEvent(&e))
            if (e.type == SDL_QUIT) running = 0; // Ieșim dacă fereastra se închide

        SDL_GetWindowSize(win, &w, &h); // Obținem dimensiunea curentă a ferestrei

        // Dacă s-a redimensionat fereastra, recreăm textura și buffer-ul
        if (w != prev_w || h != prev_h) {
            SDL_DestroyTexture(texture);
            texture = SDL_CreateTexture(renderer,
                                        SDL_PIXELFORMAT_ARGB8888,
                                        SDL_TEXTUREACCESS_STREAMING,
                                        w, h);
            free(fb.pixels);
            fb.pixels = malloc(sizeof(Uint32) * w * h);
            fb.width = w;
            fb.height = h;
            prev_w = w;
            prev_h = h;
        }

        // Curățăm buffer-ul (negru opac)
        for (int i = 0; i < w*h; i++)
            fb.pixels[i] = 0xFF000000;

        float fov = 1000.0f; // Factor FOV (scalare)
        float zcam = 3.0f;   // Distanța camerei pe Z

        // Desenăm wireframe-ul folosind Bresenham
        for (int i = 0; i < ecount; i++) {
            Vec3 a = rotate_y(verts[edges[i].a], angle); // Rotează primul vârf
            Vec3 b = rotate_y(verts[edges[i].b], angle); // Rotează al doilea vârf
            int x1, y1, x2, y2;
            project(a, w, h, fov, zcam, &x1, &y1);       // Proiectează primul vârf
            project(b, w, h, fov, zcam, &x2, &y2);       // Proiectează al doilea vârf
            draw_line(&fb, x1, y1, x2, y2, 0xFF00FFDA);  // Linie albă
        }

        // Copiem buffer-ul software în textura SDL și afișăm
        SDL_UpdateTexture(texture, NULL, fb.pixels, w * sizeof(Uint32));
        SDL_RenderClear(renderer);
        SDL_RenderCopy(renderer, texture, NULL, NULL);
        SDL_RenderPresent(renderer);

        angle += 0.02f;             // Incrementăm unghiul pentru animație
        if (angle > 6.283185f)      // Resetare la 2*PI pentru a evita overflow
            angle -= 6.283185f;

        SDL_Delay(16); // Pauză ~16ms (~60 FPS)
    }

    // Curățare memorie și resurse SDL
    free(fb.pixels);
    free(verts);
    free(edges);
    SDL_DestroyTexture(texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(win);
    SDL_Quit();

    return 0; // Ieșire program
}
