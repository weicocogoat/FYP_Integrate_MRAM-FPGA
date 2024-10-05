`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.09.2024 20:46:02
// Design Name: 
// Module Name: parallel_to_serial
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

// Reference: https://github.com/mnmhdanas/Parallel-IN-Serial-OUT 
// Concept for serial to parallel https://www.globalspec.com/learnmore/semiconductors/logic/digital_parallel_serial_converters
// https://evlsi.wordpress.com/2014/10/24/paralleltoserialconverter/
module parallel_to_serial(
    input clk,
    input rst,
    input en,
    
    input load,                     // When data is ready to be read, this signal will be asserted and data will be loaded into an internal register
    input send_data,                // Send the data serially
    
    /*
    Selects full, upper, or lower byte
    11 -> Full byte
    01 -> Lower byte
    10 -> Upper byte
    */
    input [1:0] word_sel,           
    
    input [15:0] data_in,           // Data from MRAM
    
    output reg data_out
    //output reg end_of_transmission        // Enable this only when testing this module independatantly
);

reg [15:0] data_shift_reg;
reg [5:0] counter;

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        data_shift_reg <= 0;
        counter <= 0;
        data_out <= 0;
        //end_of_transmission <= 0;
    end
    else 
        if (en) begin
            if (load) begin
                data_shift_reg <= data_in;
                //end_of_transmission <= 0;
            end
            if (send_data) begin
            
                case (word_sel)
                    2'b11: begin
                           counter <= counter + 1;
                           data_out <= data_shift_reg[0];
                           data_shift_reg <= (data_shift_reg >> 1);
                           end 
                           
                    2'b01: begin
                           counter <= counter + 1;
                           data_out <= data_shift_reg[0];
                           data_shift_reg <= (data_shift_reg >> 1);
                           end
                           
                    2'b10: begin
                           counter <= counter + 1;
                           data_out <= data_shift_reg[8];
                           data_shift_reg <= (data_shift_reg >> 1);
                           end
                           
                    default: counter <= counter + 1; // Should never reach here
                endcase
                
                /*
                // Enable this section only when testing this independantly
                case (counter)
                    5'd16 : end_of_transmission <= 1;
                    
                    5'd17 : end_of_transmission <= 0;
                    
                    default: end_of_transmission <= 0;
                endcase
                */
            end
        end
end


endmodule
