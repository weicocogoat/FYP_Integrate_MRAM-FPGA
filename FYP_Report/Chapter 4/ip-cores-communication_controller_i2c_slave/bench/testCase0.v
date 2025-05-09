// ---------------------------------- testcase0.v ----------------------------
`include "timescale.v"
`include "i2cSlave_define.v"
`include "i2cSlaveTB_defines.v"

module testCase0();

reg ack;
reg [7:0] data;
reg [15:0] dataWord;
reg [7:0] dataRead;
reg [7:0] dataWrite;
integer i;
integer j;

initial
begin
  $write("\n\n");
  testHarness.reset;
  testHarness.MRAM_idle;
  #1000;

  // set i2c master clock scale reg PRER = (48MHz / (5 * 400KHz) ) - 1
  $write("Testing register read/write\n");
  testHarness.u_wb_master_model.wb_write(1, `PRER_LO_REG , 8'h17);
  testHarness.u_wb_master_model.wb_write(1, `PRER_HI_REG , 8'h00);
  testHarness.u_wb_master_model.wb_cmp(1, `PRER_LO_REG , 8'h17);

  // enable i2c master
  testHarness.u_wb_master_model.wb_write(1, `CTR_REG , 8'h80);

  // Write to addr 0, 0x5555
  multiByteReadWrite.write({`I2C_ADDRESS, 1'b0}, 8'h00, 32'h07000000, `SEND_STOP);
  multiByteReadWrite.write({`I2C_ADDRESS, 1'b0}, 8'h04, 32'h55550000, `SEND_STOP);

  // Write to addr 1, 0xffff
  multiByteReadWrite.write({`I2C_ADDRESS, 1'b0}, 8'h00, 32'h07010000, `SEND_STOP);
  multiByteReadWrite.write({`I2C_ADDRESS, 1'b0}, 8'h04, 32'hffff0000, `SEND_STOP);

  // Read from MRAM to reg
  testHarness.MRAM_in;    // Simulate data coming in from MRAM
  multiByteReadWrite.write({`I2C_ADDRESS, 1'b0}, 8'h00, 32'h06000000, `SEND_STOP);
  //multiByteReadWrite.write({`I2C_ADDRESS, 1'b0}, 8'h04, 32'h55ff0000, `SEND_STOP);
  //multiByteReadWrite.read({`I2C_ADDRESS, 1'b0}, 8'h00, 32'h89abcdef, dataWord, `NULL);
  //multiByteReadWrite.read({`I2C_ADDRESS, 1'b0}, 8'h04, 32'h12345678, dataWord, `NULL);

  $write("Finished all tests\n");
  $stop;	

end

endmodule

