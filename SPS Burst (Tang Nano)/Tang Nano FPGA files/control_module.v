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

    /*
    Bit 0 - 0 for Read, 1 for Write
    Bits 2:1 -
    00 - nop
    01 - Lower byte Read/Write
    10 - Upper byte Read/Write
    11 - Full byte Read/Write
    */
    input [2:0] read_write_sel,
    output reg [1:0] prev_read_write_sel,
    
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
reg [5:0] counter;                      // 6 flip flops to use as a 6-bit counter. Minimum required as of now
reg read_flag;
reg [1:0] prev_read_write_sel_intreg;

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        counter <= 0;
        read_flag <= 0;
        prev_read_write_sel_intreg[0] <= 0;
        prev_read_write_sel_intreg[1] <= 0;
        
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
        
        prev_read_write_sel <= 0;
    end
    else begin
        if (read_write_sel[0]) begin
            // Write operation
            data_en <= data_en;
            addr_en <= addr_en;
            
            load <= load;
            data_in_from_MRAM_en <= data_in_from_MRAM_en;

            // Keep track of the number of bits being shifted into data and addr shift registers
            case (counter)
                6'd1  : begin              
                        // Enable both data and addr STP addr_en on the next rising edge
                        data_en <= 1; 
                        addr_en <= 1;
                        end
                        
                6'd17 : begin
                        // All 16 bits have been shifted into the shift register, stop the shifting and retain the current state
                        data_en <= 0;     
                        end 
                        
                6'd20 : begin
                        // Refer to MRAM documentation pg 10. 
                        // This is utilizing Write Cycle 2 Timing, Enable Controlled: Pull write_en and lb&ub_en low first before pulling chip_en low. 
                        if (read_write_sel[0] == 1) begin
                            chip_en <= 1;     
                            write_en <= 0;               
                            out_en <= 1;                
                            lower_byte_en <= ~read_write_sel[1];    // Active low, therefore, not operation first
                            upper_byte_en <= ~read_write_sel[2];
                        end
                        
                        end
                        
                6'd21 : begin
                        // All 20 bits have been shifted into the shift register, stop the shift and retain current state
                        addr_en <= 0;  
                        
                        // At the 21st cycle, both addr and data shift registers are full and they can be moved to the output
                        // Set send_data to 1 so that on the next rising edge, data can be output to the MRAM
                        send_data <= 1;     
                        
                        // Set the MRAM signals such that on the next rising edge, data can be output to the MRAM as a write operation
                        
                        chip_en <= 0;     
                        write_en <= 0;               
                        out_en <= 1;                
                        lower_byte_en <= ~read_write_sel[1];    // Active low, therefore, not operation first
                        upper_byte_en <= ~read_write_sel[2];
                        
                        end
                        
                6'd22 : begin
                        // Reset Enable lines              
                        data_en <= 0;
                        addr_en <= 0;
                        //counter <= 0;   // Reset Counter at 22nd clock cycle to sync with Burst Module
                        end
                        
                        
                default : begin
                          // At every other clock cycle, do not send the data over yet
                          send_data <= 0;   
                          
                          // At every other clock cycle, do not enable MRAM yet.
                          chip_en <= 1;      
                          write_en <= 1;               
                          out_en <= 1;                
                          lower_byte_en <= 1;    
                          upper_byte_en <= 1;
                          end
            endcase
            counter <= counter + 1;
            if (counter == 22) counter <= 0;
        end
        
        else if (~read_write_sel[0]) begin
            // Read operation
            data_en <= data_en;
            addr_en <= addr_en;
            
            data_in_from_MRAM_en <= data_in_from_MRAM_en;
            send_data <= send_data;
            
            chip_en <= chip_en;     // chip_en also helps to prevent the MRAM from reading the data as valid  
            write_en <= write_en;               
            out_en <= out_en;                
            lower_byte_en <= lower_byte_en;    
            upper_byte_en <= upper_byte_en;
            
            prev_read_write_sel_intreg[1] <= prev_read_write_sel_intreg[1];
            prev_read_write_sel_intreg[0] <= prev_read_write_sel_intreg[0];
            
            prev_read_write_sel[1] <= prev_read_write_sel_intreg[1];
            prev_read_write_sel[0] <= prev_read_write_sel_intreg[0];
            
            read_flag <= read_flag;
            
            case (counter)
                6'd1  : begin
                        // Enable the addr STP module in the next rising edge
                        addr_en <= 1;
                        
                        if (read_flag) begin
                        send_data <= 0;
                        
                        //data_in_from_MRAM_en <= 1; 
                        
                        // Stop the loading. Data should have been latched in properly    
                        load <= 0;
                        end
                        
                        end
                        
                6'd2  : begin
                        // Data should have been successfully loaded in at this clock cycle 
                        // Assert the send_data signal such that data will be output serially on the next clock cycle
                        if (read_flag) begin
                            send_data <= 1;
                        end
                        
                        chip_en <= 1;     // chip_en also helps to prevent the MRAM from reading the data as valid  
                        write_en <= 1;               
                        out_en <= 1;                
                        lower_byte_en <= 1;    
                        upper_byte_en <= 1;
                        end
                
                6'd10  : begin
                        if ( read_flag && ~(prev_read_write_sel_intreg[1] && prev_read_write_sel_intreg[0]) ) 
                           begin
                           // If either one of the bits is 0, it is a half word 
                           // At the 31st cycle, all 8 bits have been sent out and should thus, stop sending data
                           data_in_from_MRAM_en <= 0;  
                           send_data <= 0;
                           end
                        end 
                        
                6'd18 : begin
                        if (read_flag) begin
                            // All data has been shifted out of the MRAM at this point. Disable the module
                            data_in_from_MRAM_en <= 0;  
                            send_data <= 0;
                            counter <= 0;
                            read_flag <= 0;
                        end
                        end
                        
                6'd20 : begin
                        prev_read_write_sel_intreg[1] <= read_write_sel[2];
                        prev_read_write_sel_intreg[0] <= read_write_sel[1];
                        end
                
                6'd21 : begin
                        // All 20 bits have been shifted into the shift register, stop the shift and retain current state
                        addr_en <= 0;
                        
                        // Set send_data to 1 so that on the next rising edge, data will be output to MRAM           
                        send_data <= 1;
                        
                        // Set the MRAM signals such that on the next rising edge, data can be output to the MRAM as a write operation
                        chip_en <= 0;     
                        write_en <= 1;               
                        out_en <= 0;
                        lower_byte_en <= ~prev_read_write_sel_intreg[0];    // Active low, therefore, not operation first
                        upper_byte_en <= ~prev_read_write_sel_intreg[1];
                        
                        //prev_read_write_sel_intreg[1] <= read_write_sel[2];
                        //prev_read_write_sel_intreg[0] <= read_write_sel[1];
                        
                        read_flag <= 1;
                        
                        // Assert the load flag to move the data into an internal register         
                        load <= 1;
                        data_in_from_MRAM_en <= 1; 
                        end
                        
                6'd22 : begin
                        // One stall cycle to enable MRAM fetch the data to its addr_en
                        // For the current implementation, I think its not necessary? But I'll leave it in for now               
                        send_data <= 1;
                        
                        chip_en <= 0;     
                        write_en <= 1;               
                        out_en <= 0;                        
                        lower_byte_en <= ~prev_read_write_sel_intreg[0];    // Active low, therefore, not operation first
                        upper_byte_en <= ~prev_read_write_sel_intreg[1];
                        
                        // Assert the load flag to move the data into an internal register         
                        load <= 1;
                        data_in_from_MRAM_en <= 1; 
                        end      
                                 
                default : begin
                          load <= 0;
                          end
            endcase
            counter <= counter + 1;
            if (counter == 22) counter <= 0;
        end
        
        
    end

end


endmodule