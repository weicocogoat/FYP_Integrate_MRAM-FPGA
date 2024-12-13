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
    input scl,
    
    output [15:0] write_data,
    output [19:0] write_addr,
    
    output chip_en, 
    output read_en,
    output write_en,
    output lb_en,
    output ub_en
);

wire PTS_en;
wire [7:0] index;

wire ser_data_input;

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
    
    .data_in(data_in),
    
    .ser_data_out(ser_data_input)
);
    

endmodule
