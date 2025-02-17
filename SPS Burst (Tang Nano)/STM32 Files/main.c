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
TIM_HandleTypeDef htim1;
TIM_HandleTypeDef htim2;

UART_HandleTypeDef huart2;

/* USER CODE BEGIN PV */

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_USART2_UART_Init(void);
static void MX_TIM1_Init(void);
static void MX_TIM2_Init(void);
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
  MX_TIM1_Init();
  MX_TIM2_Init();
  /* USER CODE BEGIN 2 */
  	// Measuring Elapsed time
    uint32_t start, stop, elapsed;
    double elapsed_time;

	// Printing to terminal
	uint8_t tx_buff[64];
	int read_data[16];

	sprintf(tx_buff, "Starting Program\r\n");
	HAL_UART_Transmit(&huart2, tx_buff, 19, 1000);

	// Delay function
	HAL_TIM_Base_Start(&htim1);
	void delay_us (uint16_t us)
	{
	// Changes depending on prescaler set in TIM1.
	// TIM1 is connected to APB2 and will be clocked at 84Mhz
	// Possible to tweak the prescalar in order to change the clock speed
    // As of now, the prescaler is set to 1, meaning that the period is 1/84^6, approx 12ns.
	__HAL_TIM_SET_COUNTER(&htim1,0);  // set the counter value a 0
	while (__HAL_TIM_GET_COUNTER(&htim1) < us);  // wait for the counter to reach the us input in the parameter
	}

	// System reset. Ends with clock being low. 9 8 6 5
	void MRAM_reset(){
	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);				// PC9
	  HAL_GPIO_WritePin(GPIOC, rst_Pin, 1);				// PC8
	  HAL_GPIO_WritePin(GPIOB, burst_en_Pin, 0);		// PB8
	  HAL_GPIO_WritePin(GPIOC, mode_sel_Pin, 0);		// PC6
	  HAL_GPIO_WritePin(GPIOB, burst_len_in_Pin, 0);	// PB9
	  HAL_GPIO_WritePin(GPIOC, addr_in_Pin, 0);			// PC5
	  HAL_GPIO_WritePin(GPIOA, data_in_Pin, 0);			// PA6
	  HAL_GPIO_WritePin(GPIOA, rws_0_Pin, 1);			// PA11
	  HAL_GPIO_WritePin(GPIOA, rws_1_Pin, 1);			// PA7
	  HAL_GPIO_WritePin(GPIOB, rws_2_Pin, 1);			// PB12
	  delay_us(1);
	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
	  delay_us(1);
	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
	}

	void MRAM_reset_no_HAL(){
		  // Set the GPIO pins
		  GPIOA->BSRR = 0x000008C0;
		  GPIOB->BSRR = 0x00001300;
		  GPIOC->BSRR = 0x00000360;

		  // Write the following values to the pins (as per MRAM_reset)
		  GPIOA->ODR = 0x00000880;
		  GPIOB->ODR = 0x00001000;
		  GPIOC->ODR = 0x00000100;
		  delay_us(1);
		  // Set clock high
		  GPIOC->ODR = 0x00000300;
		  delay_us(1);
		  // Set clock low
		  GPIOC->ODR = 0x00000100;
	}

	// Single word write
	uint32_t bitwise_one = 1;

	void MRAM_single_word_write(uint32_t addr_in, uint32_t data_in){		// 16-bit unsigned short
	  int  i;
	  uint32_t addr = addr_in;
	  uint32_t data = data_in;


	  for (i = 0; i < 23; i++){
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);					// PC9
		  HAL_GPIO_WritePin(GPIOC, rst_Pin, 0);					// PC8

		  if (i == 0){
			  HAL_GPIO_WritePin(GPIOB, burst_en_Pin, 0);		// PB8
			  HAL_GPIO_WritePin(GPIOC, mode_sel_Pin, 0);		// PC6
			  HAL_GPIO_WritePin(GPIOB, burst_len_in_Pin, 0);	// PB9
			  HAL_GPIO_WritePin(GPIOA, rws_0_Pin, 1);			// PA11
			  HAL_GPIO_WritePin(GPIOA, rws_1_Pin, 1);			// PA7
			  HAL_GPIO_WritePin(GPIOB, rws_2_Pin, 1);			// PB12
		  }
		  else{
			  if (i > 1){
				  addr = addr >> 1;
				  data = data >> 1;
			  }
			  HAL_GPIO_WritePin(GPIOC, addr_in_Pin, addr & bitwise_one);		// PC5
			  HAL_GPIO_WritePin(GPIOA, data_in_Pin, data & bitwise_one);		// PA6
		  }

		  delay_us(1);
		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
		  delay_us(1);
	  }
	}

	  void MRAM_single_word_write_no_HAL(uint32_t addr_in, uint32_t data_in){
	  	  int  i;
	  	  uint32_t addr = addr_in;
	  	  uint32_t data = data_in;


	  	  for (i = 0; i < 23; i++){
	  		  // Set clk and rst low
	  		  GPIOC->ODR = GPIOC->ODR & 0xFCFF;

	  		  if (i == 0){
	  			GPIOA->ODR = 0x00000880;
	  			GPIOB->ODR = 0x00001300;
	  			//GPIOC->ODR = 0x00000000;
	  		  }
	  		  else{
	  			  if (i > 1){
	  				  addr = addr >> 1;
	  				  data = data >> 1;
	  			  }
	  			  GPIOC->ODR = (GPIOC->ODR & 0xFFDF) | ((addr & bitwise_one) << 5);
	  			  GPIOA->ODR = (GPIOA->ODR & 0xFFBF) | ((data & bitwise_one) << 6);
	  		  }

	  		  //delay_us(1);
	  		  GPIOC->ODR = GPIOC->ODR | 0x200;
	  		  //delay_us(1);
	  	  }

	  // End on low clock
	  	GPIOC->ODR = 0x00000000;
	}

  	  // Single Word Read
  	  void MRAM_single_word_read(uint32_t addr_in, uint16_t arr_read[]){		// 16-bit unsigned short
  	  int  i;
  	  uint32_t addr = addr_in;
  	  uint16_t data = 0;

  	  // First loop to receive base address
  	  for (i = 0; i < 23; i++){
  		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
  		  HAL_GPIO_WritePin(GPIOC, rst_Pin, 0);

  		  if (i == 0){
  			  HAL_GPIO_WritePin(GPIOB, burst_en_Pin, 0);
  			  HAL_GPIO_WritePin(GPIOC, mode_sel_Pin, 0);
  			  HAL_GPIO_WritePin(GPIOB, burst_len_in_Pin, 0);
  			  HAL_GPIO_WritePin(GPIOA, rws_0_Pin, 0);
  			  HAL_GPIO_WritePin(GPIOA, rws_1_Pin, 1);
  			  HAL_GPIO_WritePin(GPIOB, rws_2_Pin, 1);
  		  }
  		  else{
  			if (i > 1){
  				addr = addr >> 1;
  			}
  			HAL_GPIO_WritePin(GPIOC, addr_in_Pin, addr & bitwise_one);
  		  }
  		  //delay_us(1);
  		  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
  		  //delay_us(1);
  	  }

  	  // Second loop: Stall and receive data
  	    for (int i = 0; i < 2; i++){
  	    	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
  	    	  //delay_us(1);
  	    	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
  	    	  //delay_us(1);
  	    }

  	    for (int i = 0; i < 16; i++){
  	  	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
  	  	  //read_data[i] = HAL_GPIO_ReadPin(GPIOB, PTS_ser_out_Pin);								// PB6
  	  	  arr_read[0] = (arr_read[0] >> 1) | (HAL_GPIO_ReadPin(GPIOB, PTS_ser_out_Pin) << 15);
  	  	  //sprintf(tx_buff, "Data[%d]: %d \r\n", i, read_data[i]);
  	  	  //HAL_UART_Transmit(&huart2, tx_buff, 14, 1000);
  	  	  //delay_us(1);
  	  	  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
  	  	  //delay_us(1);
  	    }

  	    //sprintf(tx_buff, "Data: %d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d \r\n", read_data[15], read_data[14], read_data[13], read_data[12], read_data[11], read_data[10], read_data[9], read_data[8], read_data[7], read_data[6], read_data[5], read_data[4], read_data[3], read_data[2], read_data[1], read_data[0]);
  	    //HAL_UART_Transmit(&huart2, tx_buff, 27, 1000);
  	    //sprintf(tx_buff, "Data: %x\r\n", data);
  	  	//HAL_UART_Transmit(&huart2, tx_buff, 27, 1000);

  	    // End on low clock
  	    HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
    }

  	void MRAM_single_word_read_no_HAL(uint32_t addr_in, uint16_t arr_read[]){
		  int  i;
		  uint32_t addr = addr_in;
		  uint16_t data = 0;

		  for (i = 0; i < 23; i++){
			  // Set clk and rst low
			  GPIOC->ODR = GPIOC->ODR & 0xFCFF;

			  if (i == 0){
				GPIOA->ODR = 0x00000080;
				GPIOB->ODR = 0x00001300;		// should be 0x00001000
				//GPIOC->ODR = 0x00000000;
			  }
			  else{
				  if (i > 1){
					  addr = addr >> 1;
				  }
				  // Shift in the bits from LSB to MSB
				  GPIOC->ODR = (GPIOC->ODR & 0xFFDF) | ((addr & bitwise_one) << 5);
			  }

			  delay_us(1);
			  GPIOC->ODR = GPIOC->ODR | 0x200;
			  delay_us(1);
		  }

		// Second loop: Stall and receive data
		for (int i = 0; i < 2; i++){
			  GPIOC->ODR = GPIOC->ODR | 0x200;
			  delay_us(1);
			  GPIOC->ODR = GPIOC->ODR & 0xFCFF;
			  delay_us(1);
		}

		for (int i = 0; i < 16; i++){
		  GPIOC->ODR = GPIOC->ODR | 0x200;
		  arr_read[0] = arr_read[0] >> 1 | ((GPIOB->IDR & 0x40) << 9);
		  delay_us(1);
		  GPIOC->ODR = GPIOC->ODR & 0xFCFF;
		  delay_us(1);
		}

		// End on low clock
		GPIOC->ODR = GPIOC->ODR & 0xFCFF;
	}


  	// Burst write
  	void MRAM_burst_write(uint32_t addr_in, uint32_t data_arr[], uint32_t burst_len_in){
  		int i;
  		int j;
  		uint32_t addr = addr_in;
  		uint32_t burst_len = burst_len_in;		// Burst_len has same len as array len
  		uint32_t burst_len_loop = burst_len_in;
  		uint32_t data;

  		for (i = 0; i < burst_len_loop; i++ ){

  			data = data_arr[i];

  			for (j = 0; j < 23; j++){
				  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
				  HAL_GPIO_WritePin(GPIOC, rst_Pin, 0);

				  if (j == 0){
					  HAL_GPIO_WritePin(GPIOB, burst_en_Pin, 1);
					  HAL_GPIO_WritePin(GPIOC, mode_sel_Pin, 1);
					  HAL_GPIO_WritePin(GPIOA, rws_0_Pin, 1);
					  HAL_GPIO_WritePin(GPIOA, rws_1_Pin, 1);
					  HAL_GPIO_WritePin(GPIOB, rws_2_Pin, 1);
				  }
				  else{
					  if (j > 1){
						  addr = addr >> 1;
						  data = data >> 1;
						  burst_len = burst_len >> 1;
					  }
					  HAL_GPIO_WritePin(GPIOC, addr_in_Pin, addr & bitwise_one);
					  HAL_GPIO_WritePin(GPIOA, data_in_Pin, data & bitwise_one);
					  HAL_GPIO_WritePin(GPIOB, burst_len_in_Pin, burst_len & bitwise_one);
				  }

				  delay_us(1);
				  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
				  delay_us(1);
  			}
  		}
  		// End on low clock
  		HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
  	}

  	// Burst write
  	  	void MRAM_burst_write_no_HAL(uint32_t addr_in, uint32_t data_arr[], uint32_t burst_len_in){
  	  		int i;
  	  		int j;
  	  		uint32_t addr = addr_in;
  	  		uint32_t burst_len = burst_len_in;		// Burst_len has same len as array len
  	  		uint32_t burst_len_loop = burst_len_in;
  	  		uint32_t data;

  	  		for (i = 0; i < burst_len_loop; i++ ){

  	  			data = data_arr[i];

  	  			for (j = 0; j < 23; j++){

  	  				  GPIOC->ODR = GPIOC->ODR & 0xFCFF;

  					  if (j == 0){
  						  GPIOA->ODR = GPIOA->ODR | 0x00000880;
  						  GPIOB->ODR = GPIOA->ODR | 0x00001100;
  						  GPIOC->ODR = GPIOA->ODR | 0x00000040;
  					  }
  					  else{
  						  if (j > 1){
  							  addr = addr >> 1;
  							  data = data >> 1;
  							  burst_len = burst_len >> 1;
  						  }
  						  GPIOC->ODR = (GPIOC->ODR & 0xFFDF) | ((addr & bitwise_one) << 5);
  						  GPIOA->ODR = (GPIOA->ODR & 0xFFBF) | ((data & bitwise_one) << 6);
  						  GPIOB->ODR = (GPIOB->ODR & 0xFDFF) | ((burst_len & bitwise_one) << 9);
  					  }

  					  delay_us(1);
  					  GPIOC->ODR = GPIOC->ODR | 0x200;
  					  delay_us(1);
  	  			}
  	  		}
  	  		// End on low clock
  	  		GPIOC->ODR = GPIOC->ODR & 0xFCFF;
  	  	}

  	// Burst read
  	void MRAM_burst_read(uint32_t addr_in, uint16_t arr_read[], uint32_t burst_len_in){
  		int i;
  		int j;
  		uint32_t addr = addr_in;
  		uint32_t burst_len = burst_len_in;
  		uint32_t burst_len_loop = burst_len_in;
  		uint16_t data = 0;

  		for (i = 0; i <= burst_len_loop; i++){
  			switch(i){
  			case 0:
  				for (j = 0; j < 23; j++){
  					HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
  					HAL_GPIO_WritePin(GPIOC, rst_Pin, 0);
					if (j == 0){
						  HAL_GPIO_WritePin(GPIOB, burst_en_Pin, 1);
						  HAL_GPIO_WritePin(GPIOC, mode_sel_Pin, 1);
						  HAL_GPIO_WritePin(GPIOA, rws_0_Pin, 0);
						  HAL_GPIO_WritePin(GPIOA, rws_1_Pin, 1);
						  HAL_GPIO_WritePin(GPIOB, rws_2_Pin, 1);
					}
					else{
						if (j > 1){
							  addr = addr >> 1;
							  burst_len = burst_len >> 1;
						  }
						  HAL_GPIO_WritePin(GPIOC, addr_in_Pin, addr & bitwise_one);
						  HAL_GPIO_WritePin(GPIOB, burst_len_in_Pin, burst_len & bitwise_one);
					}
					delay_us(1);
				    HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
				    delay_us(1);
				}
  				break;

  			default:
  				for (int k = 0; k < 1; k++){
  					  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
  					  delay_us(1);
					  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
					  delay_us(1);
				}
  				for (int k = 0; k < 16; k++){
  					  HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
  					  delay_us(1);
					  HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
					  //read_data[k] = HAL_GPIO_ReadPin(GPIOB, PTS_ser_out_Pin);
					  arr_read[i-1] = (arr_read[i-1] >> 1) | (HAL_GPIO_ReadPin(GPIOB, PTS_ser_out_Pin) << 15);
					  //sprintf(tx_buff, "Data[%d]: %d \r\n", k, read_data[k]);
					  //HAL_UART_Transmit(&huart2, tx_buff, 14, 1000);
					  delay_us(1);
				}

				//sprintf(tx_buff, "Data: %d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d \r\n", read_data[15], read_data[14], read_data[13], read_data[12], read_data[11], read_data[10], read_data[9], read_data[8], read_data[7], read_data[6], read_data[5], read_data[4], read_data[3], read_data[2], read_data[1], read_data[0]);
				//HAL_UART_Transmit(&huart2, tx_buff, 27, 1000);
				//sprintf(tx_buff, "Data: %x\r\n", data);
				//HAL_UART_Transmit(&huart2, tx_buff, 27, 1000);

				for (int k = 0; k < 6; k++){
					HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
					delay_us(1);
				    HAL_GPIO_WritePin(GPIOC, clk_Pin, 1);
				    delay_us(1);
				}
				break;
  			}

  		}
  		// End on low clock
  		HAL_GPIO_WritePin(GPIOC, clk_Pin, 0);
  	}

  	// Burst read
	void MRAM_burst_read_no_HAL(uint32_t addr_in, uint16_t arr_read[], uint32_t burst_len_in){
		int i;
		int j;
		uint32_t addr = addr_in;
		uint32_t burst_len = burst_len_in;
		uint32_t burst_len_loop = burst_len_in;

		for (i = 0; i <= burst_len_loop; i++){
			switch(i){
			case 0:
				for (j = 0; j < 23; j++){

					GPIOC->ODR = GPIOC->ODR & 0xFCFF;

					if (j == 0){
						GPIOA->ODR = 0x00000080;
					    GPIOB->ODR = 0x00001300;
					    GPIOC->ODR = GPIOC->ODR | 0x00000040;
					}
					else{
						if (j > 1){
							  addr = addr >> 1;
							  burst_len = burst_len >> 1;
						  }
						GPIOC->ODR = (GPIOC->ODR & 0xFFDF) | ((addr & bitwise_one) << 5);
					    GPIOB->ODR = (GPIOB->ODR & 0xFDFF) | ((burst_len & bitwise_one) << 9);
					}
					delay_us(1);
					GPIOC->ODR = GPIOC->ODR | 0x200;
					delay_us(1);
				}
				break;

			default:
				for (int k = 0; k < 1; k++){
					GPIOC->ODR = GPIOC->ODR & 0xFCFF;
				    delay_us(1);
				    GPIOC->ODR = GPIOC->ODR | 0x200;
				    delay_us(1);
				}
				for (int k = 0; k < 16; k++){
					  GPIOC->ODR = GPIOC->ODR & 0xFCFF;
					  delay_us(1);
					  GPIOC->ODR = GPIOC->ODR | 0x200;
					  arr_read[i-1] = (arr_read[i-1] >> 1) | (HAL_GPIO_ReadPin(GPIOB, PTS_ser_out_Pin) << 15);
					  delay_us(1);
				}

				for (int k = 0; k < 6; k++){
					GPIOC->ODR = GPIOC->ODR & 0xFCFF;
					delay_us(1);
					GPIOC->ODR = GPIOC->ODR | 0x200;
					delay_us(1);
				}
				break;
			}

		}
		// End on low clock
		GPIOC->ODR = GPIOC->ODR & 0xFCFF;
	}


  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  uint32_t arr[] = {0x89ab, 0x5555, 0x1234};
  //uint32_t arr[] = {0x1234, 0x5678, 0x9abc};
  uint32_t arr_8B[] = {0x1234, 0x5678, 0x9abc, 0xdef0};
  uint32_t arr_16B[] = {0x4321, 0x8765, 0xcba9, 0x0fed, 0x1111, 0x2222, 0x3333, 0x4444};
  uint32_t arr_32B[] = {0x1122, 0x3344, 0x4455, 0x6677, 0x8899, 0xaabb, 0xccdd, 0xeeff, 0x1234, 0x5678, 0x9abc, 0xdef0, 0x4321, 0x8765, 0xcba9, 0x0fed};
  uint16_t arr_read[16];
  GPIOA->BSRR = 0x00000400;
  GPIOB->BSRR = 0x00000400;
  GPIOC->BSRR = 0x00000400;

  __HAL_RCC_TIM2_CLK_ENABLE();
  //TIM2->PSC = HAL_RCC_GetPCLK1Freq()/1000000 - 1;
  TIM2->CR1 = TIM_CR1_CEN;
  while (1)
  {
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
	  // Timer 2's counter
	  //__HAL_TIM_SET_COUNTER(&htim2,0);  // set the counter value a 0
	  //start = TIM2->CNT;

	  // MRAM operation
	  MRAM_reset();
	  //MRAM_reset_no_HAL();
	  //start = TIM2->CNT;
	  //MRAM_single_word_write(0, 0x4567);
	  //MRAM_single_word_write_no_HAL(0, 0xabcd);
	  //stop = TIM2->CNT;

	  //start = TIM2->CNT;
	  //MRAM_single_word_read(0, arr_read);
	  //MRAM_single_word_read_no_HAL(0, arr_read);
	  //stop = TIM2->CNT;

	  //start = TIM2->CNT;
	  //MRAM_burst_write(0, arr, 3);
	  MRAM_burst_write_no_HAL(0, arr_32B, 16);
	  //stop = TIM2->CNT;
	  MRAM_reset();

	  start = TIM2->CNT;
	  //MRAM_burst_read(0, arr_read, 3);
	  MRAM_burst_read_no_HAL(0, arr_read, 16);
	  stop = TIM2->CNT;

	  //MRAM_reset();
	  //MRAM_single_word_read(2);

	  // Stop counter, read the time
	  //stop = TIM2->CNT;
	  elapsed = stop - start;
	  elapsed_time = elapsed;
	  sprintf(tx_buff, "Elapsed Time: %d us\r\n", elapsed);
	  HAL_UART_Transmit(&huart2, tx_buff, 23, 1000);

	  for (int b = 0; b < 16; b++){
		  sprintf(tx_buff, "Data: 0x%x \r\n", arr_read[b]);
		  HAL_UART_Transmit(&huart2, tx_buff, 16, 1000);
	  }

	  //sprintf(tx_buff, "Data: 0x%x \r\n", arr_read[0]);
	  //HAL_UART_Transmit(&huart2, tx_buff, 16, 1000);

	  /*
	  // Testing GPIO manipulation without HAL
	  // Set the gpio pin
	  GPIOA->BSRR = 0x00000020;
	  // Set output of gpio pin to 1
	  GPIOA->ODR = 0x00000020;
	  HAL_Delay(1000);
	  // Set output of gpio pin to 1
	  GPIOA->ODR = 0x00000000;
	  HAL_Delay(1000);
	*/


	  //HAL_GPIO_TogglePin(GPIOC, GPIO_PIN_10);
	  //GPIOC->ODR = 0x400;
	  //delay_us(1);
	  //GPIOC->ODR = 0x000;
	  //delay_us(1);

	  while (1){
		  HAL_Delay(1000);
	  }
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
  * @brief TIM1 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM1_Init(void)
{

  /* USER CODE BEGIN TIM1_Init 0 */

  /* USER CODE END TIM1_Init 0 */

  TIM_ClockConfigTypeDef sClockSourceConfig = {0};
  TIM_MasterConfigTypeDef sMasterConfig = {0};

  /* USER CODE BEGIN TIM1_Init 1 */

  /* USER CODE END TIM1_Init 1 */
  htim1.Instance = TIM1;
  htim1.Init.Prescaler = 1 - 1;
  htim1.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim1.Init.Period = 0xffff - 1;
  htim1.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim1.Init.RepetitionCounter = 0;
  htim1.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
  if (HAL_TIM_Base_Init(&htim1) != HAL_OK)
  {
    Error_Handler();
  }
  sClockSourceConfig.ClockSource = TIM_CLOCKSOURCE_INTERNAL;
  if (HAL_TIM_ConfigClockSource(&htim1, &sClockSourceConfig) != HAL_OK)
  {
    Error_Handler();
  }
  sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
  sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
  if (HAL_TIMEx_MasterConfigSynchronization(&htim1, &sMasterConfig) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN TIM1_Init 2 */

  /* USER CODE END TIM1_Init 2 */

}

/**
  * @brief TIM2 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM2_Init(void)
{

  /* USER CODE BEGIN TIM2_Init 0 */

  /* USER CODE END TIM2_Init 0 */

  TIM_ClockConfigTypeDef sClockSourceConfig = {0};
  TIM_MasterConfigTypeDef sMasterConfig = {0};

  /* USER CODE BEGIN TIM2_Init 1 */

  /* USER CODE END TIM2_Init 1 */
  htim2.Instance = TIM2;
  htim2.Init.Prescaler = 84 - 1;
  htim2.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim2.Init.Period = 4294967295;
  htim2.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim2.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
  if (HAL_TIM_Base_Init(&htim2) != HAL_OK)
  {
    Error_Handler();
  }
  sClockSourceConfig.ClockSource = TIM_CLOCKSOURCE_INTERNAL;
  if (HAL_TIM_ConfigClockSource(&htim2, &sClockSourceConfig) != HAL_OK)
  {
    Error_Handler();
  }
  sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
  sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
  if (HAL_TIMEx_MasterConfigSynchronization(&htim2, &sMasterConfig) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN TIM2_Init 2 */

  /* USER CODE END TIM2_Init 2 */

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
  HAL_GPIO_WritePin(GPIOC, addr_in_Pin|mode_sel_Pin|rst_Pin|clk_Pin
                          |GPIO_PIN_10, GPIO_PIN_RESET);

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

  /*Configure GPIO pins : addr_in_Pin mode_sel_Pin rst_Pin clk_Pin
                           PC10 */
  GPIO_InitStruct.Pin = addr_in_Pin|mode_sel_Pin|rst_Pin|clk_Pin
                          |GPIO_PIN_10;
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
