`timescale 1ns / 1ps
module mult_ip_conv2(
    input  CLK,
    input  CE,
    input  signed   [7:0] A,
    input  signed  [7:0] B,
    output   [19:0] P
);
//assign  P=$unsigned(A) * $unsigned(B);
assign  P=$signed(A) * $signed(B);
endmodule