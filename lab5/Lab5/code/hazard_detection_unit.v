module hazard_detection_unit(
            clk_i,
            rst_i,
            IF_ID_RS_i,
            IF_ID_RT_i,
            ID_EX_RT_i,
            ID_EX_mem_read_i,
            pc_src_i,
            pc_write_o,
            IF_ID_write_o,
            IF_flush_o,
            ID_flush_o,
            EX_flush_o

               );
		   
			
//I/O ports              
input           clk_i;
input           rst_i; 
input  [5-1:0]  IF_ID_RS_i;
input  [5-1:0]  IF_ID_RT_i;
input  [5-1:0]  ID_EX_RT_i;
input           ID_EX_mem_read_i;
input           pc_src_i;

output           pc_write_o;
output           IF_ID_write_o;
output           IF_flush_o;
output           ID_flush_o;
output           EX_flush_o;

//Internal Signals
reg           pc_write_o;
reg           IF_ID_write_o;
reg           IF_flush_o;
reg           ID_flush_o;
reg           EX_flush_o;

//Main function




always@ ( posedge clk_i or ID_EX_mem_read_i ) begin

    IF_flush_o = 1'b0;
    EX_flush_o = 1'b0;

    if ( ID_EX_mem_read_i && ( ( ID_EX_RT_i == IF_ID_RS_i ) || ( ID_EX_RT_i == IF_ID_RT_i ) ) ) begin
    ID_flush_o = 1'b1 ; 
    pc_write_o = 1'b1 ;
    IF_ID_write_o = 1'b1;
    end

    else begin
    ID_flush_o = 1'b0 ; 
    pc_write_o = 1'b0 ;
    IF_ID_write_o = 1'b0;
    end
end

endmodule      
          