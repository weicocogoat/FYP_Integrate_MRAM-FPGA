`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.09.2024 00:58:29
// Design Name: 
// Module Name: control_module
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


module control_module(
    input clk,
    input rst,

    input read_write_sel,               // 0 for read, 1 for write
    
    output reg data_en,                 // Enable the data STP module
    output reg addr_en,                 // Enable the addr STP module
    output reg send_data,               // Flag to send parallel data out
    
    output reg load,                    // Flag to load data from MRAM to internal shift registers
    output reg data_in_from_MRAM_en,    // Enable the data in from MRAM PTS module
    
    output reg chip_en,                 // Chip enable, active low
    output reg write_en,                // Write enable, active low
    output reg out_en,                  // Read enable, active low
    output reg lower_byte_en,           // Reading of bytes 7:0 enable line, active low
    output reg upper_byte_en            // Reading of bytes 15:8 enable line, active low
);
reg [5:0] counter;                      // 6 flip flops to use as a 5-bit counter. Need to count up to 20. 

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        counter <= 0;
        
        data_en <= 0;
        addr_en <= 0;
        send_data <= 0;
        
        load <= 0;
        data_in_from_MRAM_en <= 0;
                       
        chip_en <= 1;                 
        write_en <= 1;               
        out_en <= 1;                
        lower_byte_en <= 1;    
        upper_byte_en <= 1;
    end
    else begin
        if (read_write_sel) begin
            // Write operation
            data_en <= data_en;
            addr_en <= addr_en;
            
            load <= load;
            data_in_from_MRAM_en <= data_in_from_MRAM_en;

            counter <= counter + 1;
            
            case (counter)
                5'd0  : begin               // Keep track of the number of bits being shifted into data and addr shift registers
                        data_en <= 1; 
                        addr_en <= 1;
                        end
                        
                5'd16 : data_en <= 0;       // All 16 bits have been shifted into the shift register, stop the shifting and retain the current state
                
                5'd20 : begin
                        addr_en <= 0;       // All 20 bits have been shifted into the shift register, stop the shift and retain current state
                        send_data <= 1;     // At the 21st cycle, both addr and data shift registers are full and they can be moved to the output
                        
                        chip_en <= 0;     
                        write_en <= 0;               
                        out_en <= 1;                
                        lower_byte_en <= 0;    
                        upper_byte_en <= 0;
                        end
                        
                5'd21 : begin               
                        counter <= 0;       // Reset counter to 0 and prepare for the next set of inputs
                        data_en <= 0;
                        addr_en <= 0;
                        end
                        
                default : begin
                          send_data <= 0;   // At every other clock cycle, do not send the data over yet
                          
                          chip_en <= 1;     // chip_en also helps to prevent the MRAM from reading the data as valid  
                          write_en <= 1;               
                          out_en <= 1;                
                          lower_byte_en <= 1;    
                          upper_byte_en <= 1;
                          end
            endcase
            //counter <= counter + 1;
        end
        
        else if (~read_write_sel) begin
            // Read operation
            // Write operation
            data_en <= data_en;
            addr_en <= addr_en;
            data_in_from_MRAM_en <= data_in_from_MRAM_en;
            send_data <= send_data;
            
            case (counter)
                6'd0  : addr_en <= 1;
                
                6'd20 : begin
                        addr_en <= 0;           // All 20 bits have been shifted into the shift register, stop the shift and retain current state
                        send_data <= 1;
                        
                        chip_en <= 0;     
                        write_en <= 1;               
                        out_en <= 0;            // Assert the out(read) line to signal a read operation for the MRAM                         
                        lower_byte_en <= 0;    
                        upper_byte_en <= 0;
                        end
                        
                6'd21 : begin               
                        send_data <= 1;         // At the 21st cycle, send the addr to the MRAM
                        
                        chip_en <= 0;     
                        write_en <= 1;               
                        out_en <= 0;            // Assert the out(read) line to signal a read operation for the MRAM                         
                        lower_byte_en <= 0;    
                        upper_byte_en <= 0;
                        end
                        
                    
                6'd22 : begin
                        // Assume that data will be ready on the next clock cycle for now
                        
                        // These values need to be held low to allow reading of data (as per the MRAM module)
                        chip_en <= 0;     
                        write_en <= 1;               
                        out_en <= 0;                                   
                        lower_byte_en <= 0;    
                        upper_byte_en <= 0;
                        
                        send_data <= 0;
                        
                        data_in_from_MRAM_en <= 1;          // Start the parallel to serial module
                        load <= 1;                          // Assert the load flag to move the data into an internal register
                        end
                        
                6'd23 : send_data <= 1;                     // After data has been loaded in, start to send data serially
                    
                6'd39 : begin
                        data_in_from_MRAM_en <= 0;          // All data has been shifted out of the MRAM at this point. Disable the module   
                        send_data <= 0;
                        counter <= 0;
                        end
                                 
                default : begin
                          //send_data <= 0;   // At every other clock cycle, do not send the data over yet
                          
                          load <= 0;
                          
                          chip_en <= 1;     // chip_en also helps to prevent the MRAM from reading the data as valid  
                          write_en <= 1;               
                          out_en <= 1;                
                          lower_byte_en <= 1;    
                          upper_byte_en <= 1;
                          end
            endcase
            counter <= counter + 1;
        end
        
        
    end

end


endmodule
