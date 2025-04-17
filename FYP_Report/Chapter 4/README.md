# Chapter 4 - Hardware Design
Folders will namely contain the Verilog files used. 

## Section 4.1 - SPS Module
- Relevant Folder: SPS_Module
- Top Module: MRAM_Top_Module.v
- Testbench: MRAM_Top_Module_tb.v

## Section 4.2 - SPS with burst functionality
- Relevant Folder: SPS_Burst
- Top Module: Integrate_Top_Module.v
- Testbench: Integrate_Top_Module_tb.v
- Constraint file is for the Tang Nano 9k

## Section 4.3 - SPI-SPS Module
- Relevant Folder: SPI-SPS
- Top Module: SPI_Top_Module.v
- Testbench: SPI_Top_Module_tb.v

## Section 4.4 - SPI Module
- Relevant Folder: SPI_Module
- Top Module: SPI_top_module.v
- Testbench: SPI_Slave_tb.v
- Contraint file is for the Tang Nano 9k

## Section 4.5.1 - Initial I2C Module
- Relevant Folder: I2C_Initial_Design
- Top Module: top_module.v
- Testbench: top_module_tb.v

## Section 4.5.2 - OpenIP Cores I2C Slave
- Relevant Folder: ip-core-communication-controller_i2c_slave/rtl
- Top Module: i2cSlaveTop.v
- Testbench: ip-core-communication-controller_i2c_slave/sim & ip-core-communication-controller_i2c_slave/bench
- Running the testbench requires Icarus Verilog and GTK wave
