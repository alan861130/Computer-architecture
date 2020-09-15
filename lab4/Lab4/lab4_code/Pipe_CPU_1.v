`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [32-1:0] mux0_out;
wire [32-1:0] pc_out;
wire [32-1:0] instr_out;
wire [32-1:0] pc_plus4;
wire [64-1:0] IF_ID_in;
wire [64-1:0] IF_ID_out;

assign IF_ID_in = { pc_plus4 , instr_out };


/**** ID stage ****/
wire [31:0] RSdata_out;
wire [31:0] RTdata_out;
wire [32-1:0] Extend_out;
wire           Branch_out ;
wire           MemtoReg_out ;
wire           MemRead_out ;
wire           MemWrite_out ;
wire  [3-1:0]  ALU_op_out ; 
wire           ALUSrc_out ;
wire	       RegWrite_out ;    
wire           RegDst_out ;

//control signal
wire [148-1:0] ID_EX_in;
wire [148-1:0] ID_EX_out;

assign ID_EX_in = { MemtoReg_out , RegWrite_out , Branch_out , MemRead_out , MemWrite_out , RegDst_out , ALU_op_out , ALUSrc_out , IF_ID_out[63:32] ,  RTdata_out , RSdata_out , Extend_out , IF_ID_out[20:16], IF_ID_out[15:11] };

/**** EX stage ****/
wire  [32-1:0] shift_left_out;
wire  [32-1:0] result_out;
wire           zero_out;
wire  [32-1:0] mux1_out;
wire  [5-1:0]  mux2_out;
wire  [32-1:0] sum_out;
wire  [4-1:0]  ALUCtrl_out;


//control signal
wire  [107-1:0] EX_MEM_in;
wire  [107-1:0] EX_MEM_out;

assign EX_MEM_in = { ID_EX_out[147:143] , sum_out , zero_out , result_out , ID_EX_out[105:74] , mux2_out };


/**** MEM stage ****/
wire [32-1:0] memory_out;
wire  pc_src;

assign pc_src = ( EX_MEM_out[104] & EX_MEM_out[69] );



//control signal
wire [71-1:0] MEM_WB_in;
wire [71-1:0] MEM_WB_out;

assign MEM_WB_in = { EX_MEM_out[106:105] , memory_out , EX_MEM_out[68:37] , EX_MEM_out[4:0] };

/**** WB stage ****/
wire [32-1:0] mux3_out;
//control signal


/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
    .data0_i( pc_plus4 ),
    .data1_i( EX_MEM_out[101:70] ), 
    .select_i( pc_src ),
    .data_o(  mux0_out )

);

ProgramCounter PC(
    .clk_i( clk_i ),      
	.rst_i ( rst_i ),     
	.pc_in_i( mux0_out ) ,   
	.pc_out_o( pc_out ) 

);

Instruction_Memory IM(
    .addr_i( pc_out ),  
	.instr_o( instr_out ) 

);
			
Adder Add_pc(
    .src1_i( pc_out ),     
	.src2_i( 32'b0100 ),     
	.sum_o( pc_plus4 ) 
);

		
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
    .clk_i( clk_i ),
    .rst_i( rst_i ),
    .data_i(  IF_ID_in ),
    .data_o(  IF_ID_out )

);


//Instantiate the components in ID stage
Reg_File RF(
    .clk_i( clk_i ),      
	.rst_i( rst_i ) ,     
    .RSaddr_i( IF_ID_out[25:21] ) ,  
    .RTaddr_i( IF_ID_out[20:16] ) ,  
    .RDaddr_i( MEM_WB_out[4:0] ) ,  
    .RDdata_i( mux3_out  )  , 
    .RegWrite_i ( MEM_WB_out[69] ),
    .RSdata_o( RSdata_out ) ,  
    .RTdata_o( RTdata_out ) 

);

Decoder Control(
    .instr_op_i( IF_ID_out[31:26] ),
    .Branch_o ( Branch_out ) ,
    .MemtoReg_o ( MemtoReg_out ), 
    .MemRead_o( MemRead_out ),
    .MemWrite_o( MemWrite_out ),
    .ALU_op_o( ALU_op_out ), 
    .ALUSrc_o( ALUSrc_out ),
	.RegWrite_o( RegWrite_out ),    
	.RegDst_o( RegDst_out )

);

Sign_Extend Sign_Extend(
    .data_i( IF_ID_out[15:0] ),
    .data_o( Extend_out )

);	

Pipe_Reg #(.size(148)) ID_EX(
    .clk_i( clk_i ),
    .rst_i( rst_i ),
    .data_i( ID_EX_in ),
    .data_o( ID_EX_out )
);


//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
    .data_i( ID_EX_out[41:10] ),
    .data_o( shift_left_out )
);

ALU ALU(
    .src1_i( ID_EX_out[73:42] ),
	.src2_i( mux1_out ),
	.ctrl_i( ALUCtrl_out ),
	.result_o ( result_out ),
	.zero_o ( zero_out )

);
		
ALU_Ctrl ALU_Control(
    .funct_i( ID_EX_out[15:10] ),   
    .ALUOp_i( ID_EX_out[141:139] ),           
    .ALUCtrl_o( ALUCtrl_out ) 

);

MUX_2to1 #(.size(32)) Mux1(
    .data0_i( ID_EX_out[105:74] ),
    .data1_i( ID_EX_out[41:10] ),
    .select_i( ID_EX_out[138] ),
    .data_o( mux1_out )

);
		
MUX_2to1 #(.size(5)) Mux2(
    .data0_i( ID_EX_out[9:5] ),
    .data1_i( ID_EX_out[4:0] ),
    .select_i( ID_EX_out[142] ),
    .data_o( mux2_out )

);

Adder Add_pc_branch(
    .src1_i( ID_EX_out[137:106] ),     
	.src2_i( shift_left_out ),     
	.sum_o( sum_out )    
);

Pipe_Reg #(.size(107)) EX_MEM(
    .clk_i( clk_i ),
    .rst_i( rst_i ),
    .data_i( EX_MEM_in ),
    .data_o(  EX_MEM_out )


);


//Instantiate the components in MEM stage
Data_Memory DM(
    .clk_i( clk_i),
	.addr_i( EX_MEM_out[68:37] ),
	.data_i( EX_MEM_out[36:5] ),
	.MemRead_i( EX_MEM_out[103] ),
	.MemWrite_i( EX_MEM_out[102] ),
	.data_o( memory_out )

);

Pipe_Reg #(.size(71)) MEM_WB(
    .clk_i( clk_i ),
    .rst_i( rst_i ),
    .data_i( MEM_WB_in ),
    .data_o( MEM_WB_out )
);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
    .data0_i( MEM_WB_out[36:5] ),
    .data1_i( MEM_WB_out[68:37] ),
    .select_i( MEM_WB_out[70] ),
    .data_o( mux3_out )


);

/****************************************
signal assignment
****************************************/

endmodule

