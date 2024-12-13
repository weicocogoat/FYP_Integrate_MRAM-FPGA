`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2024 00:26:20
// Design Name: 
// Module Name: top_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module(
    input sda,
    input scl
);

wire PTS_en;
wire [7:0] index;

wire ser_data_input;

// Simulate with MRAM
wire [15:0] write_data;
wire [19:0] write_addr;
    
wire chip_en;
wire read_en;
wire write_en;
wire lb_en;
wire ub_en;

wire [15:0] data_out;

I2C_Simple_Slave_Controller uut1
(
    .sda(sda),
    .scl(scl),

    
    .write_data(write_data),       // should be inout
    .write_addr(write_addr),
    
    .PTS_en(PTS_en),
    .index(index),
   
    .chip_en(chip_en),
    .read_en(read_en),
    .write_en(write_en),
    .lb_en(lb_en),
    .ub_en(ub_en),
    
    .ser_data_input(ser_data_input)  
);   

PTS_module uut2
(
    .PTS_en(PTS_en),
    .index(index),
    
    .data_in(data_out),
    
    .ser_data_out(ser_data_input)
);

MRAM_model uut3
(
    .clk(scl),
    
    .e_chipEnable_n(chip_en),
    .g_outputEnable_n(read_en),
    .w_writeEnable_n(write_en),
    .lb_lowerByteEnable_n(lb_en),
    .ub_upperByteEnable_n(ub_en),
    
    .address(write_addr),
    .dqi_datainput(write_data),
    .dqo_dataoutput(data_out)
);

endmodule
