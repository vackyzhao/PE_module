`timescale 1ns / 1ps
module middle_new_PE(
    input clk,  //PE 时钟(3倍频clk时钟)
    input rst_n,  //复位信号，低有效
    input en,  //使能信号，高有效 

    input [13:0] Psum_in,

    input [7:0] Ifmap_shift_in_2,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [7:0] Ifmap_shift_in_1,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [7:0] Ifmap_shift_in_0,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    input [11:0] Filtr_in_2,// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)    
    input [11:0] Filtr_in_1,//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    input [11:0] Filtr_in_0,// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    
    output [7:0] Ifmap_shift_out_2,// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    output [7:0] Ifmap_shift_out_1,// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
   
    output  [13:0] Psum_out,  //输出计算结果
    output  result_out_en  // 输出有效信号

);
  wire [13:0] Psum_1; //内部传递运算结果
  wire [13:0] Psum_0; //内部传递运算结果



new_PE_Unit new_PE_Unit_2(
    .clk(clk),  //PE 时钟
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效   

    .Filtr_in(Filtr_in_2),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)   
    .Ifmap_shift_in(Ifmap_shift_in_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Psum_in(Psum_1),

    .Ifmap_shift_out(),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Psum_out(Psum_out)  //输出计算结果   
);
new_PE_Unit new_PE_Unit_1(
    .clk(clk),  //PE 时钟
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效   

    .Filtr_in(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)   
    .Ifmap_shift_in(Ifmap_shift_in_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Psum_in(Psum_0),

    .Ifmap_shift_out(Ifmap_shift_out_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Psum_out(Psum_1)  //输出计算结果   
);

new_PE_Unit new_PE_Unit_0(
    .clk(clk),  //PE 时钟
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效   

    .Filtr_in(Filtr_in_0),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)   
    .Ifmap_shift_in(Ifmap_shift_in_0),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Psum_in(Psum_in),

    .Ifmap_shift_out(Ifmap_shift_out_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Psum_out(Psum_0)  //输出计算结果   
);
endmodule