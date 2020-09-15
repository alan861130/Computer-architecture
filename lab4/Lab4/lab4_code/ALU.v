//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals

reg zero_o;
reg [31:0] result_o;


	always @ (ctrl_i or src1_i or src2_i)  begin
		case (ctrl_i)

		4'b0000:  begin 
		zero_o <= 0 ;
		result_o <= src1_i & src2_i;
		end

		4'b0001:  begin 
		zero_o <= 0; 
		result_o <= src1_i | src2_i; 
		end

		4'b0010:  begin 
		zero_o <= 0; 
		result_o <= src1_i + src2_i; 
		end

		4'b0110:  begin 
		if ( src1_i == src2_i ) 
		zero_o <= 1;
		else zero_o <= 0; 
		result_o <= src1_i - src2_i;
		end

		4'b0111:  begin 
		zero_o <= 0; 
		if ( src1_i - src2_i >= 32'h8000_0000) result_o <= 32'b1; 
		else result_o <= 32'b0; 
		end

		4'b1000:  begin 
		zero_o <= 0; 
		result_o <= src1_i * src2_i; 
		end
		
		default: begin 
		zero_o <= 0; 
		result_o <= src1_i; 
		end
		endcase
	end

endmodule





                    
                    