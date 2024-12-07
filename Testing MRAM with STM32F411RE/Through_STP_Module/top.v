module top
#(parameter BUS_WIDTH = 3)
(
    input clk,
    input rst,
    input en,

    input data_in,

    output [BUS_WIDTH-1:0] data_out
);

// Variables
reg [BUS_WIDTH - 1:0] data_shift_reg;

// Datapath
always @(posedge clk or posedge rst)
begin
    if (rst) begin
        // Resets all shift registers to 0
        data_shift_reg <= 0;
    end
    else
        // On the clock edge, move in serial data to shift registers one bit at a time
        if (en) begin
            data_shift_reg[BUS_WIDTH - 1 : 0] <= {data_in, data_shift_reg[BUS_WIDTH - 1 : 1]};
        end 
end


// If send_data gets asserted, send the contents of the shift registers out. If not, retain its old value. 
//assign data_out = (send_data == 1'b1) ? data_shift_reg : data_out;

// Use this for debugging purposes. For implementation, use the above with tenary operator
assign data_out = data_shift_reg;

endmodule
