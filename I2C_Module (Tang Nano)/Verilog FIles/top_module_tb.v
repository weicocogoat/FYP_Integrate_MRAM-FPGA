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

reg FPGA_clk = 1;
reg FPGA_rst = 1;

reg sda = 1;
reg scl = 1;
wire sda_output;

wire [19:0] write_addr;
wire [15:0] write_data;

// Comment out the following to see write operation. 
// Leave the following in to see read operation
reg [15:0] write_data_drive;
wire [15:0] write_data_recv;
assign write_data = write_data_drive;
assign write_data_recv = write_data;

wire chip_en;
wire read_en;
wire write_en;
wire lb_en;
wire ub_en;

integer i;
integer j; 

top_module I2C_module
(
    .FPGA_clk(FPGA_clk),
    .FPGA_rst(FPGA_rst),

    .sda(sda),
    .scl(scl),
    .sda_output(sda_output),
    
    .write_data(write_data),
    .write_addr(write_addr),
    
    .chip_en(chip_en), 
    .read_en(read_en),
    .write_en(write_en),
    .lb_en(lb_en),
    .ub_en(ub_en)
);

// FPGA clock will run 5x faster than SCL from master
always begin
    #1
    FPGA_clk <= ~FPGA_clk;
end

always begin
    #10
    scl <= ~scl;
end

initial begin
    #1
    // Start the module
    FPGA_rst <= 0;
    #2

    // Pull SDA low to start I2C comms
    sda <= 0;       
    
/*-------------------------------------------SINGLE BYTE WRITE-------------------------------------------*/
/*
    // Pull SDA low to start I2C comms
    sda <= 0;   
    
    // Send Slave addr and RWS
    for (i = 0; i < 7; i = i+1) begin
        @(posedge scl)
        sda <= 1;
    end
    
    // Write operation
    @(posedge scl)
    sda <= 1;
    
    // ACK signal
    @(posedge scl)
    
    
    // Input addr and burst len
    for (j = 0; j < 3; j = j+1) begin
        for (i = 0; i < 8; i = i+1) begin
            @(posedge scl)
            sda <= 0;
        end
        
        // Ack
        @(posedge scl)
        sda <= 0;
    end
    
    
    // Input data bits
    for (j = 0; j < 2; j = j+1) begin
        for (i = 0; i < 8; i = i+1) begin
            @(posedge scl)
            sda <= i%2;
        end
        
        // Ack
        @(posedge scl)
        sda <= 0;
    end
    
    @(posedge scl)
    #1
    sda <= 1;
    
    @(posedge scl)
    @(posedge scl)
*/
/*-------------------------------------------------------------------------------------------------------*/

/*-------------------------------------------SINGLE BYTE READ--------------------------------------------*/
    /*
    // Pull SDA low to start I2C comms
    sda <= 0;    
    
    // Send Slave addr and RWS
    for (i = 0; i < 7; i = i+1) begin
        @(posedge scl)
        sda <= 1;
    end
    
    // Read operation
    @(posedge scl)
    sda <= 0;
    
    // ACK signal
    @(posedge scl)
    
    // Input addr and burst len
    for (j = 0; j < 3; j = j+1) begin
        for (i = 0; i < 8; i = i+1) begin
            @(posedge scl)
            sda <= 0;
        end
        
        // Ack
        @(posedge scl)
        sda <= 0;
    end
    
    write_data_drive <= 16'b0101_0101_0101_0101_0101;
    
    // Wait for data bits
    for (j = 0; j < 2; j = j+1) begin
        for (i = 0; i < 8; i = i+1) begin
            @(posedge scl)
            sda <= i%2;
        end
        
        // Ack
        @(posedge scl)
        sda <= 0;
    end
    
    @(posedge scl)
    #1
    sda <= 1;
    
    @(posedge scl)
    @(posedge scl)
*/

/*-------------------------------------------------------------------------------------------------------*/

/*----------------------------------------Burst write of length 3----------------------------------------*/

    // Pull SDA low to start I2C comms
    sda <= 0;   
    
    // Send Slave addr and RWS
    for (i = 0; i < 7; i = i+1) begin
        @(posedge scl)
        sda <= 1;
    end
    
    // Write operation
    @(posedge scl)
    sda <= 1;
    
    // ACK signal
    @(posedge scl)
    
    // Input addr and burst len
    for (j = 0; j < 2; j = j+1) begin
        for (i = 0; i < 8; i = i+1) begin
            @(posedge scl)
            sda <= 0;
        end
        
        // Ack
        @(posedge scl)
        sda <= 0;
    end
    
    // Burst len of 3
    for (i = 0; i < 2; i = i+1) begin
        @(posedge scl)
        sda <= 0;
    end
    
    for (i = 0; i < 2; i = i+1) begin
        @(posedge scl)
        sda <= 1;
    end
    
    // Remaining 4 bits of addr
    for (i = 0; i < 4; i = i+1) begin
        @(posedge scl)
        sda <= 0;
    end
    
    // ACK signal
    @(posedge scl)
    
    // Data 1
    for (j = 0; j < 2; j = j+1) begin
        for (i = 0; i < 8; i = i+1) begin
            @(posedge scl)
            sda <= i%2;
        end
        
        // Ack
        @(posedge scl)
        sda <= 0;
    end
    
    // Data 2
    for (j = 0; j < 2; j = j+1) begin
        for (i = 0; i < 8; i = i+1) begin
            @(posedge scl)
            sda <= 1;
        end
        
        // Ack
        @(posedge scl)
        sda <= 0;
    end
    
    // Data 3
    for (j = 0; j < 2; j = j+1) begin
        for (i = 0; i < 8; i = i+1) begin
            @(posedge scl)
            sda <= 0;
        end
        
        // Ack
        @(posedge scl)
        sda <= 0;
    end
    
    @(posedge scl)
    #1
    sda <= 1;
    
    @(posedge scl)
    @(posedge scl)
    

/*-------------------------------------------------------------------------------------------------------*/

/*----------------------------------------Burst read of length 3-----------------------------------------*/

    // Pull SDA low to start I2C comms
    sda <= 0;   
    
    // Send Slave addr and RWS
    for (i = 0; i < 7; i = i+1) begin
        @(posedge scl)
        sda <= 1;
    end
    
    // Write operation
    @(posedge scl)
    sda <= 0;
    
    // ACK signal
    @(posedge scl)
    
    // Input addr and burst len
    for (j = 0; j < 2; j = j+1) begin
        for (i = 0; i < 8; i = i+1) begin
            @(posedge scl)
            sda <= 0;
        end
        
        // Ack
        @(posedge scl)
        sda <= 0;
    end
    
    // Burst len of 3
    for (i = 0; i < 2; i = i+1) begin
        @(posedge scl)
        sda <= 0;
    end
    
    for (i = 0; i < 2; i = i+1) begin
        @(posedge scl)
        sda <= 1;
    end
    
    // Remaining 4 bits of addr
    for (i = 0; i < 4; i = i+1) begin
        @(posedge scl)
        sda <= 0;
    end
    
    // ACK signal
    @(posedge scl)
    
    // Data 1
    write_data_drive <= 16'b0101_0101_0101_0101_0101;
    for (j = 0; j < 2; j = j+1) begin
        for (i = 0; i < 8; i = i+1) begin
            @(posedge scl)
            sda <= i%2;
        end
        
        // Ack
        @(posedge scl)
        sda <= 0;
    end
    
    // Data 2
    write_data_drive <= 16'b1111_1111_1111_1111_1111;
    for (j = 0; j < 2; j = j+1) begin
        for (i = 0; i < 8; i = i+1) begin
            @(posedge scl)
            sda <= 1;
        end
        
        // Ack
        @(posedge scl)
        sda <= 0;
    end
    
    // Data 3
    write_data_drive <= 16'b0000_0000_0000_0000_0000;
    for (j = 0; j < 2; j = j+1) begin
        for (i = 0; i < 8; i = i+1) begin
            @(posedge scl)
            sda <= 0;
        end
        
        // Ack
        @(posedge scl)
        sda <= 0;
    end
    
    @(posedge scl)
    #1
    sda <= 1;
    
    @(posedge scl)
    @(posedge scl)
    

/*-------------------------------------------------------------------------------------------------------*/
    $finish;
end


endmodule