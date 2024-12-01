`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2024 02:43:54
// Design Name: 
// Module Name: Integrate_Top_Module
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


module Integrate_Top_Module(
    input clk,
    input rst,
    
    // Burst Module
    input burst_en,                 // Enables control module
    input mode_sel,                 // 0 -> Single Transfer, 1-> Burst Mode
    
    input burst_len_in,             // Serial burst len input
    
    // Shared line
    input addr_in,                  // Serial initial addr input
    
    // STP/PTS Module
    input data_in,
    input [2:0] read_write_sel,
    
    output ser_data_out
);

wire addr_sel;
wire addr_ser_out;
wire addr_mux_output;

wire addr_in_delayed;
wire data_in_delayed;


burst_ctrl_Top_Module burst_module
(
    .clk(clk),
    .rst(rst),
    
    .burst_en(burst_en),
    .mode_sel(mode_sel),
    
    .burst_len_in(burst_len_in),
    .addr_in(addr_in),
    
    .addr_sel(addr_sel),
    .addr_ser_out(addr_ser_out)
);


MRAM_Top_Module MRAM_Module
(
    .clk(clk),
    .rst(rst),
    
    .data_in(data_in_delayed),
    .addr_in(addr_mux_output),
    .read_write_sel(read_write_sel),
    
    .ser_data_out(ser_data_out),
    
    // Redundant Signals
    .data_out(),
    .addr_out()
);

delay_register delay_reg_addr
(
    .clk(clk),
    .rst(rst),
    
    .in(addr_in),
    .out(addr_in_delayed)
);

delay_register delay_reg_data
(
    .clk(clk),
    .rst(rst),
    
    .in(data_in),
    .out(data_in_delayed)

);

// 0 -> no burst. 1 -> burst
assign addr_mux_output = (addr_sel) ? addr_ser_out : addr_in_delayed;

endmodule
