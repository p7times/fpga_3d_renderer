#ifndef VIDEO_DEMO_H_
#define VIDEO_DEMO_H_

// Include definitii fisiere

#include "xil_types.h"
#include "video_capture/video_capture.h"
#include "display_ctrl/display_ctrl.h"

// Diverse declaratii

#define DEMO_MAX_FRAME (1920*1080*3)
#define DEMO_STRIDE (1920 * 3)
#define DEMO_START_ON_DET 1

// Declaratii de proceduri

void DemoInitialize(); 																			// Initializeaza intreg demo-ul
void DemoRun();		   																			// Bucla principala a programului
void DemoISR(void *callBackRef, void *pVideo);  												// ISR (callback) pentru captura video

void CordicRotate(float theta, float *cos_out, float *sin_out);									// Calculeaza cos(theta) si sin(theta) folosind CORDIC
void DrawRect(u8 *frame, u32 stride, int x, int y);												// Tipareste un dreptunghi foarte mic pe post de "punct"
void DrawPoint(u8 *frame, u32 stride, float x, float y, float z, u32 width, u32 height);		// Punct: Project -> ScreenPos -> DrawRect
void DrawLine(u8 *frame, u32 stride, int x0, int y0, int x1, int y1, u32 width, u32 height);	// Deseneaza o linie intre 2 puncte folosind algoritmul Bresenham

void RotateY(float x, float y, float z, float theta, float *out_x, float *out_y, float *out_z);	// Roteste corpul 3D in jurul axei Y, relativ la centrul corpului, folosind CORDIC
void Project(float x, float y, float z, float *out_x, float *out_y, float aspect);				// Proiectia 3D -> 2D a unui punct
void ScreenPos(float x_ndc, float y_ndc, u32 *out_x, u32 *out_y, u32 width, u32 height);		// Converteste coordonatele din sistemul NDC in cel al monitorului
void Print3D(u8 *frame, u32 width, u32 height, u32 stride);										// Deseneaza corpul 3D: Parseaza -> RotateY -> Project -> ScreenPos -> DrawLine

#endif /* VIDEO_DEMO_H_ */
