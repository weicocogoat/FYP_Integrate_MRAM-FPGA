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


module serial_to_parallel_tb_backup;

// Connection to unit under test
reg clk = 0;
reg rst = 0;
reg ctrl = 0;

reg addr_in;                
reg data_in;                                  

wire [19:0] addr_out;        
wire [15:0] data_out;          
wire chip_en;           
wire write_en;            
wire out_en;              
wire lower_byte_en;      
wire upper_byte_en;

// Variables 
integer i = 0;

serial_to_parallel uut
(
    .clk(clk),
    .rst(rst),
    .ctrl(ctrl),
    
    .addr_in(addr_in),                
    .data_in(data_in),                                    
    
    .addr_out(addr_out),         
    .data_out(data_out),          
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
    ctrl <= 1'b0;
    
    // At the negative edge of the clock, change the signal being fed into the UUT. 
    // Addr and data are fed in from LSB to MSB
    // For the first 10 cycles, addr and data bits will be set to 1
    for (i = 0; i < 10; i= i+1) begin
        @(negedge clk);
        rst <= 1'b0;
        ctrl <= 1'b1;
        addr_in <= 1'b1;
        data_in <= 1'b1;
        //ctrl <= 1'b1;
    end
    
    // For the next 10 cycles, addr and data bits will be set to 0
    for (i = 0; i < 10; i= i+1) begin
        @(negedge clk);
        rst <= 1'b0;
        ctrl <= 1'b1;
        addr_in <= 1'b0;
        data_in <= 1'b0;
        //ctrl <= 1'b1;
    end
    
    @(negedge clk)
    @(negedge clk)
    ctrl <= 1'b0;
    
    #20
   
    // Having issues with inout.
    //data_out <= 16'b1111110000000000;
    

    $finish;
 
end

endmodule
