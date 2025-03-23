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
reg [2:0] read_write_sel;                          

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
    
    //.parallel_data_in(parallel_data_in),
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
    
    #10
    
    // Testing of Write operation starts here 
 /*-----------------------------------------------------------------------------------------------------------------*/
    /* FULL BYTE WRITE*/
  
    // Assert the read_write_sel line(write operation) 1 cycle before serial input goes into the STP modules
    #5
    rst <= 1'b0;
    read_write_sel <= 3'b111;
    
    // At the negative edge of the clock, change the signal being fed into the UUT. 
    // Addr and data are fed in from LSB to MSB
    @(posedge clk)      // Stall 2 cycle
    @(posedge clk)
    
    // For the next 20 cycles, addr will be set to 0, data will be "01" repeated
    for (i = 0; i < 20; i= i+1) begin
        @(posedge clk);
        rst <= 1'b0;
        read_write_sel <= 3'b111;
        addr_in <= 1'b0;
        data_in <= i%2;
    end
    
    // Enable reset and to stop all modules
    @(posedge clk)      // Stall
    @(posedge clk)      // Stall
    rst <= 1'b1;
    
 /*--------------------------------------------------------------------------------------------------------------*/
    /* LOWER BYTE WRITE*/
    @(posedge clk)
    rst <= 1'b0;
    @(posedge clk)      // Stall
    @(posedge clk)      // Stall
    
    read_write_sel <= 3'b011;
    
    addr_in <= 1'b1;
    data_in <= 1'b0;
    
    for (i = 0; i < 19; i= i+1) begin
        @(posedge clk);
        rst <= 1'b0;
        read_write_sel <= 3'b011;
        addr_in <= 1'b0;
        data_in <= i%2 + 1;
    end
    
    @(posedge clk)  //21
    @(posedge clk)  //22
    
    rst <= 1'b1;
 /*--------------------------------------------------------------------------------------------------------------*/
    /*UPPER BYTE WRITE*/
    @(posedge clk)  
    rst <= 1'b0;
    @(posedge clk)      // Stall
    @(posedge clk)      // Stall
    
    read_write_sel <= 3'b101;
    addr_in <= 1'b0;
    data_in <= 1'b1;
    
    @(posedge clk)
    read_write_sel <= 3'b101;
    addr_in <= 1'b1;
    data_in <= 1'b1;
    
    for (i = 0; i < 18; i= i+1) begin
        @(posedge clk);
        rst <= 1'b0;
        read_write_sel <= 3'b101;
        addr_in <= 1'b0;
        data_in <= i%2;
    end
    
    @(posedge clk)
    @(posedge clk)
    rst <= 1'b1;
    
  /*--------------------------------------------------------------------------------------------------------------*/   
    // Testing of Write operation ends here
 
   /*--------------------------------------------------------------------------------------------------------------*/
   /* FULL BYTE READ*/
      
    // Set the read_write_sel line to 0(read operation) 1 cycle before serial input goes into the STP modules
    @(posedge clk)    
    rst <= 1'b0;
    @(posedge clk)      // Stall
    @(posedge clk)      // Stall
    
    // Testing of Read operation starts here
    // Outputs from MSB to LSB
    for (i = 0; i < 20; i = i+1) begin
        @(posedge clk)
        rst <= 1'b0;
        read_write_sel <= 3'b110;
        //read_write_sel <= 3'b010;
        //read_write_sel <= 3'b100;
        addr_in <= 1'b0;
    end
    
    /* LOWER BYTE READ*/
    // Stall for until loop starts
    @(posedge clk)
    @(posedge clk)
    @(posedge clk)
    read_write_sel <= 3'b010;
    addr_in <= 1'b1;
    
    for (i = 0; i<19; i = i+1) begin
        @(posedge clk)
        addr_in <= 1'b0;
    end
    
    /* UPPER BYTE READ*/
    @(posedge clk)     
    @(posedge clk)      
    @(posedge clk)
    @(posedge clk)
    read_write_sel <= 3'b100;
    addr_in <= 1'b0;
    
    @(posedge clk)
    addr_in <= 1'b1;
    
    for (i = 0; i<18; i = i+1) begin
        @(posedge clk)
        addr_in <= 1'b0;
    end

    //Stall to see the output
    @(posedge clk)
    for (i = 0; i<20; i = i+1) begin
        @(posedge clk)
        rst <= 0;
    end


    $finish;
 
end

endmodule