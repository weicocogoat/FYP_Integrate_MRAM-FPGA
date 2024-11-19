`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2024 22:10:25
// Design Name: 
// Module Name: i2c_simple_slave_controller
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


module i2c_simple_slave_controller(     
    //inout sda1,// Data line 1  (upper byte)
    //inout sda2,     // Data line 2  (lower byte)
    
    input sda1,
    input sda2,
    input sda3,     // Addr line
    
    input scl
    //inout scl
);

    // Slave address
    localparam ADDRESS = 5'b11111;
	
	// States
	localparam READ_INPUTS = 0;
	localparam SEND_ACK = 1;
	localparam READ_DATA = 2;
	localparam WRITE_DATA = 3;
	localparam SEND_ACK2 = 4;
	
	// Data
	reg [4:0] slave_addr;
	reg [7:0] counter;         // Internal counter
	reg [7:0] state = 0;
	
	// From SDA1 line
	reg [7:0] data1_UB_in = 0;
	reg [2:0] data1_rw_sel_in = 0;
	reg [4:0] data1_slave_addr_in = 0;
	
	// From SDA2 line
	reg [7:0] data2_LB_in = 0;
	reg [6:0] data2_burst_len_in = 0;
	reg data2_burst_sel_in = 0;
	
	// From SDA3 Line
	reg [19:0] data3_initial_addr_in = 0;
	
	reg [7:0] data_out = 8'b11001100;
	
	reg sda1_out = 0;
	reg sda2_out = 0;
	reg sda3_out = 0;
	
	reg sda1_in = 0;
	reg sda2_in = 0;
	reg sda3_in = 0;
	
	reg start = 0;
	reg write_enable = 0;
	
	assign sda1 = (write_enable == 1) ? sda1_out : 'bz;
	assign sda2 = (write_enable == 1) ? sda2_out : 'bz;
	assign sda3 = (write_enable == 1) ? sda3_out : 'bz;
    
    
    // In I2C, data doesnt change during the rising and falling edge of the sclk. 
    // If SDA transitions when the sclk is high, it indicates a start/stop signal
    
    // When SDA line is pulled down when the clock is high, it signals the start of the I2C comms
    always @(negedge sda3) begin
		if ((start == 0) && (scl == 1)) begin
			start <= 1;	
			counter <= 19;
		end
	end
	
	// When SDA is pulled high when the clk is high, it signals the end of I2C comms
	always @(posedge sda3) begin
		if ((start == 1) && (scl == 1)) begin
			state <= READ_INPUTS;
			start <= 0;
			write_enable <= 0;
		end
	end
	
	// Additional counters
	reg [7:0] counter_data_bytes = 7;
	reg [7:0] counter_rw_sel = 2;
	reg [7:0] counter_slave_addr = 4;
	reg [7:0] counter_burst_len = 6;
	
	
	always @(posedge scl) begin
		if (start == 1) begin
			case(state)
				READ_INPUTS: begin
				    // Inputs are LSB to MSB
				    
                    // First 8 bits are the upper and lower byte for SDA1 and SDA2
				    if (counter >= 12) begin
				        data1_UB_in[counter_data_bytes] <= sda1;
				        data2_LB_in[counter_data_bytes] <= sda2;
				        counter_data_bytes <= counter_data_bytes - 1;
				    end
				    
				    // Burst sel on counter == 11
				    if (counter == 11) data2_burst_sel_in <= sda2;
				    
				    // 3 bits of rw sel
				    if (counter >=9 && counter < 12) begin
				        data1_rw_sel_in[counter_rw_sel] <= sda1;
				        counter_rw_sel <= counter_rw_sel - 1;
				    end
				    
				    // 5 bits of slave addr
				    if (counter >=4 && counter <9) begin
				        data1_slave_addr_in[counter_slave_addr] <= sda1;
				        counter_slave_addr <= counter_slave_addr - 1;
                    end
                    
				    // 7 bit of burst length
				    if (counter >=4 && counter < 11) begin
				        data2_burst_len_in[counter_burst_len] <= sda2;
				        counter_burst_len <= counter_burst_len - 1;
				    end
				    
				    // Full 20 bits of addr is on SDA3
					data3_initial_addr_in[counter] <= sda3;
					
					if(counter == 0) state <= SEND_ACK;
					else counter <= counter - 1;					
				end
				
				SEND_ACK: begin
					if(data1_slave_addr_in == ADDRESS) begin
						counter <= 7;
						// Write -> 1, Read -> 0
						if(data1_rw_sel_in[0] == 0) begin 
							state <= READ_DATA;
						end
						else state <= WRITE_DATA;
					end
				end
				
				/*
				READ_DATA: begin
					data_in[counter] <= sda;
					if(counter == 0) begin
						state <= SEND_ACK2;
					end else counter <= counter - 1;
				end
				
				SEND_ACK2: begin
					state <= READ_INPUTS;					
				end
				
				WRITE_DATA: begin
					if(counter == 0) state <= READ_INPUTS;
					else counter <= counter - 1;		
				end
				*/
				
			endcase
		end
	end

endmodule
