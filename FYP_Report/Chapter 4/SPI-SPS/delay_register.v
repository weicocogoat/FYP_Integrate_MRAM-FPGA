
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2024 17:33:50
// Design Name: 
// Module Name: delay_register
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


module delay_register(
    input clk,
    input rst,
    
    input in,
    
    output out
);

reg temp;

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        temp <= 0;
    end
    else begin
        temp <= in;
    end
end

assign out = temp;
endmodule
