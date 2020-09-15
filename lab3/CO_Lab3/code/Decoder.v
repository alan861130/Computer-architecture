//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i , 
    instr_func_i,
    Branch_o ,
    MemtoReg_o , 
    Branch_type_o ,
    jump_o ,
    MemRead_o ,
    MemWrite_o ,
    ALU_op_o , 
    ALUSrc_o ,
	RegWrite_o ,    
	RegDst_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;
input  [6-1:0] instr_func_i;

output           Branch_o ;
output  [2-1:0]  MemtoReg_o ;
output  [2-1:0]  Branch_type_o ;
output  [2-1:0]   jump_o ;
output           MemRead_o ;
output           MemWrite_o ;
output  [3-1:0]  ALU_op_o ; 
output           ALUSrc_o ;
output	         RegWrite_o ;    
output  [2-1:0]  RegDst_o ;
 
//Internal Signals

wire           Branch_o ;
wire  [2-1:0]  MemtoReg_o ;
wire  [2-1:0]  Branch_type_o ;
wire  [2-1:0]  jump_o ;
wire           MemRead_o ;
wire           MemWrite_o ;
wire  [3-1:0]  ALU_op_o ; 
wire           ALUSrc_o ;
wire	       RegWrite_o ;    
wire  [2-1:0]  RegDst_o ;

assign Branch_o=((~instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0])) ;  //000100(beq)
                


assign MemtoReg_o[1]=((~instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(instr_op_i [0])); //000011(jal)

assign MemtoReg_o[0]=((instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(instr_op_i [0])); //100011(lw)

assign Branch_type_o[1]=0;

assign Branch_type_o[0]=0;

assign jump_o[1]=( (~instr_func_i [5])&(~instr_func_i [4])&(instr_func_i [3])&(~instr_func_i [2])&(~instr_func_i [1]) &(~instr_func_i [0])&(~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(~instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0]) ) ; 
//000000 001000 (jr)

assign jump_o[0]=((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(~instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0])) |  //001000(addi)
                 ((~instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(~instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0])) | //000000
                 ((instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(instr_op_i [0])) |    //100011(lw)
                 ((instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(instr_op_i [0])) |     //101011(sw)
                 ((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0])) |    //001100(andi)
                 ((~instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0])) ;  //000100(beq)

assign MemRead_o=((instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(instr_op_i [0])); //100011(lw)

assign MemWrite_o=((instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(instr_op_i [0])); //101011(sw)



assign ALU_op_o [1]=((~instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(~instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0]))| //000000
                    ((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0])); //, 001100(andi)
					
assign ALU_op_o [0]= ((~instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0]))|  //000100 (beq)
                     ((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0]));//001100(andi)

assign ALU_op_o [2]=((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(~instr_op_i [0]));  //001010(slti)



assign ALUSrc_o=((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(~instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0])) |  //001000(addi)
                   ((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0])) |   //001100(andi)
                   ((instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(instr_op_i [0])) |    //100011(lw)
                   ((instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(instr_op_i [0])) |     //101011(sw)
                   ((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(~instr_op_i [0])) ;   //001010(slti)


assign RegWrite_o=(~instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(~instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0]) |  //000000
                  ((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(~instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0])) | //001000(addi)
				  ((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0])) |  //001100(andi)
				  ((instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(instr_op_i [0])) |   //100011(lw)
				  ((~instr_op_i [5])&(~instr_op_i [4])&(instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(~instr_op_i [0])) |  //001010(slti)
                  ((~instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(instr_op_i [0]));   //000011(jal)


assign RegDst_o[1]=((~instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(~instr_op_i [2])&(instr_op_i [1])&(instr_op_i [0])) ; //000011(jal)

assign RegDst_o[0]=((~instr_op_i [5])&(~instr_op_i [4])&(~instr_op_i [3])&(~instr_op_i [2])&(~instr_op_i [1])&(~instr_op_i [0]));//000000

endmodule



                    
                    