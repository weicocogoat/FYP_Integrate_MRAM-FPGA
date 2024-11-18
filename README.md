# MRAM memory controller for PULP microcontroller
This repository documents my progress of my FYP at NTU, designing a MRAM memory controller and integrating it with the pre-existing PULP microcontroller developed at NTU.

## (Most Updated) First Iteration Integration
- Integrates the burst module and STP/PTS module with the MRAM
- There is a pdf inside that showcases a rough timing analysis

### First iteration of STP&PTS module
- The very first iteration of converting serial input to parallel & parallel to serial using shift registers
- Also consists of logic to interface with a simulated MRAM
- Takes approximately 40 cycles for reading, 23 for writing

### Second iteration of STP&PTS module 
- Slight improvement to the first iteration
- 23 cycles for writing
- For reading:
  - 23 cycles to first get the address to be read from
  - In the next loop, takes approximately 19 cycles to output data serially

### Third iteration of STP&PTS module 
- Similar to second iteration, but slight changes made to synchronize with the burst module

### First Iteration Burst Module 
- Enables burst operation
- 23 cycles per loop
- Output of address is available on cycle 2
