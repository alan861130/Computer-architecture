//Subject:     CO project 2 - Adder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Adder(
    src1_i,
	src2_i,
	sum_o
	);
     
//I/O ports
input  [31:0]  src1_i;
input  [31:0]	 src2_i;
output [31:0]	 sum_o;

//Internal Signals
wire    [31:0]	 sum_o;

assign sum_o = src1_i + src2_i;

endmodule





                    
                    