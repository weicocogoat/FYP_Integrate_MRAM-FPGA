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
    input FPGA_clk,
    input FPGA_rst,

    input sda,
    input scl,
    output sda_output,
    
    inout [15:0] write_data,
    output [19:0] write_addr,
    
    output chip_en, 
    output read_en,
    output write_en,
    output lb_en,
    output ub_en
    
);

wire PTS_en;
wire cycle_out;
wire [2:0] counter_out;

wire ser_data_input;


I2C_Simple_Slave_Controller uut1
(
    .FPGA_clk(FPGA_clk),
    .FPGA_rst(FPGA_rst),
    
    .sda(sda),
    .scl(scl),
    .sda_output(sda_output),

    
    .write_data(write_data),       // should be inout
    .write_addr(write_addr),
    
    .PTS_en(PTS_en),
    .cycle_out(cycle_out),               // index MSB
    .counter_out(counter_out),
   
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
    
    .cycle_in(cycle_out),
    .counter_in(counter_out),
    
    //.data_in(data_out),
    .data_in(write_data),
    
    .ser_data_out(ser_data_input)
);


endmodule
