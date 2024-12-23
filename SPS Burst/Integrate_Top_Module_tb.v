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

wire [15:0] data_to_MRAM;
reg [15:0] data_to_MRAM_drive;
wire [15:0] data_to_MRAM_recv;
wire [19:0] addr_to_MRAM;
assign data_to_MRAM = data_to_MRAM_drive;
assign data_to_MRAM_recv = data_to_MRAM;

wire chip_en;                 // Chip enable, active low
wire write_en;                // Write enable, active low
wire out_en;                  // Read enable, active low
wire lower_byte_en;           // Reading of bytes 7:0 enable line, active low
wire upper_byte_en;            // Reading of bytes 15:8 enable line, active low

wire PTS_ser_data_out;

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
    
    .data_to_MRAM(data_to_MRAM),
    .addr_to_MRAM(addr_to_MRAM),
    
    .chip_en(chip_en),                 // Chip enable, active low
    .write_en(write_en),                // Write enable, active low
    .out_en(out_en),                  // Read enable, active low
    .lower_byte_en(lower_byte_en),           // Reading of bytes 7:0 enable line, active low
    .upper_byte_en(upper_byte_en),            // Reading of bytes 15:8 enable line, active low
    
    .PTS_ser_data_out(PTS_ser_data_out)
);

always begin
    #5
    clk = ~clk;
end

initial begin
    // FULL BYTE WRITE
    data_to_MRAM_drive <= 'bz;
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
    
    // Full byte read
    @(posedge clk)
    rst <= 0;
    
    burst_en <= 0;
    mode_sel <= 0;
    read_write_sel <= 3'b110;
    
    data_to_MRAM_drive <= 16'b010;
    
     for (i = 0; i < 20; i = i+1) begin
        @(posedge clk)
        addr_in <= 0;
    end
    
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)

    // Stall for output
    @(posedge clk)
    for (i = 0; i < 23; i = i+1) begin
        @(posedge clk)
        addr_in <= 0;
    end
    
    @(posedge clk)
    rst <= 1;
    
    /*----------------------------------------------------------------------------------------------------------*/   
    // BURST WRITE
    @(posedge clk)
    rst <= 0;
    
    burst_en <= 1;
    mode_sel <= 1;
    read_write_sel <= 3'b111;
    
    data_to_MRAM_drive <= 'bz;
    
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
    $finish;

end


endmodule;
