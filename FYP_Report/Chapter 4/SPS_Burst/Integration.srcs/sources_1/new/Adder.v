`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2024 01:16:58
// Design Name: 
// Module Name: Adder
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

// A simple 2 input adder
// No overflow checking for now
module Adder
#(parameter ADDR_WIDTH = 20, COUNTER_WIDTH = 5)
(
    input clk,
    input rst,
    
    input en,
    input [ADDR_WIDTH - 1:0] initial_addr,
    input [COUNTER_WIDTH - 1:0] counter,
    
    output [ADDR_WIDTH - 1:0] burst_addr
);

reg [ADDR_WIDTH - 1:0] data_shift_reg;

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        data_shift_reg <= 0;
    end
    else begin
        if (en) begin
            // 1 cycle delay before data gets updated
            // When en is asserted, adds both inputs together
            data_shift_reg <= initial_addr + counter;
        end
    end
end

assign burst_addr = data_shift_reg;

endmodule
