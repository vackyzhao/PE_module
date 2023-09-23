`timescale 1ns / 1ps
module tb_3x3_PE_Unit();
 
 reg PE_clk;
 reg rst_n;
 reg en;

 reg [23:0] Ifmap_in_1 = 0;
 reg [23:0] Ifmap_in_2 = 0;
 reg [23:0] Ifmap_in_3 = 0;

 reg [11:0] Filtr_in_1 = 0;
 reg [11:0] Filtr_in_2 = 0;
 reg [11:0] Filtr_in_3 = 0;

 wire [19:0] Conv_result;
 wire PE_out_clk;
 wire [23:0] Ifmap_out_1;
 wire [23:0] Ifmap_out_2;


 
PEx3_module tb_PEx3_module(
    .PE_clk(PE_clk),  //PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效 

    .Ifmap_in_1(Ifmap_in_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_2(Ifmap_in_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_3(Ifmap_in_3),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .Ifmap_out_1(Ifmap_out_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_out_2(Ifmap_out_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Conv_result(Conv_result),  //输出计算结果
    .PE_out_clk(PE_out_clk)
);


 parameter Tclk = 10;
 
 initial begin
 // define clk
 PE_clk = 0;
 forever #(Tclk / 2) PE_clk = ~PE_clk;
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
 Filtr_in_1 = {{4'b0001},{4'b0010},{4'b0011}};
 Filtr_in_2 = {{4'b0100},{4'b0101},{4'b0110}};
 Filtr_in_3 = {{4'b0111},{4'b1000},{4'b1001}};

 #(Tclk * 3)
 Ifmap_in_3 = {{8'b0000_0011},{8'b0000_0001},{8'b0000_0001}};
 #(Tclk * 3)
 Ifmap_in_2 = {{8'b0000_0001},{8'b0000_0001},{8'b0000_0001}};
 #(Tclk * 3)
 Ifmap_in_1 = {{8'b0000_0001},{8'b0000_0001},{8'b0000_0001}};
 end
 
endmodule