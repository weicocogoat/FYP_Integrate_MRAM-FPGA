`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.12.2024 23:11:50
// Design Name: 
// Module Name: I2C_Simple_Slave_Controller
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


module I2C_Simple_Slave_Controller(
    // Data and Clock lines for I2C comms
    // should be inout, but for testing, use input instead
    input sda,
    input scl,
    
    // Output to burst module
    output reg burst_en,
    output reg [3:0] burst_len_out,
    
    // Output to MRAM
    output reg [15:0] write_data,
    output reg [19:0] write_addr,
    output reg read_signal,
    output reg write_signal,
    
    // Input from MRAM
    input [15:0] data_from_MRAM
);

    // Slave address
    localparam ADDRESS = 5'b1_1111;
    
    // States
    localparam READ_SLAVE_ADDR_AND_RWS = 0;
    localparam SEND_ACK1 = 1;
    localparam READ_DATA1 = 2;
    localparam SEND_ACK2 = 3; 
    localparam READ_MRAM = 4;
    localparam READ_DATA2 = 5;
    localparam SEND_ACK3 = 6;
    localparam WRITE_MRAM = 7;
    
    // Internal control data
    reg [7:0] counter;         // Internal counter
    reg [7:0] state = 0;
    reg [7:0] data_input_from_SDA;
    
    // Data from SDA line
    reg [2:0] read_write_sel = 0;
    reg [4:0] slave_addr;
    
    reg [3:0] burst_len = 0;
    
    reg [15:0] MRAM_write_data = 0;
    
    reg [19:0] MRAM_base_addr = 0;
    
    
    reg [7:0] data_out = 8'b11001100;
    reg sda_out = 0;
    reg sda_in = 0;
    reg start = 0;
    reg write_enable = 0;
    
    assign sda = (write_enable == 1) ? sda_out : 'bz;
 
    // In I2C, data doesnt change during the rising and falling edge of the sclk. 
    // If SDA transitions when the sclk is high, it indicates a start/stop signal
    
    // When SDA line is pulled down when the clock is high, it signals the start of the I2C comms
    always @(negedge sda) begin
        if ((start == 0) && (scl == 1)) begin
            start <= 1;	
            counter <= 7;
        end
    end
    
    // When SDA is pulled high when the clk is high, it signals the end of I2C comms
    always @(posedge sda) begin
        if ((start == 1) && (scl == 1)) begin
            state <= READ_SLAVE_ADDR_AND_RWS;
            start <= 0;
            write_enable <= 0;
        end
    end
    
    // Additional registers
    reg [1:0] cycle = 0;
    
    always @(posedge scl) begin
        if (start == 1) begin
            case(state)
                // *** Inputs are read from MSB to LSB ***
                READ_SLAVE_ADDR_AND_RWS: begin
                    // Serial data is being put into a temp register
                    data_input_from_SDA[counter] <= sda;
					if(counter == 0) state <= SEND_ACK1;
					else counter <= counter - 1;					
                end
                
                SEND_ACK1: begin
                    if(data_input_from_SDA[7:3] == ADDRESS) begin
                        counter <= 7;
                        read_write_sel <= data_input_from_SDA[2:0];
                        slave_addr <= data_input_from_SDA[7:3];
                        state <= READ_DATA1;
                    end
                    // If slave addr is wrong, stop the comms
                    else start <= 0;
                end                
                
                READ_DATA1: begin
                    // Read burst_len (4bit) and MRAM_base_addr (24 bit)
                    data_input_from_SDA[counter] <= sda;
					if(counter == 0) state <= SEND_ACK2;
					else counter <= counter - 1;
                end
                
                SEND_ACK2: begin
                    case(cycle)
                        2'b00:  MRAM_base_addr[7:0] <= data_input_from_SDA;
                        
                        2'b01:  MRAM_base_addr[15:8] <= data_input_from_SDA;
                        
                        2'b10:  begin
                                MRAM_base_addr[19:16] <= data_input_from_SDA[3:0];
                                burst_len <= data_input_from_SDA[7:4];
                        end
                    endcase
                    cycle <= cycle + 1;
                    
                    if (cycle == 2) begin
                        if (read_write_sel[0] == 0) state <= READ_MRAM;     // If read_write_sel[0] is 0 -> read operation
                        else begin
                            state <= READ_DATA2;                            // If read_write_sel[0] is 1 -> write operation
                            counter <= 7;
                        end 
                        cycle <= 0;                     // Reset cycle to 0
                    end
                    else begin
                        state <= READ_DATA1;            // If not on cycle 2, go back to reading data
                        counter <= 7;
                    end
                end
                
                
                READ_MRAM: begin
                    // At this point, the I2C master should have initiated a stop signal.
                    write_addr <= MRAM_base_addr;
                    burst_len_out <= burst_len;
                    
                    if (burst_len == 0) burst_en = 0;
                    else burst_en = 1;
                    
                    read_signal <= 1;
                end
                
                READ_DATA2: begin
                    // Read 16-bit data to be written to MRAM
                    data_input_from_SDA[counter] <= sda;
					if(counter == 0) state <= SEND_ACK3;
					else counter <= counter - 1;
                end
                
                SEND_ACK3: begin
                    case(cycle)
                        2'b00:  MRAM_write_data[7:0] <= data_input_from_SDA;
                        
                        2'b01:  MRAM_write_data[15:8] <= data_input_from_SDA;
                    endcase
                    
                    cycle <= cycle + 1;
                    if (cycle == 1) state <= WRITE_MRAM;
                    else begin
                        state <= READ_DATA2;
                        counter <= 7;
                    end
                end
                
                WRITE_MRAM: begin
                    write_addr <= MRAM_base_addr;
                    write_data <= MRAM_write_data;
                    
                    burst_len_out <= burst_len;
                    if (burst_len == 0) burst_en = 0;
                    else burst_en = 1;
                    
                    write_signal <= 1;
                end
                
                
            endcase
        end
    end 

    always @(negedge scl) begin
		case(state)
		
			SEND_ACK1: begin
				sda_out <= 0;
			end
			
			SEND_ACK2: begin
				sda_out <= 0;
			end
			
		endcase
	end


endmodule
