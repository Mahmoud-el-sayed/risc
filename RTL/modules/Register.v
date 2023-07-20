/*
The VeriRISC CPU contains an accumulator register and an instruction register. One generic register 
definition can serve both purposes.  
*/  
`default_nettype none 
module Register #(
   parameter  DATA_WIDTH=8 
) (
    input  wire                       clk,
    input  wire                       rst,
    input  wire                       load,
    input  wire  [DATA_WIDTH-1:0]     data_in,
    output reg   [DATA_WIDTH-1:0]     data_out
);
    

always @(posedge clk ) begin
    if (rst) begin
        data_out<='b0;
    end
    else if (load) begin
        data_out<=data_in;
    end
end

endmodule

