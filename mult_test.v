`timescale 1ns / 1ps
module mult_test(
    input clk,
    input rst_n,
    input en,
    input [7:0] A,
    input [3:0] B,
    output [11:0] P
);
mult_8x4 mult_8x4_0 (
  .CLK(clk),  // input wire CLK
  .A(A),      // input wire [7 : 0] A
  .B(B),      // input wire [3 : 0] B
  .CE(en),    // input wire CE
  .P(P)      // output wire [11 : 0] P
);
endmodule