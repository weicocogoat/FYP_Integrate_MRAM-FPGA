`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.10.2024 00:39:56
// Design Name: 
// Module Name: burst_ctrl
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


module burst_ctrl(
    input clk,
    input rst,
    
    // Burst Mode Signals
    input en,                       // Enables the burst control module
    input mode_sel,                 // 0 -> Single Transfer, 1-> Burst Mode


    // burst_len_STP Signals
    output reg burst_len_en,
    output reg send_burst_len_data,
    
    
    // addr_STP signals
    output reg initial_addr_en,
    output reg send_addr_data,
    
    
    //  addr_PTS_out signals
    output reg addr_PTS_out_en,
    output reg addr_PTS_out_load,
    output reg addr_PTS_out_send_data,
    output reg [1:0] addr_PTS_out_word_sel,
    
    
    // counter signals
    input stop_signal,
    output reg counter_en,
    
    
    // adder signals
    output reg adder_en,
    
    
    // Internal Register holding initial addr
    output reg initial_addr_reg_wen,
    
    
    // Internal Register holding burst_len
    output reg initial_burst_len_reg_en,
    
    
    // Mux Signal
    output reg addr_sel
);

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        // burst_len_STP Signals
        burst_len_en <= 0;
        send_burst_len_data <= 0;
        
        
        // addr_STP signals
        initial_addr_en <= 0;
        send_addr_data <= 0;
        
        
        //  addr_PTS_out signals
        addr_PTS_out_en <= 0;
        addr_PTS_out_load <= 0;
        addr_PTS_out_send_data <= 0;
        addr_PTS_out_word_sel <= 0; 
        
        
        // counter signals
        counter_en <= 0;
        
        
        // adder signals
        adder_en <= 0;
        
        
        // Internal Register holding initial addr
        initial_addr_reg_wen <= 0;
        
        
        // Internal Register holding burst_len
        initial_burst_len_reg_en <= 0;
        
        
        // Mux Signal
        addr_sel <= 0;
        
    end
    else begin 
        if (en && ~mode_sel) begin
            // If mod_sel is 0, Single Transfer is selected. Set the mux input to 0 to use the serial addr in. No other signals are necesary
            addr_sel <= 0;
        end
    
    end

end

endmodule
