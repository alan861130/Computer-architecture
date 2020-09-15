`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe Register
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_Reg(
    
    clk_i,
    rst_i,
    data_i,
    flush_i,
    write_i,
    data_o
    );
					
parameter size = 0;

input   clk_i;		  
input   rst_i;
input   flush_i;
input   write_i;
input   [size-1:0] data_i;
output  [size-1:0] data_o;

reg     [size-1:0] data_delay1;
reg     [size-1:0] data_delay2;

assign data_o = data_delay2;
	  
always@(posedge clk_i) begin
    if(~rst_i) begin
        data_delay1 <= { size {1'b0} };
        data_delay2 <= { size {1'b0} };
    end
    else begin
        data_delay1 <= data_i;
        data_delay2 <= data_delay1;
        if ( write_i == 1'b0 ) begin
            data_delay2 <= data_i;
        end 
        if ( flush_i == 1'b1 ) begin
            data_delay2 <= { size {1'b0} };
        end   
    end 
end

endmodule	