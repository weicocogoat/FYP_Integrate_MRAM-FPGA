`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2024 02:46:00
// Design Name: 
// Module Name: burst_ctrl_tb
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


module burst_ctrl_tb;

reg clk;
reg rst;

// Burst Mode Signals
reg en;                       // Enables the burst control module
reg mode_sel;                 // 0 -> Single Transfer, 1-> Burst Mode


// burst_len_STP Signals
wire burst_len_en;
wire send_burst_len_data;


// addr_STP signals
wire initial_addr_en;
wire send_addr_data;


//  addr_PTS_out signals
wire addr_PTS_out_en;
wire addr_PTS_out_load;
wire addr_PTS_out_send_data;
wire [1:0] addr_PTS_out_word_sel;


// counter signals
reg stop_signal;
wire counter_en;


// adder signals
wire adder_en;


// Internal Register holding initial addr
wire initial_addr_reg_wen;


// Internal Register holding burst_len
wire initial_burst_len_reg_en;


// Mux Signal
wire addr_sel;

burst_ctrl uut(
    .clk(clk),
    .rst(rst),
    
    // Burst Mode Signals
    .en(en),                       // Enables the burst control module
    .mode_sel(mode_sel),                 // 0 -> Single Transfer, 1-> Burst Mode


    // burst_len_STP Signals
    .burst_len_en(burst_len_en),
    .send_burst_len_data(send_burst_len_data),
    
    
    // addr_STP signals
    .initial_addr_en(initial_addr_en),
    .send_addr_data(send_addr_data),
    
    
    //  addr_PTS_out signals
    .addr_PTS_out_en(addr_PTS_out_en),
    .addr_PTS_out_load(addr_PTS_out_load),
    .addr_PTS_out_send_data(addr_PTS_out_send_data),
    .addr_PTS_out_word_sel(addr_PTS_out_word_sel),
    
    
    // counter signals
    .stop_signal(stop_signal),
    .counter_en(counter_en),
    
    
    // adder signals
    .adder_en(adder_en),
    
    
    // Internal Register holding initial addr
    .initial_addr_reg_wen(initial_addr_reg_wen),
    
    
    // Internal Register holding burst_len
    .initial_burst_len_reg_en(initial_burst_len_reg_en),
    
    
    // Mux Signal
    .addr_sel(addr_sel)
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
    en <= 1;
    mode_sel <= 0;
    stop_signal <= 0;
    
    @(posedge clk)
    @(posedge clk)
    
    $finish;

end
endmodule
