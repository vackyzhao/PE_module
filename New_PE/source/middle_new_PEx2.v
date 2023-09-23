`timescale 1ns / 1ps
module middle_new_PEx2(    
    
    input clk,  //PE 时钟(3倍频clk时钟)
    input rst_n,  //复位信号，低有效
    input en,  //使能信号，高有效 


    input [7:0] Ifmap_shift_in_0_2,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [7:0] Ifmap_shift_in_0_1,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [7:0] Ifmap_shift_in_0_0,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    input [7:0] Ifmap_shift_in_1_0,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    input [11:0] Filtr_in_2,// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)    
    input [11:0] Filtr_in_1,//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    input [11:0] Filtr_in_0,// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    
   
    output   [13:0] Psum_out_0,  //输出计算结果
    output   [13:0] Psum_out_1  //输出计算结果
);


wire [11:0] Filtr_0_2;
wire [11:0] Filtr_0_1;
wire [11:0] Filtr_0_0;

wire [7:0] Ifmap_shift_0_2;
wire [7:0] Ifmap_shift_0_1;

middle_new_PE middle_new_PE_0(
    .clk(clk),  //PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效 

    .Psum_in(14'b0),

    .Ifmap_shift_in_2(Ifmap_shift_in_0_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_shift_in_1(Ifmap_shift_in_0_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_shift_in_0(Ifmap_shift_in_0_0),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    .Filtr_in_2(Filtr_in_2),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_1(Filtr_in_1),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_0(Filtr_in_0),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .Ifmap_shift_out_2(Ifmap_shift_0_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_shift_out_1(Ifmap_shift_0_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)

    .Psum_out(Psum_out_0),  //输出计算结果
    
    .Filtr_out_2(Filtr_0_2),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_out_1(Filtr_0_1),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_out_0(Filtr_0_0),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .result_out_en()
);

middle_new_PE middle_new_PE_1(
    .clk(clk),  //PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效 

    .Psum_in(14'b0),

    .Ifmap_shift_in_2(Ifmap_shift_0_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_shift_in_1(Ifmap_shift_0_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_shift_in_0(Ifmap_shift_in_1_0),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    .Filtr_in_2(Filtr_0_2),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_1(Filtr_0_1),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_0(Filtr_0_0),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .Ifmap_shift_out_2(Ifmap_shift_out_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_shift_out_1(Ifmap_shift_out_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)

    .Psum_out(Psum_out_1),  //输出计算结果

    .Filtr_out_2(),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_out_1(),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_out_0(),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
 
    
    .result_out_en()
);

endmodule 