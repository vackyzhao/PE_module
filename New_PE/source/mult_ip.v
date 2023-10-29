`timescale 1ns / 1ps

module mult_ip(
    input  CLK,       // 时钟输入
    input  CE,        // 使能输入
    input  [7:0] A,   // 8位无符号整数 A 输入
    input  [3:0] B,   // 4位无符号整数 B 输入
    output   reg[11:0] P // 12位无符号整数乘法结果 P 输出
);
//unused ip
/*
mult_gen_0 mult_8x4_1 (
  .CLK(CLK),
  .CE(CE),
  .A(A),
  .B(B),
  .P(P)
);
*/

// 使用 always_ff 块，根据使能信号 CE 控制乘法操作
always@(posedge CLK or negedge CE) begin
    if (!CE) begin
        P <= 12'b0; // 如果 CE 为低电平，将 P 清零
    end else begin
        // 执行无符号整数乘法操作，将 A 和 B 视为无符号数
        P <= $unsigned(A) * $unsigned(B);
    end
end

endmodule
