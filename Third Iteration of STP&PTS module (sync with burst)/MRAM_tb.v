`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.09.2024 01:07:46
// Design Name: 
// Module Name: MRAM_tb
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


module MRAM_tb;

reg clk;
reg e_chipEnable_n;
reg g_outputEnable_n;
reg w_writeEnable_n;
reg lb_lowerByteEnable_n; // Lower byte enable
reg ub_upperByteEnable_n; // Upper byte enable

reg [19:0] address;
reg [15:0] dqi_datainput;
wire [15:0] dqo_dataoutput;


MRAM_model uut (
    .clk(clk),
    .e_chipEnable_n(e_chipEnable_n),
    .g_outputEnable_n(g_outputEnable_n),
    .w_writeEnable_n(w_writeEnable_n),
    .lb_lowerByteEnable_n(lb_lowerByteEnable_n),
    .ub_upperByteEnable_n(ub_upperByteEnable_n),
    
    .address(address),
    .dqi_datainput(dqi_datainput),
    .dqo_dataoutput(dqo_dataoutput)
);

always begin
    #5
    clk = ~clk;
end

initial begin

    // Reset the MRAM
    clk <= 1'b0;
    
    e_chipEnable_n = 1;
    g_outputEnable_n = 1;
    w_writeEnable_n = 1;
    lb_lowerByteEnable_n = 1;
    ub_upperByteEnable_n = 1;
    
    // Write operation
    @(posedge clk)
    address = 20'b0;
    dqi_datainput = 16'b0101_0101_0101_0101;
    
    e_chipEnable_n = 0;
    g_outputEnable_n = 1;
    w_writeEnable_n = 0;
    lb_lowerByteEnable_n = 0;
    ub_upperByteEnable_n = 0;
    
    // End of Write Operation
    
    
    @(posedge clk)
    e_chipEnable_n = 1;
    g_outputEnable_n = 1;
    w_writeEnable_n = 1;
    lb_lowerByteEnable_n = 1;
    ub_upperByteEnable_n = 1;
    dqi_datainput = 16'b0;
    
    @(posedge clk)
    address = 20'b0;
    
    e_chipEnable_n = 0;
    g_outputEnable_n = 0;
    w_writeEnable_n = 1;
    lb_lowerByteEnable_n = 0;
    ub_upperByteEnable_n = 0;
    
    #10
    
    $finish;

end


endmodule
