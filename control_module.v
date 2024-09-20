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
    
    output reg chip_en,                 // Chip enable, active low
    output reg write_en,                // Write enable, active low
    output reg out_en,                  // Read enable, active low
    output reg lower_byte_en,           // Reading of bytes 7:0 enable line, active low
    output reg upper_byte_en            // Reading of bytes 15:8 enable line, active low
);
reg [4:0] counter;                      // 5 flip flops to use as a 5-bit counter. Need to count up to 20. 

always @(posedge clk or rst)
begin
    if (rst) begin
        counter <= 0;
        
        data_en <= 0;
        addr_en <= 0;
        send_data <= 0;
                       
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
            
            case (counter)
                5'd0  : begin               // Keep track of the number of bits being shifted into data and addr shift registers
                        data_en <= 1; 
                        addr_en <= 1;
                        end
                        
                5'd16 : data_en <= 0;       // All 16 bits have been shifted into the shift register, stop the shifting and retain the current state
                
                5'd20 : addr_en <= 0;       // All 20 bits have been shifted into the shift register, stop the shift and retain current state
                
                5'd21 : begin               
                        counter <= 0;       // Reset counter to 0 and prepare for the next set of inputs
                        send_data <= 1;     // At the 21st cycle, both addr and data shift registers are full and they can be moved to the output
                        
                        chip_en <= 0;     
                        write_en <= 0;               
                        out_en <= 1;                
                        lower_byte_en <= 0;    
                        upper_byte_en <= 0;
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
            counter <= counter + 1;
        end
        /*
        else if (~read_write_sel) begin
            // Read operation
        end
        */
        
    end

end


endmodule
