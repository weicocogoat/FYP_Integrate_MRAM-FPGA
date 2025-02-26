`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.12.2024 01:32:16
// Design Name: 
// Module Name: SPI_Slave_tb
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


module SPI_Slave_tb;

reg FPGA_clk = 0;
reg FPGA_rst = 1;

reg SCLK = 0;
reg SSEL = 1;       // Active Low
reg MOSI = 0;
wire MISO;

wire [19:0] addr_line;
wire [15:0] data_line;     // bidirectional signal from DUT
reg [15:0] data_line_drive;    // locally driven value
wire [15:0] data_line_recv;    // locally received value (optional, but models typical pad)
assign data_line = data_line_drive;
assign data_line_recv = data_line;

wire chip_en_out;
wire read_en_out;
wire write_en_out;
wire lb_en_out;
wire ub_en_out;

integer i;

SPI_top_module uut
(
    // Internal clock that runs faster than SPI clk
    .FPGA_clk(FPGA_clk),
    .FPGA_rst(FPGA_rst),
    
    // SPI comms protocol
    .SCLK(SCLK),
    .SSEL(SSEL),
    .MOSI(MOSI),
    .MISO(MISO),
    
    // Output to peripheral
    .data_line(data_line),
    .addr_line(addr_line),
    
    .chip_en_out(chip_en_out),
    .read_en_out(read_en_out),
    .write_en_out(write_en_out),
    .lb_en_out(lb_en_out),
    .ub_en_out(ub_en_out)
);

// FPGA clock for SPI module will run 5x faster than SCLK from master
always begin
    #1
    FPGA_clk <= ~FPGA_clk;
end

always begin
    #10
    SCLK <= ~SCLK;
end

initial begin
    #20
    FPGA_rst <= 0;
    
    #20
    SSEL <= 0;
    data_line_drive <= 'bz;
    
 //----------------------------------------Single Write-----------------------------------------------//  
    /*
    // RWS, write operation
    for (i = 0; i < 3; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= 1;
    end
    
    // burst_len and burst_ctrl, all 0
    for (i = 0; i < 5; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= 0;
    end
    
    // addr in
    for (i = 0; i < 24; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= i%2;
    end
    
    // data in
    for (i = 0; i < 16; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= i%2;
        //data_line_drive <= 100;
    end
*/
 //--------------------------------------------------------------------------------------------------//  
 
 //----------------------------------------Burst Write-----------------------------------------------//   
 /*
    // RWS, write operation
    for (i = 0; i < 3; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= 1;
    end
    
    // burst_len and burst_ctrl, burst len of 3
    for (i = 0; i < 2; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= 0;
    end
    
    for (i = 0; i < 3; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= 1;
    end
    
    // addr in
    for (i = 0; i < 24; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= i%2;
    end
    
    // data in
    for (i = 0; i < 16; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= i%2;
        //data_line_drive <= 100;
    end
    
    for (i = 0; i < 16; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= 0;
        //data_line_drive <= 100;
    end
    
    for (i = 0; i < 16; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= 1;
        //data_line_drive <= 100;
    end
    
    // Need to wait approx 1 FPGA clk cycle so that we can enter the state to assert the send signals
    @(posedge FPGA_clk)
    @(posedge FPGA_clk)
    
    SSEL <= 1;
    */
 //--------------------------------------------------------------------------------------------------//   
    
 //----------------------------------------Single Read-----------------------------------------------//     
 /*
    // RWS, read operation
    for (i = 0; i < 2; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= 1;
    end
    
    // burst_len and burst_ctrl, all 0
    for (i = 0; i < 6; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= 0;
    end
    
    // addr in
    for (i = 0; i < 24; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= i%2;
    end
    
    // data in
    for (i = 0; i < 16; i = i + 1) begin
        @(posedge SCLK)
        //MOSI <= i%2;
        data_line_drive <= 100;
    end
*/   
 //--------------------------------------------------------------------------------------------------//
 
 //----------------------------------------Burst Read-----------------------------------------------//  
 
    // RWS, read operation
    for (i = 0; i < 2; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= 1;
    end
    
    @(posedge SCLK)
    MOSI <= 0;
    
    // burst_len and burst_ctrl, all 0
    for (i = 0; i < 2; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= 0;
    end
    for (i = 0; i < 3; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= 1;
    end
    
    // addr in
    for (i = 0; i < 24; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= i%2;
    end
    
    data_line_drive <= 100;
    // data in
    for (i = 0; i < 16; i = i + 1) begin
        @(posedge SCLK)
        //MOSI <= i%2;
        data_line_drive <= 100;
    end
    
    // data in
    for (i = 0; i < 16; i = i + 1) begin
        @(posedge SCLK)
        //MOSI <= i%2;
        data_line_drive <= 200;
    end
    
    // data in
    for (i = 0; i < 16; i = i + 1) begin
        @(posedge SCLK)
        //MOSI <= i%2;
        data_line_drive <= 300;
    end
    
 //--------------------------------------------------------------------------------------------------//   

    @(posedge SCLK)
    FPGA_rst <= 1;
    SSEL <= 1;
    
    $finish;
end

endmodule
