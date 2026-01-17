#include <SDL2/SDL.h>
#include <stdio.h>

void plotLine(SDL_Renderer *renderer, int x0, int y0, int x1, int y1) {
    int dx = x1 - x0;
    int dy = y1 - y0;
    
    int abs_dx = dx > 0 ? dx : -dx;
    int abs_dy = dy > 0 ? dy : -dy;
    
    int sx = dx >= 0 ? 1 : -1;
    int sy = dy >= 0 ? 1 : -1;
    
    int err = (abs_dx > abs_dy ? abs_dx : -abs_dy) / 2;
    int e2;

    while (1) {
        SDL_RenderDrawPoint(renderer, x0, y0); // plot the pixel

        if (x0 == x1 && y0 == y1) break;

        e2 = err;
        if (e2 > -abs_dx) { err -= abs_dy; x0 += sx; }
        if (e2 < abs_dy)  { err += abs_dx; y0 += sy; }
    }
}

int main() {
    // Initialize SDL
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        printf("SDL_Init Error: %s\n", SDL_GetError());
        return 1;
    }

    // Create a window
    SDL_Window *window = SDL_CreateWindow(
        "Single Point",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        800, 600,
        SDL_WINDOW_SHOWN
    );
    if (!window) {
        printf("SDL_CreateWindow Error: %s\n", SDL_GetError());
        SDL_Quit();
        return 1;
    }

    // Create a renderer
    SDL_Renderer *renderer = SDL_CreateRenderer(
        window, -1, SDL_RENDERER_ACCELERATED
    );
    if (!renderer) {
        printf("SDL_CreateRenderer Error: %s\n", SDL_GetError());
        SDL_DestroyWindow(window);
        SDL_Quit();
        return 1;
    }

    int running = 1;
    while (running) {
        SDL_Event e;
        while (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT)
                running = 0;
        }

        // Clear screen to black
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
        SDL_RenderClear(renderer);

        // Draw a single white point in the middle
        
        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);

        plotLine(renderer, 120, 200, 360, 520);
        //plotLine(renderer, 100, 500, 700, 100);
        // Present the frame
        SDL_RenderPresent(renderer);

        SDL_Delay(16); // ~60 FPS
    }

    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}


