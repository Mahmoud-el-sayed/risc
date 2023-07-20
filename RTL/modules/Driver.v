/*
The driver output is equal to the input value when enabled (data_en is true) and is high-impedance 
when not enabled (data_en is false). 
*/  
`default_nettype none 
module Driver #(
   parameter  DRIVER_WIDTH=8 
) (
    input  wire                       data_en,
    input  wire  [DRIVER_WIDTH-1:0]   data_in,
    output wire  [DRIVER_WIDTH-1:0]   data_out
);
    

assign data_out=data_en?data_in:'dz;

endmodule
