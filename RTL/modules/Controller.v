/*
The controller generates all control signals for the VeriRISC CPU. The operation code, fetch-and-
execute phase, and whether the accumulator is zero determine the control signal levels.
*/  
`default_nettype none 
module Controller #(
   parameter  OP_CODE_WIDTH=3,
              PHASE_WIDTH=3
) (
    input  wire                       zero,
    input  wire  [PHASE_WIDTH-1:0]    phase,
    input  wire                       clk,
    input  wire                       rst,
    input  wire  [OP_CODE_WIDTH-1:0]  opcode,
    output wire                       sel,     
    output wire                       rd,        
    output wire                       ld_ir,       
    output wire                       halt,       
    output wire                       inc_pc,  
    output wire                       ld_ac,   
    output wire                       wr,      
    output wire                       ld_pc,     
    output wire                       data_e    
);

localparam  INST_ADDR=3'b000, INST_FETCH=3'b001, INST_LOAD=3'b010 , IDLE =3'b011, OP_ADDR  =3'b100,OP_FETCH=3'b101,ALU_OP  =3'b110,STORE=3'b111;
localparam  HLT=0,SKZ=1,ADD=2, AND=3, XOR=4, LDA=5,STO=6,JMP=7;
reg [8:0]   controller_output ;
wire halt_cond,ALUOP_cond,skz_cond,jmp_cond,STO_cond;

assign {sel,rd,ld_ir,halt,inc_pc,ld_ac,ld_pc,wr,data_e}=controller_output;
assign halt_cond=(opcode==HLT);
assign ALUOP_cond=((opcode==ADD)||(opcode==AND)||(opcode==XOR)||(opcode==LDA));
assign skz_cond=(opcode==SKZ);
assign jmp_cond=(opcode==JMP);
assign STO_cond=(opcode==STO);

always @(posedge clk ) begin
    if (rst) begin
        controller_output<='b0;
    end
    else begin
        case (phase)
            INST_ADDR:controller_output<=9'b1_0000_0000; 
            INST_FETCH:controller_output<=9'b1_1000_0000; 
            INST_LOAD:controller_output<=9'b111000000;
            IDLE:controller_output<=9'b1_1100_0000;
            OP_ADDR:controller_output<={3'b000,halt_cond,5'b1_0000};
            OP_FETCH:controller_output<={1'b0,ALUOP_cond,7'b000_0000};
            ALU_OP:controller_output<={1'b0,ALUOP_cond,2'b00,zero&&skz_cond,1'b0,jmp_cond,1'b0,STO_cond};
            STORE:controller_output<={1'b0,ALUOP_cond,3'b000,ALUOP_cond,jmp_cond,{'d2 {STO_cond}}};
            default:controller_output<=9'b000000000; 
        endcase
    end
end
endmodule