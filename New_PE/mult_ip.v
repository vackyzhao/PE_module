`timescale 1ns / 1ps
module mult_ip(
    input  CLK,
    input  CE,
    input  [7:0] A,
    input  [3:0] B,
    output   [11:0] P
);
mult_gen_0 mult_test_0(
   .CLK(CLK),
   .CE(CE),
    .A(A),
    .B(B),
    .P(P)
);
endmodule