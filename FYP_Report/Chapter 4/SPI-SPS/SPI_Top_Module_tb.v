`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2025 02:12:16
// Design Name: 
// Module Name: SPI_Top_Module_tb
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


module SPI_Top_Module_tb;

reg FPGA_clk = 0;
reg FPGA_rst = 1;

reg SCLK = 1;
reg SSEL = 1;
reg MOSI = 0;
wire MISO;

wire [15:0] data_to_MRAM;
wire [19:0] addr_to_MRAM;

wire chip_en;
wire write_en;
wire out_en;
wire lower_byte_en;
wire upper_byte_en;

integer i;

SPI_Top_Module uut
(
    .FPGA_clk(FPGA_clk),
    .FPGA_rst(FPGA_rst),
    .SCLK(SCLK),
    .SSEL(SSEL),
    .MOSI(MOSI),
    
    .MISO(MISO),
    
    .data_to_MRAM(data_to_MRAM),
    .addr_to_MRAM(addr_to_MRAM),

    .chip_en(chip_en),
    .write_en(write_en), 
    .out_en(out_en),                  // Read enable, active low
    .lower_byte_en(lower_byte_en),           // Reading of bytes 7:0 enable line, active low
    .upper_byte_en(upper_byte_en)            // Reading of bytes 15:8 enable line, active low
);

always begin
    #1
    FPGA_clk <= ~FPGA_clk;
end

always begin
    #10
    SCLK <= ~SCLK;
end

initial begin
    #5
    FPGA_rst <= 0;
    SSEL <= 0;
    SCLK <= 1;
    
//----------------------------------------Single Write-----------------------------------------------//  
    
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
    
    for (i = 0; i < 23; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= 0;
    end
//-----------------------------------------------------------------------------------------------// 
    
    @(posedge SCLK)
    FPGA_rst <= 1;
    SSEL <= 1;
    @(posedge SCLK)
    FPGA_rst <= 0;
    SSEL <= 0;
    
//----------------------------------------Single Read-----------------------------------------------//     
 
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
        MOSI <= 0;
    end
    
    // data in
    for (i = 0; i < 46; i = i + 1) begin
        @(posedge SCLK)
        MOSI <= i%2;
    end
    
    
   
 //--------------------------------------------------------------------------------------------------// 
    

    @(posedge SCLK)
    FPGA_rst <= 1;
    SSEL <= 1;
    
    @(posedge SCLK)
    
    $finish;

end

endmodule
