`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2024 23:47:16
// Design Name: 
// Module Name: testbench_misc
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


module testbench_misc;

/*----------------------------------------------------------------------------------------------------------------------------
// single_reg testbench

localparam reg_width = 20;

reg clk;
reg rst;
reg wen;
reg [reg_width - 1:0] data_in;

wire [reg_width - 1:0] data_out;


single_reg #(.BUS_WIDTH(reg_width)) uut(
    .clk(clk),
    .rst(rst),
    
    .wen(wen),              // Write enable
    .data_in(data_in),
    
    .data_out(data_out)
);

always begin
    #5
    clk = ~clk;
end

initial begin
    clk <= 0;
    rst <= 0;
    wen <= 1;
    
    @(posedge clk)
    //rst <= 0;
    //wen <= 1;
    data_in <= 20'b1010_1010_1010_1010_1010;
    
    @(posedge clk) 
    wen <= 0;
    
    @(posedge clk)
    
    $finish;
end

----------------------------------------------------------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------------------------------------------------------
// counter testbench

reg clk;
reg rst;
reg en;

wire [3:0] counter_out;

integer i = 0;

counter #(.COUNTER_WIDTH(4)) uut
(
    .clk(clk),
    .rst(rst),
    
    .en(en),
    
    .counter_out(counter_out)
);

always begin
    #5
    clk = ~clk;
end


initial begin
    clk <= 0;
    rst <= 1;
    en <= 0;
    
    @(posedge clk)
    rst <= 0;
    en <= 1;
    
    for (i = 0; i < 15; i = i + 1) begin
        @(posedge clk)
        rst <= 0;
        en <= 1;
    end
    
    $finish;
   
end

----------------------------------------------------------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------------------------------------------------------
// compare testbench

reg clk;
reg rst;
reg [3:0] burst_len;
reg [3:0] counter;

wire stop_signal;

compare #(.COUNTER_WIDTH(4)) compare
(
    .clk(clk),
    .rst(rst),
    
    .burst_len(burst_len),
    .counter(counter),
    
    .stop_signal(stop_signal)
);

always begin
    #5
    clk = ~clk;
end

initial begin 
    clk <= 0;
    rst <= 1;
    
    @(posedge clk)
    rst <= 0;
    burst_len <= 4'b0001;
    counter <= 4'b1000;
    
    @(posedge clk)
    burst_len <= 4'b1111;
    counter <= 4'b1111;
    
    @(posedge clk)
    burst_len <= 4'b0001;
    counter <= 4'b1000;
    
    @(posedge clk)
    
    $finish;

end
----------------------------------------------------------------------------------------------------------------------------*/

// adder testbench
reg clk;
reg rst;

reg en;
reg [19:0] addr;
reg [3:0] counter;

wire [19:0] burst_addr;

Adder #(.ADDR_WIDTH(20), .COUNTER_WIDTH(4)) adder
(
    .clk(clk),
    .rst(rst),
    
    .en(en),
    .initial_addr(addr),
    .counter(counter),
    
    .burst_addr(burst_addr)
);

always begin
    #5
    clk = ~clk;
end

initial begin 
    clk <= 0;
    rst <= 1;
    en <= 0;
    
    @(posedge clk)
    rst <= 0;
    en <= 1;
    addr <= 20'b0000_0000_0000_0000_0000;
    counter <= 4'b0001;
    
    @(posedge clk)
    @(posedge clk)
    
    $finish;

end


endmodule
