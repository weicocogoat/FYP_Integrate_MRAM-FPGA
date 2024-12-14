`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2024 01:19:57
// Design Name: 
// Module Name: top_module_tb
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


module top_module_tb;

reg sda = 1;
reg scl = 1;

top_module uut
(
    .sda(sda),
    .scl(scl)
);

integer i, j;
reg foo;

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
    
    /*
    // Read operation
    @(negedge scl)
    sda <= 0;
    #1 
    sda <= 0;
    */
    
    
    // Write operation
    @(negedge scl)
    sda <= 1;
    #1 
    
   
    // ack signal from master
    @(negedge scl)
    sda <= 1;
    #1 
    sda <= 1;
    
    
    // Input addr and burst len
    // First 16 bits of addr
    for (j = 0; j < 2; j = j+1) begin
        for (i = 0; i < 8; i = i+1) begin
            @(negedge scl)
            sda <= 0;
            #1 
            sda <= 0;
        end
        
        // ack signal from master
        @(negedge scl)
        sda <= 0;
        #1 
        sda <= 0;
    end
    
    // Burst len of 2 - b'0010
    @(negedge scl)
    sda <= 0;
    #1 
    sda <= 0;
    
    @(negedge scl)
    sda <= 0;
    #1 
    sda <= 0;
    
    @(negedge scl)
    sda <= 1;
    #1 
    sda <= 1;
    
    @(negedge scl)
    sda <= 0;
    #1 
    sda <= 0;
    
    // Remaining 4 bits of addr
    for (i = 0; i < 4; i = i+1) begin
        @(negedge scl)
        sda <= 0;
        #1 
        sda <= 0;
    end
    
    // ack signal from master
    @(negedge scl)
    sda <= 1;
    #1 
    sda <= 1;
     
    
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
    
    // Input 
    for (j = 0; j < 2; j = j+1) begin
        for (i = 0; i < 8; i = i+1) begin
            @(negedge scl)
            sda <= i%2 + 1;
            #1 
            sda <= i%2 + 1;
        end
        
        @(negedge scl)
        #1 
        sda <= sda;
    end
    
    // Wait for data to be fully written to MRAM first
    @(negedge scl)
    
    // Pull up SDA when scl is high and stop I2C comms
    @(posedge scl)
    #1
    sda <= 1;
    #1
/*------------------------------------End of I2C Burst Write------------------------------------------------------------------------*/    
    
    // Start a new I2C comms
    @(posedge scl)
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

    // Read operation
    @(negedge scl)
    sda <= 0;
    #1 
    sda <= 0;
    
    // ack signal from master
    @(negedge scl)
    sda <= 1;
    #1 
    sda <= 1;
    
    
    // Input addr and burst len
    // First 16 bits of addr
    for (j = 0; j < 2; j = j+1) begin
        for (i = 0; i < 8; i = i+1) begin
            @(negedge scl)
            sda <= 0;
            #1 
            sda <= 0;
        end
        
        // ack signal from master
        @(negedge scl)
        sda <= 0;
        #1 
        sda <= 0;
    end
    
    // Burst len of 2 - b'0010
    @(negedge scl)
    sda <= 0;
    #1 
    sda <= 0;
    
    @(negedge scl)
    sda <= 0;
    #1 
    sda <= 0;
    
    @(negedge scl)
    sda <= 1;
    #1 
    sda <= 1;
    
    @(negedge scl)
    sda <= 0;
    #1 
    sda <= 0;
    
    // Remaining 4 bits of addr
    for (i = 0; i < 4; i = i+1) begin
        @(negedge scl)
        sda <= 0;
        #1 
        sda <= 0;
    end
    
    // ack signal from master
    @(negedge scl)
    sda <= 1;
    #1 
    sda <= 1;
    
    #500
    
    $finish;
    
end

endmodule
