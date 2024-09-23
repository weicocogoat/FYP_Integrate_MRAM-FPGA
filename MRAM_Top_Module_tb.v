`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2024 16:29:16
// Design Name: 
// Module Name: serial_to_parallel_tb
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


module MRAM_Top_Module_tb;

// Connection to unit under test
reg clk = 0;
reg rst = 0;
            
reg data_in;   
reg addr_in;     
reg read_write_sel;                          

wire [15:0] data_out;
wire [19:0] addr_out;

reg [15:0] parallel_data_in;
wire ser_data_out;

wire chip_en;           
wire write_en;            
wire out_en;              
wire lower_byte_en;      
wire upper_byte_en;
               

// Variables 
integer i = 0;

MRAM_Top_Module uut
(
    .clk(clk),
    .rst(rst),
    
    .data_in(data_in),
    .addr_in(addr_in),
    .read_write_sel(read_write_sel),
    
    .data_out(data_out),
    .addr_out(addr_out),
    
    .parallel_data_in(parallel_data_in),
    .ser_data_out(ser_data_out),
    
    // MRAM signals
    .chip_en(chip_en),               
    .write_en(write_en),             
    .out_en(out_en),                 
    .lower_byte_en(lower_byte_en),          
    .upper_byte_en(upper_byte_en)       
);

always begin
    #5
    clk = ~clk;
end

initial begin
    clk <= 1'b0;
    rst <= 1'b1;
    
    // Testing of Write operation starts here 
    
    // Assert the read_write_sel line(write operation) 1 cycle before serial input goes into the STP modules
    #5
    rst <= 1'b0;
    read_write_sel <= 1'b1;
    @(negedge clk)
    
    
    // At the negative edge of the clock, change the signal being fed into the UUT. 
    // Addr and data are fed in from LSB to MSB
    // For the first 10 cycles, addr and data bits will be set to 1
    for (i = 0; i < 10; i= i+1) begin
        @(negedge clk);
        rst <= 1'b0;
        read_write_sel <= 1'b1;
        addr_in <= 1'b0;
        data_in <= 1'b1;
    end
    
    // For the next 10 cycles, addr and data bits will be set to 0
    for (i = 0; i < 10; i= i+1) begin
        @(negedge clk);
        rst <= 1'b0;
        read_write_sel <= 1'b1;
        addr_in <= 1'b0;
        data_in <= 1'b0;
    end
    
    // Enable reset and to stop all modules
    @(negedge clk)
    @(negedge clk)
    rst <= 1'b1;
    
    #20
    
    // Testing of Write operation ends here
    
    // Set the read_write_sel line to 0(read operation) 1 cycle before serial input goes into the STP modules
    rst <= 1'b0;
    read_write_sel <= 1'b1;
    @(negedge clk)
    
    // Testing of Read operation starts here
    for (i = 0; i < 20; i = i+1) begin
        @(negedge clk)
        rst <= 1'b0;
        read_write_sel <= 1'b0;
        addr_in <= 0;
    end
    
    #300
    

    $finish;
 
end

endmodule
