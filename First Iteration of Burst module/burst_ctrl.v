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
    output reg addr_PTS_out_rst,
    output reg addr_PTS_out_en,
    output reg addr_PTS_out_load,
    output reg addr_PTS_out_send_data,
    output reg [1:0] addr_PTS_out_word_sel,
    
    
    // counter signals
    input stop_signal,
    output reg counter_en,
    
    
    // adder signals
    output reg adder_en,
    
    
    // Mux Signal
    output reg addr_sel
);

// Flag to determine if the initial burst len and addr is loaded into the register
// 0 -> Not loaded in | 1 -> Loaded in.
reg addr_loaded_flag;       

// 6-bit counter to keep track of the number of clock cycles
reg [5:0] internal_counter;

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
        addr_PTS_out_rst <= 0;
        addr_PTS_out_en <= 0;
        addr_PTS_out_load <= 0;
        addr_PTS_out_send_data <= 0;
        addr_PTS_out_word_sel <= 0; 
        
        
        // counter signals
        counter_en <= 0;
        
        
        // adder signals
        adder_en <= 0;
        
        
        // Mux Signal
        addr_sel <= 0;
        
        // Initialize flag to 0
        addr_loaded_flag <= 0;
        
        // Initialize counter to 0
        internal_counter <= 0;
        
    end
    else begin 
        if (en && ~mode_sel) begin
            // If mode_sel is 0, Single Transfer is selected. Set the mux input to 0 to use the serial addr in. No other signals are necesary
            addr_sel <= 0;
        end
        else if (en && mode_sel && ~stop_signal) begin
            // If mode_sel is 1, Burst Transfer is selected.
            
            // Assign new value as old value (prevent latches)
            burst_len_en <= burst_len_en;
            send_burst_len_data <= send_burst_len_data;
            
            initial_addr_en <= initial_addr_en;
            send_addr_data <= 0;
            
            addr_PTS_out_rst <= addr_PTS_out_rst;
            addr_PTS_out_en <= addr_PTS_out_en;
            addr_PTS_out_load <= addr_PTS_out_load;
            addr_PTS_out_send_data <= addr_PTS_out_send_data;
            addr_PTS_out_word_sel <= addr_PTS_out_word_sel; 

            counter_en <= counter_en;
            
            adder_en <= adder_en;
            
            addr_sel <= addr_sel;

            addr_loaded_flag <= addr_loaded_flag;
            
            case (internal_counter)
                6'd0:   begin
                        if (~addr_loaded_flag) begin
                            burst_len_en <= 1;          // Enable STP burst_len on the next clk cycle
                            initial_addr_en <= 1;       // Enable STP initial_addr_in on the next clk cycle
                        end
                        
                        else begin
                            addr_sel <= 1;
                            
                            addr_PTS_out_en <= 1;
                            addr_PTS_out_load <= 0;
                            addr_PTS_out_send_data <= 1;
                            addr_PTS_out_word_sel <= 2'b11;
                        end
                        
                        end
                /*        
                6'd1:   begin
                        counter_en <= 0;
                        adder_en <= 0;
                        end
                */       
                6'd4:   
                begin
                        if (~addr_loaded_flag) begin
                            burst_len_en <= 0;              // Disable STP burst_len on the next clk cycle
                            send_burst_len_data <= 1;       // Move the burst_len compare module
                        end
                        
                        end
                        
                6'd20:  begin
                        if (~addr_loaded_flag) begin
                            initial_addr_en <= 0;           // Disable STP initial_addr_en on the next clk cycle
                            send_addr_data <= 1;            // Move the burst_len into the adder module
                        end
                        
                        // Assert these signals early
                        counter_en <= 1;                    
                        adder_en <= 1;
                        
                        addr_PTS_out_en <= 0;
                        addr_PTS_out_load <= 0;
                        addr_PTS_out_send_data <= 0;
                        end
                        
                6'd21:  begin
                        if (~addr_loaded_flag) begin
                            addr_loaded_flag <= 1;                      // Burst_len and initial_addr has been loaded in. Stop the loading of data.
                        end
                        
                        counter_en <= 0; 
                        addr_PTS_out_rst <= 1;
                        end
                        
                6'd22:  begin
                        addr_PTS_out_rst <= 0;
                        addr_PTS_out_en <= 1;
                        addr_PTS_out_load <= 1;
                        addr_PTS_out_send_data <= 0;
                        end
                        
               
            endcase
            
            // These 2 are not occuring sequentially
            internal_counter <= internal_counter + 1;
            if (internal_counter == 22) internal_counter <= 0;
            
        end
    
    end

end

endmodule
