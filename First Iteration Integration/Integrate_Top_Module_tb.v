`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2024 02:51:34
// Design Name: 
// Module Name: Integrate_Top_Module_tb
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


module Integrate_Top_Module_tb;

reg clk = 0;
reg rst = 1;

reg burst_en;
reg mode_sel;

reg burst_len_in;

reg addr_in;

reg data_in;
reg [2:0] read_write_sel;

wire ser_data_out;

integer i;

Integrate_Top_Module uut
(
    .clk(clk),
    .rst(rst),
    
    .burst_en(burst_en),
    .mode_sel(mode_sel),
    
    .burst_len_in(burst_len_in),
    
    .addr_in(addr_in),
    
    .data_in(data_in),
    .read_write_sel(read_write_sel),
    
    .ser_data_out(ser_data_out)
);

always begin
    #5
    clk = ~clk;
end

initial begin

/*----------------------------------------------------------------------------------------------------------*/
    /*SINGLE TRANSFER WRITE*/
    
    // FULL BYTE WRITE
    @(posedge clk)
    rst <= 1'b0;
    
    burst_en <= 0;
    mode_sel <= 0;
    
    read_write_sel <= 3'b111;
    
    for (i = 0; i < 20; i = i+1) begin
        @(posedge clk)
        data_in <= i%2;
        addr_in <= 0;
    end
    
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    rst <= 1;
    
    // LOWER BYTE WRITE
    @(posedge clk)
    rst <= 0;
    
    burst_en <= 0;
    mode_sel <= 0;
    read_write_sel <= 3'b011;
    
    @(posedge clk)      // Stall cycle 0
    data_in <= 0;
    addr_in <= 1;
    
    for (i = 0; i < 19; i = i+1) begin
        @(posedge clk)
        data_in <= i%2 + 1;
        addr_in <= 0;
    end
    
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    rst <= 1;
    
    // UPPER BYTE WRITE
    @(posedge clk)
    rst <= 0;
    
    burst_en <= 0;
    mode_sel <= 0;
    read_write_sel <= 3'b101;
    
    @(posedge clk)      // Stall cycle 0
    data_in <= 0;
    addr_in <= 0;
    
    @(posedge clk)
    data_in <= 1;
    addr_in <= 1;
    
    for (i = 0; i < 18; i = i+1) begin
        @(posedge clk)
        data_in <= i%2;
        addr_in <= 0;
    end
    
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    rst <= 1;

  /*----------------------------------------------------------------------------------------------------------*/   
    // BURST WRITE
    @(posedge clk)
    rst <= 0;
    
    burst_en <= 1;
    mode_sel <= 1;
    read_write_sel <= 3'b111;
    
    // Write AAAA to addr 0
    @(posedge clk)
    burst_len_in <= 1;
    addr_in <= 0;
    data_in <= 1;
    
    @(posedge clk)
    burst_len_in <= 1;
    addr_in <= 0;
    data_in <= 0;
    
    for (i = 0; i < 18; i = i+1) begin
        @(posedge clk)
        data_in <= i%2 + 1;
        addr_in <= 0;
        burst_len_in <= 0;
    end
    
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    
    // Write FFFF to addr 1
    for (i = 0; i < 20; i = i+1) begin
        @(posedge clk)
        data_in <= 1;
    end
    
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    
    // Write 2 to addr 2
    @(posedge clk)
    data_in <= 0;
    
    @(posedge clk)
    data_in <= 1;
    
    for (i = 0; i < 18; i = i+1) begin
        @(posedge clk)
        data_in <= 0;
    end

    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    rst <= 1;
    
  /*----------------------------------------------------------------------------------------------------------*/   
    // BURST READ
    @(posedge clk)
    rst <= 0;
    
    burst_en <= 1;
    mode_sel <= 1;
    read_write_sel <= 3'b110;
    
    @(posedge clk)
    burst_len_in <= 1;
    addr_in <= 0;
    
    @(posedge clk)
    burst_len_in <= 1;
    addr_in <= 0;
    
    for (i = 0; i < 18; i = i+1) begin
        @(posedge clk)
        addr_in <= 0;
        burst_len_in <= 0;
    end
    
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)


    // Stall to see output
    @(posedge clk)
    for (i = 0; i < 69; i = i+1) begin
        @(posedge clk)
        addr_in <= 0;
    end
    
    
    $finish;

end


endmodule;
