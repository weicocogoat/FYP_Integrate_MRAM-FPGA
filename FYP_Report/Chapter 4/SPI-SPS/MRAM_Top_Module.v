
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


module MRAM_Top_Module(
    input clk,
    input rst,
    
    input data_in,
    input addr_in,
    input [2:0] read_write_sel,
    
    inout [15:0] data_out,
    output [19:0] addr_out,
    
    output chip_en,                 // Chip enable, active low
    output write_en,                // Write enable, active low
    output out_en,                  // Read enable, active low
    output lower_byte_en,           // Reading of bytes 7:0 enable line, active low
    output upper_byte_en,            // Reading of bytes 15:8 enable line, acti
    
    //input [15:0] parallel_data_in,
    output ser_data_out

);

wire data_en;                 // Enable the data STP module
wire addr_en;                 // Enable the addr STP module
wire send_data; 

wire load;                    // Flag to load data from MRAM to internal shift registers
wire data_in_from_MRAM_en;    // Enable the data in from MRAM PTS module, Bit 0 enables full word, Bit 1 enables half word

//wire [15:0] parallel_data_in;

wire [1:0] prev_read_write_sel;

wire out_en_intermediate;
wire [15:0] data;

/*
wire chip_en;                 // Chip enable, active low
wire write_en;                // Write enable, active low
wire out_en;                  // Read enable, active low
wire lower_byte_en;           // Reading of bytes 7:0 enable line, active low
wire upper_byte_en;           // Reading of bytes 15:8 enable line, active low

MRAM_model MRAM(
    .clk(clk),
    
    .e_chipEnable_n(chip_en),
    .w_writeEnable_n(write_en),
    .g_outputEnable_n(out_en),
    .lb_lowerByteEnable_n(lower_byte_en),
    .ub_upperByteEnable_n(upper_byte_en),
    
    .address(addr_out),
    .dqi_datainput(data_out),
    .dqo_dataoutput(parallel_data_in)
);
*/

serial_to_parallel #(.BUS_WIDTH(16)) data_STP
(
    .clk(clk),
    .rst(rst),
    .en(data_en),
                  
    .data_in(data_in),
    .send_data(send_data),                                     
           
    .data_out(data)          
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

parallel_to_serial #(.BUS_WIDTH(16)) PTS
(
    .clk(clk),
    .rst(rst),
    .en(data_in_from_MRAM_en),
    
    .load(load),                     // When data is ready to be read, this signal will be asserted and data will be loaded into an internal register
    .send_data(send_data),           // Send the data serially
    
    .word_sel(prev_read_write_sel),  // Bits to select full, upper or lower byte
    
    .data_in(data_out),           // Data from MRAM
    
    .data_out(ser_data_out)
);


control_module controller
(
    .clk(clk),
    .rst(rst),

    .read_write_sel(read_write_sel),               // 0 for read, 1 for write
    .prev_read_write_sel(prev_read_write_sel),
    
    .data_en(data_en),                              
    .addr_en(addr_en),                 
    .send_data(send_data),
    
    .load(load),
    .data_in_from_MRAM_en(data_in_from_MRAM_en),
    
    .chip_en(chip_en),                 
    .write_en(write_en),              
    .out_en(out_en_intermediate),                 
    .lower_byte_en(lower_byte_en),           
    .upper_byte_en(upper_byte_en)          
);

assign out_en = out_en_intermediate;
assign data_out = (out_en_intermediate) ? data : 'bz;

endmodule
