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
module serial_to_parallel(
// To include serial output later
// Currently will write only serial in to parallel out
    input clk,
    input rst,
    input ctrl_en,
    
    input addr_in,                  // Serial address input
    input data_in,                  // Serial data input (for writing)
    input ctrl,                     // Control signal to determine the operation (reading ort writing)
    
    output [19:0] addr_out,         // Address sent to MRAM
    output [15:0] data_out,          // Serves as data input when reading from MRAM, Serves as data output when writing to RAM
    output reg chip_en,                 // Chip enable
    output reg write_en,                // Write enable
    output reg out_en,                  // Read enable
    output reg lower_byte_en,           // Reading of bytes 7:0 enable line
    output reg upper_byte_en            // Reading of bytes 15:8 enable line
);

// Variables
reg [19:0] addr_shift_reg;
reg [15:0] data_shift_reg;
reg [4:0] counter;          // 5 flip flops to use as a 5-bit counter. Need to count up to 20. 
reg addr_en;                // Addr enable signal
reg data_en;                // Data enable signal
reg send_data;              // Flag to send parallel data out


// Datapath
always @(posedge clk or rst)
begin
    if (rst) begin
        // Resets all shift registers to 0
        addr_shift_reg <= 0;
        data_shift_reg <= 0;
    end
    else begin
        // On the clock edge, move in serial data to shift registers one bit at a time
        if (addr_en) begin
            // Move the serial input of the addr_in line to the shift register
            addr_shift_reg[19:0] <= {addr_in, addr_shift_reg[19:1]}; 
        end
        if (data_en) begin
            data_shift_reg[15:0] <= {data_in, data_shift_reg[15:1]};
        end
        
    end
end

// Control logic
always @(posedge clk or rst)
begin
    if (rst) begin
        counter <= 0;
        addr_en <= 0;
        data_en <= 0;
    end
    else begin
        if (ctrl_en) begin
            counter <= counter + 1;         // Increment counter by 1 for every clock edge
            data_en <= data_en;         
            addr_en <= addr_en;         
            case (counter)
                5'd1  : begin               // Keep track of the number of bits being shifted into data and addr shift registers
                        data_en <= 1; 
                        addr_en <= 1;
                        end
                        
                5'd16 : data_en <= 0;       // All 16 bits have been shifted into the shift register, stop the shifting and retain the current state
                
                5'd20 : addr_en <= 0;       // All 20 bits have been shifted into the shift register, stop the shift and retain current state
                
                5'd21 : begin               
                        send_data <= 1;     // At the 21st cycle, both addr and data shift registers are full and they can be moved to the output
                        counter <= 0;       // Reset counter to 0 and prepare for the next set of inputs
                        chip_en <= 1;       
                        write_en <= 1;               
                        out_en <= 0;                
                        lower_byte_en <= 1;    
                        upper_byte_en <= 1;
                        end
                        
                default : begin
                          send_data <= 0;   // At every other clock cycle, do not send the data over yet.
                          chip_en <= 0;       
                          write_en <= 0;               
                          out_en <= 0;                
                          lower_byte_en <= 0;    
                          upper_byte_en <= 0;
                          end
            endcase
        end
    end
end

//assign addr_out = (send_data) ? addr_shift_reg : 0;
//assign data_out = (send_data) ? data_shift_reg : 0;

assign addr_out = addr_shift_reg;
assign data_out = data_shift_reg;

endmodule
