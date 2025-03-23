//////////////////////////////////////////////////////////////////////
////                                                              ////
//// i2cSlaveTop.v                                                   ////
////                                                              ////
//// This file is part of the i2cSlave opencores effort.
//// <http://www.opencores.org/cores//>                           ////
////                                                              ////
//// Module Description:                                          ////
//// You will need to modify this file to implement your 
//// interface.
////                                                              ////
//// To Do:                                                       ////
//// 
////                                                              ////
//// Author(s):                                                   ////
//// - Steve Fielding, sfielding@base2designs.com                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2008 Steve Fielding and OPENCORES.ORG          ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE. See the GNU Lesser General Public License for more  ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from <http://www.opencores.org/lgpl.shtml>                   ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
`include "i2cSlave_define.v"


module i2cSlaveTop (
  input wire clk,           // Conncected to Tang Nano's internal 27Mhz oscillator
  input wire rst,
  inout wire sda,           // To RPI
  input wire scl,           // To RPI 

  output [7:0] myReg1,
  output [7:0] myReg2,
  inout [7:0] data_lb,
  inout [7:0] data_ub,

  output chip_en,
  output read_en,
  output write_en,
  output lb_en,
  output ub_en
  
);

i2cSlave u_i2cSlave(
  .clk(clk),
  .rst(rst),
  .sda(sda),
  .scl(scl),

  // Reg storing data coming in from SDA line
  .myReg0(),                  // Burst_len [7:5] & RWS [2:0]
  .myReg1(myReg1),            // addr line [7:0]
  .myReg2(myReg2),            // addr line [15:8]
  .myReg3(),                  // addr line [19:0]
  .data_lb(data_lb),          // data line [7:0], connected to reg 4
  .data_ub(data_ub),          // data line [15:0], connected to reg 5
  .myReg6(),
  .myReg7(),

  // Reg that can be used to store data coming in from MRAM
  .myReg8(),
  .myReg9(),
  .myReg10(),
  .myReg11(),
  .myReg12(),
  .myReg13(),
  .myReg14(),
  .myReg15(),

  // Control signals
  .chip_en(chip_en),
  .read_en(read_en),
  .write_en(write_en),
  .lb_en(lb_en),
  .ub_en(ub_en)
);




endmodule


 
