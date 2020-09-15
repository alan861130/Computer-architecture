module forwarding_unit(
               clk_i,
               rst_i,
               ID_EX_RS_i,
               ID_EX_RT_i,
               EX_MEM_RD_i,
               EX_MEM_reg_write_i,
               MEM_WB_RD_i,
               MEM_WB_reg_write_i,
               forwardA_o,
               forwardB_o

               );
		   
			
//I/O ports            
input           clk_i;
input           rst_i;   
input  [5-1:0]  ID_EX_RS_i;
input  [5-1:0]  ID_EX_RT_i;
input  [5-1:0]  EX_MEM_RD_i;
input           EX_MEM_reg_write_i;
input  [5-1:0]  MEM_WB_RD_i;
input           MEM_WB_reg_write_i;


output  [2-1:0]  forwardA_o;
output  [2-1:0]  forwardB_o;





//Internal Signals
reg     [2-1:0] forwardA_o;
reg     [2-1:0] forwardB_o;

//Main function

always@ ( * ) begin
    forwardA_o = 2'b00;
    forwardB_o = 2'b00;


    //EX hazzard
    if ( EX_MEM_reg_write_i && ( EX_MEM_RD_i != 5'b0000 ) && ( EX_MEM_RD_i == ID_EX_RS_i ) ) begin
    forwardA_o = 2'b10;
    end 
    if ( EX_MEM_reg_write_i && ( EX_MEM_RD_i != 5'b0000 ) && ( EX_MEM_RD_i == ID_EX_RT_i ) ) begin
    forwardB_o = 2'b10;
    end

    //MEM hazzard 
    if ( MEM_WB_reg_write_i && ( MEM_WB_RD_i != 5'b0000 ) && ( MEM_WB_RD_i == ID_EX_RS_i ) ) begin
    forwardA_o = 2'b01;
    end
    if ( MEM_WB_reg_write_i && ( MEM_WB_RD_i != 5'b0000 ) && ( MEM_WB_RD_i == ID_EX_RT_i ) ) begin
    forwardB_o = 2'b01;
    end

    

end

endmodule      
          