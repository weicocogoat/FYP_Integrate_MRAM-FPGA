import machine
import utime
import ustruct
import sys

'''
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
'''

# Set Slave Select
SSEL = machine.Pin(6, mode = machine.Pin.OUT, pull = machine.Pin.PULL_DOWN)
SSEL.value(1)

# Set SPI signals
SCK = machine.Pin(2, mode = machine.Pin.OUT, pull = machine.Pin.PULL_DOWN)
SCK.value(1)

MOSI = machine.Pin(3, mode = machine.Pin.OUT, pull = machine.Pin.PULL_DOWN)
MOSI.value(1)

MISO = machine.Pin(4, mode = machine.Pin.IN, pull = machine.Pin.PULL_DOWN)

# Set the FPGA Reset Signal (1->Initiate FPGA reset, 0 -> Operation as per normal)
FPGA_rst = machine.Pin(1, machine.Pin.OUT)
FPGA_rst.value(1)

# Buffer to read data
read_buf = 0;

print("Starting Program")

while True:
    # Simulate SPI, turn on LED
    utime.sleep(1)
    print("Writing to MRAM")
    FPGA_rst.value(0)
    SSEL.value(0)
    
    for i in range(3):
        SCK.value(0)
        MOSI.value(1)
        SCK.value(1)
    for i in range(5):
        SCK.value(0)
        MOSI.value(0)
        SCK.value(1)
        
    for i in range(24):
        SCK.value(0)
        MOSI.value(0)
        SCK.value(1)
        
    for i in range(16):
        SCK.value(0)
        MOSI.value(i%2)
        SCK.value(1)
    
    SSEL.value(1)
    

    utime.sleep(1)
    print("Reading from MRAM")
    SSEL.value(0)
    
    for i in range(2):
        SCK.value(0)
        MOSI.value(1)
        SCK.value(1)
    for i in range(6):
        SCK.value(0)
        MOSI.value(0)
        SCK.value(1)
        
    for i in range(24):
        SCK.value(0)
        MOSI.value(0)
        SCK.value(1)
    
    for i in range(16):
        SCK.value(0)
        print(f"Pin value: {MISO.value()}")
        SCK.value(1)
    
    SSEL.value(1)
    
    FPGA_rst.value(1)

print("End of Program")
