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
    
    // Output to burst module (redundant)
    //output burst_en_out,
    //output [3:0] burst_len_out,
    
    // Output to MRAM
    output [15:0] write_data,       // should be inout
    output [19:0] write_addr,
    
    // Output to PTS module
    output PTS_en,
    output [7:0] index,
    
    // Output to both burst and PTS module (redundant)
    //output cycle_out,
    //output [3:0] current_burst_count,
   // output [7:0] counter_out,
    
    // Control Signals to MRAM
    output chip_en,
    output read_en,
    output write_en,
    output lb_en,
    output ub_en,
    
    // Input from MRAM
    //input [15:0] data_from_MRAM
    input ser_data_input        // input from PTS multiplexer
);

    // Slave address
    localparam ADDRESS = 5'b1_1111;
    
    // States
    localparam READ_SLAVE_ADDR_AND_RWS = 0;
    localparam SEND_ACK1 = 1;
    localparam READ_DATA1 = 2;
    localparam SEND_ACK2 = 3; 
    localparam READ_MRAM = 4;
    localparam RECV_ACK = 5;
    localparam READ_DATA2 = 6;
    localparam SEND_ACK3 = 7;
    localparam WRITE_MRAM_END = 8;
    
    // Internal control data
    reg [7:0] counter;         // Internal counter
    reg [7:0] state = 0;
    reg [7:0] data_input_from_SDA;
    
    // Data from SDA line
    
    // Bit 0 determines read(0) or write(1)
    // Bit 1 determines lower_byte enable
    // Bit 2 determines upper_byte enable
    reg [2:0] read_write_sel = 0;       
    reg [4:0] slave_addr;
    
    reg burst_en = 0;
    reg [3:0] burst_len = 0;
    
    reg [15:0] MRAM_write_data = 0;
    
    reg [19:0] MRAM_base_addr = 0;
    
    
    // Internal control signals
    //reg [7:0] data_out = 8'b11001100;
    reg sda_out = 0;        // Register that holds the value to be output via SDA line
    reg sda_in = 0;         // Register that holds the value to be input via SDA line
    reg start = 0;          // Indicates the start of the I2C comms, initiated by the master device 
    reg internal_write_enable = 0;   // Enables the slave to write on the SDA line
    
    reg read_MRAM = 0;
    reg write_MRAM = 0;
    
    // Additional registers
    reg [1:0] cycle = 0;        // Keeps tracks of which cycle for data read/write the system is on
    reg [3:0] current_burst_count = 0;
    
    //assign cycle_out = cycle[0];
    //assign current_burst_count_out = current_burst_count;
    assign index = (8*cycle[0]) + (7-counter);
    
    // MRAM control signal
    assign chip_en = (read_MRAM || write_MRAM) ? 0 : 1;     // Assign 0 to chip_en if either of the signals are asserted (active low)
    assign read_en = (read_MRAM) ? 0 : 1;
    assign write_en = (write_MRAM) ? 0 : 1;
    assign lb_en =  ((read_MRAM || write_MRAM) && read_write_sel[1] ) ? 0 : 1;
    assign ub_en =  ((read_MRAM || write_MRAM) && read_write_sel[2] ) ? 0 : 1;
 
    // PTS_en
    assign PTS_en = (read_MRAM) ? 1 : 0;
    
    // 
    assign write_data = MRAM_write_data;
    assign write_addr = MRAM_base_addr + current_burst_count;
    //assign burst_en_out = burst_len[0] | burst_len[1] | burst_len[2] | burst_len[3] ;   // Determines if burstlen is >0
    //assign burst_len_out = burst_len;
    //assign counter_out = counter;
    
    // I2C - the slave only writes to SDA line when write_en is high
     assign sda = (internal_write_enable == 1) ? sda_out : 'bz;
     
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
            internal_write_enable <= 0;
        end
    end
    
    reg increment_burst_flag = 0;
    
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
                
                // This is the step that determines read/write operation and which state the module jumps to. 
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
                        if (read_write_sel[0] == 0) begin
                            // If read is selected, move to READ_MRAM state
                            state <= READ_MRAM;                             // If read_write_sel[0] is 0 -> read operation
                            read_MRAM <= 1;                           
                            
                            /*
                            // Send information to burst module
                            if (data_input_from_SDA[7:4] > 0) begin
                                // Enable burst module if burst len is above 0
                                burst_en <= 1;                                   
                            end
                            else begin
                                // If there is no burst, burst module doesnt do anything
                                burst_en <= 0;  
                            end
                            */
                            
                            cycle <= 0;
                            counter <= 7;
                        end
                        else begin
                            // If write is selected, continue to read the data bits
                            state <= READ_DATA2;                            // If read_write_sel[0] is 1 -> write operation
                            counter <= 7;
                        end 
                        cycle <= 0;                                         // Reset cycle to 0
                        
                        
                    end
                    else begin
                        state <= READ_DATA1;            // If not on cycle 2, go back to reading data
                        counter <= 7;
                    end
                end
                
                READ_MRAM: begin          
                    if(counter == 0) state <= RECV_ACK;
					else counter <= counter - 1;
					
					if (burst_len > 0) burst_en <= 1;
					
					if (increment_burst_flag) begin
					   current_burst_count <= current_burst_count + 1;
					   increment_burst_flag <= 0;
                    end
                end
                
                RECV_ACK: begin
                    if (cycle == 0) begin
                        state <= READ_MRAM;
                        cycle <= cycle + 1;
                        counter <= 7;
                    end
                    else if (cycle == 1 && burst_en == 0) begin
                        // If not a burst read, readout has ended and I2C comms should be ended by master. Take this time to reset the necessary registers
                        cycle <= 0;
                        sda_out <= 0;
                        read_write_sel <= 0; 
                        read_MRAM <= 0;
                        write_MRAM <= 0;
                        counter <= 0;
                    end
                    else if (cycle == 1 && burst_en == 1) begin
                        // If burst was enabled, check the burst length
                        if (current_burst_count < burst_len - 1) begin
                            // If current burst count is lower, continue reading from MRAM and increment current burst count
                            state <= READ_MRAM;
                            //current_burst_count <= current_burst_count + 1;
                            increment_burst_flag <= 1;
                            cycle <= 0;
                            counter <= 7;
                        end
                        else begin
                            // If current burst count reached (burst_len-1), burst read is completed and I2C comms should be ended by master
                            cycle <= 0;
                            sda_out <= 0;
                            read_write_sel <= 0; 
                            read_MRAM <= 0;
                            write_MRAM <= 0;
                            counter <= 0;
                            state <= RECV_ACK;
                        end   
                    end
                end
                
                READ_DATA2: begin
                    // Read 16-bit data to be written to MRAM
                    data_input_from_SDA[counter] <= sda;
					if(counter == 0) state <= SEND_ACK3;
					else counter <= counter - 1;

					write_MRAM <= 0;
					if (burst_len > 0) burst_en <= 1;
					
					if (increment_burst_flag) begin
					   current_burst_count <= current_burst_count + 1;
					   increment_burst_flag <= 0;
                    end
                end
                
                SEND_ACK3: begin
                    case(cycle)
                        2'b00:  MRAM_write_data[7:0] <= data_input_from_SDA;
                        
                        2'b01:  MRAM_write_data[15:8] <= data_input_from_SDA;
                    endcase
                    
                    if (cycle == 0) begin
                        state <= READ_DATA2;
                        counter <= 7;
                        cycle <= cycle + 1;
                    end
                    else if (cycle == 1 && burst_en == 0) begin
                        // If not a burst read, readout has ended and I2C comms should be ended by master. Take this time to reset the necessary registers
                        cycle <= 0;
                        counter <= 0;
                        write_MRAM <= 1;
                        state <= WRITE_MRAM_END;
                    end
                    else if (cycle == 1 && burst_en == 1) begin
                        if (current_burst_count < burst_len - 1) begin
                            write_MRAM <= 1;
                            //current_burst_count <= current_burst_count + 1;
                            increment_burst_flag <= 1;
                            cycle <= 0;
                            counter <= 7;
                            state <= READ_DATA2;
                        end
                        else begin
                            cycle <= 0;
                            counter <= 0;
                            write_MRAM <= 1;
                            state <= WRITE_MRAM_END;
                        end
                        
                    end
                end
                
                WRITE_MRAM_END: begin  
                    // data should have been written during SEND_ACK3. This extra cycle just stops anymore writes. 
                    write_MRAM <= 0;
                    current_burst_count <= 0;
                end
                
                
            endcase
        end
    end 

    always @(negedge scl) begin
        // To send ACK in I2C, signal is held low(0)
        // For simulation purposes, this will be asserted. Change this when implementing on hardware
		case(state)
		
            READ_SLAVE_ADDR_AND_RWS: begin
                internal_write_enable <= 0;
            end
            
            READ_DATA1: begin
                internal_write_enable <= 0;	       
            end
            
            SEND_ACK1: begin
                internal_write_enable <= 1;
                sda_out <= 0;
            end
            
            SEND_ACK2: begin
                internal_write_enable <= 1;
                sda_out <= 0;
            end
            
            READ_MRAM: begin
                internal_write_enable <= 1;
                //sda_out <= 0;
                sda_out <= ser_data_input;
            end 
            
            RECV_ACK: begin
                internal_write_enable <= 0;
            end
            
            READ_DATA2: begin
                internal_write_enable <= 0;	        
            end
            
            SEND_ACK3: begin
                internal_write_enable <= 0;
                sda_out <= 0;
            end
			
			WRITE_MRAM_END: begin
			     internal_write_enable <= 0;
			     sda_out <= 0;
			end
			
			
		endcase
	end


endmodule
