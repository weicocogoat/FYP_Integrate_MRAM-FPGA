// https://randomnerdtutorials.com/esp32-spi-communication-arduino/

#include <SPI.h>

#define FPGA_rst 22

static const int spiClk = 1000000 / 2;  // 1 MHz

//uninitialized pointers to SPI objects
SPIClass *vspi = NULL;

void setup() {
  //Find the default SPI pins for your board
  Serial.begin(115200);
  Serial.print("MOSI: ");
  Serial.println(MOSI);
  Serial.print("MISO: ");
  Serial.println(MISO);
  Serial.print("SCK: ");
  Serial.println(SCK);
  Serial.print("SS: ");
  Serial.println(SS);  
  //initialize an instances of the SPIClass attached to VSPI
  vspi = new SPIClass(VSPI);
  vspi->begin();
  pinMode(vspi->pinSS(), OUTPUT);  //VSPI SS
  pinMode(FPGA_rst, OUTPUT);
  digitalWrite(FPGA_rst, HIGH);
}

void spiCommand(SPIClass *spi, byte data) {
  //use it as you would the regular arduino SPI API
  spi->beginTransaction(SPISettings(spiClk, MSBFIRST, SPI_MODE3));
  digitalWrite(spi->pinSS(), LOW);  // Pull SS slow to prep other end for transfer
  spi->transfer(data);
  digitalWrite(spi->pinSS(), HIGH);  // Pull ss high to signify end of data transfer
  spi->endTransaction();
}

void loop() {
  // put your main code here, to run repeatedly:
  //use the SPI buses
  digitalWrite(FPGA_rst, HIGH);   // Pull reset High to reset comms
  digitalWrite(FPGA_rst, LOW);   // Pull reset low to enable comms
  delay(100);

  spiCommand(vspi, 0b01010101);  // Turn on LED
  delay(1000);

  spiCommand(vspi, 0b10101010);  // Turn off LED
  delay(1000);
}

