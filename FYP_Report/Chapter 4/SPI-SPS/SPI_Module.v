`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2025 23:47:34
// Design Name: 
// Module Name: SPI_Module
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


module SPI_Module(
    input FPGA_clk,
    input FPGA_rst,
    input SCLK,
    input SSEL,
    input MOSI,
    
    output MISO,
    
    input PTS_ser_data_out,
    output SPS_clk_out,
    output SPS_rst_out,
    output burst_en_out,
    output mode_sel_out,
    output burst_len_out,
    output addr_out,
    output data_out,
    output [2:0] rws_out
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
reg [7:0] bitcnt;

reg byte_received;  // high when a byte has been received
reg [7:0] byte_data_received;

// we use the LSB of the data received to control an LED
//reg LED;

reg [7:0] byte_data_sent = 0;

reg [7:0] cnt;

// States 
reg [3:0] state = 0;
localparam IDLE = 0;
localparam READ_INFO = 1;   // Reads RWS, burst_len, and burst_en values
localparam READ_ADDR = 2;   // Reads base addr
localparam READ_DATA = 3;   // Reads data bits used for write operation
localparam WRITE_TO_SPS = 4;

reg msg_valid_detection = 0;
reg [3:0]cycle = 0;
reg [3:0] addr_burst_counter = 1;

// Reg to store values
reg SPS_clk = 0;
reg SPS_rst = 1;
reg burst_en = 0;
reg mode_sel = 0;
reg[3:0] burst_len = 0;
reg [19:0] addr_reg = 0;
reg [15:0] data_reg = 0;
reg [2:0] rws = 0;

always @(posedge FPGA_clk) begin
    if (FPGA_rst) begin
        SCLKr <= 3'b111;
        SSELr <= 3'b111;
        MOSIr <= 0;
        byte_received <= 0;
        bitcnt <= 3'b000;
        byte_data_received <= 0;

        state <= 0;
        msg_valid_detection = 0;
        
        SPS_clk <= 0;
        SPS_rst <= 1;
        burst_en <= 0;
        mode_sel <= 0;
        burst_len <= 0;
        addr_reg <= 0;
        data_reg <= 0;
        rws <= 0;
    end
    else begin
        SCLKr <= {SCLKr[1:0], SCLK};
        SSELr <= {SSELr[1:0], SSEL};
        MOSIr <= {MOSIr[0], MOSI};
        
        byte_received <= SSEL_active && SCLK_risingedge && (bitcnt==3'b111);

        // Ensure that only one SPI msg gets read
        if (SSEL_startmessage) begin
            msg_valid_detection <= 1;
        end

        case (state)
            IDLE:   begin
                if(SSEL_active && msg_valid_detection) begin
                    bitcnt <= 3'b000;  
                    state <= READ_INFO;
                end
                else begin
                    state <= IDLE;
                end
            end
            
             READ_INFO:  begin
                if(SCLK_risingedge) begin
                    // On every rising edge of the SCLK, increment bit count by 1
                    bitcnt <= bitcnt + 3'b001;
                    
                    // implement a shift-left register (since we receive the data MSB first)
                    byte_data_received <= {byte_data_received[6:0], MOSI_data};
                end
                
                if(byte_received) begin
                    state <= READ_ADDR;
                    bitcnt <= 3'b000;
                    
                    burst_en <= byte_data_received[0];
                    mode_sel <= byte_data_received[0];
                    burst_len <= byte_data_received[4:1];
                    rws <= byte_data_received[7:5];
                end
            end
           
            READ_ADDR:  begin
                if(SCLK_risingedge) begin
                    bitcnt <= bitcnt + 3'b001;
                    byte_data_received <= {byte_data_received[6:0], MOSI_data};
                end
                
                if(byte_received) begin
                    case (cycle)
                        4'd0:   begin
                            state <= READ_ADDR;
                            bitcnt <= 3'b000;
                            cycle <= cycle + 1;
                            addr_reg[7:0] <= byte_data_received;
                        end
                        
                        4'd1:   begin
                            state <= READ_ADDR;
                            bitcnt <= 3'b000;
                            cycle <= cycle + 1;
                            addr_reg[15:8] <= byte_data_received;
                        end
                        
                        4'd2:   begin
                            bitcnt <= 3'b000;
                            cycle <= 0;
                            addr_reg[19:16] <= byte_data_received[3:0];

                            if (rws[0] == 1'b1) begin
                                // Write operation
                                state <= READ_DATA;
                            end
                            else begin
                                state <= WRITE_TO_SPS;
                                
                                SPS_rst <= 0;
                            end
                        end
                    endcase
                end
                end
                
                 READ_DATA:  begin                    
                    if(SCLK_risingedge) begin
                        bitcnt <= bitcnt + 3'b001;
                        byte_data_received <= {byte_data_received[6:0], MOSI_data};
                    end
                    
                    if (byte_received) begin
                        case (cycle)
                            4'd0:   begin
                                state <= READ_DATA;
                                bitcnt <= 3'b000;
                                cycle <= cycle + 1;
                                data_reg[7:0] <= byte_data_received;
                            end
                            
                            4'd1:   begin
                                state <= WRITE_TO_SPS; 
                                bitcnt <= 3'b000;
                                cycle <= 0;
                                data_reg[15:8] <= byte_data_received;
                                
                                SPS_rst <= 0;
                            end
                        endcase  
                    end         
                end
                
                WRITE_TO_SPS: begin
                    if(SCLK_risingedge) begin
                        SPS_clk <= 1;
                        bitcnt <= bitcnt + 3'b001;
                    end
                    
                    if(SCLK_fallingedge) begin
                        SPS_clk <= 0;
                    end
                    
                    if (bitcnt == 23) begin
                        if (rws[0] == 1) begin
                            // Write operation
                            state <= IDLE;
                            msg_valid_detection <= 1;
                            bitcnt <= 0;
                        end
                    end
                    else if (bitcnt == 46) begin
                        // Read operation
                        state <= IDLE;
                        msg_valid_detection <= 1;
                        bitcnt <= 0;
                    end
                
                end
            
          endcase
    end
end

//assign MISO = byte_data_sent[7];  // send MSB first
// we assume that there is only one slave on the SPI bus
// so we don't bother with a tri-state buffer for MISO
// otherwise we would need to tri-state MISO when SSEL is inactive

assign MISO = PTS_ser_data_out;
assign SPS_clk_out = SPS_clk;
assign SPS_rst_out = SPS_rst;
assign burst_en_out = burst_en;
assign mode_sel_out = mode_sel;
assign burst_len_out = burst_len[bitcnt - 2];
assign addr_out = addr_reg[bitcnt - 2];
assign data_out = data_reg[bitcnt - 2];
assign rws_out = rws;

endmodule