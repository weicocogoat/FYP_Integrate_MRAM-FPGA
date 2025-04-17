`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2025 23:47:46
// Design Name: 
// Module Name: SPI_Top_Module
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


module SPI_Top_Module(
    input FPGA_clk,
    input FPGA_rst,
    input SCLK,
    input SSEL,
    input MOSI,
    
    output MISO,
    
    inout [15:0] data_to_MRAM,
    output [19:0] addr_to_MRAM,

    output chip_en,
    output write_en, 
    output out_en,                  // Read enable, active low
    output lower_byte_en,           // Reading of bytes 7:0 enable line, active low
    output upper_byte_en            // Reading of bytes 15:8 enable line, active low
);

wire PTS_ser_data_out;
wire SPS_clk;
wire SPS_rst;
wire burst_en;
wire mode_sel;
wire burst_en;
wire burst_len;
wire addr;
wire data;
wire [2:0] rws;

SPI_Module uut1
(
    .FPGA_clk(FPGA_clk),
    .FPGA_rst(FPGA_rst),
    .SCLK(SCLK),
    .SSEL(SSEL),
    .MOSI(MOSI),
    
    .MISO(MISO),
    
    .PTS_ser_data_out(PTS_ser_data_out),
    .SPS_clk_out(SPS_clk),
    .SPS_rst_out(SPS_rst),
    .burst_en_out(burst_en),
    .mode_sel_out(mode_sel),
    .burst_len_out(burst_len),
    .addr_out(addr),
    .data_out(data),
    .rws_out(rws)
);

Integrate_Top_Module uut2
(
    .clk(SPS_clk),
    .rst(SPS_rst),
    
    .burst_en(burst_en),                 // Enables control module
    .mode_sel(mode_sel),                 // 0 -> Single Transfer, 1-> Burst Mode
    
    .burst_len_in(burst_len),             // Serial burst len input
    
    .addr_in(addr),                  // Serial initial addr input
    
    .data_in(data),
    .read_write_sel(rws),
    
    .data_to_MRAM(data_to_MRAM),
    .addr_to_MRAM(addr_to_MRAM),
    
    .chip_en(chip_en),                 // Chip enable, active low
    .write_en(write_en),                // Write enable, active low
    .out_en(out_en),                  // Read enable, active low
    .lower_byte_en(lower_byte_en),           // Reading of bytes 7:0 enable line, active low
    .upper_byte_en(upper_byte_en),            // Reading of bytes 15:8 enable line, active low
    
    .PTS_ser_data_out(PTS_ser_data_out)
);

endmodule
