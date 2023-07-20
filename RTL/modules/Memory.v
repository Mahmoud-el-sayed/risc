/*
The VeriRISC CPU uses the same memory for instructions and data. The memory has a single 
bidirectional data port and separate write and read control inputs. It cannot perform simultaneous 
write and read operations.
*/  
`default_nettype none 
module Memory #(
   parameter  AWIDTH=5,
              DWIDTH=8
) (
    input  wire                       rd,
    input  wire                       wr,
    input  wire                       rst,
    input  wire                       clk,
    input  wire  [AWIDTH-1:0]         addr,
    inout wire   [DWIDTH-1:0]         data //bidirectional data port 
);
    
localparam   DEPTH=2**AWIDTH;
integer i;
reg  [DWIDTH-1:0] RAM  [DEPTH-1:0];

always @(posedge clk ) begin
    if (rst) begin
        for (i=0;i<DEPTH;i=i+1) begin
          RAM[i]<='b0;  
        end  
    end
    else if (wr&&(~rd)) begin
       RAM[addr]<=data;
    end
end


assign data=(rd&&(~wr))?RAM[addr]:'bz;

endmodule

