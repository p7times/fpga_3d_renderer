/************************************************************************/
/*																		*/
/*	video_demo.h	--	ZYBO Video demonstration 						*/
/*																		*/
/************************************************************************/
/*	Author: Sam Bobrowicz												*/
/*	Copyright 2015, Digilent Inc.										*/
/************************************************************************/
/*  Module Description: 												*/
/*																		*/
/*		This file contains code for running a demonstration of the		*/
/*		Video input and output capabilities on the ZYBO. It is a good	*/
/*		example of how to properly use the display_ctrl and				*/
/*		video_capture drivers.											*/
/*																		*/
/*																		*/
/************************************************************************/
/*  Revision History:													*/
/* 																		*/
/*		11/25/2015(SamB): Created										*/
/*																		*/
/************************************************************************/

#ifndef VIDEO_DEMO_H_
#define VIDEO_DEMO_H_

/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include "xil_types.h"
#include "video_capture/video_capture.h"
#include "display_ctrl/display_ctrl.h"

/* ------------------------------------------------------------ */
/*					Miscellaneous Declarations					*/
/* ------------------------------------------------------------ */

#define DEMO_PATTERN_0 0
#define DEMO_PATTERN_1 1
#define DEMO_PATTERN_2 2

#define DEMO_MAX_FRAME (1920*1080*3)
#define DEMO_STRIDE (1920 * 3)

/*
 * Configure the Video capture driver to start streaming on signal
 * detection
 */
#define DEMO_START_ON_DET 1

/* ------------------------------------------------------------ */
/*					Procedure Declarations						*/
/* ------------------------------------------------------------ */

void DemoInitialize();
void DemoRun();
void DemoPrintMenu();
void DemoChangeRes();
void DemoCRMenu();
void DemoISR(void *callBackRef, void *pVideo);

void cordic_rotate(float theta, float *cos_out, float *sin_out);
void RotateY(float x, float y, float z, float theta, float *out_x, float *out_y, float *out_z);
void DrawRect(u8 *frame, u32 stride, int x, int y);
void DrawLine(u8 *frame, u32 stride, int x0, int y0, int x1, int y1, u32 width, u32 height);
void ScreenPos(float x_ndc, float y_ndc, u32 *out_x, u32 *out_y, u32 width, u32 height);
void Project(float x, float y, float z, float *out_x, float *out_y, float aspect);
void DrawPoint(u8 *frame, u32 stride, float x, float y, float z, u32 width, u32 height);
void Print3D(u8 *frame, u32 width, u32 height, u32 stride);


/* ------------------------------------------------------------ */

/************************************************************************/

#endif /* VIDEO_DEMO_H_ */
