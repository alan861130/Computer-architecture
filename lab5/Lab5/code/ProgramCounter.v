//Subject:     CO project 2 - PC
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ProgramCounter(
    clk_i,
	rst_i,
	pc_in_i,
	pc_write_i,
	pc_out_o
	);
     
//I/O ports
input           clk_i;
input	        rst_i;
input           pc_write_i;
input  [32-1:0] pc_in_i;
output [32-1:0] pc_out_o;
 
//Internal Signals

reg    [32-1:0] pc_delay1;
reg    [32-1:0] pc_delay2;
 
//Parameter

    
//Main function

assign pc_out_o = pc_delay2;

always @(posedge clk_i) begin
    if(~rst_i) begin
	    pc_delay1 <= 32'b0;
		pc_delay2 <= 32'b0;
	end	
	else begin
	    pc_delay1 <= pc_in_i;
		pc_delay2 <= pc_delay1;
		if( pc_write_i == 1'b0) begin
			pc_delay2 <= pc_in_i;
			end
	end
end

endmodule



                    
                    