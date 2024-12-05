/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/
/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"

#include "xgpio.h"
#include "xparameters.h"
#include "stdio.h"
#include "sleep.h"


int main()
{
    XGpio DIP_GPIO;
    XGpio LED_GPIO;
    unsigned int DIP_value;
    unsigned int LED_value;

    init_platform();

    print("Hello World\n\r");

    // Initialize the GPIO configuration. Refer to xparameters.h and get the base addr of AXI_GPIO_0 and AXI_GPIO_1
    XGpio_Initialize(&DIP_GPIO, XPAR_AXI_GPIO_0_BASEADDR);
    XGpio_Initialize(&LED_GPIO, XPAR_AXI_GPIO_1_BASEADDR);

    // Set the GPIO for DIP switches to input
    XGpio_SetDataDirection(&DIP_GPIO, 1, 0xff);
    // Set the GPIO for LED switches to output
    XGpio_SetDataDirection(&LED_GPIO, 1, 0x00);

    // Write 1 to the LEDs initially. (useful for debugging)
    XGpio_DiscreteWrite(&LED_GPIO, 1, 0xFF);

    while (1)
	{
		// Read from the GPIO to determine the position of the DIP switches
		DIP_value = XGpio_DiscreteRead(&DIP_GPIO, 1);

        LED_value = DIP_value;

		// Write the value back to the GPIO
		XGpio_DiscreteWrite(&LED_GPIO, 1, LED_value);

        sleep(1);
	}

    cleanup_platform();
    return 0;
}
