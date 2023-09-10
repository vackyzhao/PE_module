`timescale 1ns / 1ps
module PE_28x3_module (
    input clk,  //PE 时钟(3倍频clk时钟)
    input rst_n,  //复位信号，低有效
    input en,  //使能信号，高有效 

    input [11:0] Filtr_in_1,// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    input [11:0] Filtr_in_2,//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    input [11:0] Filtr_in_3,// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    input [23:0] Ifmap_in_1_1,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_1_2,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_1_3,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_2,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_3,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_4,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)    
    input [23:0] Ifmap_in_5,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_6,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_7,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data) 
    input [23:0] Ifmap_in_8,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_9,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_10,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)    
    input [23:0] Ifmap_in_11,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_12,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_13,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data) 
    input [23:0] Ifmap_in_14,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_15,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_16,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)    
    input [23:0] Ifmap_in_17,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_18,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_19,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data) 
    input [23:0] Ifmap_in_20,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_21,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_22,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)    
    input [23:0] Ifmap_in_23,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_24,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_25,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data) 
    input [23:0] Ifmap_in_26,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)    
    input [23:0] Ifmap_in_27,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_28,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    output [19:0] Conv_result_1,   //输出计算结果
    output [19:0] Conv_result_2,   //输出计算结果
    output [19:0] Conv_result_3,   //输出计算结果
    output [19:0] Conv_result_4,   //输出计算结果
    output [19:0] Conv_result_5,   //输出计算结果
    output [19:0] Conv_result_6,   //输出计算结果
    output [19:0] Conv_result_7,   //输出计算结果
    output [19:0] Conv_result_8,   //输出计算结果
    output [19:0] Conv_result_9,   //输出计算结果
    output [19:0] Conv_result_10,  //输出计算结果
    output [19:0] Conv_result_11,  //输出计算结果
    output [19:0] Conv_result_12,  //输出计算结果
    output [19:0] Conv_result_13,  //输出计算结果
    output [19:0] Conv_result_14,  //输出计算结果
    output [19:0] Conv_result_15,  //输出计算结果
    output [19:0] Conv_result_16,  //输出计算结果
    output [19:0] Conv_result_17,  //输出计算结果
    output [19:0] Conv_result_18,  //输出计算结果
    output [19:0] Conv_result_19,  //输出计算结果
    output [19:0] Conv_result_20,  //输出计算结果
    output [19:0] Conv_result_21,  //输出计算结果
    output [19:0] Conv_result_22,  //输出计算结果
    output [19:0] Conv_result_23,  //输出计算结果
    output [19:0] Conv_result_24,  //输出计算结果
    output [19:0] Conv_result_25,  //输出计算结果
    output [19:0] Conv_result_26,  //输出计算结果
    output [19:0] Conv_result_27,  //输出计算结果
    output [19:0] Conv_result_28,  //输出计算结果

    output reg PE_out_clk  // 输出的3分频时钟信号 (Output 3x frequency clock signal)
);

  wire [23:0] Ifmap_out_1_1;
  wire [23:0] Ifmap_out_1_2;
  wire [23:0] Ifmap_out_2_1;
  wire [23:0] Ifmap_out_2_2;
  wire [23:0] Ifmap_out_3_1;
  wire [23:0] Ifmap_out_3_2;
  wire [23:0] Ifmap_out_4_1;
  wire [23:0] Ifmap_out_4_2;
  wire [23:0] Ifmap_out_5_1;
  wire [23:0] Ifmap_out_5_2;
  wire [23:0] Ifmap_out_6_1;
  wire [23:0] Ifmap_out_6_2;
  wire [23:0] Ifmap_out_7_1;
  wire [23:0] Ifmap_out_7_2;
  wire [23:0] Ifmap_out_8_1;
  wire [23:0] Ifmap_out_8_2;
  wire [23:0] Ifmap_out_9_1;
  wire [23:0] Ifmap_out_9_2;
  wire [23:0] Ifmap_out_10_1;
  wire [23:0] Ifmap_out_10_2;
  wire [23:0] Ifmap_out_11_1;
  wire [23:0] Ifmap_out_11_2;
  wire [23:0] Ifmap_out_12_1;
  wire [23:0] Ifmap_out_12_2;
  wire [23:0] Ifmap_out_13_1;
  wire [23:0] Ifmap_out_13_2;
  wire [23:0] Ifmap_out_14_1;
  wire [23:0] Ifmap_out_14_2;
  wire [23:0] Ifmap_out_15_1;
  wire [23:0] Ifmap_out_15_2;
  wire [23:0] Ifmap_out_16_1;
  wire [23:0] Ifmap_out_16_2;
  wire [23:0] Ifmap_out_17_1;
  wire [23:0] Ifmap_out_17_2;
  wire [23:0] Ifmap_out_18_1;
  wire [23:0] Ifmap_out_18_2;
  wire [23:0] Ifmap_out_19_1;
  wire [23:0] Ifmap_out_19_2;
  wire [23:0] Ifmap_out_20_1;
  wire [23:0] Ifmap_out_20_2;
  wire [23:0] Ifmap_out_21_1;
  wire [23:0] Ifmap_out_21_2;
  wire [23:0] Ifmap_out_22_1;
  wire [23:0] Ifmap_out_22_2;
  wire [23:0] Ifmap_out_23_1;
  wire [23:0] Ifmap_out_23_2;
  wire [23:0] Ifmap_out_24_1;
  wire [23:0] Ifmap_out_24_2;
  wire [23:0] Ifmap_out_25_1;
  wire [23:0] Ifmap_out_25_2;
  wire [23:0] Ifmap_out_26_1;
  wire [23:0] Ifmap_out_26_2;
  wire [23:0] Ifmap_out_27_1;
  wire [23:0] Ifmap_out_27_2;

  PEx3_module PEx3_module_1 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_in_1_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_in_1_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_1_3),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_1_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_1_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_1),  //输出计算结果
      .PE_out_clk()
  );

  PEx3_module PEx3_module_2 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_1_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_1_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_2_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_2_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_2),  //输出计算结果
      .PE_out_clk()
  );
  PEx3_module PEx3_module_3 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_2_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_2_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_3),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_3_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_3_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_3),  //输出计算结果
      .PE_out_clk()
  );
  PEx3_module PEx3_module_4 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_3_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_3_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_4),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_4_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_4_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_4),  //输出计算结果
      .PE_out_clk()
  );
  PEx3_module PEx3_module_5 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_4_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_4_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_5),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_5_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_5_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_5),  //输出计算结果
      .PE_out_clk()
  );

  PEx3_module PEx3_module_6 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_5_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_5_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_6),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_6_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_6_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_6),  //输出计算结果
      .PE_out_clk()
  );

  PEx3_module PEx3_module_7 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_6_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_6_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_7),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_7_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_7_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_7),  //输出计算结果
      .PE_out_clk()
  );

  PEx3_module PEx3_module_8 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_7_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_7_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_8),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_8_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_8_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_8),  //输出计算结果
      .PE_out_clk()
  );

  PEx3_module PEx3_module_9 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_8_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_8_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_9),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_9_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_9_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_9),  //输出计算结果
      .PE_out_clk()
  );
  PEx3_module PEx3_module_10 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_9_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_9_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_10),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_10_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_10_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_10),  //输出计算结果
      .PE_out_clk()
  );

  PEx3_module PEx3_module_11 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_10_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_10_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_11),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_11_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_11_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_11),  //输出计算结果
      .PE_out_clk()
  );

  PEx3_module PEx3_module_12 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_11_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_11_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_12),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_12_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_12_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_12),  //输出计算结果
      .PE_out_clk()
  );

  PEx3_module PEx3_module_13 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_12_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_12_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_13),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_13_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_13_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_13),  //输出计算结果
      .PE_out_clk()
  );

  PEx3_module PEx3_module_14 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_13_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_13_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_14),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_14_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_14_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_14),  //输出计算结果
      .PE_out_clk()
  );

  PEx3_module PEx3_module_15 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_14_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_14_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_15),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_15_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_15_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_15),  //输出计算结果
      .PE_out_clk()
  );

  PEx3_module PEx3_module_16 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_15_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_15_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_16),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_16_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_16_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_16),  //输出计算结果
      .PE_out_clk()
  );

  PEx3_module PEx3_module_17 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_16_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_16_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_17),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_17_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_17_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_17),  //输出计算结果
      .PE_out_clk()
  );

  PEx3_module PEx3_module_18 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_17_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_17_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_18),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_18_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_18_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_18),  //输出计算结果
      .PE_out_clk()
  );

  PEx3_module PEx3_module_19 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_18_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_18_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_19),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_19_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_19_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_19),  //输出计算结果
      .PE_out_clk()
  );

  PEx3_module PEx3_module_20 (
      .PE_clk(clk),  //PE 时钟(3倍频clk时钟)
      .rst_n(rst_n),  //复位信号，低有效
      .en(en),  //使能信号，高有效 

      .Ifmap_in_1(Ifmap_out_19_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_2(Ifmap_out_19_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_in_3(Ifmap_in_20),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_2(Filtr_in_2),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_out_1(Ifmap_out_20_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_out_2(Ifmap_out_20_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Conv_result(Conv_result_20),  //输出计算结果
      .PE_out_clk()
  );

  PEx3_module PEx3_module_21 (
    .PE_clk(clk),  // PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  // 复位信号，低有效
    .en(en),  // 使能信号，高有效 

    .Ifmap_in_1(Ifmap_out_20_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_2(Ifmap_out_20_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_3(Ifmap_in_21),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_2(Filtr_in_2),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .Ifmap_out_1(Ifmap_out_21_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_out_2(Ifmap_out_21_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Conv_result(Conv_result_21),  // 输出计算结果
    .PE_out_clk()
);

PEx3_module PEx3_module_22 (
    .PE_clk(clk),  // PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  // 复位信号，低有效
    .en(en),  // 使能信号，高有效 

    .Ifmap_in_1(Ifmap_out_21_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_2(Ifmap_out_21_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_3(Ifmap_in_22),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_2(Filtr_in_2),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .Ifmap_out_1(Ifmap_out_22_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_out_2(Ifmap_out_22_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Conv_result(Conv_result_22),  // 输出计算结果
    .PE_out_clk()
);

PEx3_module PEx3_module_23 (
    .PE_clk(clk),  // PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  // 复位信号，低有效
    .en(en),  // 使能信号，高有效 

    .Ifmap_in_1(Ifmap_out_22_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_2(Ifmap_out_22_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_3(Ifmap_in_23),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_2(Filtr_in_2),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .Ifmap_out_1(Ifmap_out_23_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_out_2(Ifmap_out_23_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Conv_result(Conv_result_23),  // 输出计算结果
    .PE_out_clk()
);

PEx3_module PEx3_module_24 (
    .PE_clk(clk),  // PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  // 复位信号，低有效
    .en(en),  // 使能信号，高有效 

    .Ifmap_in_1(Ifmap_out_23_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_2(Ifmap_out_23_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_3(Ifmap_in_24),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_2(Filtr_in_2),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .Ifmap_out_1(Ifmap_out_24_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_out_2(Ifmap_out_24_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Conv_result(Conv_result_24),  // 输出计算结果
    .PE_out_clk()
);

PEx3_module PEx3_module_25 (
    .PE_clk(clk),  // PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  // 复位信号，低有效
    .en(en),  // 使能信号，高有效 

    .Ifmap_in_1(Ifmap_out_24_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_2(Ifmap_out_24_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_3(Ifmap_in_25),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_2(Filtr_in_2),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .Ifmap_out_1(Ifmap_out_25_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_out_2(Ifmap_out_25_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Conv_result(Conv_result_25),  // 输出计算结果
    .PE_out_clk()
);

PEx3_module PEx3_module_26 (
    .PE_clk(clk),  // PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  // 复位信号，低有效
    .en(en),  // 使能信号，高有效 

    .Ifmap_in_1(Ifmap_out_25_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_2(Ifmap_out_25_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_3(Ifmap_in_26),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_2(Filtr_in_2),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .Ifmap_out_1(Ifmap_out_26_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_out_2(Ifmap_out_26_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Conv_result(Conv_result_26),  // 输出计算结果
    .PE_out_clk()
);

PEx3_module PEx3_module_27 (
    .PE_clk(clk),  // PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  // 复位信号，低有效
    .en(en),  // 使能信号，高有效 

    .Ifmap_in_1(Ifmap_out_26_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_2(Ifmap_out_26_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_3(Ifmap_in_27),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_2(Filtr_in_2),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .Ifmap_out_1(Ifmap_out_27_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_out_2(Ifmap_out_27_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Conv_result(Conv_result_27),  // 输出计算结果
    .PE_out_clk()
);

PEx3_module PEx3_module_28 (
    .PE_clk(clk),  // PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  // 复位信号，低有效
    .en(en),  // 使能信号，高有效 

    .Ifmap_in_1(Ifmap_out_27_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_2(Ifmap_out_27_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_in_3(Ifmap_in_28),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_2(Filtr_in_2),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_3(Filtr_in_3),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .Ifmap_out_1(),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_out_2(),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Conv_result(Conv_result_28),  // 输出计算结果
    .PE_out_clk()
);


endmodule
