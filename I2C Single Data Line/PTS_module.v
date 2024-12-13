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
    input [7:0] index,
    
    input [15:0] data_in,
    
    output ser_data_out
);

// Multiplexer
assign ser_data_out = (PTS_en) ? data_in[index] : 'bz;

endmodule
