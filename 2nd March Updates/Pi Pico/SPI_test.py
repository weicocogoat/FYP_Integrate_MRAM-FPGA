import machine
import utime
import ustruct
import sys

# Initialize SPI. My implemention uses CPOL = 1, CPHA = 1
spi = machine.SPI(0,
                  baudrate=500000,  	#500kHz
                  polarity=1,
                  phase=1,
                  bits=8,
                  firstbit=machine.SPI.MSB,
                  sck=machine.Pin(2),
                  mosi=machine.Pin(3),
                  miso=machine.Pin(4))

# Set Slave Select
SSEL = machine.Pin(6, mode = machine.Pin.OUT, pull = machine.Pin.PULL_DOWN)
SSEL.value(1)

# Set the FPGA Reset Signal (1->Initiate FPGA reset, 0 -> Operation as per normal)
FPGA_rst = machine.Pin(1, machine.Pin.OUT)
FPGA_rst.value(1)

# LED will take the value of the byte's MSB
LED_ON = bytearray()
LED_ON.append(0x55)		# MSB 0

LED_OFF = bytearray()
LED_OFF.append(0xaa) 	# MSB 1


while True:
    FPGA_rst.value(0)
    
    SSEL.value(0)
    spi.write(LED_ON)
    SSEL.value(1)
    
    utime.sleep(1)
    
    SSEL.value(0)
    spi.write(LED_OFF)
    SSEL.value(1)
    
    utime.sleep(1)