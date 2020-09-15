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

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
			  //bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;
//input   [3-1:0] bonus_control; 

output [32-1:0] result;
output         zero;
output         cout;
output         overflow;

reg             constant = 1'b0;
reg             cout_control;
reg             overflow_control;
reg             zero_control;
reg             first;
reg   [31:0]    temp_result;

wire   [31:0]   alu_result; 
wire            set;
wire   [31:0]   ripple;      
        



always@(*) begin  //fisrt carryin control
    if ( ALU_control == 4'b0110 || ALU_control == 4'b0111) begin // sub(include slt)
    first <= 1'b1;
    end
    else begin
    first <= 1'b0;
    end
end

always@(posedge clk) begin //overflow control
    if ( ALU_control == 4'b0010 ) begin //add
        if ( ( src1[31] == src2[31] ) && ( alu_result[31] != src1[31] ) ) begin  //overflow
        overflow_control = 1'b1;
        end
        else begin
        overflow_control = 1'b0;
        end
    end
    if ( ALU_control == 4'b0110 ) begin //sub
        if ( ( src1[31] != src2[31] ) && ( alu_result[31] != src1[31] ) ) begin  //overflow
        overflow_control = 1'b1;
        end
        else begin
        overflow_control = 1'b0;
        end
    end
    else begin 
    overflow_control = 1'b0;
    end
end

always @(posedge clk) begin //carry out
    if ( ALU_control == 4'b0010 ) begin //add
        if ( ripple[31] == 1 ) begin
        cout_control = 1;
        end
        else begin 
        cout_control = 0;
        end
    end
    if ( ALU_control == 4'b0110 ) begin //sub
        if ( src1[31] == 1'b1 && src2[31]== 1'b0)  begin 
        cout_control = 0;
        end
        else if( src1[31] == 1'b0 && src2[31] == 1'b1 ) begin 
        cout_control = 1;
        end
        else begin
        cout_control = ripple[30];
        end
    end
    else begin
    cout_control = 0;
    end
end

always@(posedge clk) begin //zero
    if ( alu_result == 32'b0) begin
    zero_control = 1'b1;
    end
    else begin
    zero_control = 1'b0;
    end
end

always@(posedge clk) begin //restart
    if(rst_n) begin
    temp_result[31:0] <= alu_result[31:0];
    end
end

assign result[31:0] = temp_result[31:0];
assign overflow = overflow_control;
assign cout = cout_control;
assign zero = zero_control;



alu_top a0(.cin(first), .src1(src1[0]), .src2(src2[0]), .less(set), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]), .result(alu_result[0]), .cout(ripple[0]));
alu_top a1(.cin(ripple[0]), .src1(src1[1]), .src2(src2[1]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[1]),.cout(ripple[1]));
alu_top a2(.cin(ripple[1]), .src1(src1[2]), .src2(src2[2]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[2]),.cout(ripple[2]));
alu_top a3(.cin(ripple[2]), .src1(src1[3]), .src2(src2[3]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[3]),.cout(ripple[3]));
alu_top a4(.cin(ripple[3]), .src1(src1[4]), .src2(src2[4]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[4]),.cout(ripple[4]));
alu_top a5(.cin(ripple[4]), .src1(src1[5]), .src2(src2[5]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[5]),.cout(ripple[5]));
alu_top a6(.cin(ripple[5]), .src1(src1[6]), .src2(src2[6]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[6]),.cout(ripple[6]));
alu_top a7(.cin(ripple[6]), .src1(src1[7]), .src2(src2[7]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[7]),.cout(ripple[7]));
alu_top a8(.cin(ripple[7]), .src1(src1[8]), .src2(src2[8]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[8]),.cout(ripple[8]));
alu_top a9(.cin(ripple[8]), .src1(src1[9]), .src2(src2[9]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[9]),.cout(ripple[9]));
alu_top a10(.cin(ripple[9]), .src1(src1[10]), .src2(src2[10]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[10]),.cout(ripple[10]));
alu_top a11(.cin(ripple[10]), .src1(src1[11]), .src2(src2[11]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[11]),.cout(ripple[11]));
alu_top a12(.cin(ripple[11]), .src1(src1[12]), .src2(src2[12]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[12]),.cout(ripple[12]));
alu_top a13(.cin(ripple[12]), .src1(src1[13]), .src2(src2[13]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[13]),.cout(ripple[13]));
alu_top a14(.cin(ripple[13]), .src1(src1[14]), .src2(src2[14]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[14]),.cout(ripple[14]));
alu_top a15(.cin(ripple[14]), .src1(src1[15]), .src2(src2[15]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[15]),.cout(ripple[15]));
alu_top a16(.cin(ripple[15]), .src1(src1[16]), .src2(src2[16]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[16]),.cout(ripple[16]));
alu_top a17(.cin(ripple[16]), .src1(src1[17]), .src2(src2[17]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[17]),.cout(ripple[17]));
alu_top a18(.cin(ripple[17]), .src1(src1[18]), .src2(src2[18]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[18]),.cout(ripple[18]));
alu_top a19(.cin(ripple[18]), .src1(src1[19]), .src2(src2[19]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[19]),.cout(ripple[19]));
alu_top a20(.cin(ripple[19]), .src1(src1[20]), .src2(src2[20]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[20]),.cout(ripple[20]));
alu_top a21(.cin(ripple[20]), .src1(src1[21]), .src2(src2[21]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[21]),.cout(ripple[21]));
alu_top a22(.cin(ripple[21]), .src1(src1[22]), .src2(src2[22]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[22]),.cout(ripple[22]));
alu_top a23(.cin(ripple[22]), .src1(src1[23]), .src2(src2[23]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[23]),.cout(ripple[23]));
alu_top a24(.cin(ripple[23]), .src1(src1[24]), .src2(src2[24]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[24]),.cout(ripple[24]));
alu_top a25(.cin(ripple[24]), .src1(src1[25]), .src2(src2[25]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[25]),.cout(ripple[25]));
alu_top a26(.cin(ripple[25]), .src1(src1[26]), .src2(src2[26]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[26]),.cout(ripple[26]));
alu_top a27(.cin(ripple[26]), .src1(src1[27]), .src2(src2[27]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[27]),.cout(ripple[27]));
alu_top a28(.cin(ripple[27]), .src1(src1[28]), .src2(src2[28]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[28]),.cout(ripple[28]));
alu_top a29(.cin(ripple[28]), .src1(src1[29]), .src2(src2[29]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[29]),.cout(ripple[29]));
alu_top a30(.cin(ripple[29]), .src1(src1[30]), .src2(src2[30]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[30]),.cout(ripple[30]));
alu_bottom b0(.cin(ripple[30]), .src1(src1[31]), .src2(src2[31]), .less(constant), .operation(ALU_control[1:0]), .B_invert(ALU_control[2]), .A_invert(ALU_control[3]),.result(alu_result[31]),.cout(ripple[31]) ,.set(set));

endmodule
