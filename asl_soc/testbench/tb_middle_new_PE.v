`timescale 1ns / 1ps
module tb_middle_new_PE();
 
 reg clk;
 reg rst_n;
 reg en;

reg [13:0] Psum_in =14'd0;

 reg [7:0] Ifmap_shift_in_2 = 0;
 reg [7:0] Ifmap_shift_in_1 = 0;
 reg [7:0] Ifmap_shift_in_0 = 0;

 reg [11:0] Filtr_in_2 = 0;
 reg [11:0] Filtr_in_1 = 0;
 reg [11:0] Filtr_in_0 = 0;

 wire [7:0] Ifmap_shift_out_2;
 wire [7:0] Ifmap_shift_out_1;

 wire [13:0] Psum_out;
 wire result_out_en;



 
middle_new_PE tb_middle_new_PE(
    .clk(clk),  //PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效 

    .Psum_in(Psum_in),

    .Ifmap_shift_in_2(Ifmap_shift_in_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_shift_in_1(Ifmap_shift_in_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_shift_in_0(Ifmap_shift_in_0),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    .Filtr_in_2(Filtr_in_2),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_1(Filtr_in_1),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_0(Filtr_in_0),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .Ifmap_shift_out_2(Ifmap_shift_out_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_shift_out_1(Ifmap_shift_out_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)

    .Psum_out(Psum_out),  //输出计算结果
    
    .result_out_en(result_out_en)
);


 parameter Tclk = 10;
 
 initial begin
 // define clk
clk = 0;
 forever #(Tclk / 2) clk = ~clk;
 end
 
 initial begin
 // define rst and en
 rst_n = 0;
 en = 0;
 Filtr_in_2 = {{4'd1},{4'd2},{4'd3}};
 Filtr_in_1 = {{4'd4},{4'd5},{4'd6}};
 Filtr_in_0 = {{4'd7},{4'd8},{4'd9}};
 #(Tclk * 2) rst_n = 1;
 #(Tclk) en = 1;



 #(Tclk * 10)
 Ifmap_shift_in_2 = {8'd0};
 Ifmap_shift_in_1 = {8'd0};
 Ifmap_shift_in_0 = {8'd7};
 #(Tclk * 1)
 Ifmap_shift_in_2 = {8'd0};
 Ifmap_shift_in_1 = {8'd4};
 Ifmap_shift_in_0 = {8'd8};
 #(Tclk * 1)
 Ifmap_shift_in_2 = {8'd1};
 Ifmap_shift_in_1 = {8'd5};
 Ifmap_shift_in_0 = {8'd9};
  #(Tclk * 1)
 Ifmap_shift_in_2 = {8'd2};
 Ifmap_shift_in_1 = {8'd6};
 Ifmap_shift_in_0 = {8'd0};
  #(Tclk * 1)
 Ifmap_shift_in_2 = {8'd3};
 Ifmap_shift_in_1 = {8'd0};
 Ifmap_shift_in_0 = {8'd0};
 #(Tclk * 30)
  $stop;
 end
 
endmodule