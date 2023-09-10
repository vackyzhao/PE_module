`timescale 1ns / 1ps


module top_3x3_PE_Unit(
 input clk,
 input rst,
 input en,
 input [23:0] Ifmap_in_1,
 input [23:0] Ifmap_in_2,
 input [23:0] Ifmap_in_3,
 input [23:0] Ifmap_in_4,
 input [23:0] Ifmap_in_5,

 input [11:0] Filtr_in_1,
 input [11:0] Filtr_in_2,
 input [11:0] Filtr_in_3,
 
 output [19:0] Conv_result_1,
 output [19:0] Conv_result_2,
 output [19:0] Conv_result_3
 );
 
 wire [19:0] Psum_out[2:0][2:0];
 wire [23:0] Ifmap_out[2:0][2:0];
 
 PE_Unit u00(
 .clk(clk), .rst(rst), .en(en),
 .Ifmap_in(Ifmap_in_1), .Filtr_in(Filtr_in_1),
 .Psum_in(Psum_out[1][0]), .Ifmap_out(Ifmap_out[0][0]),
 .Psum_out(Conv_result_1));
 
 PE_Unit u01(
 .clk(clk), .rst(rst), .en(en),
 .Ifmap_in(Ifmap_out[1][0]), .Filtr_in(Filtr_in_1),
 .Psum_in(Psum_out[1][1]), .Ifmap_out(Ifmap_out[0][1]),
 .Psum_out(Conv_result_2));
 
 PE_Unit u02(
 .clk(clk), .rst(rst), .en(en),
 .Ifmap_in(Ifmap_out[1][1]), .Filtr_in(Filtr_in_1),
 .Psum_in(Psum_out[1][2]), .Ifmap_out(Ifmap_out[0][2]),
 .Psum_out(Conv_result_3));
 
 PE_Unit u10(
 .clk(clk), .rst(rst), .en(en),
 .Ifmap_in(Ifmap_in_2), .Filtr_in(Filtr_in_2),
 .Psum_in(Psum_out[2][0]), .Ifmap_out(Ifmap_out[1][0]),
 .Psum_out(Psum_out[1][0]));
 
 PE_Unit u11(
 .clk(clk), .rst(rst), .en(en),
 .Ifmap_in(Ifmap_out[1][0]), .Filtr_in(Filtr_in_2),
 .Psum_in(Psum_out[2][1]), .Ifmap_out(Ifmap_out[1][1]),
 .Psum_out(Psum_out[1][1]));
 
 PE_Unit u12(
 .clk(clk), .rst(rst), .en(en),
 .Ifmap_in(Ifmap_out[1][1]), .Filtr_in(Filtr_in_2),
 .Psum_in(Psum_out[2][2]), .Ifmap_out(Ifmap_out[1][2]),
 .Psum_out(Psum_out[1][2]));
 
 PE_Unit u20(
 .clk(clk), .rst(rst), .en(en),
 .Ifmap_in(Ifmap_in_3), .Filtr_in(Filtr_in_3),
 .Psum_in(0), .Ifmap_out(Ifmap_out[2][0]),
 .Psum_out(Psum_out[2][0]));
 
 PE_Unit u21(
 .clk(clk), .rst(rst), .en(en),
 .Ifmap_in(Ifmap_in_4), .Filtr_in(Filtr_in_3),
 .Psum_in(0), .Ifmap_out(Ifmap_out[2][1]),
 .Psum_out(Psum_out[2][1]));
 
 PE_Unit u22(
 .clk(clk), .rst(rst), .en(en),
 .Ifmap_in(Ifmap_in_5), .Filtr_in(Filtr_in_3),
 .Psum_in(0), .Ifmap_out(Ifmap_out[2][2]),
 .Psum_out(Psum_out[2][2]));
 
endmodule
