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
    // Internal clock that runs faster than SPI clk
    input FPGA_clk,
    input FPGA_rst,
 
    // Data and Clock lines for I2C comms
    // For testing purpose, use 3 lines first
    input sda,                      // should be inout
    input scl,                      // should be inout
    output sda_output,              
    
    // Output to MRAM
    inout [15:0] write_data,
    output [19:0] write_addr,
    
    // Output to PTS module
    output PTS_en,
    output cycle_out,                       // index MSB
    output [2:0] counter_out,               // index remaining bits
    
    // Control Signals to MRAM
    output chip_en,
    output read_en,
    output write_en,
    output lb_en,
    output ub_en,
    
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
    localparam IDLE = 8;
    
    // **Detecting I2C signal**
    reg start = 0;
    
    // Sync SCL to FPGA clock using a 3-it shift register. I2C module should start with both lines held high
    reg [2:0] SCLr = 3'b111;
    reg [2:0] SDAr = 3'b111;
    
    // Detect SCL rising and falling edge
    wire SCL_risingedge = (SCLr[2:1] == 2'b01);     // Rising edge
    wire SCL_fallingedge = (SCLr[2:1] == 2'b10);    // Falling edge
    
    // Detect SDA rising and falling edge
    wire SDA_risingedge = (SDAr[2:1] == 2'b01);     // Rising edge
    wire SDA_fallingedge = (SDAr[2:1] == 2'b10);    // Falling edge
    
    // Wire to detect SDA data
    wire SDA_data = SDAr[1];
    
    reg end_of_comms = 0;               // High end if one I2C comms is reached
    reg [2:0] counter = 7;              // Counter to count the no. of bits coming in or leaving I2C peripheral
    reg [3:0] state = 0;                // Stores the state information
    reg [7:0] data_input_from_SDA;      // stores the data bytes
    
    reg sda_out = 0;                    // reg to store data to be sent
    reg internal_write_enable = 0;   // Enables the slave to write on the SDA line

    // Information to keep track of
    reg [2:0] read_write_sel = 0;       // Bit 0 determines read(0) or write(1), Bit 1 determines lower_byte enable, Bit 2 determines upper_byte enable
    reg [4:0] slave_addr;               // Stores the incoming slave addr 
    
    reg burst_en = 0;
    reg [3:0] burst_len = 0;
    
    reg [15:0] MRAM_write_data = 0;
    reg [19:0] MRAM_base_addr = 0;
    
    reg read_MRAM = 0;
    reg write_MRAM = 0;
    reg send_ack = 0;
    
    // Additional registers
    reg [1:0] cycle = 0;        // Keeps tracks of which cycle for data read/write the system is on
    reg [3:0] current_burst_count = 0;
    reg increment_burst_flag = 0;
    
    // Counter at cycle 0 will index into bits 0-7
    // Counter at cycle 1 will index into bits 8-15
    assign counter_out = counter;
    assign cycle_out = cycle[0];
    
    // MRAM control signal
    assign chip_en = (read_MRAM || write_MRAM) ? 0 : 1;     // Assign 0 to chip_en if either of the signals are asserted (active low)
    assign read_en = (read_MRAM) ? 0 : 1;
    assign write_en = (write_MRAM) ? 0 : 1;
    assign lb_en =  ((read_MRAM || write_MRAM) && read_write_sel[1] ) ? 0 : 1;
    assign ub_en =  ((read_MRAM || write_MRAM) && read_write_sel[2] ) ? 0 : 1;
 
    // PTS_en
    assign PTS_en = (read_MRAM) ? 1 : 0;                    // Enables the PTS module
    
    assign write_data = (write_MRAM) ? MRAM_write_data : 'bz;
    assign write_addr = MRAM_base_addr + current_burst_count;
    
    // I2C - the slave only writes to SDA line when write_en is high
    assign sda_output = (internal_write_enable) ? ((send_ack) ? 1 : ser_data_input) : 0;
    //assign sda = (internal_write_enable) ? ((send_ack) ? 0 : ser_data_input) : 'bz;
    
    always @(posedge FPGA_clk) begin 
        if (FPGA_rst) begin
            SCLr <= 3'b111;
            SDAr <= 3'b111;
            end_of_comms <= 0;
            data_input_from_SDA <= 0;
            sda_out <= 0;
            
            read_MRAM <= 0;
            write_MRAM <= 0;
            send_ack <= 0;
            
            counter <= 0;
            state <= IDLE;
            current_burst_count <= 0;
            increment_burst_flag <= 0;
            internal_write_enable <= 0;
            
        end
        else begin   
            // On the FPGA clock, detect any rising or falling edge of the incoming I2C signal
            SCLr <= {SCLr[1:0], scl};
            SDAr <= {SDAr[1:0], sda};
            
             
            case(state)
                // *** Inputs are read from MSB to LSB ***
                IDLE: begin  
                    // data should have been written during SEND_ACK3. This extra cycle just stops anymore writes. 
                    data_input_from_SDA <= 0;
                    sda_out <= 0;
                    
                    read_MRAM <= 0;
                    write_MRAM <= 0;
                    send_ack <= 0;
                    
                    counter <= 0;
                    current_burst_count <= 0;
                    increment_burst_flag <= 0;
                    state <= IDLE;
			        
			        if (SDA_fallingedge && (SCLr == 3'b111) && (~end_of_comms)) begin
			             // SDA falls when SCL is high: Start of I2C comms
			             state <= READ_SLAVE_ADDR_AND_RWS;
			             counter <= 7;
			        end
			        
			        if (SDA_risingedge && (SCLr == 3'b111) && (end_of_comms)) begin
			             // SDA rises when SCL is high: End of I2C comms
			             state <= IDLE;
			             end_of_comms <= 0;
			        end
                end
                
                READ_SLAVE_ADDR_AND_RWS: begin
                    if (SCL_risingedge) begin
                        // Serial data is being put into a temp register
                        data_input_from_SDA[counter] <= sda;
                        if(counter == 0) begin
                           state <= SEND_ACK1;
                           internal_write_enable <= 1;
                           sda_out <= 0;
                           send_ack <= 1;
                        end 
                        else begin
                           counter <= counter - 1;
                           internal_write_enable <= 0;
                        end			
					end
                end
                
                SEND_ACK1: begin
                    if (SCL_risingedge) begin
                    
                        if(data_input_from_SDA[7:3] == ADDRESS) begin
                            counter <= 7;
                            read_write_sel <= data_input_from_SDA[2:0];
                            slave_addr <= data_input_from_SDA[7:3];
                            state <= READ_DATA1;
                            
    
                            internal_write_enable <= 0;
                            send_ack <= 0;
                        end
                        // If slave addr is wrong, stop the comms
                        else state <= IDLE;
                        
                    end
                end                
                
                READ_DATA1: begin
                    if (SCL_risingedge) begin
                    
                        // Read burst_len (4bit) and MRAM_base_addr (20 bit)
                        data_input_from_SDA[counter] <= sda;
                        if(counter == 0) begin
                           state <= SEND_ACK2;
                           internal_write_enable <= 1;
                           sda_out <= 0;
                           send_ack <= 1;
                        end 
                        else begin
                           counter <= counter - 1;
                           internal_write_enable <= 0;
                        end
                        
                    end
                end
                
                // This is the step that determines read/write operation and which state the module jumps to. 
                SEND_ACK2: begin
                    if (SCL_risingedge) begin
                    
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
                                write_MRAM <= 0;                           
                                internal_write_enable <= 1;
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
                                send_ack <= 0;
    
                            end
                            else begin
                                // If write is selected, continue to read the data bits
                                state <= READ_DATA2;                            // If read_write_sel[0] is 1 -> write operation
                                counter <= 7;
                                
                                internal_write_enable <= 0;
                                send_ack <= 0;
                            end 
                            cycle <= 0;                                         // Reset cycle to 0
                            
                            
                        end
                        else begin
                            state <= READ_DATA1;            // If not on cycle 2, go back to reading data
                            counter <= 7;
                            
                            internal_write_enable <= 0;
                            send_ack <= 0;
                        end
                        
                    end
                end
                
                READ_MRAM: begin
                    if (SCL_risingedge) begin          
                        if(counter == 0) begin
                            state <= RECV_ACK;
                            internal_write_enable <= 0;
                        end
                        else begin
                           counter <= counter - 1;
                           internal_write_enable <= 1;
                           sda_out <= ser_data_input;
                        end
                        
                        if (burst_len > 0) burst_en <= 1;
                        
                        if (increment_burst_flag) begin
                           current_burst_count <= current_burst_count + 1;
                           increment_burst_flag <= 0;
                        end
                    end
                end
                
                RECV_ACK: begin
                    if (SCL_risingedge) begin
                    
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
                            
                            state <= IDLE;
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
                                
                                state <= IDLE;
                            end   
                        end
                        
                        
                        internal_write_enable <= 1;
                        end_of_comms <= 1;
                    end
                end
                
                READ_DATA2: begin
                    if (SCL_risingedge) begin
                    
                        // Read 16-bit data to be written to MRAM
                        data_input_from_SDA[counter] <= sda;
                        if(counter == 0) begin
                           state <= SEND_ACK3;
                           internal_write_enable <= 1;
                           sda_out <= 0;
                           send_ack <= 1;
                        end
                        else begin
                           counter <= counter - 1;
                           internal_write_enable <= 0;	
                        end 
                        write_MRAM <= 0;
                        if (burst_len > 0) burst_en <= 1;
                        
                        if (increment_burst_flag) begin
                           current_burst_count <= current_burst_count + 1;
                           increment_burst_flag <= 0;
                        end
                        
                    end
                end
                
                SEND_ACK3: begin
                    if (SCL_risingedge) begin
                    
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
                            state <= IDLE;
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
                                
                                state <= IDLE;
                            end
                            
                        end
                        
                        internal_write_enable <= 0;
                        send_ack <= 0;
                        end_of_comms <= 1;
                    end
                    
                end
                
            endcase
        end
       
    end 

endmodule
