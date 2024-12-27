`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.12.2024 15:28:03
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
    input FPGA_clk,
    input FPGA_rst,
    
    input en,
    input [3:0] index,
    
    input [15:0] data_in,
    output ser_data_out
);

reg [15:0] data_bits = 0;

always @(posedge FPGA_clk) begin
    if (FPGA_rst) begin
        data_bits <= 0;
    end
    else begin
        if (en) begin
            data_bits <= data_in;
        end
    end
end

assign ser_data_out = (en) ? data_bits[index] : 0;
endmodule
