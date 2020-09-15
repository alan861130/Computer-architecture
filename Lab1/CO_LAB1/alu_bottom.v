`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 10/10/2013
// Design Name: 
// Module Name:    alu_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,
               set       
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;


reg           src1_temp;
reg   	      src2_temp;
reg           result;
reg	      cout;

always@(*) begin
	src1_temp = ((src1) & (~A_invert)) | ((~src1) & (A_invert));
	src2_temp = ((src2) & (~B_invert)) | ((~src2) & (B_invert));
	case(operation) 
        2'b00: begin  //and
		result = src1_temp & src2_temp;
		cout = 0;
		end
	2'b01: begin  //or
		result = src1_temp | src2_temp;
		cout = 0;
		end
	2'b10: begin  //add
		result = src1_temp ^ src2_temp ^ cin;
		cout = (src1_temp & src2_temp) | (cin & (src1_temp^src2_temp)) ;
		end
	2'b11: begin  //slt
		result = less;
		set = (src1_temp & src2_temp) | (cin & (src1_temp^src2_temp)) ;
        cout = 0;
		end
        endcase
end


endmodule



