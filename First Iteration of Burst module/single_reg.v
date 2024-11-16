`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2024 00:55:37
// Design Name: 
// Module Name: single_reg
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

// A single register holding data
// When wen is enabled, data_in gets laoded into the shift reg to be stored
// Can be changed to a regfile later on
module single_reg
#(parameter BUS_WIDTH = 16)
(
    input clk,
    input rst,
    
    input wen,              // Write enable
    input [BUS_WIDTH - 1:0] data_in,
    
    output [BUS_WIDTH - 1:0] data_out

);

reg [BUS_WIDTH - 1:0] data_shift_reg;

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        data_shift_reg <= 0;
    end
    else begin
        // 1 cycle needed to move data into the shift reg
        if (wen) data_shift_reg <= data_in;             // When wen is asserted, move in data
    end
end

assign data_out = data_shift_reg;

endmodule
