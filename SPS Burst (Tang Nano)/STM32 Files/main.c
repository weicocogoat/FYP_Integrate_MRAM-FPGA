/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2025 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
UART_HandleTypeDef huart2;

/* USER CODE BEGIN PV */

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_USART2_UART_Init(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_USART2_UART_Init();
  /* USER CODE BEGIN 2 */
  uint8_t tx_buff[64];
  int read_data[16];

  sprintf(tx_buff, "Starting Program\r\n");
  HAL_UART_Transmit(&huart2, tx_buff, 18, 1000);

  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */

/*---------------------------------------Reset the system---------------------------------------*/
/*
  	HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
  	HAL_Delay(5);
    HAL_GPIO_WritePin(GPIOC, rst_Pin, 1);
    HAL_GPIO_WritePin(GPIOB, burst_en_Pin, 0);
    HAL_GPIO_WritePin(GPIOC, mode_sel_Pin, 0);
    HAL_GPIO_WritePin(GPIOB, burst_len_in_Pin, 0);
    HAL_GPIO_WritePin(GPIOC, addr_in_Pin, 0);
    HAL_GPIO_WritePin(GPIOA, data_in_Pin, 0);
    HAL_GPIO_WritePin(GPIOA, rws_0_Pin, 1);
    HAL_GPIO_WritePin(GPIOA, rws_1_Pin, 1);
    HAL_GPIO_WritePin(GPIOB, rws_2_Pin, 1);
    HAL_Delay(5);

    HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
    HAL_Delay(10);
*/
/*-----------------------------------------------------------------------------------------------*/

/*-------------------------------Single byte write data to addr 0x0------------------------------*/
/*
    HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
    HAL_Delay(5);
    HAL_GPIO_WritePin(GPIOC, rst_Pin, 0);
    HAL_GPIO_WritePin(GPIOB, burst_en_Pin, 0);
    HAL_GPIO_WritePin(GPIOC, mode_sel_Pin, 0);
    HAL_GPIO_WritePin(GPIOB, burst_len_in_Pin, 0);
    HAL_GPIO_WritePin(GPIOC, addr_in_Pin, 0);
    HAL_GPIO_WritePin(GPIOA, data_in_Pin, 0);
    HAL_GPIO_WritePin(GPIOA, rws_0_Pin, 1);
    HAL_GPIO_WritePin(GPIOA, rws_1_Pin, 1);
    HAL_GPIO_WritePin(GPIOB, rws_2_Pin, 1);
    HAL_Delay(5);

    // Cycle 0
    HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
    HAL_Delay(10);

    HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
    HAL_Delay(5);

    // Cycles 1 to 19.
    for (int i = 0; i < 19; i++){
  	  HAL_GPIO_WritePin(GPIOA, data_in_Pin, i%2);
  	  if (i == 0)HAL_GPIO_WritePin (GPIOA, data_in_Pin, 1);
  	  HAL_Delay(5);

  	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
  	  HAL_Delay(10);

  	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
  	  HAL_Delay(5);
    }

    // Cycles 20 to 22
    for (int i = 0; i < 3; i++){
      	HAL_GPIO_WritePin(GPIOA, data_in_Pin, i%2);
      	HAL_Delay(5);
      	HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
      	HAL_Delay(10);
		HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
		HAL_Delay(5);
    }
*/
/*----------------------------------------------------------------------------------------------*/

/*---------------------------------------Reset the system---------------------------------------*/
/*
    HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
    HAL_Delay(5);
	HAL_GPIO_WritePin(GPIOC, rst_Pin, 1);
	HAL_GPIO_WritePin(GPIOB, burst_en_Pin, 0);
	HAL_GPIO_WritePin(GPIOC, mode_sel_Pin, 0);
	HAL_GPIO_WritePin(GPIOB, burst_len_in_Pin, 0);
	HAL_GPIO_WritePin(GPIOC, addr_in_Pin, 0);
	HAL_GPIO_WritePin(GPIOA, data_in_Pin, 0);
	HAL_GPIO_WritePin(GPIOA, rws_0_Pin, 0);
	HAL_GPIO_WritePin(GPIOA, rws_1_Pin, 1);
	HAL_GPIO_WritePin(GPIOB, rws_2_Pin, 1);
	HAL_Delay(5);

	HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	HAL_Delay(10);
*/
/*----------------------------------------------------------------------------------------------*/

/*-------------------------------Single byte read data at addr 0x0------------------------------*/
/*
    HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
    HAL_Delay(5);
    HAL_GPIO_WritePin(GPIOC, rst_Pin, 0);
    HAL_GPIO_WritePin(GPIOB, burst_en_Pin, 0);
    HAL_GPIO_WritePin(GPIOC, mode_sel_Pin, 0);
    HAL_GPIO_WritePin(GPIOB, burst_len_in_Pin, 0);
    HAL_GPIO_WritePin(GPIOC, addr_in_Pin, 0);
    HAL_GPIO_WritePin(GPIOA, data_in_Pin, 0);
    HAL_GPIO_WritePin(GPIOA, rws_0_Pin, 0);
    HAL_GPIO_WritePin(GPIOA, rws_1_Pin, 1);
    HAL_GPIO_WritePin(GPIOB, rws_2_Pin, 1);
    HAL_Delay(5);


    // Cycle 0 to 22
    for (int i = 0; i < 23; i++){
    	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
    	  HAL_Delay(10);
    	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
    	  HAL_Delay(10);
    }

    // Stall for 1 cycle. Serial data is output from cycle 1 onwards
    for (int i = 0; i < 2; i++){
    	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	      HAL_Delay(10);
    	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
    	  HAL_Delay(10);
    }

    for (int i = 0; i < 16; i++){
  	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
  	  read_data[i] = HAL_GPIO_ReadPin(GPIOB, PTS_ser_out_Pin);
  	  sprintf(tx_buff, "Data[%d]: %d \r\n", i, read_data[i]);
  	  HAL_UART_Transmit(&huart2, tx_buff, 14, 1000);
  	  HAL_Delay(100);
  	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
  	  HAL_Delay(100);
    }

    sprintf(tx_buff, "Data: %d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d \r\n", read_data[15], read_data[14], read_data[13], read_data[12], read_data[11], read_data[10], read_data[9], read_data[8], read_data[7], read_data[6], read_data[5], read_data[4], read_data[3], read_data[2], read_data[1], read_data[0]);
    HAL_UART_Transmit(&huart2, tx_buff, 27, 1000);
*/
/*----------------------------------------------------------------------------------------------*/

/*---------------------------------------Reset the system---------------------------------------*/

	HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	HAL_Delay(5);
	HAL_GPIO_WritePin(GPIOC, rst_Pin, 1);
	HAL_GPIO_WritePin(GPIOB, burst_en_Pin, 0);
	HAL_GPIO_WritePin(GPIOC, mode_sel_Pin, 0);
	HAL_GPIO_WritePin(GPIOB, burst_len_in_Pin, 0);
	HAL_GPIO_WritePin(GPIOC, addr_in_Pin, 0);
	HAL_GPIO_WritePin(GPIOA, data_in_Pin, 0);
	HAL_GPIO_WritePin(GPIOA, rws_0_Pin, 1);
	HAL_GPIO_WritePin(GPIOA, rws_1_Pin, 1);
	HAL_GPIO_WritePin(GPIOB, rws_2_Pin, 1);
	HAL_Delay(5);

	HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	HAL_Delay(10);

/*----------------------------------------------------------------------------------------------*/

/*------------------------------Burst write of length 3 to addr 0x0-----------------------------*/

	// Write 0xffff to addr 0
    HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
    HAL_Delay(5);
    HAL_GPIO_WritePin(GPIOC, rst_Pin, 0);
    HAL_GPIO_WritePin(GPIOB, burst_en_Pin, 1);
    HAL_GPIO_WritePin(GPIOC, mode_sel_Pin, 1);
    HAL_GPIO_WritePin(GPIOB, burst_len_in_Pin, 1);
    HAL_GPIO_WritePin(GPIOC, addr_in_Pin, 0);
    HAL_GPIO_WritePin(GPIOA, data_in_Pin, 1);
    HAL_GPIO_WritePin(GPIOA, rws_0_Pin, 1);
    HAL_GPIO_WritePin(GPIOA, rws_1_Pin, 1);
    HAL_GPIO_WritePin(GPIOB, rws_2_Pin, 1);
    HAL_Delay(5);

    // Cycle 0
    HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
    HAL_Delay(10);
    HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
    HAL_Delay(10);

    // Cycle 1, first bit of burst_len gets loaded in
    HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	HAL_Delay(10);
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	HAL_Delay(10);

	// Cycle 2, second bit of burst_len gets laoded in
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	HAL_Delay(10);
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	HAL_Delay(5);
	HAL_GPIO_WritePin(GPIOB, burst_len_in_Pin, 0);
	HAL_Delay(5);

	// Cycle 3 to 19
	for (int i = 0; i < 17; i++){
	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	  HAL_Delay(10);
	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	  HAL_Delay(10);
	}

	// Cycles 20 to 22
	for (int i = 0; i < 3; i++){
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
		  HAL_Delay(10);
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
		  HAL_Delay(10);
	}

	// Loop 2, write 0101_0101_0101_0101 to addr 1
	// Cycle 0
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	HAL_Delay(10);
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	HAL_Delay(5);
	HAL_GPIO_WritePin(GPIOA, data_in_Pin, 0);
	HAL_Delay(5);

	// Cycle 1 to 19
	for (int i = 0; i < 19; i++){
		HAL_GPIO_WritePin(GPIOA, data_in_Pin, i%2);
		if (i == 0)HAL_GPIO_WritePin (GPIOA, data_in_Pin, 1);
		HAL_Delay(5);

		HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
		HAL_Delay(10);

		HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
		HAL_Delay(5);
	}

	// Cycle 20 to 22
	for (int i = 0; i < 3; i++){
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
		  HAL_Delay(10);
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
		  HAL_Delay(10);
	}

	// Loop 3 write 0 to addr 2
	// Cycle 0
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	HAL_Delay(10);
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	HAL_Delay(5);
	HAL_GPIO_WritePin(GPIOA, data_in_Pin, 0);
	HAL_Delay(5);

	// Cycle 1 to 19
	for (int i = 0; i < 19; i++){
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
		  HAL_Delay(10);
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
		  HAL_Delay(10);
	}

	// Cycle 20 to 22
	for (int i = 0; i < 3; i++){
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
		  HAL_Delay(10);
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
		  HAL_Delay(10);
	}

/*----------------------------------------------------------------------------------------------*/

/*---------------------------------------Reset the system---------------------------------------*/

	HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	HAL_Delay(5);
	HAL_GPIO_WritePin(GPIOC, rst_Pin, 1);
	HAL_GPIO_WritePin(GPIOB, burst_en_Pin, 0);
	HAL_GPIO_WritePin(GPIOC, mode_sel_Pin, 0);
	HAL_GPIO_WritePin(GPIOB, burst_len_in_Pin, 0);
	HAL_GPIO_WritePin(GPIOC, addr_in_Pin, 0);
	HAL_GPIO_WritePin(GPIOA, data_in_Pin, 0);
	HAL_GPIO_WritePin(GPIOA, rws_0_Pin, 0);
	HAL_GPIO_WritePin(GPIOA, rws_1_Pin, 1);
	HAL_GPIO_WritePin(GPIOB, rws_2_Pin, 1);
	HAL_Delay(5);

	HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	HAL_Delay(10);


/*----------------------------------------------------------------------------------------------*/

/*---------------------------Burst read data at addr 0x1, length of 3---------------------------*/
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	HAL_Delay(5);
	HAL_GPIO_WritePin(GPIOC, rst_Pin, 0);
	HAL_GPIO_WritePin(GPIOB, burst_en_Pin, 1);
	HAL_GPIO_WritePin(GPIOC, mode_sel_Pin, 1);
	HAL_GPIO_WritePin(GPIOB, burst_len_in_Pin, 1);
	HAL_GPIO_WritePin(GPIOC, addr_in_Pin, 0);
	HAL_GPIO_WritePin(GPIOA, data_in_Pin, 0);
	HAL_GPIO_WritePin(GPIOA, rws_0_Pin, 0);
	HAL_GPIO_WritePin(GPIOA, rws_1_Pin, 1);
	HAL_GPIO_WritePin(GPIOB, rws_2_Pin, 1);
	HAL_Delay(5);

	// Cycle 0
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	HAL_Delay(10);
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	HAL_Delay(10);

	// Cycle 1, first bit of burst_len gets loaded in
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	HAL_Delay(10);
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	HAL_Delay(10);

	// Cycle 2, second bit of burst_len gets laoded in
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	HAL_Delay(10);
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	HAL_Delay(5);
	HAL_GPIO_WritePin(GPIOB, burst_len_in_Pin, 0);
	HAL_Delay(5);

	// Cycle 3 to 19
	for (int i = 0; i < 17; i++){
	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	  HAL_Delay(10);
	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	  HAL_Delay(10);
	}

	// Cycles 20 to 22
	for (int i = 0; i < 3; i++){
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
		  HAL_Delay(10);
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
		  HAL_Delay(10);
	}

	// Loop 2
	for (int i = 0; i < 2; i++){
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
		  HAL_Delay(10);
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
		  HAL_Delay(10);
	}

	for (int i = 0; i < 16; i++){
	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	  read_data[i] = HAL_GPIO_ReadPin(GPIOB, PTS_ser_out_Pin);
	  sprintf(tx_buff, "Data[%d]: %d \r\n", i, read_data[i]);
	  HAL_UART_Transmit(&huart2, tx_buff, 14, 1000);
	  HAL_Delay(100);
	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	  HAL_Delay(100);
	}

	sprintf(tx_buff, "Data: %d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d \r\n", read_data[15], read_data[14], read_data[13], read_data[12], read_data[11], read_data[10], read_data[9], read_data[8], read_data[7], read_data[6], read_data[5], read_data[4], read_data[3], read_data[2], read_data[1], read_data[0]);
	HAL_UART_Transmit(&huart2, tx_buff, 27, 1000);

	// Stall until end of loop
	for (int i = 0; i < 5; i++){
			  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
			  HAL_Delay(10);
			  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
			  HAL_Delay(10);
	}

	// loop 3
	for (int i = 0; i < 2; i++){
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
		  HAL_Delay(10);
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
		  HAL_Delay(10);
	}

	for (int i = 0; i < 16; i++){
	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	  read_data[i] = HAL_GPIO_ReadPin(GPIOB, PTS_ser_out_Pin);
	  sprintf(tx_buff, "Data[%d]: %d \r\n", i, read_data[i]);
	  HAL_UART_Transmit(&huart2, tx_buff, 14, 1000);
	  HAL_Delay(100);
	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	  HAL_Delay(100);
	}

	sprintf(tx_buff, "Data: %d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d \r\n", read_data[15], read_data[14], read_data[13], read_data[12], read_data[11], read_data[10], read_data[9], read_data[8], read_data[7], read_data[6], read_data[5], read_data[4], read_data[3], read_data[2], read_data[1], read_data[0]);
	HAL_UART_Transmit(&huart2, tx_buff, 27, 1000);

	// Stall until end of loop
	for (int i = 0; i < 5; i++){
			  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
			  HAL_Delay(10);
			  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
			  HAL_Delay(10);
	}

	// Loop 4
	for (int i = 0; i < 2; i++){
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
		  HAL_Delay(10);
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
		  HAL_Delay(10);
	}

	for (int i = 0; i < 16; i++){
	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	  read_data[i] = HAL_GPIO_ReadPin(GPIOB, PTS_ser_out_Pin);
	  sprintf(tx_buff, "Data[%d]: %d \r\n", i, read_data[i]);
	  HAL_UART_Transmit(&huart2, tx_buff, 14, 1000);
	  HAL_Delay(100);
	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	  HAL_Delay(100);
	}

	sprintf(tx_buff, "Data: %d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d \r\n", read_data[15], read_data[14], read_data[13], read_data[12], read_data[11], read_data[10], read_data[9], read_data[8], read_data[7], read_data[6], read_data[5], read_data[4], read_data[3], read_data[2], read_data[1], read_data[0]);
	HAL_UART_Transmit(&huart2, tx_buff, 27, 1000);

/*----------------------------------------------------------------------------------------------*/

/*-------------------------------Single byte read data at addr 0x1------------------------------*/
/*
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	HAL_Delay(5);
	HAL_GPIO_WritePin(GPIOC, rst_Pin, 0);
	HAL_GPIO_WritePin(GPIOB, burst_en_Pin, 0);
	HAL_GPIO_WritePin(GPIOC, mode_sel_Pin, 0);
	HAL_GPIO_WritePin(GPIOB, burst_len_in_Pin, 0);
	HAL_GPIO_WritePin(GPIOC, addr_in_Pin, 0);
	HAL_GPIO_WritePin(GPIOA, data_in_Pin, 0);
	HAL_GPIO_WritePin(GPIOA, rws_0_Pin, 0);
	HAL_GPIO_WritePin(GPIOA, rws_1_Pin, 1);
	HAL_GPIO_WritePin(GPIOB, rws_2_Pin, 1);
	HAL_Delay(5);

	// Cycle 0
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	HAL_Delay(10);
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	HAL_Delay(5);

	// Cycle 1, first bit of addr
	HAL_GPIO_WritePin(GPIOC, addr_in_Pin, 1);
	HAL_Delay(5);
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	HAL_Delay(10);
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	HAL_Delay(5);

	// Cycle 2
	HAL_GPIO_WritePin(GPIOC, addr_in_Pin, 0);
	HAL_Delay(5);
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	HAL_Delay(10);
	HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	HAL_Delay(10);


	// Cycle 3 to 22
	for (int i = 0; i < 20; i++){
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
		  HAL_Delay(10);
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
		  HAL_Delay(10);
	}

	// Stall for 1 cycle. Serial data is output from cycle 1 onwards
	for (int i = 0; i < 2; i++){
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
		  HAL_Delay(10);
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
		  HAL_Delay(10);
	}

	for (int i = 0; i < 16; i++){
	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	  read_data[i] = HAL_GPIO_ReadPin(GPIOB, PTS_ser_out_Pin);
	  sprintf(tx_buff, "Data[%d]: %d \r\n", i, read_data[i]);
	  HAL_UART_Transmit(&huart2, tx_buff, 14, 1000);
	  HAL_Delay(100);
	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	  HAL_Delay(100);
	}

	sprintf(tx_buff, "Data: %d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d \r\n", read_data[15], read_data[14], read_data[13], read_data[12], read_data[11], read_data[10], read_data[9], read_data[8], read_data[7], read_data[6], read_data[5], read_data[4], read_data[3], read_data[2], read_data[1], read_data[0]);
	HAL_UART_Transmit(&huart2, tx_buff, 27, 1000);
*/
/*----------------------------------------------------------------------------------------------*/


  while (1)
  {
    /* USER CODE END WHILE */
	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	  HAL_Delay(10);
	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	  HAL_Delay(10);
    /* USER CODE BEGIN 3 */
  }
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Configure the main internal regulator output voltage
  */
  __HAL_RCC_PWR_CLK_ENABLE();
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSI;
  RCC_OscInitStruct.PLL.PLLM = 16;
  RCC_OscInitStruct.PLL.PLLN = 336;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV4;
  RCC_OscInitStruct.PLL.PLLQ = 4;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_2) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief USART2 Initialization Function
  * @param None
  * @retval None
  */
static void MX_USART2_UART_Init(void)
{

  /* USER CODE BEGIN USART2_Init 0 */

  /* USER CODE END USART2_Init 0 */

  /* USER CODE BEGIN USART2_Init 1 */

  /* USER CODE END USART2_Init 1 */
  huart2.Instance = USART2;
  huart2.Init.BaudRate = 115200;
  huart2.Init.WordLength = UART_WORDLENGTH_8B;
  huart2.Init.StopBits = UART_STOPBITS_1;
  huart2.Init.Parity = UART_PARITY_NONE;
  huart2.Init.Mode = UART_MODE_TX_RX;
  huart2.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart2.Init.OverSampling = UART_OVERSAMPLING_16;
  if (HAL_UART_Init(&huart2) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN USART2_Init 2 */

  /* USER CODE END USART2_Init 2 */

}

/**
  * @brief GPIO Initialization Function
  * @param None
  * @retval None
  */
static void MX_GPIO_Init(void)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};
/* USER CODE BEGIN MX_GPIO_Init_1 */
/* USER CODE END MX_GPIO_Init_1 */

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOC_CLK_ENABLE();
  __HAL_RCC_GPIOH_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOA, LD2_Pin|data_in_Pin|rws_1_Pin|rws_0_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOC, addr_in_Pin|mode_sel_Pin|rst_Pin|clk_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOB, rws_2_Pin|burst_en_Pin|burst_len_in_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin : B1_Pin */
  GPIO_InitStruct.Pin = B1_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_IT_FALLING;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(B1_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pins : LD2_Pin data_in_Pin rws_1_Pin rws_0_Pin */
  GPIO_InitStruct.Pin = LD2_Pin|data_in_Pin|rws_1_Pin|rws_0_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

  /*Configure GPIO pins : addr_in_Pin mode_sel_Pin rst_Pin clk_Pin */
  GPIO_InitStruct.Pin = addr_in_Pin|mode_sel_Pin|rst_Pin|clk_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);

  /*Configure GPIO pins : rws_2_Pin burst_en_Pin burst_len_in_Pin */
  GPIO_InitStruct.Pin = rws_2_Pin|burst_en_Pin|burst_len_in_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

  /*Configure GPIO pin : PTS_ser_out_Pin */
  GPIO_InitStruct.Pin = PTS_ser_out_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(PTS_ser_out_GPIO_Port, &GPIO_InitStruct);

/* USER CODE BEGIN MX_GPIO_Init_2 */
/* USER CODE END MX_GPIO_Init_2 */
}

/* USER CODE BEGIN 4 */

/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
