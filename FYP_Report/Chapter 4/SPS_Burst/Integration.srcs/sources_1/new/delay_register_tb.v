`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2024 17:38:02
// Design Name: 
// Module Name: delay_register_tb
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


module delay_register_tb;

reg clk = 0;
reg rst = 1;

reg in;
wire out;

delay_register uut
(
    .clk(clk),
    .rst(rst),
    
    .in(in),
    .out(out)
);

always begin
    #5
    clk = ~clk;
end

initial begin
    @(posedge clk)
    rst <= 0;
    in <= 1;
    
    @(posedge clk)
    in <= 0;
    
    @(posedge clk)
    in <= 1;
    
    @(posedge clk)
    @(posedge clk)
    
    $finish;
end

endmodule
