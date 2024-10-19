`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2024 01:28:26
// Design Name: 
// Module Name: compare
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

// Checks if the burst_len and counter are the same values.
// If they are, send a stop signal to the control module to stop incrementing the address
module compare
#(parameter COUNTER_WIDTH = 4)
(
    input clk,
    input rst,
    
    input [COUNTER_WIDTH - 1:0] burst_len,
    input [COUNTER_WIDTH - 1:0] counter,
    
    output stop_signal
);

/*
reg flag;

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        flag <= 0;
    end
    else begin
        if (burst_len == counter) flag <= 1;
    end
end
*/

// Slight workaround to detect when the burst_len exceeds counter
assign stop_signal = ( (burst_len + 1) == counter) ? 1 : 0;


endmodule
