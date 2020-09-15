`timescale 1ns/10ps
module marquee(
  clk,
  rst,
  indataA,
  indataB,
  outdata
  );

input clk;
input rst;  
input  [2:0] indataA;
input  [2:0] indataB;
output [5:0] outdata;

reg [1:0] counter;
reg [5:0] out;

always@(posedge clk)begin
    if(rst == 1) counter <= 2'b0;
    else counter <= counter + 1;
end

always@(*) begin
    if(counter == 0) out = indataA | indataB;
    else if(counter == 1) out = indataA & indataB;
    else if(counter == 2) out = indataA ^ indataB;
    else if(counter == 3) out = {indataA, indataB};
end

assign outdata = out;

endmodule
