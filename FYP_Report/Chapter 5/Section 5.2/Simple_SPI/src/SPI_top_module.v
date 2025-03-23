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
    output LED

);

wire PTS_en_out;
wire [3:0] index;
wire PTS_ser_data_in;

wire [15:0] SPI_data_line;
wire [15:0] PTS_data_line;

SPI_slave uut
(
    .FPGA_clk(FPGA_clk),
    .FPGA_rst(FPGA_rst),
    
    .SCLK(SCLK),
    .SSEL(SSEL),
    .MOSI(MOSI),
    .MISO(MISO),
    .LED(LED)
);

/*
PTS_module PTS_module
(
    .FPGA_clk(FPGA_clk),
    .FPGA_rst(FPGA_rst),
    
    .en(PTS_en_out),
    .index(index),
    
    .data_in(PTS_data_line),
    .ser_data_out(PTS_ser_data_in)
);


assign data_line = (~PTS_en_out) ? SPI_data_line : 16'bz;
assign PTS_data_line = data_line;
*/

endmodule
