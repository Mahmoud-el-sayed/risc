/*
ALU performs arithmetic operations on numbers depending upon the operation encoded in the 
instruction. This ALU will perform 8 operations on the 8-bit inputs (see table in the Specification) 
and generate an 8-bit output and single-bit output. 
*/  
`default_nettype none 
module Alu #(
   parameter  ALU_WIDTH=8 ,
              OP_CODE_WIDTH=3
) (
    input  wire  [ALU_WIDTH-1:0]      in_a,
    input  wire  [ALU_WIDTH-1:0]      in_b,
    input  wire  [OP_CODE_WIDTH-1:0]  opcode,
    output reg   [ALU_WIDTH-1:0]      alu_out,
    output wire                       a_is_zero
);
    
localparam  ADD=3'd2, AND=3'd3, XOR=3'd4, PASSB=3'd5;

assign a_is_zero=in_a?1'b0:1'b1;

always @(*) begin
    alu_out=in_a;
 case (opcode)
    ADD:alu_out=in_a+in_b; 
    AND:alu_out=in_a&in_b; 
    XOR:alu_out=in_a^in_b; 
    PASSB:alu_out=in_b; 
    default: alu_out=in_a;
 endcase   
end

endmodule

