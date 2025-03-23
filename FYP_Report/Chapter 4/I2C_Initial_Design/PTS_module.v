`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2024 16:26:33
// Design Name: 
// Module Name: PTS_module
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


module PTS_module(
    input PTS_en,
    
    // Indexing into bits
    input cycle_in,
    input [2:0] counter_in,
    
    input [15:0] data_in,
    
    output ser_data_out
);

// Multiplexer
// Counter at cycle 0 will index into bits 0-7
// Counter at cycle 1 will index into bits 8-15
assign ser_data_out = (PTS_en) ? data_in[(cycle_in * 8) + (7-counter_in)] : 'bz;

endmodule
