/*
The CPU architecture is as follows:  
-> The Program Counter (counter) provides the program address. 
-> The MUX (mux) selects between the program address or the address field of the 
   instruction.  
-> The Memory (memory) accepts data and provides instructions and data. 
-> The Instruction Register (register) accepts instructions from the memory. 
-> The Accumulator Register (register) accepts data from the ALU. 
-> The ALU (alu) accepts memory and accumulator data, and the opcode field of the 
   instruction, and provides new data to the accumulator and memory.   
*/  
`default_nettype none 
module Risc_top #(
   parameter  OP_CODE_WIDTH=3 ,
              PHASE_WIDTH=3,
              AWIDTH=5,
              DWIDTH=8
) (
    input  wire                       clk,
    input  wire                       rst,
    output wire                       halt
);
//------------------------------------------------------------------------------
wire [PHASE_WIDTH-1:0]        phase;   
wire [PHASE_WIDTH-1:0]        pahse_cnt_in;  
wire                          zero; 
wire [OP_CODE_WIDTH-1:0]      opcode; 
wire                          sel;  
wire                          rd;  
wire                          ld_ir; 
wire                          inc_pc;
wire                          ld_ac;
wire                          wr;
wire                          ld_pc;
wire                          data_e ;
wire [DWIDTH-1:0]             data; 
wire [DWIDTH-1:0]             ac_out; 
wire [DWIDTH-1:0]             alu_out; 
wire [AWIDTH-1:0]             ir_addr; 
wire [AWIDTH-1:0]             pc_addr; 
wire [AWIDTH-1:0]             addr; 
//------------------------------------------------------------------------------
assign  pahse_cnt_in={PHASE_WIDTH {1'b0}};
//------------------------------------------------------------------------------
Counter #(
    .COUNTER_WIDTH (PHASE_WIDTH )
)
u_Counter_phase(
    .load    (1'b0    ),
    .enable  (!halt),//!glue logic
    .clk     (clk     ),
    .rst     (rst     ),
    .cnt_in  (pahse_cnt_in  ),
    .cnt_out (phase )
);
//------------------------------------------------------------------------------
Controller #(
    .OP_CODE_WIDTH (OP_CODE_WIDTH ),
    .PHASE_WIDTH   (PHASE_WIDTH   )
)
u_Controller(
    .zero   (zero   ),
    .phase  (phase  ),
    .clk    (clk    ),
    .rst    (rst    ),
    .opcode (opcode ),
    .sel    (sel    ),
    .rd     (rd     ),
    .ld_ir  (ld_ir  ),
    .halt   (halt   ),
    .inc_pc (inc_pc ),
    .ld_ac  (ld_ac  ),
    .wr     (wr     ),
    .ld_pc  (ld_pc  ),
    .data_e (data_e )
);
//------------------------------------------------------------------------------
Alu #(
    .ALU_WIDTH     (DWIDTH     ),
    .OP_CODE_WIDTH (OP_CODE_WIDTH )
)
u_Alu(
    .in_a      (ac_out      ),
    .in_b      (data      ),
    .opcode    (opcode    ),
    .alu_out   (alu_out   ),
    .a_is_zero (zero )
);
//------------------------------------------------------------------------------
Counter #(
    .COUNTER_WIDTH (AWIDTH )
)
u_Counter_pc(
    .load    (ld_pc    ),
    .enable  (inc_pc  ),
    .clk     (clk     ),
    .rst     (rst     ),
    .cnt_in  (ir_addr  ),
    .cnt_out (pc_addr )
);
//------------------------------------------------------------------------------
Memory #(
    .AWIDTH (AWIDTH ),
    .DWIDTH (DWIDTH )
)u_Memory(
    .rd   (rd   ),
    .wr   (wr   ),
    .rst  (rst  ),
    .clk  (clk  ),
    .addr (addr ),
    .data (data )
);
//------------------------------------------------------------------------------
Multiplexor #(
    .MUX_WIDTH (AWIDTH )
)
u_Multiplexor(
    .sel     (sel     ),
    .in0     (ir_addr     ),
    .in1     (pc_addr     ),
    .mux_out (addr )
);
//------------------------------------------------------------------------------
Register #(
    .DATA_WIDTH (DWIDTH )
)
u_Register_ir(
    .clk      (clk      ),
    .rst      (rst      ),
    .load     (ld_ir     ),
    .data_in  (data  ),
    .data_out ({opcode,ir_addr} )
);
//------------------------------------------------------------------------------
Register #(
    .DATA_WIDTH (DWIDTH )
)
u_Register_ac(
    .clk      (clk      ),
    .rst      (rst      ),
    .load     (ld_ac     ),
    .data_in  (alu_out  ),
    .data_out (ac_out )
);
//------------------------------------------------------------------------------
Driver #(
    .DRIVER_WIDTH (DWIDTH )
)
u_Driver(
    .data_en  (data_e  ),
    .data_in  (alu_out  ),
    .data_out (data )
);


endmodule

