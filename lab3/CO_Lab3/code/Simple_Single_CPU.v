//Subject:     CO project 3 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
	rst_i
);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles




//adder
wire [32-1:0] pc_plus4;
wire [32-1:0] sum_out;

//Shifter
wire [32-1:0] shift_left1_out;
wire [28-1:0] shift_left2_out;


//MUX
wire [5-1:0] mux1_out;
wire [32-1:0] mux2_out;
wire [32-1:0] mux3_out;
wire [32-1:0] mux4_out;
wire [32-1:0]mux5_out;
wire mux6_out;


//pc
wire [31:0] pc_out;


//IM
wire [31:0] instr_out;


//RF
wire [31:0] RSdata_out;
wire [31:0] RTdata_out;


//Decoder
wire  Branch_out; 
wire  [1:0] MemtoReg_out;
wire  [1:0] Branch_type_out;
wire  [1:0] jump_out;
wire  MemRead_out;
wire  MemWrite_out;
wire  [2:0] ALU_op_out;
wire  ALUSrc_out; 
wire  RegWrite_out; 
wire  [1:0]RegDst_out; 
 

//AC
wire [4-1:0] ALUCtrl_out;


//SE
wire [32-1:0] Extend_out;


//ALU
wire [32-1:0] result_out;
wire  zero_out;

//Data_Memory
wire [32-1:0] memory_out;

wire temp1;
wire temp2; 
wire [32-1:0] temp3;

assign temp1 = ~ (zero_out & result_out[31] );
assign temp2 = mux6_out & Branch_out;
assign temp3 = { pc_plus4[31:28] , shift_left2_out};


ProgramCounter PC(      
        .clk_i( clk_i ),      
	.rst_i ( rst_i ),     
	.pc_in_i( mux4_out ) ,   
	.pc_out_o( pc_out ) 
);
	

Instr_Memory IM(
        .pc_addr_i( pc_out ),  
	.instr_o( instr_out ) 
);

			
Reg_File Registers(
        .clk_i( clk_i ),      
	.rst_i( rst_i ) ,     
        .RSaddr_i( instr_out[25:21] ) ,  
        .RTaddr_i( instr_out[20:16] ) ,  
        .RDaddr_i( mux1_out ) ,  
        .RDdata_i(  mux5_out )  , 
        .RegWrite_i ( RegWrite_out ),
        .RSdata_o( RSdata_out ) ,  
        .RTdata_o( RTdata_out ) 
);

	
Decoder Decoder(
        .instr_op_i( instr_out[31:26] ),
        .instr_func_i ( instr_out[5:0]), 
        .Branch_o ( Branch_out ) ,
        .MemtoReg_o ( MemtoReg_out ), 
        .Branch_type_o ( Branch_type_out ),
        .jump_o( jump_out ),
        .MemRead_o(MemRead_out),
        .MemWrite_o(MemWrite_out),
        .ALU_op_o(ALU_op_out), 
        .ALUSrc_o(ALUSrc_out),
	.RegWrite_o(RegWrite_out),    
	.RegDst_o(RegDst_out)
);


ALU_Ctrl AC(
        .funct_i( instr_out[5:0] ),   
        .ALUOp_i( ALU_op_out ),   
        .ALUCtrl_o( ALUCtrl_out ) 
);

	
Sign_Extend SE(
        .data_i( instr_out[15:0] ),
        .data_o( Extend_out )
);
	
		
ALU ALU(
        .src1_i( RSdata_out ),
	.src2_i( mux2_out ),
	.ctrl_i( ALUCtrl_out ),
	.result_o ( result_out ),
	.zero_o ( zero_out )
);
	

Data_Memory Data_Memory(
	.clk_i( clk_i),
	.addr_i( result_out ),
	.data_i( RTdata_out ),
	.MemRead_i( MemRead_out ),
	.MemWrite_i( MemWrite_out ),
	.data_o( memory_out )
);


Adder Adder1(
        .src1_i( pc_out ),     
	.src2_i( 32'b0100 ),     
	.sum_o( pc_plus4 ) 
);


Adder Adder2(
        .src1_i( pc_plus4 ),     
	.src2_i( shift_left1_out ),     
	.sum_o( sum_out )     
);	


Shift_Left_Two_32 Shifter1(
        .data_i( Extend_out ),
        .data_o (shift_left1_out)
); 	


Shift_Left_Two_26 Shifter2(
        .data_i ( instr_out[25:0] ),
        .data_o ( shift_left2_out  )
);




MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i( RTdata_out ),
        .data1_i( Extend_out ),
        .select_i( ALUSrc_out ),
        .data_o( mux2_out )
);

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i( pc_plus4 ),
        .data1_i( sum_out ),
        .select_i( temp2 ),
        .data_o( mux3_out )
);




MUX_3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i( instr_out[20:16] ),
        .data1_i( instr_out[15:11] ),
        .data2_i( 5'b11111 ),
        .select_i( RegDst_out ),
        .data_o( mux1_out )
);

MUX_3to1 #(.size(32)) Mux_branch_address(
        .data0_i( temp3 ),
        .data1_i( mux3_out ),
        .data2_i( RSdata_out ),
        .select_i( jump_out ),
        .data_o( mux4_out )
);	

	
MUX_3to1 #(.size(32)) Mux_Mem_to_Reg(
        .data0_i( result_out ),
        .data1_i( memory_out ),
        .data2_i( pc_plus4 ),
        .select_i( MemtoReg_out ),
        .data_o( mux5_out )
);


MUX_4to1 #(.size(1)) Mux_Branch_type(
        .data0_i( zero_out ),
        .data1_i( temp1 ),
        .data2_i( ~result_out[31] ),
        .data3_i( ~zero_out ),
        .select_i( Branch_type_out ),
        .data_o( mux6_out )
);


endmodule
		  


