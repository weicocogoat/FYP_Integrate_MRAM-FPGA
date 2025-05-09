`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.09.2024 01:16:46
// Design Name: 
// Module Name: top_module
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


module top_module(
    input clk,
    input rst,
    
    input data_in,
    input addr_in,
    input [3:0] read_write_sel,
    
    output [15:0] data_out,
    output [19:0] addr_out,
    
    input [15:0] parallel_data_in,
    output ser_data_out,
    
    // MRAM signals
    output chip_en,                 // Chip enable, active low
    output write_en,                // Write enable, active low
    output out_en,                  // Read enable, active low
    output lower_byte_en,           // Reading of bytes 7:0 enable line, active low
    output upper_byte_en            // Reading of bytes 15:8 enable line, active low

);

wire data_en;                 // Enable the data STP module
wire addr_en;                 // Enable the addr STP module
wire send_data; 

wire load;                    // Flag to load data from MRAM to internal shift registers
wire data_in_from_MRAM_en;    // Enable the data in from MRAM PTS module

serial_to_parallel #(.BUS_WIDTH(16)) data_STP
(
    .clk(clk),
    .rst(rst),
    .en(data_en),
                  
    .data_in(data_in),
    .send_data(send_data),                                     
           
    .data_out(data_out)          
);

serial_to_parallel #(.BUS_WIDTH(20)) addr_STP
(
    .clk(clk),
    .rst(rst),
    .en(addr_en),
                  
    .data_in(addr_in), 
    .send_data(send_data),                                   
           
    .data_out(addr_out)          
);

parallel_to_serial PTS
(
    .clk(clk),
    .rst(rst),
    .en(data_in_from_MRAM_en),
    
    .load(load),                     // When data is ready to be read, this signal will be asserted and data will be loaded into an internal register
    .send_data(send_data),                // Send the data serially
    
    .data_in(parallel_data_in),           // Data from MRAM
    
    .data_out(ser_data_out)
);

control_module controller
(
    .clk(clk),
    .rst(rst),

    .read_write_sel(read_write_sel),               // 0 for read, 1 for write
    
    .data_en(data_en),                              
    .addr_en(addr_en),                 
    .send_data(send_data),
    
    .load(load),
    .data_in_from_MRAM_en(data_in_from_MRAM_en),
    
    .chip_en(chip_en),                 
    .write_en(write_en),              
    .out_en(out_en),                 
    .lower_byte_en(lower_byte_en),           
    .upper_byte_en(upper_byte_en)          
);


endmodule
