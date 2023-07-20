/*
The VeriRISC CPU contains a program counter and a phase counter. One generic counter definition 
can serve both purposes. 
*/  
`default_nettype none 
module Counter #(
   parameter  COUNTER_WIDTH=5
) (
    input  wire                       load,
    input  wire                       enable,
    input  wire                       clk,
    input  wire                       rst,    
    input  wire  [COUNTER_WIDTH-1:0]  cnt_in,
    output reg   [COUNTER_WIDTH-1:0]  cnt_out
);
    

always @(posedge clk ) begin
    if (rst) begin
        cnt_out<='b0;
    end
    else if (load) begin
        cnt_out<=cnt_in;
    end
    else if (enable) begin
        cnt_out<=cnt_out+1'b1;
    end
end
endmodule

