`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 01:14:31
// Design Name: 
// Module Name: Top_Module
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


module Top_Module(
    // Zedboard Signals
    inout [14:0]DDR_addr,
    inout [2:0]DDR_ba,
    inout DDR_cas_n,
    inout DDR_ck_n,
    inout DDR_ck_p,
    inout DDR_cke,
    inout DDR_cs_n,
    inout [3:0]DDR_dm,
    inout [31:0]DDR_dq,
    inout [3:0]DDR_dqs_n,
    inout [3:0]DDR_dqs_p,
    inout DDR_odt,
    inout DDR_ras_n,
    inout DDR_reset_n,
    inout DDR_we_n,
    inout FIXED_IO_ddr_vrn,
    inout FIXED_IO_ddr_vrp,
    inout [53:0]FIXED_IO_mio,
    inout FIXED_IO_ps_clk,
    inout FIXED_IO_ps_porb,
    inout FIXED_IO_ps_srstb,
    inout [0:0]gpio_rtl_0_tri_io,
    inout [9:0]gpio_rtl_tri_io,
    
    //SPS burst top module signals
    
    input clk,
    input rst,
    input burst_en,                 // Enables control module
    input mode_sel,                 // 0 -> Single Transfer, 1-> Burst Mode
    input burst_len_in,             // Serial burst len input
    input addr_in,                  // Serial initial addr input
    input data_in,
    input [2:0] read_write_sel, 
    output PTS_ser_data_out,
    
    inout [15:0] data_to_MRAM,
    output [19:0] addr_to_MRAM,
    output chip_en,                 // Chip enable, active low
    output write_en,                // Write enable, active low
    output out_en,                  // Read enable, active low
    output lower_byte_en,           // Reading of bytes 7:0 enable line, active low
    output upper_byte_en            // Reading of bytes 15:8 enable line, active low
);

//wire [9:0] gpio_rtl_tri_io;
//wire [0:0] gpio_rtl_0_tri_io;

design_1_wrapper Zedboard_System
(
    .DDR_addr(DDR_addr),
    .DDR_ba(DDR_ba),
    .DDR_cas_n(DDR_cas_n),
    .DDR_ck_n(DDR_ck_n),
    .DDR_ck_p(DDR_ck_p),
    .DDR_cke(DDR_cke),
    .DDR_cs_n(DDR_cs_n),
    .DDR_dm(DDR_dm),
    .DDR_dq(DDR_dq),
    .DDR_dqs_n(DDR_dqs_n),
    .DDR_dqs_p(DDR_dqs_p),
    .DDR_odt(DDR_odt),
    .DDR_ras_n(DDR_ras_n),
    .DDR_reset_n(DDR_reset_n),
    .DDR_we_n(DDR_we_n),
    .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
    .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
    .FIXED_IO_mio(FIXED_IO_mio),
    .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
    .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
    .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
    .gpio_rtl_0_tri_io(gpio_rtl_0_tri_io),
    .gpio_rtl_tri_io(gpio_rtl_tri_io)
);

Integrate_Top_Module SPS_Burst
(
    
    .clk(clk),
    .rst(rst),
    .burst_en(burst_en),            
    .mode_sel(mode_sel),                
    .burst_len_in(burst_len_in),        
    .addr_in(addr_in),                
    .data_in(data_in),
    .read_write_sel(read_write_sel),
    .PTS_ser_data_out(PTS_ser_data_out),
    
    .data_to_MRAM(data_to_MRAM),
    .addr_to_MRAM(addr_to_MRAM),
    .chip_en(chip_en),           
    .write_en(write_en),            
    .out_en(out_en),             
    .lower_byte_en(lower_byte_en),        
    .upper_byte_en(upper_byte_en)
    
    /*
    .clk(gpio_rtl_tri_io[0]),
    .rst(gpio_rtl_tri_io[1]),
    .burst_en(gpio_rtl_tri_io[2]),            
    .mode_sel(gpio_rtl_tri_io[3]),                
    .burst_len_in(gpio_rtl_tri_io[4]),        
    .addr_in(gpio_rtl_tri_io[5]),                
    .data_in(gpio_rtl_tri_io[6]),
    .read_write_sel({gpio_rtl_tri_io[7], gpio_rtl_tri_io[8], gpio_rtl_tri_io[9]}),
    .PTS_ser_data_out(PTS_ser_data_out),
    
    .data_to_MRAM(data_to_MRAM),
    .addr_to_MRAM(addr_to_MRAM),
    .chip_en(chip_en),           
    .write_en(write_en),            
    .out_en(out_en),             
    .lower_byte_en(lower_byte_en),        
    .upper_byte_en(upper_byte_en)
    */            
);
endmodule
