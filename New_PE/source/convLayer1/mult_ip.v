`timescale 1ns / 1ps
module mult_ip(
    input  CLK,
    input  CE,
    input  [7:0] A,
    input  [3:0] B,
    output   [11:0] P
);
//assign  P=$unsigned(A) * $unsigned(B);
assign  P=$signed(A) * $signed(B);
endmodule