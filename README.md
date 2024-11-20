# Off chip MRAM memory controller for ECS-DOT.
This repository documents my progress of my FYP at NTU, designing an MRAM memory controller and integrating it with the ECS-DOT SoC developed at NTU by the ECS Group.

## (Most Updated) First Iteration Integration
- Integrates the burst module and SPS module with the MRAM
- There is a pdf inside that showcases a rough timing analysis (FYP Timing Analysis.pdf)

### First iteration of the SPS module
- The very first iteration of converting serial input to parallel & parallel to serial using shift registers
- Also consists of logic to interface with a simulated MRAM
- Takes approximately 40 cycles for reading, 23 for writing

### Second iteration of SPS module 
- Slight improvement to the first iteration
- 22 cycles for writing
- For reading:
  - 22 cycles to first get the address to be read from
  - In the next loop, takes 19 cycles to output a full byte of data serially

### Third iteration of SPS module 
- Similar to second iteration, but slight changes made to synchronize with the burst module

### First Iteration Burst Module 
- Enables burst operation
- 23 cycles per loop
- Output of address is available on cycle 2

### First Iteration of I2C_Simple
- Editted version of: https://github.com/mitya1337/Simple_I2C
- Modified to fit this project
