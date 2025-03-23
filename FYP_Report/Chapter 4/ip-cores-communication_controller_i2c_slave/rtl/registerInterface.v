//////////////////////////////////////////////////////////////////////
////                                                              ////
//// registerInterface.v                                          ////
////                                                              ////
//// This file is part of the i2cSlave opencores effort.
//// <http://www.opencores.org/cores//>                           ////
////                                                              ////
//// Module Description:                                          ////
//// You will need to modify this file to implement your 
//// interface.
//// Add your control and status bytes/bits to module inputs and outputs,
//// and also to the I2C read and write process blocks  
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


module registerInterface (
  clk,
  addr,
  dataIn,
  writeEn,
  dataOut,
  myReg0,
  myReg1,
  myReg2,
  myReg3,
  data_lb,
  data_ub,
  myReg6,
  myReg7,
  myReg8,
  myReg9,
  myReg10,
  myReg11,
  myReg12,
  myReg13,
  myReg14,
  myReg15,
  chip_en,
  read_en,
  write_en, 
  lb_en,
  ub_en

);
input clk;
input [7:0] addr;
input [7:0] dataIn;         // Data in from SDA
input writeEn;
output [7:0] dataOut;
output [7:0] myReg0;
output [7:0] myReg1;
output [7:0] myReg2;
output [7:0] myReg3;
inout [7:0] data_lb;
inout [7:0] data_ub;
output [7:0] myReg6;
output [7:0] myReg7;
input [7:0] myReg8;
input [7:0] myReg9;
input [7:0] myReg10;
input [7:0] myReg11;
input [7:0] myReg12;
input [7:0] myReg13;
input [7:0] myReg14;
input [7:0] myReg15;
output chip_en;
output read_en;
output write_en;
output lb_en;
output ub_en;

reg [7:0] dataOut;
reg [7:0] myReg0;       // Burst_len [7:5] & RWS [2:0]
reg [7:0] myReg1;       // addr line [7:0]
reg [7:0] myReg2;       // addr line [15:8]
reg [7:0] myReg3;       // addr line [19:0]
reg [7:0] myReg4;       // data line [7:0]
reg [7:0] myReg5;       // data line [15:0]
reg [7:0] myReg6;
reg [7:0] myReg7;

wire [7:0] data_lb;
wire [7:0] data_ub;

reg chip_en = 1;
reg read_en = 1;
reg write_en = 1;
reg lb_en = 1;
reg ub_en = 1;

reg reset_flag = 0;
// Some delay cycles needed as MRAM needs minimally 35ns to do read/write operations
reg [2:0] read_MRAM = 0;      // Delay cycles for read op
reg [2:0] write_MRAM = 0;     // Delay cycles for write op
//reg [7:0] addr_MRAM_delay = 0;      

assign data_lb = (read_en) ? myReg4 : 8'bz;
assign data_ub = (read_en) ? myReg5 : 8'bz;

// --- I2C Read
always @(posedge clk) begin
  case (addr)
    8'h00: dataOut <= myReg0;  
    8'h01: dataOut <= myReg1;  
    8'h02: dataOut <= myReg2;  
    8'h03: dataOut <= myReg3;  
    8'h04: dataOut <= myReg4;  
    8'h05: dataOut <= myReg5;  
    8'h06: dataOut <= myReg6;  
    8'h07: dataOut <= myReg7;  
    8'h08: dataOut <= myReg8;  
    8'h09: dataOut <= myReg9;  
    8'h0A: dataOut <= myReg10;  
    8'h0B: dataOut <= myReg11;  
    8'h0C: dataOut <= myReg12;  
    8'h0D: dataOut <= myReg13;  
    8'h0E: dataOut <= myReg14;  
    8'h0F: dataOut <= myReg15;
    default: dataOut <= 8'h00;
  endcase
end

// --- I2C Write
always @(posedge clk) begin
  if (writeEn == 1'b1) begin
    case (addr)
      8'h00: myReg0 <= dataIn;  
      8'h01: myReg1 <= dataIn;
      8'h02: myReg2 <= dataIn;

      8'h03:begin
                myReg3 <= dataIn;
                if (myReg0[0] == 0) begin
                    // Read operation
                    chip_en <= 0;
                    read_en <= 0;
                    write_en <= 1;
                    lb_en <= 0;
                    ub_en <= 0;

                    myReg4 <= data_lb;
                    myReg5 <= data_ub;

                    read_MRAM <= 5;
                end
            end
            
      8'h04:    begin
                    myReg4 <= dataIn;  
                end

      8'h05:    begin
                    myReg5 <= dataIn;
                    if (myReg0[0] == 1) begin
                        // Write operation, chip enable controlled
                        chip_en <= 1;
                        read_en <= 1;
                        write_en <= 0;
                        lb_en <= 0;
                        ub_en <= 0;

                        write_MRAM <= 5;
                    end
                end

      8'h06: myReg6 <= dataIn;
      8'h07: myReg7 <= dataIn;
    endcase
  end
  
  if (read_MRAM > 0) begin
  // Read operation
  chip_en <= 0;
  read_en <= 0;
  write_en <= 1;
  lb_en <= 0;
  ub_en <= 0;

  myReg4 <= data_lb;
  myReg5 <= data_ub;
  
  read_MRAM <= read_MRAM - 1;

  if (read_MRAM == 1) begin
    reset_flag <= 1;
  end
  end

  if (write_MRAM > 0) begin
    // Write operation
    chip_en <= 0;
    read_en <= 1;
    write_en <= 0;
    lb_en <= 0;
    ub_en <= 0;

    write_MRAM <= write_MRAM - 1;

    if (write_MRAM == 1) begin
      reset_flag <= 1;
    end
  end
  
  if (reset_flag == 1) begin
    chip_en <= 1;
    read_en <= 1;
    write_en <= 1;
    lb_en <= 1;
    ub_en <= 1;
    
    myReg0 <= 0;
    myReg1 <= 0;
    myReg2 <= 0;
    myReg3 <= 0;

    reset_flag <= 0;
  end

end

endmodule