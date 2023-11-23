`timescale 1ns / 1ps
module mult_ip_conv1(
    input  CLK,
    input  CE,
    input  unsigned [7:0] A,
    input  signed  [7:0] B,
    output   [19:0] P
);
assign  P=$signed($unsigned(A) * $signed(B));
endmodule