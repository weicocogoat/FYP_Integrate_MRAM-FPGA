`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2024 00:20:36
// Design Name: 
// Module Name: i2c_simple_slave_controller_tb
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


module i2c_simple_slave_controller_tb;
reg rst = 0;

//wire sda1;
//wire sda2;
reg sda1;
reg sda2;
reg sda3;
reg scl = 1;


i2c_simple_slave_controller slave(
    .sda1(sda1), 
    .sda2(sda2),
    .sda3(sda3),
    .scl(scl)
);

always begin
    #5
    scl = ~scl;
end


initial begin
    // When SCL is high, pull SDA1 Low
    sda1 <= 1;
    sda2 <= 1;
    sda3 <= 0;
    #1
    
    @(negedge scl)
    sda3 <= 1;
    #1

    #200
    
    $finish;
    
end
    
    
    
    

endmodule
