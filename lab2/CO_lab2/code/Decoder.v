//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [5:0] instr_op_i;

output         RegWrite_o;
output [2:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
wire    [2:0] ALU_op_o;
wire            ALUSrc_o;
wire            RegWrite_o;
wire            RegDst_o;
wire            Branch_o;

	assign RegDst_o=(~instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(~instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0]);//000000
	assign Branch_o=(~instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0]);//000100
	assign ALUSrc_o=((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(~instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0])) | ((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0])) | ((instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(instr_op_i [0])) | (((instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(instr_op_i [0]))) | ((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(~instr_op_i [0])); 
	assign RegWrite_o=(~instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(~instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0]) | ((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(~instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0])) | ((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0])) | ((instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(instr_op_i [0])) |((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(~instr_op_i [0]));//000000,001000,001100,100011
	assign ALU_op_o [1]=((~instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(~instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0]))|((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0]));//000000, 001100(andi)
	assign ALU_op_o [0]= ((~instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0]))|((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0]));//000100,001100(andi)
    assign ALU_op_o [2]=((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(~instr_op_i [0]));
  



endmodule





                    
                    