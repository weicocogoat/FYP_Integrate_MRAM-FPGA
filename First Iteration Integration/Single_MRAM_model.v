module MRAM_model #(
    parameter ADDR_WIDTH = 20, // 20 bits address width
    parameter DATA_WIDTH = 16  // 16 bits data width
) (
    clk,
    e_chipEnable_n,
    g_outputEnable_n,
    w_writeEnable_n,
    lb_lowerByteEnable_n,
    ub_upperByteEnable_n,

    address,
    dqi_datainput,
    dqo_dataoutput
);

localparam MEM_NUMBER = 2**ADDR_WIDTH;

input                       clk;
input                       e_chipEnable_n;
input                       g_outputEnable_n;
input                       w_writeEnable_n;
input                       lb_lowerByteEnable_n; // Lower byte enable
input                       ub_upperByteEnable_n; // Upper byte enable

input  [ADDR_WIDTH - 1:0]   address;
input  [DATA_WIDTH - 1:0]   dqi_datainput;
output [DATA_WIDTH - 1:0]   dqo_dataoutput;

reg    [DATA_WIDTH - 1:0]   mram [0: 15];

// READ CYCLE
assign dqo_dataoutput = (~e_chipEnable_n && ~g_outputEnable_n && w_writeEnable_n && ~lb_lowerByteEnable_n && ~ub_upperByteEnable_n) ? mram[address]                  :  // Read both bytes
                        (~e_chipEnable_n && ~g_outputEnable_n && w_writeEnable_n && ~lb_lowerByteEnable_n &&  ub_upperByteEnable_n) ? {8'bz, mram[address][7:0]}      :  // Read lower byte only
                        (~e_chipEnable_n && ~g_outputEnable_n && w_writeEnable_n &&  lb_lowerByteEnable_n && ~ub_upperByteEnable_n) ? {mram[address][15:8], 8'bz}     :  // Read upper byte only
                        {DATA_WIDTH{1'bz}}; // High impedance if no conditions met

// WRITE CYCLE
always @(posedge clk) begin
    if (~e_chipEnable_n) begin
        if (g_outputEnable_n) begin
            if (~w_writeEnable_n) begin
                if (~lb_lowerByteEnable_n && ~ub_upperByteEnable_n) begin
                    // Write both upper and lower bytes
                    mram[address] <= dqi_datainput;
                end
                else if (~lb_lowerByteEnable_n && ub_upperByteEnable_n) begin
                    // Write only lower byte
                    mram[address][7:0] <= dqi_datainput[7:0];
                end
                else if (lb_lowerByteEnable_n && ~ub_upperByteEnable_n) begin
                    // Write only upper byte
                    mram[address][15:8] <= dqi_datainput[15:8];
                end
            end
        end
    end
end

endmodule