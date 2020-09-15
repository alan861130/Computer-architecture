//Subject:     CO project 2 - Simple Single CPU
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
//pc
wire [31:0] pc_out;


//adder1
wire [31:0] pc_plus4;

//IM
wire [31:0] instr_out;

//Mux_Write_Reg
wire [4:0] mux1_out;

//RF
wire [31:0] RSdata_out;
wire [31:0] RTdata_out;

//Decoder
wire  RegWrite_out; 
wire [2:0] ALU_op_out;
wire  ALUSrc_out;   
wire  RegDst_out; 
wire  Branch_out;  

//AC
wire [3:0] ALUCtrl_out;

//SE
wire [32-1:0] Extend_out;

//Mux_ALUSrc
wire [31:0] mux2_out;

//ALU
wire [31:0] result_out;
wire  zero_out;

//Mux_PC_Source
wire [32-1:0] mux3_out;

//Adder2
wire [32-1:0] sum_out;

//Branch 
wire  branch_control;

//Shifter
wire [32-1:0] shift_left_out;


//Greate componentes

assign branch_control = Branch_out & zero_out ;



ProgramCounter PC(
        .clk_i( clk_i ),      
	.rst_i ( rst_i ),     
	.pc_in_i( mux3_out ) ,   
	.pc_out_o( pc_out ) 
	);
	
Adder Adder1(
        .src1_i( pc_out ),     
	.src2_i( 32'b0100 ),     
	.sum_o( pc_plus4 )    
	);
	
Instr_Memory IM(
        .pc_addr_i( pc_out ),  
	.instr_o( instr_out )    
	);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i( instr_out[20:16] ),
        .data1_i( instr_out[15:11] ),
        .select_i( RegDst_out ),
        .data_o( mux1_out )
        );	
		
Reg_File RF(
        .clk_i( clk_i ),      
	.rst_i( rst_i ) ,     
        .RSaddr_i( instr_out[25:21] ) ,  
        .RTaddr_i( instr_out[20:16] ) ,  
        .RDaddr_i( mux1_out ) ,  
        .RDdata_i(  result_out )  , 
        .RegWrite_i ( RegWrite_out ),
        .RSdata_o( RSdata_out ) ,  
        .RTdata_o( RTdata_out )   
        );
	
Decoder Decoder(
        .instr_op_i( instr_out[31:26] ), 
	.RegWrite_o(RegWrite_out), 
	.ALU_op_o(ALU_op_out),   
	.ALUSrc_o(ALUSrc_out),   
	.RegDst_o(RegDst_out),   
	.Branch_o(Branch_out)   
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
        

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i( RTdata_out ),
        .data1_i( Extend_out ),
        .select_i( ALUSrc_out ),
        .data_o( mux2_out )
        );
Shift_Left_Two_32 Shifter(
        .data_i( Extend_out ),
        .data_o (shift_left_out)
); 	
		
ALU ALU(
        .src1_i( RSdata_out ),
	.src2_i( mux2_out ),
	.ctrl_i( ALUCtrl_out ),
	.result_o ( result_out ),
	.zero_o ( zero_out )
	);
		
Adder Adder2(
        .src1_i( pc_plus4 ),     
	.src2_i( shift_left_out ),     
	.sum_o( sum_out )      
	);
		
		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i( pc_plus4 ),
        .data1_i( sum_out ),
        .select_i( branch_control ),
        .data_o( mux3_out )
        );	

endmodule
		  


