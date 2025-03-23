`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2024 01:47:30
// Design Name: 
// Module Name: counter
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


module counter

#(parameter COUNTER_WIDTH = 4)
(
    input clk,
    input rst,
    
    input en,
    
    output [COUNTER_WIDTH - 1:0] counter_out
);

reg [COUNTER_WIDTH - 1:0] counter_reg;

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        counter_reg <= 0;
    end
    else begin
        // 1 cycle delay is needed before data is updated
        if (en) begin
            counter_reg <= counter_reg + 1;
        end
    end
end

assign counter_out = counter_reg;

endmodule
