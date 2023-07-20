/*
The address multiplexor selects between the instruction address during the instruction 
fetch phase and the operand address during the instruction execution phase.  
*/  
`default_nettype none
module Multiplexor #(
    parameter MUX_WIDTH=5
) (
    input  wire                        sel,
    input  wire  [MUX_WIDTH-1:0]       in0,
    input  wire  [MUX_WIDTH-1:0]       in1,
    output wire  [MUX_WIDTH-1:0]       mux_out
);

assign mux_out=sel?in1:in0;
    
endmodule
