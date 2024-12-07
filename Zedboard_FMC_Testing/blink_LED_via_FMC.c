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
    XGpio LED1_GPIO;
    XGpio LED2_GPIO;
    unsigned int LED_value = 0;

    init_platform();

    print("Testing GPIO\n\r");

    XGpio_Initialize(&LED1_GPIO, XPAR_AXI_GPIO_0_BASEADDR);
    XGpio_Initialize(&LED2_GPIO, XPAR_AXI_GPIO_1_BASEADDR);

    XGpio_SetDataDirection(&LED1_GPIO, 1, 0x0);
    XGpio_SetDataDirection(&LED2_GPIO, 1, 0x0);

    while (1){
        XGpio_DiscreteWrite(&LED1_GPIO, 1, LED_value);
        XGpio_DiscreteWrite(&LED2_GPIO, 1, LED_value);
        LED_value = ~LED_value;
        sleep(1);
    }

    cleanup_platform();
    return 0;
}
