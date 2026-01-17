#include "xil_io.h"
#include "sleep.h"

#define LED_BASE_ADDR 0x41200000 // Replace with your GPIO physical address if needed
#define LED_MASK      0xF        // 4-bit LEDs

int main(void) {
    unsigned int led_val = 1;

    while (1) {
        // Write LED value
        Xil_Out32(LED_BASE_ADDR, led_val);

        // Wait ~0.5 sec
        usleep(500000);

        // Rotate LEDs
        led_val <<= 1;
        if (led_val > LED_MASK) led_val = 1;
    }

    return 0;
}
