`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
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

module ALU(
           src1_i,          // 32 bits source 1          (input)
           src2_i,          // 32 bits source 2          (input)
           ctrl_i,   // 4 bits ALU control input  (input)
		
           result_o,        // 32 bits result_o            (output)
           zero_o          // 1 bit when the output is 0, zero_o must be set (output)
           );
		   
localparam [3:0] AND = 4'b0000, OR = 4'b0001, ADD = 4'b0010, SUB = 4'b0110,
				 NOR = 4'b1100, SLT = 4'b0111;
		   

input  [32-1:0] src1_i;
input  [32-1:0] src2_i;
input  [4-1:0]  ctrl_i;


output [32-1:0] result_o;
output          zero_o;

reg zero_o;
reg [31:0] result_o;
	always @ (ctrl_i or src1_i or src2_i)begin
		case (ctrl_i)
		4'b0000:begin 
		zero_o <=0 ;
		result_o <= src1_i&src2_i;
		end

		4'b0001:begin 
		zero_o <= 0; 
		result_o <=src1_i|src2_i; 
		end
		4'b0010:begin 
		zero_o<=0; 
		result_o<=src1_i+src2_i; 
		end
		4'b0110:begin 
		if(src1_i==src2_i) 
		zero_o<=1;
		else zero_o<=0; 
		result_o<=src1_i-src2_i;
		end
		4'b0111:begin 
		zero_o<=0; if(src1_i-src2_i>=32'h8000_0000) result_o<=32'b1; 
		else result_o<=32'b0; 
		end// how to implement signed number
		default: begin 
		zero_o<=0; 
		result_o<=src1_i; 
		end
		endcase
	end
endmodule


