`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2024 16:27:16
// Design Name: 
// Module Name: serial_to_parallel
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

// Reference System verilog code from https://www.edaplayground.com/x/ukY 
// Concept for serial to parallel https://www.globalspec.com/learnmore/semiconductors/logic/digital_parallel_serial_converters
module serial_to_parallel
#(parameter BUS_WIDTH = 16)
(
// To include serial output later
// Currently will write only serial in to parallel out
    input clk,
    input rst,
    input en,                           // Signals that data is coming in and should be processed (Only asserted when a write operation is done
    
    input data_in,                      // Serial data input (for writing)
    input send_data,                    // Flag to send data
    
    output [BUS_WIDTH-1 : 0] data_out   // Serves as data input when reading from MRAM, Serves as data output when writing to RAM
);

// Variables
reg [BUS_WIDTH - 1:0] data_shift_reg;

// Datapath
always @(posedge clk or posedge rst)
begin
    if (rst) begin
        // Resets all shift registers to 0
        data_shift_reg <= 0;
    end
    else begin
        // On the clock edge, move in serial data to shift registers one bit at a time
        if (en) begin
            data_shift_reg[BUS_WIDTH - 1 : 0] <= {data_in, data_shift_reg[BUS_WIDTH - 1 : 1]};
        end
        
    end
end


// If send_data gets asserted, send the contents of the shift registers out. If not, retain its old value. 
//assign data_out = (send_data == 1'b1) ? data_shift_reg : data_out;

// Use this for debugging purposes. For implementation, use the above with tenary operator
assign data_out = data_shift_reg;

endmodule

