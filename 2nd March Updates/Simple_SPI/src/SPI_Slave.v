`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.02.2025 16:59:57
// Design Name: 
// Module Name: SPI_slave
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


module SPI_slave(
    input FPGA_clk,
    input FPGA_rst,
    input SCLK,
    input SSEL,
    input MOSI,
    
    output MISO,
    output reg LED
);

// CPOL 1 -> Active low, Idle high
// CPHA 1 -> Sampled on trialing edge, rising edge

// sync SCK to the FPGA clock using a 3-bit shift register
reg [2:0] SCLKr;
wire SCLK_risingedge = (SCLKr[2:1]==2'b01);  // now we can detect SCK rising edges
wire SCLK_fallingedge = (SCLKr[2:1]==2'b10);  // and falling edges

// same thing for SSEL
reg [2:0] SSELr;
wire SSEL_active = ~SSELr[1];  // SSEL is active low
wire SSEL_startmessage = (SSELr[2:1]==2'b10);  // message starts at falling edge
wire SSEL_endmessage = (SSELr[2:1]==2'b01);  // message stops at rising edge

// and for MOSI
reg [1:0] MOSIr;
wire MOSI_data = MOSIr[1];

// we handle SPI in 8-bit format, so we need a 3 bits counter to count the bits as they come in
reg [2:0] bitcnt;

reg byte_received;  // high when a byte has been received
reg [7:0] byte_data_received;

// we use the LSB of the data received to control an LED
//reg LED;

reg [7:0] byte_data_sent = 0;

reg [7:0] cnt;

always @(posedge FPGA_clk) begin
    if (FPGA_rst) begin
        SCLKr <= 3'b111;
        SSELr <= 3'b111;
        MOSIr <= 0;
        byte_received <= 0;
        bitcnt <= 3'b000;
        byte_data_received <= 0;
    end
    else begin
        SCLKr <= {SCLKr[1:0], SCLK};
        SSELr <= {SSELr[1:0], SSEL};
        MOSIr <= {MOSIr[0], MOSI};
        
        byte_received <= SSEL_active && SCLK_risingedge && (bitcnt==3'b111);
        
        if(~SSEL_active) begin
            bitcnt <= 3'b000;
        end
        else if(SCLK_risingedge) begin
            bitcnt <= bitcnt + 3'b001;

            // implement a shift-left register (since we receive the data MSB first)
            byte_data_received <= {byte_data_received[6:0], MOSI_data};
        end 
        
        if(byte_received) begin
            LED <= byte_data_received[0];
        end
    end
end

//assign MISO = byte_data_sent[7];  // send MSB first
// we assume that there is only one slave on the SPI bus
// so we don't bother with a tri-state buffer for MISO
// otherwise we would need to tri-state MISO when SSEL is inactive

endmodule
