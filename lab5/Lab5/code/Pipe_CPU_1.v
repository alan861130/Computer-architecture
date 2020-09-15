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
wire blank;
assign blank = 1'b0;

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

wire           IF_flush_out; 
wire           ID_flush_out;
wire           EX_flush_out;
wire           pc_write_out;
wire           IF_ID_write_out;

wire  [10-1:0] mux1_out;

//control signal
wire [153-1:0] ID_EX_in;
wire [153-1:0] ID_EX_out;
wire [10-1:0]  signal_out;

assign signal_out = { MemtoReg_out , RegWrite_out , Branch_out , MemRead_out , MemWrite_out , RegDst_out , ALU_op_out , ALUSrc_out };
assign ID_EX_in = { mux1_out , IF_ID_out[63:32] ,  RTdata_out , RSdata_out , Extend_out , IF_ID_out[25:21], IF_ID_out[20:16], IF_ID_out[15:11] };

/**** EX stage ****/
wire  [32-1:0] shift_left_out;
wire  [5-1:0]  mux2_out;
wire  [32-1:0]  mux3_out;
wire  [32-1:0]  mux4_out;
wire  [32-1:0]  mux5_out;
wire  [5-1:0]  mux6_out;

wire  [32-1:0] result_out;
wire           zero_out;
wire  [32-1:0] sum_out;
wire  [4-1:0]  ALUCtrl_out;
wire  [2-1:0]  forwardA_out;
wire  [2-1:0]  forwardB_out;


//control signal
wire  [107-1:0] EX_MEM_in;
wire  [107-1:0] EX_MEM_out;

assign EX_MEM_in = { mux2_out , sum_out , zero_out , result_out , mux4_out , mux6_out };


/**** MEM stage ****/
wire [32-1:0] memory_out;
wire  pc_src;

assign pc_src = ( EX_MEM_out[104] & EX_MEM_out[69] );



//control signal
wire [71-1:0] MEM_WB_in;
wire [71-1:0] MEM_WB_out;

assign MEM_WB_in = { EX_MEM_out[106:105] , memory_out , EX_MEM_out[68:37] , EX_MEM_out[4:0] };

/**** WB stage ****/
wire [32-1:0] mux7_out;
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
    .pc_write_i( pc_write_out ),
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
    .flush_i( IF_flush_out ), 
    .write_i( IF_ID_write_out ),
    .data_o(  IF_ID_out )

);


//Instantiate the components in ID stage
Reg_File RF(
    .clk_i( clk_i ),      
	.rst_i( rst_i ) ,     
    .RSaddr_i( IF_ID_out[25:21] ) ,  
    .RTaddr_i( IF_ID_out[20:16] ) ,  
    .RDaddr_i( MEM_WB_out[4:0] ) ,  
    .RDdata_i( mux7_out  )  , 
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

MUX_2to1 #(.size(10)) Mux1(
    .data0_i( signal_out ),
    .data1_i( 10'b0 ), 
    .select_i( ID_flush_out ),
    .data_o(  mux1_out )

);



Sign_Extend Sign_Extend(
    .data_i( IF_ID_out[15:0] ),
    .data_o( Extend_out )
);	

hazard_detection_unit H(
    .clk_i( clk_i ),
    .rst_i( rst_i ),
    .IF_ID_RS_i( IF_ID_out[25:21] ),
    .IF_ID_RT_i( IF_ID_out[20:16] ),
    .ID_EX_RT_i( ID_EX_out[9:5] ),
    .ID_EX_mem_read_i( ID_EX_out[149] ),
    .pc_src_i( pc_src ),
    .pc_write_o( pc_write_out ),
    .IF_ID_write_o( IF_ID_write_out ),
    .IF_flush_o( IF_flush_out ),
    .ID_flush_o( ID_flush_out ),
    .EX_flush_o( EX_flush_out )

);

Pipe_Reg #(.size(153)) ID_EX(
    .clk_i( clk_i ),
    .rst_i( rst_i ),
    .data_i( ID_EX_in ),
    .flush_i( blank ), 
    .write_i( blank ),
    .data_o( ID_EX_out )
);


//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
    .data_i( ID_EX_out[46:15] ),
    .data_o( shift_left_out )
);

MUX_2to1 #(.size(5)) Mux2(
    .data0_i( ID_EX_out[152:148] ),
    .data1_i( 5'b0 ),
    .select_i( EX_flush_out ),
    .data_o( mux2_out )

);

MUX_3to1 #(.size(32)) Mux3(
    .data0_i( ID_EX_out[78:47] ),
    .data1_i( EX_MEM_out[68:37] ),
    .data2_i( mux7_out ),
    .select_i( forwardA_out ),
    .data_o( mux3_out )

);

MUX_3to1 #(.size(32)) Mux4(
    .data0_i( ID_EX_out[110:79] ),
    .data1_i( EX_MEM_out[68:37] ),
    .data2_i( mux7_out ),
    .select_i( forwardB_out ),
    .data_o( mux4_out )

);

MUX_2to1 #(.size(32)) Mux5(
    .data0_i( mux4_out ),
    .data1_i( ID_EX_out[46:15] ),
    .select_i( ID_EX_out[143] ),
    .data_o( mux5_out )

);

ALU ALU(
    .src1_i( mux3_out ),
	.src2_i( mux5_out ),
	.ctrl_i( ALUCtrl_out ),
	.result_o ( result_out ),
	.zero_o ( zero_out )

);
		
ALU_Ctrl ALU_Control(
    .funct_i( ID_EX_out[20:15] ),   
    .ALUOp_i( ID_EX_out[146:144] ),           
    .ALUCtrl_o( ALUCtrl_out ) 

);


		
MUX_2to1 #(.size(5)) Mux6(
    .data0_i( ID_EX_out[9:5] ),
    .data1_i( ID_EX_out[4:0] ),
    .select_i( ID_EX_out[147] ),
    .data_o( mux6_out )

);

Adder Add_pc_branch(
    .src1_i( ID_EX_out[142:111] ),     
	.src2_i( shift_left_out ),     
	.sum_o( sum_out )    
);

forwarding_unit F(
    .clk_i( clk_i ),
    .rst_i( rst_i ),
    .ID_EX_RS_i( ID_EX_out[14:10] ),
    .ID_EX_RT_i( ID_EX_out[9:5] ),
    .EX_MEM_RD_i( EX_MEM_out[4:0] ),
    .EX_MEM_reg_write_i( EX_MEM_out[105] ),
    .MEM_WB_RD_i( MEM_WB_out[4:0] ),
    .MEM_WB_reg_write_i( MEM_WB_out[69] ),
    .forwardA_o( forwardA_out ),
    .forwardB_o( forwardB_out )

);

Pipe_Reg #(.size(107)) EX_MEM(
    .clk_i( clk_i ),
    .rst_i( rst_i ),
    .data_i( EX_MEM_in ),
    .flush_i( blank ), 
    .write_i( blank ),
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
    .flush_i( blank ), 
    .write_i( blank ),
    .data_o( MEM_WB_out )
);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux7(
    .data0_i( MEM_WB_out[36:5] ),
    .data1_i( MEM_WB_out[68:37] ),
    .select_i( MEM_WB_out[70] ),
    .data_o( mux7_out )


);

/****************************************
signal assignment
****************************************/

endmodule

