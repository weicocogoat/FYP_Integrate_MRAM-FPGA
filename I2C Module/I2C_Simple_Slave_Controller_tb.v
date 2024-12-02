`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.12.2024 01:48:27
// Design Name: 
// Module Name: I2C_Simple_Slave_Controller_tb
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


module I2C_Simple_Slave_Controller_tb;

reg sda;
reg scl = 1;

wire burst_en;
wire [3:0] burst_len_out;
wire [15:0] write_data;
wire [19:0] write_addr;
wire read_signal;
wire write_signal;
wire [15:0] data_from_MRAM;

integer i, j;
reg foo;

I2C_Simple_Slave_Controller uut(
    // I2C signal
    .sda(sda),
    .scl(scl),
    
    // Outputs to other modules and MRAM
    .burst_en(burst_en),
    .burst_len_out(burst_len_out),
    
    .write_data(write_data),
    .write_addr(write_addr),
    .read_signal(read_signal),
    .write_signal(write_signal),
    
    .data_from_MRAM(data_from_MRAM)
);

always begin
    #5
    scl = ~scl;
end

initial begin
    // When SCL is high, pull SDA Low
    sda <= 1;
    #1
    sda <= 0;
    #1      // For some reason, this must be included or else I2C fails for some reason

    // Input slave address and read_write sel
    for (i = 0; i < 7; i = i+1) begin
        @(negedge scl)
        sda <= 1;
        #1 
        sda <= 1;
    end
    
    // Write
    @(negedge scl)
    sda <= 1;
    #1 
    
    /*
    // read
    @(negedge scl)
    sda <= 0;
    #1 
    */
    
    // Input addr and burst len
    for (j = 0; j < 3; j = j+1) begin
        for (i = 0; i < 8; i = i+1) begin
            @(negedge scl)
            sda <= 1;
            #1 
            sda <= 1;
        end
        
        @(negedge scl)
        sda <= 1;
        #1 
        sda <= 1;
        
    end
    
    // Input 
    for (j = 0; j < 2; j = j+1) begin
        for (i = 0; i < 8; i = i+1) begin
            @(negedge scl)
            sda <= i%2;
            #1 
            sda <= i%2;
        end
        
        @(negedge scl)
        #1 
        sda <= sda + 1;
    end
    
    #500
    
    $finish;
    
end

endmodule
