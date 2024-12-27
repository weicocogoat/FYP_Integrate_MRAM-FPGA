`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.12.2024 15:51:10
// Design Name: 
// Module Name: SPI_top_module
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


module SPI_top_module(
    // Internal clock that runs faster than SPI clk
    input FPGA_clk,
    input FPGA_rst,
    
    // SPI comms protocol
    input SCLK,
    input SSEL,
    input MOSI,
    output MISO,
    
    // Output to peripheral
    inout [15:0] data_line,
    output [19:0]addr_line,
    
    output chip_en_out,
    output read_en_out,
    output write_en_out,
    output lb_en_out,
    output ub_en_out
);

wire PTS_en_out;
wire [3:0] index;
wire PTS_ser_data_in;

SPI_Slave SPI_Slave
(
    .FPGA_clk(FPGA_clk),
    .FPGA_rst(FPGA_rst),
    
    .SCLK(SCLK),
    .SSEL(SSEL),
    .MOSI(MOSI),
    .MISO(MISO),
    
    .data_line(data_line),
    .addr_line(addr_line),
    
    .chip_en_out(chip_en_out),
    .read_en_out(read_en_out),
    .write_en_out(write_en_out),
    .lb_en_out(lb_en_out),
    .ub_en_out(ub_en_out),
    
    .PTS_en_out(PTS_en_out),
    .index(index),
    .PTS_ser_data_in(PTS_ser_data_in)
);

PTS_module PTS_module
(
    .FPGA_clk(FPGA_clk),
    .FPGA_rst(FPGA_rst),
    
    .en(PTS_en_out),
    .index(index),
    
    .data_in(data_line),
    .ser_data_out(PTS_ser_data_in)
);

endmodule
