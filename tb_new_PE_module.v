`timescale 1ns / 1ps
module tb_new_PE_Unit();
 
 reg clk;
 reg rst_n;
 reg en;

 reg [7:0] Ifmap_in_1 = 0;
 reg [7:0] Ifmap_in_2 = 0;
 reg [7:0] Ifmap_in_3 = 0;

 reg [3:0] Filtr_in_1 = 0;
 reg [3:0] Filtr_in_2 = 0;
 reg [3:0] Filtr_in_3 = 0;

 reg [11:0] Psum_in=0;

 wire [11:0] Psum_out;

 wire [7:0] Ifmap_out_1;
 wire [7:0] Ifmap_out_2;
 wire [7:0] Ifmap_out_3;

new_PE_Unit tb_PEx3_module(
    .clk(clk),  //PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效 

    .Ifmap_in_1(Ifmap_in_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_2(Ifmap_in_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_3(Ifmap_in_3),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .Psum_in(Psum_in),

    .Ifmap_out_1(Ifmap_out_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_out_2(Ifmap_out_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_out_3(Ifmap_out_3),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)

    .Psum_out(Psum_out)  //输出计算结果   
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
 #(Tclk * 2) rst_n = 1;
 #(Tclk) en = 1;
 end
 
 initial begin
 // input data
 Filtr_in_1 = 4'b0001;
 Filtr_in_2 = 4'b0001;
 Filtr_in_3 = 4'b0001;

 #(Tclk * 3)
 Ifmap_in_1=8'b0000_0001;
 Ifmap_in_2=8'b0000_0001;
 Ifmap_in_3=8'b0000_0001;
 end
 
endmodule