`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 11:12:53
// Design Name: 
// Module Name: SPI_Slave
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

// Reference: https://www.fpga4fun.com/SPI2.html 
module SPI_Slave(
    // Internal clock that runs faster than SPI clk
    input FPGA_clk,
    input FPGA_rst,
    
    // SPI comms protocol
    input SCLK,
    input SSEL,
    input MOSI,
    output MISO,
    
    // Output to peripheral
    //output LED            // Test
    output [15:0] data_line,
    output [19:0] addr_line,
    
    output chip_en_out,
    output read_en_out,
    output write_en_out,
    output lb_en_out,
    output ub_en_out,
    
    output PTS_en_out,
    output [3:0] index,
    input PTS_ser_data_in
);

// Sync SCLK to the FPGA clock using a 3-bit shift register
reg [2:0] SCLKr;  
reg [2:0] SSELr; 
reg [1:0] MOSIr; 

// Detect SCLK rising and falling edge
wire SCLK_risingedge = (SCLKr[2:1]==2'b01);  // Rising edges
wire SCLK_fallingedge = (SCLKr[2:1]==2'b10);  // Falling edges

// Detect Slave Select rising and falling edge
wire SSEL_active = ~SSELr[1];  // SSEL is active low
wire SSEL_startmessage = (SSELr[2:1]==2'b10);  // message starts at falling edge
wire SSEL_endmessage = (SSELr[2:1]==2'b01);  // message stops at rising edge

// Detect MOSI data
wire MOSI_data = MOSIr[1];

// 3-bit counter to count no. of bits coming in or leaving the SPI peripheral
reg [2:0] bitcnt;

reg byte_received;              // high when a byte has been received
reg [7:0] byte_data_received;   // stores the data byte

// LSB of the data received is used to control an LED
//reg LED;

// Transmission of data byte
reg [7:0] byte_data_sent;   // reg to store data to be sent
reg [7:0] cnt;              // reg to count the data bits being sent

// States 
localparam IDLE = 0;
localparam READ_INFO = 1;   // Reads RWS, burst_len, and burst_en values
localparam READ_ADDR = 2;
localparam READ_DATA = 3;
localparam WRITE_MRAM = 4;
localparam READ_MRAM = 5;
localparam MRAM_DATA_OUTPUT = 6;

// Information to keep track of
reg [3:0] state = 0;
reg [2:0] read_write_sel;
reg [3:0] burst_len;
reg burst_en;
reg [19:0] addr_bits;
reg [15:0] data_bits;
reg chip_en = 1;
reg read_en = 1;
reg write_en = 1;
reg lb_en = 1;
reg ub_en = 1;

reg [3:0] cycle = 0;
reg PTS_en = 0;
reg [3:0] addr_burst_counter = 0;

always @(posedge FPGA_clk) begin
    if (FPGA_rst) begin
        // reset all signals if reset is called
        SCLKr <= 3'b111;
        SSELr <= 3'b111;
        MOSIr <= 0;
        byte_received <= 0;
        bitcnt <= 3'b000;
        byte_data_received <= 0;
        
        state <= IDLE;
        cycle <= 0;
        addr_burst_counter <= 1;
    end
    else begin
        // Using the FPGA clock, detect any rising or falling edge of the incoming SPI clk signal
        // The updated state is shifted from LSB to MSB
        SCLKr <= {SCLKr[1:0], SCLK};
        SSELr <= {SSELr[1:0], SSEL};
        MOSIr <= {MOSIr[0], MOSI};
        
        // On the rising edge of the SCLK, if bit count is 7 and SSEL is active, byte has been fully received from MOSI.
        byte_received <= SSEL_active && SCLK_risingedge && (bitcnt==3'b111);
        
        case (state)
            IDLE:   begin
                if(SSEL_active) begin
                    bitcnt <= 3'b000;  
                    state <= READ_INFO;
                end
                else begin
                    state <= IDLE;
                end

                chip_en <= 1;
                read_en <= 1;
                write_en <= 1;
                lb_en <= 1;
                ub_en <= 1;
                
                PTS_en <= 0;

            end
            
            READ_INFO:  begin
                if(SCLK_risingedge) begin
                    // On every rising edge of the SCLK, increment bit count by 1
                    bitcnt <= bitcnt + 3'b001;
                    
                    // implement a shift-left register (since we receive the data MSB first)
                    byte_data_received <= {byte_data_received[6:0], MOSI_data};
                end
                
                if(byte_received) begin
                    // When full byte is received, move data to their specified registers
                    burst_en <= byte_data_received[0];
                    burst_len <= byte_data_received[4:1];
                    read_write_sel <= byte_data_received[7:5];
                    
                    state <= READ_ADDR;
                    bitcnt <= 3'b000;
                end
                
                chip_en <= 1;
                read_en <= 1;
                write_en <= 1;
                lb_en <= 1;
                ub_en <= 1;
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
                            addr_bits[7:0] <= byte_data_received;
                        end
                        
                        4'd1:   begin
                            state <= READ_ADDR;
                            bitcnt <= 3'b000;
                            cycle <= cycle + 1;
                            addr_bits[15:8] <= byte_data_received;
                        end
                        
                        4'd2:   begin
                            bitcnt <= 3'b000;
                            cycle <= 0;
                            addr_bits[19:16] <= byte_data_received[3:0];
                            
                            if (read_write_sel[0]) begin
                                // Write operation
                                state <= READ_DATA;
                            end
                            else begin
                                // Read operation
                                state <= READ_MRAM;
                            end
                        end
                    endcase
                end
                
            end
        
            READ_DATA:  begin
                chip_en <= 1;
                read_en <= 1;
                write_en <= 1;
                lb_en <= 1;
                ub_en <= 1;
                
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
                            data_bits[7:0] <= byte_data_received;
                        end
                        
                        4'd1:   begin
                            state <= WRITE_MRAM;
                            bitcnt <= 3'b000;
                            cycle <= 0;
                            data_bits[15:8] <= byte_data_received;
                        end
                    endcase
                end         
            end
            
            WRITE_MRAM: begin
                chip_en <= 0;
                read_en <= 1;
                write_en <= 0;
                lb_en <= 0;
                ub_en <= 0;
                
                if ((addr_burst_counter < burst_len) && (burst_en) )begin
                    state <= READ_DATA;
                    addr_burst_counter <= addr_burst_counter + 1;
                end
                else begin
                    state <= IDLE;
                end
            end
            
            READ_MRAM: begin
                chip_en <= 0;
                read_en <= 0;
                write_en <= 1;
                lb_en <= 0;
                ub_en <= 0;
                
                PTS_en <= 1;
                bitcnt <= 3'b000;
                
                state <= MRAM_DATA_OUTPUT;
            end
            
            MRAM_DATA_OUTPUT:  begin
                chip_en <= 1;
                read_en <= 1;
                write_en <= 1;
                lb_en <= 1;
                ub_en <= 1;
                
                if(SCLK_risingedge) begin
                    bitcnt <= bitcnt + 3'b001;
                end
                
                if (bitcnt == 3'b111) begin
                    case (cycle)
                        4'd0:   begin
                            state <= READ_MRAM;
                            bitcnt <= 3'b000;
                            cycle <= cycle + 1;
                        end
                        
                        4'd1:   begin
                            bitcnt <= 3'b000;
                            cycle <= 0;
                            
                            if ((addr_burst_counter < burst_len) && (burst_en) )begin
                                state <= READ_MRAM;
                                addr_burst_counter <= addr_burst_counter + 1;
                            end
                            else begin
                                state <= IDLE;
                            end 
                        end
                    endcase 
                end

            end
            
        endcase
    end
end

//assign MISO = byte_data_sent[7];  // send MSB first

assign chip_en_out = chip_en;
assign read_en_out = read_en;
assign write_en_out = write_en;
assign lb_en_out = lb_en;
assign ub_en_out = ub_en;

// if read_en is 1, write operation. Data is written to data_line. 
// if read_en is 0, read operation. Data is coming in from MRAM. 
assign data_line = data_bits;     
assign addr_line = addr_bits + addr_burst_counter - 1;

assign index = (cycle*8) + (bitcnt);
assign PTS_en_out = PTS_en;
assign MISO = PTS_ser_data_in;

// Assume only 1 slave on SPI bus
endmodule
