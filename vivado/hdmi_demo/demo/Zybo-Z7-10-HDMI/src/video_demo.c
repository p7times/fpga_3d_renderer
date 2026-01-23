#include "video_demo.h"
#include "display_ctrl/display_ctrl.h"
#include "intc/intc.h"
#include "xuartps.h"
#include "xil_types.h"
#include "xil_cache.h"
#include "timer_ps/timer_ps.h"
#include "xparameters.h"

// Definirea adreselor și ID-urilor hardware din platforma Zynq/ZYBO
#define DYNCLK_BASEADDR        XPAR_AXI_DYNCLK_0_S_AXI_LITE_BASEADDR
#define VDMA_ID                XPAR_AXIVDMA_0_DEVICE_ID
#define HDMI_OUT_VTC_ID        XPAR_V_TC_OUT_DEVICE_ID
#define HDMI_IN_VTC_ID         XPAR_V_TC_IN_DEVICE_ID
#define HDMI_IN_GPIO_ID        XPAR_AXI_GPIO_VIDEO_DEVICE_ID

// Interrupții hardware (fabric interrupts)
#define HDMI_IN_VTC_IRPT_ID    XPAR_FABRIC_V_TC_IN_IRQ_INTR
#define HDMI_IN_GPIO_IRPT_ID   XPAR_FABRIC_AXI_GPIO_VIDEO_IP2INTC_IRPT_INTR

// Timer și UART (PS side)
#define SCU_TIMER_ID           XPAR_SCUTIMER_DEVICE_ID
#define UART_BASEADDR          XPAR_PS7_UART_1_BASEADDR


// Structuri globale pentru componentele demo-ului
DisplayCtrl dispCtrl;      // Controlerul de display (VDMA + timing + frame buffer)
XAxiVdma vdma;             // AXI VDMA (scriere în frame buffer)
VideoCapture videoCapt;    // Captură HDMI IN (VTC + GPIO)
INTC intc;                 // Controller de întreruperi (interrupt controller)
char fRefresh;             // Flag setat de ISR când există o nouă imagine capturată

// Buffer video pentru display (alocat static în DDR)
u8 frameBuf[DISPLAY_NUM_FRAMES][DEMO_MAX_FRAME] __attribute__((aligned(0x20)));
// Pointeri către fiecare frame buffer
u8 *pFrames[DISPLAY_NUM_FRAMES];

// Tabel de întreruperi (interrupt vector table)
const ivt_t ivt[] = {
    videoGpioIvt(HDMI_IN_GPIO_IRPT_ID, &videoCapt),
    videoVtcIvt(HDMI_IN_VTC_IRPT_ID, &(videoCapt.vtc))
};


/*
 * Desenează un dreptunghi mic 5x5 în bufferul de frame.
 * Folosește format RGB (3 bytes per pixel).
 * stride = numărul de bytes per linie (de obicei width*3)
 */
void DrawFilledRect(u8 *frame, u32 stride, u32 x, u32 y)
{
    u8 blue = 0;
    u8 green = 255;
    u8 red = 0;

    const u32 rectW = 5;
    const u32 rectH = 5;
    u32 xEnd = x + rectW;
    u32 yEnd = y + rectH;

    for (u32 yy = y; yy < yEnd; yy++)
    {
        // indexul primului pixel din linia yy
        u32 pixel_index = yy * stride + (x * 3);

        for (u32 xx = x; xx < xEnd; xx++)
        {
            // scrie valorile RGB
            frame[pixel_index + 0] = blue;
            frame[pixel_index + 1] = green;
            frame[pixel_index + 2] = red;

            pixel_index += 3;  // trece la următorul pixel
        }
    }
}


/*
 * Scrie în buffer un "test pattern" simplu:
 * - curăță ecranul (negru)
 * - desenează 3 puncte verzi (dreptunghiuri 5x5)
 * - flush la cache pentru a forța scrierea în memorie
 */
void DemoPrintTest(u8 *frame, u32 width, u32 height, u32 stride)
{
    // Clear screen (setare pixeli la 0)
    for (u32 y = 0; y < height; y++)
    {
        u32 row = y * stride;
        for (u32 x = 0; x < width; x++)
        {
            u32 p = row + (x * 3);
            frame[p + 0] = 0;
            frame[p + 1] = 0;
            frame[p + 2] = 0;
        }
    }

    // Desenează puncte verzi
    DrawFilledRect(frame, stride, 100, 50);
    DrawFilledRect(frame, stride, 1, 1);
    DrawFilledRect(frame, stride, 200, 100);
    DrawFilledRect(frame, stride, 800, 590);
    DrawFilledRect(frame, stride, 800, 450);
    DrawFilledRect(frame, stride, 1595, 895);


    // Flush cache pentru a asigura că memoria DDR conține datele actualizate
    Xil_DCacheFlushRange((unsigned int)frame, DEMO_MAX_FRAME);
}


/*
 * Inițializează întregul demo:
 * - buffer frame-uri
 * - timer
 * - VDMA
 * - Display controller (VDMA + VTC + dynamic clock)
 * - Interrupt controller + video capture
 * - setare callback pentru ISR
 * - afișează test pattern
 */
void DemoInitialize()
{
    XAxiVdma_Config *vdmaConfig;
    int Status;

    // Inițializează pointerii către buffer-ele de frame
    for (int i = 0; i < DISPLAY_NUM_FRAMES; i++)
    {
    	pFrames[i] = frameBuf[i];
    }


    // Inițializează timer-ul SCU (folosit în demo pentru delay)
    TimerInitialize(SCU_TIMER_ID);

    // Inițializează VDMA
    vdmaConfig = XAxiVdma_LookupConfig(VDMA_ID);
    if (!vdmaConfig){
		xil_printf("No video DMA found for ID %d\r\n", VDMA_ID);
		return;
	}

    Status = XAxiVdma_CfgInitialize(&vdma, vdmaConfig, vdmaConfig->BaseAddress);
    if (Status != XST_SUCCESS){
		xil_printf("VDMA Configuration Initialization failed %d\r\n", Status);
		return;
	}

    // Inițializează display-ul (VDMA + VTC + dynamic clock)
    Status = DisplayInitialize(&dispCtrl, &vdma, HDMI_OUT_VTC_ID, DYNCLK_BASEADDR, pFrames, DEMO_STRIDE);
    if (Status != XST_SUCCESS){
		xil_printf("Display Ctrl initialization failed during demo initialization%d\r\n", Status);
		return;
	}

    // Pornește display-ul (VDMA + generator de timing)
    Status = DisplayStart(&dispCtrl);
    if (Status != XST_SUCCESS)
    	{
    		xil_printf("Couldn't start display during demo initialization%d\r\n", Status);
    		return;
    	}

    // Inițializează controller-ul de întreruperi
    Status = fnInitInterruptController(&intc);
    if (Status != XST_SUCCESS){
		xil_printf("Error initializing interrupts");
		return;
	}

    // Activează întreruperile video (GPIO + VTC)
    fnEnableInterrupts(&intc, &ivt[0], sizeof(ivt)/sizeof(ivt[0]));

    // Inițializează captura video HDMI IN
    Status = VideoInitialize(&videoCapt, &intc, &vdma, HDMI_IN_GPIO_ID, HDMI_IN_VTC_ID,
                             HDMI_IN_VTC_IRPT_ID, pFrames, DEMO_STRIDE, DEMO_START_ON_DET);

    if (Status != XST_SUCCESS){
		xil_printf("Video Ctrl initialization failed during demo initialization%d\r\n", Status);
		return;
	}

    // Setează callback-ul care va fi apelat când se primește un frame nou
    VideoSetCallback(&videoCapt, DemoISR, &fRefresh);

    // Afișează test pattern pe ecran (buffer curent)
    DemoPrintTest(dispCtrl.framePtr[dispCtrl.curFrame], dispCtrl.vMode.width, dispCtrl.vMode.height, dispCtrl.stride);
}


/*
 * Afișează meniul principal în UART
 * - arată rezoluția curentă
 * - oferă opțiuni de schimbare rezoluție sau quit
 */
void DemoPrintMenu()
{
    xil_printf("\x1B[H");   // cursor home
    xil_printf("\x1B[2J");  // clear screen
    xil_printf("**************************************************\n\r");
    xil_printf("*                Proiect Licenta                 *\n\r");
    xil_printf("**************************************************\n\r");
    xil_printf("*Display Resolution: %28s*\n\r", dispCtrl.vMode.label);
    printf("*Display Pixel Clock Freq. (MHz): %15.3f*\n\r", dispCtrl.pxlFreq);
    xil_printf("**************************************************\n\r");
    xil_printf("\n\r");
    xil_printf("1 - Change Display Resolution\n\r");
    xil_printf("q - Quit\n\r");
    xil_printf("\n\r");
    xil_printf("Enter a selection:");
}


/*
 * Afișează meniul de schimbare rezoluție
 * - listează toate modurile suportate
 * - așteaptă input de la UART
 */
void DemoCRMenu()
{
    xil_printf("\x1B[H");
    xil_printf("\x1B[2J");
    xil_printf("**************************************************\n\r");
    xil_printf("*                ZYBO Video Demo                 *\n\r");
    xil_printf("**************************************************\n\r");
    xil_printf("*Current Resolution: %28s*\n\r", dispCtrl.vMode.label);
    xil_printf("*Pixel Clock Freq. (MHz): %23.3f*\n\r", dispCtrl.pxlFreq);
    xil_printf("**************************************************\n\r");
    xil_printf("\n\r");
    xil_printf("1 - %s\n\r", VMODE_640x480.label);
    xil_printf("2 - %s\n\r", VMODE_800x600.label);
    xil_printf("3 - %s\n\r", VMODE_1280x720.label);
    xil_printf("4 - %s\n\r", VMODE_1280x1024.label);
    xil_printf("5 - %s\n\r", VMODE_1600x900.label);
    xil_printf("6 - %s\n\r", VMODE_1920x1080.label);
    xil_printf("q - Quit\n\r");
    xil_printf("\n\r");
    xil_printf("Select a new resolution:");
}


/*
 * Schimbă rezoluția display-ului
 * - oprește display-ul înainte de schimbare
 * - setează noul mode în display controller
 * - pornește din nou
 */
void DemoChangeRes()
{
	int fResSet = 0;
	int status;
	char userInput = 0;

	/* Flush UART FIFO */
	while (XUartPs_IsReceiveData(UART_BASEADDR))
	{
		XUartPs_ReadReg(UART_BASEADDR, XUARTPS_FIFO_OFFSET);
	}

	while (!fResSet)
	{
		DemoCRMenu();

		/* Wait for data on UART */
		while (!XUartPs_IsReceiveData(UART_BASEADDR))
		{}

		/* Store the first character in the UART recieve FIFO and echo it */
		userInput = XUartPs_ReadReg(UART_BASEADDR, XUARTPS_FIFO_OFFSET);
		xil_printf("%c", userInput);
		status = XST_SUCCESS;
		switch (userInput)
		{
		case '1':
			status = DisplayStop(&dispCtrl);
			DisplaySetMode(&dispCtrl, &VMODE_640x480);
			DisplayStart(&dispCtrl);
			fResSet = 1;
			break;
		case '2':
			status = DisplayStop(&dispCtrl);
			DisplaySetMode(&dispCtrl, &VMODE_800x600);
			DisplayStart(&dispCtrl);
			fResSet = 1;
			break;
		case '3':
			status = DisplayStop(&dispCtrl);
			DisplaySetMode(&dispCtrl, &VMODE_1280x720);
			DisplayStart(&dispCtrl);
			fResSet = 1;
			break;
		case '4':
			status = DisplayStop(&dispCtrl);
			DisplaySetMode(&dispCtrl, &VMODE_1280x1024);
			DisplayStart(&dispCtrl);
			fResSet = 1;
			break;
		case '5':
			status = DisplayStop(&dispCtrl);
			DisplaySetMode(&dispCtrl, &VMODE_1600x900);
			DisplayStart(&dispCtrl);
			fResSet = 1;
			break;
		case '6':
			status = DisplayStop(&dispCtrl);
			DisplaySetMode(&dispCtrl, &VMODE_1920x1080);
			DisplayStart(&dispCtrl);
			fResSet = 1;
			break;
		case 'q':
			fResSet = 1;
			break;
		default :
			xil_printf("\n\rInvalid Selection");
			TimerDelay(500000);
		}
		if (status == XST_DMA_ERROR)
		{
			xil_printf("\n\rWARNING: AXI VDMA Error detected and cleared\n\r");
		}
	}
}


/*
 * Bucla principală a demo-ului:
 * - afișează meniul principal
 * - așteaptă input UART sau refresh (frame nou capturat)
 * - permite schimbarea rezoluției
 */
void DemoRun()
{
    char userInput = 0;

    // Golire buffer UART la start
    while (XUartPs_IsReceiveData(UART_BASEADDR))
    {
    	XUartPs_ReadReg(UART_BASEADDR, XUARTPS_FIFO_OFFSET);
    }


    while (userInput != 'q')
    {
        fRefresh = 0;
        DemoPrintMenu();

        // Așteaptă input UART sau semnal de refresh (ISR)
        while (!XUartPs_IsReceiveData(UART_BASEADDR) && !fRefresh) {}

        if (XUartPs_IsReceiveData(UART_BASEADDR))
        {
            userInput = XUartPs_ReadReg(UART_BASEADDR, XUARTPS_FIFO_OFFSET);
            xil_printf("%c", userInput);
        }
        else
        {
            // Dacă a venit refresh, nu schimbăm nimic
            userInput = 'r';
        }

        switch (userInput)
        {
            case '1': DemoChangeRes(); break;
            case 'q': break;
            case 'r': break;
            default:
                xil_printf("\n\rInvalid Selection");
                TimerDelay(500000);
        }
    }
}


/*
 * ISR (callback) pentru captura video.
 * Setează flag-ul fRefresh la 1 când se primește un frame nou.
 * Acesta este semnalul pentru bucla principală.
 */
void DemoISR(void *callBackRef, void *pVideo)
{
    char *data = (char *)callBackRef;
    *data = 1;
}


/*
 * Punctul de intrare al programului
 */
int main(void)
{
    DemoInitialize();
    DemoRun();
    return 0;
}
