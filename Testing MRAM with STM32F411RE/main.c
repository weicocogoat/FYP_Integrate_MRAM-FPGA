/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2024 STMicroelectronics.
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
  int status[16];

  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  sprintf(tx_buff, "Starting Program\r\n");
  HAL_UART_Transmit(&huart2, tx_buff, 18, 1000);

  // Data Pins
  HAL_GPIO_WritePin(GPIOC, data_0_Pin, 0);
  HAL_GPIO_WritePin(GPIOC, data_1_Pin, 0);
  HAL_GPIO_WritePin(GPIOB, data_2_Pin, 0);
  HAL_GPIO_WritePin(GPIOC, data_3_Pin, 0);
  HAL_GPIO_WritePin(GPIOB, data_4_Pin, 0);
  HAL_GPIO_WritePin(GPIOC, data_5_Pin, 0);
  HAL_GPIO_WritePin(GPIOA, data_6_Pin, 0);
  HAL_GPIO_WritePin(GPIOA, data_7_Pin, 0);
  HAL_GPIO_WritePin(GPIOA, data_8_Pin, 0);
  HAL_GPIO_WritePin(GPIOA, data_9_Pin, 0);
  HAL_GPIO_WritePin(GPIOA, data_10_Pin, 0);
  HAL_GPIO_WritePin(GPIOB, data_11_Pin, 0);
  HAL_GPIO_WritePin(GPIOB, data_12_Pin, 0);
  HAL_GPIO_WritePin(GPIOC, data_13_Pin, 0);
  HAL_GPIO_WritePin(GPIOA, data_14_Pin, 0);
  HAL_GPIO_WritePin(GPIOB, data_15_Pin, 0);

  // Addr Pins
  HAL_GPIO_WritePin(GPIOA, addr_0_Pin, 0);
  HAL_GPIO_WritePin(GPIOB, addr_1_Pin, 0);
  HAL_GPIO_WritePin(GPIOB, addr_2_Pin, 0);
  HAL_GPIO_WritePin(GPIOB, addr_3_Pin, 0);
  HAL_GPIO_WritePin(GPIOB, addr_4_Pin, 0);
  HAL_GPIO_WritePin(GPIOB, addr_5_Pin, 0);
  HAL_GPIO_WritePin(GPIOB, addr_6_Pin, 0);
  HAL_GPIO_WritePin(GPIOB, addr_7_Pin, 0);
  HAL_GPIO_WritePin(GPIOA, addr_8_Pin, 0);
  HAL_GPIO_WritePin(GPIOC, addr_9_Pin, 0);
  HAL_GPIO_WritePin(GPIOC, addr_10_Pin, 0);
  HAL_GPIO_WritePin(GPIOC, addr_11_Pin, 0);
  HAL_GPIO_WritePin(GPIOC, addr_12_Pin, 0);
  HAL_GPIO_WritePin(GPIOD, addr_13_Pin, 0);
  HAL_GPIO_WritePin(GPIOB, addr_14_Pin, 0);
  HAL_GPIO_WritePin(GPIOA, addr_15_Pin, 0);
  HAL_GPIO_WritePin(GPIOA, addr_16_Pin, 0);
  HAL_GPIO_WritePin(GPIOA, addr_17_Pin, 0);
  HAL_GPIO_WritePin(GPIOA, addr_18_19_Pin, 0);

  // Control Pins
  HAL_GPIO_WritePin(GPIOB, CE_Pin, 1);
  HAL_GPIO_WritePin(GPIOC, Read_En_Pin, 1);
  HAL_GPIO_WritePin(GPIOC, Write_En_Pin, 1);
  HAL_GPIO_WritePin(GPIOC, LB_En_Pin, 1);
  HAL_GPIO_WritePin(GPIOC, UB_En_Pin, 1);

  HAL_Delay(1000);

  // Write to MRAM at addr 0x0
  HAL_GPIO_WritePin(GPIOB, CE_Pin, 0);
  HAL_GPIO_WritePin(GPIOC, Read_En_Pin, 1);
  HAL_GPIO_WritePin(GPIOC, Write_En_Pin, 0);
  HAL_GPIO_WritePin(GPIOC, LB_En_Pin, 0);
  HAL_GPIO_WritePin(GPIOC, UB_En_Pin, 0);

  HAL_Delay(200);

  // Reset signals and prepare to write to addr 0x1
  HAL_GPIO_WritePin(GPIOB, CE_Pin, 1);
  HAL_GPIO_WritePin(GPIOC, Read_En_Pin, 1);
  HAL_GPIO_WritePin(GPIOC, Write_En_Pin, 1);
  HAL_GPIO_WritePin(GPIOC, LB_En_Pin, 1);
  HAL_GPIO_WritePin(GPIOC, UB_En_Pin, 1);

  HAL_Delay(200);

  HAL_GPIO_WritePin(GPIOA, addr_0_Pin, 1);

  HAL_GPIO_WritePin(GPIOC, data_0_Pin, 0);
  HAL_GPIO_WritePin(GPIOC, data_1_Pin, 0);
  HAL_GPIO_WritePin(GPIOB, data_2_Pin, 0);
  HAL_GPIO_WritePin(GPIOC, data_3_Pin, 0);
  HAL_GPIO_WritePin(GPIOB, data_4_Pin, 0);
  HAL_GPIO_WritePin(GPIOC, data_5_Pin, 0);
  HAL_GPIO_WritePin(GPIOA, data_6_Pin, 0);
  HAL_GPIO_WritePin(GPIOA, data_7_Pin, 0);
  HAL_GPIO_WritePin(GPIOA, data_8_Pin, 1);
  HAL_GPIO_WritePin(GPIOA, data_9_Pin, 1);
  HAL_GPIO_WritePin(GPIOA, data_10_Pin, 1);
  HAL_GPIO_WritePin(GPIOB, data_11_Pin, 1);
  HAL_GPIO_WritePin(GPIOB, data_12_Pin, 1);
  HAL_GPIO_WritePin(GPIOC, data_13_Pin, 1);
  HAL_GPIO_WritePin(GPIOA, data_14_Pin, 1);
  HAL_GPIO_WritePin(GPIOB, data_15_Pin, 1);

  HAL_Delay(200);

  // Write to MRAM at addr 0x1
    HAL_GPIO_WritePin(GPIOB, CE_Pin, 0);
    HAL_GPIO_WritePin(GPIOC, Read_En_Pin, 1);
    HAL_GPIO_WritePin(GPIOC, Write_En_Pin, 0);
    HAL_GPIO_WritePin(GPIOC, LB_En_Pin, 0);
    HAL_GPIO_WritePin(GPIOC, UB_En_Pin, 0);

    HAL_Delay(200);

  // Set up for reading
  HAL_GPIO_WritePin(GPIOB, CE_Pin, 1);
  HAL_GPIO_WritePin(GPIOC, Read_En_Pin, 1);
  HAL_GPIO_WritePin(GPIOC, Write_En_Pin, 1);
  HAL_GPIO_WritePin(GPIOC, LB_En_Pin, 1);
  HAL_GPIO_WritePin(GPIOC, UB_En_Pin, 1);

  HAL_Delay(100);

  //GPIOx->MODER &= ~(GPIO_MODER_MODERy); 		// x-> GPIOx, y-> Pin no
  GPIOC->MODER &= ~(GPIO_MODER_MODER9);
  GPIOC->MODER &= ~(GPIO_MODER_MODER8);
  GPIOB->MODER &= ~(GPIO_MODER_MODER8);
  GPIOC->MODER &= ~(GPIO_MODER_MODER6);
  GPIOB->MODER &= ~(GPIO_MODER_MODER9);
  GPIOC->MODER &= ~(GPIO_MODER_MODER5);
  GPIOA->MODER &= ~(GPIO_MODER_MODER5);
  GPIOA->MODER &= ~(GPIO_MODER_MODER12);
  GPIOA->MODER &= ~(GPIO_MODER_MODER6);
  GPIOA->MODER &= ~(GPIO_MODER_MODER11);
  GPIOA->MODER &= ~(GPIO_MODER_MODER7);
  GPIOB->MODER &= ~(GPIO_MODER_MODER12);
  GPIOB->MODER &= ~(GPIO_MODER_MODER6);
  GPIOC->MODER &= ~(GPIO_MODER_MODER7);
  GPIOA->MODER &= ~(GPIO_MODER_MODER9);
  GPIOB->MODER &= ~(GPIO_MODER_MODER2);

  HAL_Delay(200);

  // Read data pins at addr 0
  HAL_GPIO_WritePin(GPIOB, CE_Pin, 0);
  HAL_GPIO_WritePin(GPIOC, Read_En_Pin, 0);
  HAL_GPIO_WritePin(GPIOC, Write_En_Pin, 1);
  HAL_GPIO_WritePin(GPIOC, LB_En_Pin, 0);
  HAL_GPIO_WritePin(GPIOC, UB_En_Pin, 0);

  HAL_Delay(200);

  while (1)
  {
	  // Alternate reading between addr 0x0 and 0x1
	  HAL_GPIO_TogglePin(GPIOA, addr_0_Pin);

	  status[0] = HAL_GPIO_ReadPin(GPIOC, data_0_Pin);
	  status[1] = HAL_GPIO_ReadPin(GPIOC, data_1_Pin);
	  status[2] = HAL_GPIO_ReadPin(GPIOB, data_2_Pin);
	  status[3] = HAL_GPIO_ReadPin(GPIOC, data_3_Pin);
	  status[4] = HAL_GPIO_ReadPin(GPIOB, data_4_Pin);
	  status[5] = HAL_GPIO_ReadPin(GPIOC, data_5_Pin);
	  status[6] = HAL_GPIO_ReadPin(GPIOA, data_6_Pin);
	  status[7] = HAL_GPIO_ReadPin(GPIOA, data_7_Pin);
	  status[8] = HAL_GPIO_ReadPin(GPIOA, data_8_Pin);
	  status[9] = HAL_GPIO_ReadPin(GPIOA, data_9_Pin);
	  status[10] = HAL_GPIO_ReadPin(GPIOA, data_10_Pin);
	  status[11] = HAL_GPIO_ReadPin(GPIOB, data_11_Pin);
	  status[12] = HAL_GPIO_ReadPin(GPIOB, data_12_Pin);
	  status[13] = HAL_GPIO_ReadPin(GPIOC, data_13_Pin);
	  status[14] = HAL_GPIO_ReadPin(GPIOA, data_14_Pin);
	  status[15] = HAL_GPIO_ReadPin(GPIOB, data_15_Pin);

	  sprintf(tx_buff, "Status: %d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d \r\n", status[0], status[1], status[2], status[3], status[4], status[5], status[6], status[7], status[8], status[9], status[10], status[11], status[12], status[13], status[14], status[15]);
	  HAL_UART_Transmit(&huart2, tx_buff, 27, 1000);
	  HAL_Delay(1000);
    /* USER CODE END WHILE */

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
  __HAL_RCC_GPIOD_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOC, UB_En_Pin|Write_En_Pin|Read_En_Pin|LB_En_Pin
                          |addr_9_Pin|data_5_Pin|data_3_Pin|data_13_Pin
                          |data_1_Pin|data_0_Pin|addr_10_Pin|addr_11_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOA, addr_15_Pin|addr_16_Pin|addr_17_Pin|data_6_Pin
                          |data_8_Pin|data_10_Pin|addr_0_Pin|data_14_Pin
                          |addr_8_Pin|data_9_Pin|data_7_Pin|addr_18_19_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOB, CE_Pin|addr_1_Pin|data_15_Pin|addr_2_Pin
                          |data_11_Pin|addr_7_Pin|addr_5_Pin|addr_3_Pin
                          |addr_4_Pin|addr_6_Pin|data_12_Pin|addr_14_Pin
                          |data_2_Pin|data_4_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(addr_13_GPIO_Port, addr_13_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin : B1_Pin */
  GPIO_InitStruct.Pin = B1_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_IT_FALLING;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(B1_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pins : UB_En_Pin Write_En_Pin Read_En_Pin LB_En_Pin
                           addr_9_Pin data_5_Pin data_3_Pin data_13_Pin
                           data_1_Pin data_0_Pin addr_10_Pin addr_11_Pin */
  GPIO_InitStruct.Pin = UB_En_Pin|Write_En_Pin|Read_En_Pin|LB_En_Pin
                          |addr_9_Pin|data_5_Pin|data_3_Pin|data_13_Pin
                          |data_1_Pin|data_0_Pin|addr_10_Pin|addr_11_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);

  /*Configure GPIO pins : addr_15_Pin addr_16_Pin addr_17_Pin data_6_Pin
                           data_8_Pin data_10_Pin addr_0_Pin data_14_Pin
                           addr_8_Pin data_9_Pin data_7_Pin addr_18_19_Pin */
  GPIO_InitStruct.Pin = addr_15_Pin|addr_16_Pin|addr_17_Pin|data_6_Pin
                          |data_8_Pin|data_10_Pin|addr_0_Pin|data_14_Pin
                          |addr_8_Pin|data_9_Pin|data_7_Pin|addr_18_19_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

  /*Configure GPIO pins : CE_Pin addr_1_Pin data_15_Pin addr_2_Pin
                           data_11_Pin addr_7_Pin addr_5_Pin addr_3_Pin
                           addr_4_Pin addr_6_Pin data_12_Pin addr_14_Pin
                           data_2_Pin data_4_Pin */
  GPIO_InitStruct.Pin = CE_Pin|addr_1_Pin|data_15_Pin|addr_2_Pin
                          |data_11_Pin|addr_7_Pin|addr_5_Pin|addr_3_Pin
                          |addr_4_Pin|addr_6_Pin|data_12_Pin|addr_14_Pin
                          |data_2_Pin|data_4_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

  /*Configure GPIO pin : addr_12_Pin */
  GPIO_InitStruct.Pin = addr_12_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(addr_12_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pin : addr_13_Pin */
  GPIO_InitStruct.Pin = addr_13_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(addr_13_GPIO_Port, &GPIO_InitStruct);

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
