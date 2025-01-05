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
    XGpio GPIO_output;
    XGpio GPIO_input;
    unsigned int GPIO_value;
    unsigned int read_value;
    init_platform();

    print("Starting SPS burst\n\r");
    
    XGpio_Initialize(&GPIO_output, XPAR_AXI_GPIO_0_BASEADDR);
    XGpio_Initialize(&GPIO_input, XPAR_AXI_GPIO_1_BASEADDR);

    XGpio_SetDataDirection(&GPIO_output, 1, 0x000);
    XGpio_SetDataDirection(&GPIO_input, 1, 0x1);

    /* GPIO output in order:
    0 -> clk
    1 -> rst
    2 -> burst_en
    3 -> mode_sel
    4 -> burst_len_in
    5 -> addr_in
    6 -> data_in
    7 -> read_write_sel[0]
    8 -> read_write_sel[1]
    9 -> read_write_sel[2]

    GPIO input:
    PTS_ser_data_out
    */

//-----------------------BURST WRITE AT ADDR 0----------------------------------------------//
/*
    // Reset the module. 
    print("Starting burst write of length 3\n\r");
    GPIO_value = 0b1110000010;
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);
    GPIO_value = 0b1110000011;
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);

    // Cycle 0
    GPIO_value = 0b1111011101;      // Pull rst low
    GPIO_value = GPIO_value ^ 0b0000000001;         // toggle clock
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);
    GPIO_value = GPIO_value ^ 0b0000000001;
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);
    
    // Cycle 1, Set burst length to 3
    GPIO_value = 0b1110011101;      
    GPIO_value = GPIO_value ^ 0b0001000001;         // toggle clock
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);
    GPIO_value = GPIO_value ^ 0b0000000001;
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);

    // Cycle 2, Set burst length to 3
    GPIO_value = 0b1110011101;      
    GPIO_value = GPIO_value ^ 0b0001000001;         // toggle clock
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);
    GPIO_value = GPIO_value ^ 0b0000000001;
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);

    GPIO_value = 0b1110001101;  
    // Cycles 3 to 20. Full byte write to addr 0, burst of 3   
    for (int i = 0; i < 17; i++){
        GPIO_value = GPIO_value ^ 0b0001000001;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
        GPIO_value = GPIO_value ^ 0b0000000001;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
    }

    // Cycles 21-23 to stall
    for (int i = 0; i < 3; i++){
        GPIO_value = 0b1110001100;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
        GPIO_value = 0b1110001101;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
    }


    GPIO_value = 0b1110011101;
    // Stall for 2 more loops
    for (int i = 0; i < 46; i++){
        GPIO_value = 0b1110001100;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
        GPIO_value = 0b1110001101;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
    }

    print("Burst write of length 3 completed\n\r");
   */
//--------------------END OF BURST WRITE AT ADDR 0------------------------------------------//

//---------------------------BURST READ AT ADDR 0-------------------------------------------//
    // Reset the module. 
    print("Starting burst read of length 3\n\r");
    GPIO_value = 0b1100000010;
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);
    GPIO_value = 0b1110000011;
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);

    // Cycle 0
    GPIO_value = 0b1101011101;      // Pull rst low
    GPIO_value = GPIO_value ^ 0b0000000001;         // toggle clock
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);
    GPIO_value = GPIO_value ^ 0b0000000001;
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);

    // Cycle 1, Set burst length to 3
    GPIO_value = 0b1100011101;      
    GPIO_value = GPIO_value ^ 0b0001000001;         // toggle clock
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);
    GPIO_value = GPIO_value ^ 0b0000000001;
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);

    // Cycle 2, Set burst length to 3
    GPIO_value = 0b1100011101;      
    GPIO_value = GPIO_value ^ 0b0001000001;         // toggle clock
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);
    GPIO_value = GPIO_value ^ 0b0000000001;
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);

    GPIO_value = 0b1100001101;  
    // Cycles 3 to 20. Full byte write to addr 0, burst of 3   
    for (int i = 0; i < 17; i++){
        GPIO_value = GPIO_value ^ 0b0001000001;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
        GPIO_value = GPIO_value ^ 0b0000000001;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
    }

    // Cycles 21-23 to stall
    for (int i = 0; i < 3; i++){
        GPIO_value = 0b1100001100;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
        GPIO_value = 0b1100001101;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
    }


    GPIO_value = 0b1100011101;
    // Stall for 2 more loops
    for (int i = 0; i < 46; i++){
        GPIO_value = 0b1100001100;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
        GPIO_value = 0b1100001101;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
    }

    print("Burst read of length 3 completed\n\r");


//-------------------FULL BYTE WRITE AT ADDR 0----------------------------------------------//
/*
    // Reset the module. 
    print("Starting single byte write\n\r");
    GPIO_value = 0b1110000010;
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);
    GPIO_value = 0b1110000011;
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);

    GPIO_value = 0b1110000001;      // Pull rst low

    // Cycles 0 to 20. Full byte write to addr 0, no burst
    for (int i = 0; i < 20; i++){
        GPIO_value = GPIO_value ^ 0b0001000001;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
        GPIO_value = GPIO_value ^ 0b0000000001;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
    }

    // Cycles 21-23 to stall
    for (int i = 0; i < 3; i++){
        GPIO_value = 0b1110000000;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
        GPIO_value = 0b1110000001;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
    }
    
    print("Single byte write completed\n\r");
*/

//---------------------------FULL BYTE READ AT ADDR 0---------------------------//
/*
    // Rst the module
    print("Starting single byte read\n\r");
    GPIO_value = 0b1100000010;
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);
    GPIO_value = 0b1100000011;
    XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
    usleep(100);

    GPIO_value = 0b1100000001;      // Pull rst low

    // Cycles 0 to 23. Full byte read at addr 0
    for (int i = 0; i < 23; i++){
        GPIO_value = GPIO_value ^ 0b0000000001;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
        GPIO_value = GPIO_value ^ 0b0000000001;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
    }


    // Stall until cycle 4 when output is present
    for (int i = 0; i < 4; i++){
        GPIO_value = GPIO_value ^ 0b0000000001;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
        GPIO_value = GPIO_value ^ 0b0000000001;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
    }

    for (int i = 0; i < 16; i++){
        GPIO_value = GPIO_value ^ 0b0000000001;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        read_value = XGpio_DiscreteRead(&GPIO_input, 1);
        usleep(100);

        GPIO_value = GPIO_value ^ 0b0000000001;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        printf("Data[%d]: %d\n\r", i, read_value);
        usleep(100);
    }

    print("Single byte read completed\n\r");
*/
//---------------------------FULL BYTE READ AT END---------------------------//


    while (1){
        GPIO_value = 0b1110000010;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);

        GPIO_value = 0b1110000011;
        XGpio_DiscreteWrite(&GPIO_output, 1, GPIO_value);
        usleep(100);
    }

    cleanup_platform();
    return 0;
}