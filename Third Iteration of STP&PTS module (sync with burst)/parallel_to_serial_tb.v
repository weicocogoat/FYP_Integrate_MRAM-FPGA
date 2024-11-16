`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.09.2024 02:47:51
// Design Name: 
// Module Name: parallel_to_serial_tb
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


module parallel_to_serial_tb;
reg clk;
reg rst;
reg load;                     // When data is ready to be read, this signal will be asserted and data will be loaded into an internal register
reg send_data;                // Send the data serially

reg [15:0] data_in;           // Data from MRAM

wire data_out;
wire end_of_transmission;

parallel_to_serial uut(
    .clk(clk),
    .rst(rst),
    .load(load),
    .send_data(send_data),
    .data_in(data_in),
    .data_out(data_out),
    .end_of_transmission(end_of_transmission)
);

always begin
    #5
    clk <= ~clk;
end

initial 
begin
    clk <= 1'b0;
    rst <= 1'b1;
    
    #10
    
    @(negedge clk)
    rst <= 1'b0;
    load <= 1'b1;
    send_data <= 1'b0;
    data_in <= 16'b0101_0101_0101_0101;          // Load data into the parallel to serial converter
    
    @(negedge clk)
    load <= 1'b0;
    send_data <= 1'b1;
    
    #200

    $finish;


end



endmodule
