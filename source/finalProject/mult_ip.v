`timescale 1ns / 1ps
module mult_ip(
    input  CLK,
    input  CE,
    input  signed [7:0] A,
    input  signed [7:0] B,
    output reg signed [15:0] P
);

reg signed [15:0] P_reg;
initial begin
    P=16'd0;
    P_reg=16'd0;
end
always @(*) begin
        P<= A * B;  // 第一拍计算结果
end

endmodule
