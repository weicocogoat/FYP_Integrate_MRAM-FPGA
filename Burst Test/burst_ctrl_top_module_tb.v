`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2024 02:04:53
// Design Name: 
// Module Name: burst_ctrl_top_module_tb
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


module burst_ctrl_top_module_tb;

reg clk;
reg rst;

reg burst_en;                 // Enables control module
reg mode_sel;                 // 0 -> Single Transfer, 1-> Burst Mode

reg burst_len_in;             // Serial burst len input

reg addr_in;                  // Serial initial addr input

wire addr_sel;                // Input to mux to select the serial addr in for the STP/PTS Module

wire addr_ser_out;             // Serial addr out from the burst control module

burst_ctrl_Top_Module uut(
    .clk(clk),
    .rst(rst),
    
    .burst_en(burst_en),                 // Enables control module
    .mode_sel(mode_sel),                 // 0 -> Single Transfer, 1-> Burst Mode
    
    .burst_len_in(burst_len_in),             // Serial burst len input
    
    .addr_in(addr_in),                  // Serial initial addr input
    
    .addr_sel(addr_sel),                // Input to mux to select the serial addr in for the STP/PTS Module
    
    .addr_ser_out(addr_sel_out)            // Serial addr out from the burst control module
);

always begin
    #5
    clk = ~clk;
end

initial begin
    clk <= 0;
    rst <= 1;
    
    @(posedge clk)
    rst <= 0;
    burst_en <= 1;
    mode_sel <= 0;
    
    @(posedge clk)
    @(posedge clk)
    
    $finish;

end


endmodule
