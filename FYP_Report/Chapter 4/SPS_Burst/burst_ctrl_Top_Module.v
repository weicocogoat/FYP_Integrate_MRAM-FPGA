

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.10.2024 00:54:58
// Design Name: 
// Module Name: burst_ctrl_Top_Module
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


module burst_ctrl_Top_Module(
    input clk,
    input rst,
    
    input burst_en,                 // Enables control module
    input mode_sel,                 // 0 -> Single Transfer, 1-> Burst Mode
    
    input burst_len_in,             // Serial burst len input
    
    input addr_in,                  // Serial initial addr input
    
    output addr_sel,                // Input to mux to select the serial addr in for the STP/PTS Module
    
    output addr_ser_out             // Serial addr out from the burst control module

);

wire burst_len_en;
wire send_burst_len_data;
    
wire initial_addr_en;
wire send_addr_data;

wire [19:0] initial_addr_parallel;

wire [4:0] burst_len_parallel;

wire addr_PTS_out_rst;    
wire addr_PTS_out_en;
wire addr_PTS_out_load;
wire addr_PTS_out_send_data;
wire [1:0] addr_PTS_out_word_sel;

wire stop_signal;

wire counter_en;
wire [4:0] counter_out;

wire adder_en;

wire [19:0] burst_addr_out_parallel;

burst_ctrl burst_controller
(   
    .clk(clk),
    .rst(rst),
    
    .en(burst_en),
    .mode_sel(mode_sel),
    
    
    // burst_len_STP Signals
    .burst_len_en(burst_len_en),
    .send_burst_len_data(send_burst_len_data),
    
    
    // addr_STP signals
    .initial_addr_en(initial_addr_en),
    .send_addr_data(send_addr_data),
    
    
    //  addr_PTS_out signals
    .addr_PTS_out_rst(addr_PTS_out_rst),
    .addr_PTS_out_en(addr_PTS_out_en),
    .addr_PTS_out_load(addr_PTS_out_load),
    .addr_PTS_out_send_data(addr_PTS_out_send_data),
    .addr_PTS_out_word_sel(addr_PTS_out_word_sel),
    
    
     // counter signals
    .stop_signal(stop_signal),
    .counter_en(counter_en),
    
    
    // adder signals
    .adder_en(adder_en),
    
    
    // Mux Signal
    .addr_sel(addr_sel)
); 

serial_to_parallel #(.BUS_WIDTH(5)) burst_len_STP
(
    .clk(clk),
    .rst(rst),
    .en(burst_len_en),
                  
    .data_in(burst_len_in), 
    .send_data(send_burst_len_data),                                   
           
    .data_out(burst_len_parallel)  
);   

serial_to_parallel #(.BUS_WIDTH(20)) addr_STP
(
    .clk(clk),
    .rst(rst),
    .en(initial_addr_en),
                  
    .data_in(addr_in), 
    .send_data(send_addr_data),                                   
           
    .data_out(initial_addr_parallel)  
);   

parallel_to_serial #(.BUS_WIDTH(20)) addr_PTS_out
(
    .clk(clk),
    .rst(addr_PTS_out_rst),
    .en(addr_PTS_out_en),
    
    .load(addr_PTS_out_load),                     
    .send_data(addr_PTS_out_send_data),          
    
    .word_sel(addr_PTS_out_word_sel),  
    
    .data_in(burst_addr_out_parallel),          
    
    .data_out(addr_ser_out)
);

counter #(.COUNTER_WIDTH(5)) counter
(
    .clk(clk),
    .rst(rst),
    
    .en(counter_en),
    
    .counter_out(counter_out)
);

compare #(.COUNTER_WIDTH(5)) compare
(
    .clk(clk),
    .rst(rst),
    
    .burst_len(burst_len_parallel),
    .counter(counter_out),
    
    .stop_signal(stop_signal)
);

Adder #(.ADDR_WIDTH(20), .COUNTER_WIDTH(5)) adder
(
    .clk(clk),
    .rst(rst),
    
    .en(adder_en),
    .initial_addr(initial_addr_parallel),
    .counter(counter_out),
    
    .burst_addr(burst_addr_out_parallel)
);


endmodule

