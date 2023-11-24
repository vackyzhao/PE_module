`timescale 1ns / 1ps

module middle_new_PE_conv1 (
    input clk,          // PE时钟 (3倍频clk时钟)
    input rst_n,        // 复位信号，低有效
    input en,           // 使能信号，高有效    

    input [7:0] Ifmap_shift_in_2,  // 输入特征�? 8�?*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [7:0] Ifmap_shift_in_1,  // 输入特征�? 8�?*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [7:0] Ifmap_shift_in_0,  // 输入特征�? 8�?*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    input [23:0] Filtr_in_2,       // 输入权重 4�?*3通道（卷积核�? (Input weights 4-bit * 3 channels, convolution kernel)    
    input [23:0] Filtr_in_1,       // 输入权重 4�?*3通道（卷积核�? (Input weights 4-bit * 3 channels, convolution kernel)
    input [23:0] Filtr_in_0,       // 输入权重 4�?*3通道（卷积核�? (Input weights 4-bit * 3 channels, convolution kernel)

    output [7:0] Ifmap_shift_out_2,  // 输出特征�? 8�?*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    output [7:0] Ifmap_shift_out_1,  // 输出特征�? 8�?*3通道（数据） (Output feature map 8-bit * 3 channels, data)

    output [19:0] Psum_out,           // 输出计算结果

    output [23:0] Filtr_out_2,       // 输出权重 4�?*3通道（卷积核�?
    output [23:0] Filtr_out_1,       // 输出权重 4�?*3通道（卷积核�?
    output [23:0] Filtr_out_0        // 输出权重 4�?*3通道（卷积核�?
);

wire [19:0] Psum_1;  // 内部传�?�运算结�?
wire [19:0] Psum_0;  // 内部传�?�运算结�?

wire [7:0] unused_signal;  // 创建�?个无连接的临时信�?



new_PE_Unit_conv1 new_PE_Unit_2 (
    .clk(clk),  // PE时钟
    .rst_n(rst_n),  // 复位信号，低有效
    .en(en),  // 使能信号，高有效   

    .Filtr_in(Filtr_in_2),  // 输入权重 4�?*3通道（卷积核�? (Input weights 4-bit * 3 channels, convolution kernel)   
    .Ifmap_shift_in(Ifmap_shift_in_2),  // 输入特征�? 8�?*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Psum_in(Psum_1),
    .Filtr_out(Filtr_out_2),

    .Ifmap_shift_out(unused_signal),  // 输出特征�? 8�?*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Psum_out(Psum_out)  // 输出计算结果   
);

new_PE_Unit_conv1 new_PE_Unit_1 (
    .clk(clk),  // PE时钟
    .rst_n(rst_n),  // 复位信号，低有效
    .en(en),  // 使能信号，高有效   

    .Filtr_in(Filtr_in_1),  // 输入权重 4�?*3通道（卷积核�? (Input weights 4-bit * 3 channels, convolution kernel)   
    .Ifmap_shift_in(Ifmap_shift_in_1),  // 输入特征�? 8�?*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Psum_in(Psum_0),
    .Filtr_out(Filtr_out_1),

    .Ifmap_shift_out(Ifmap_shift_out_2),  // 输出特征�? 8�?*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Psum_out(Psum_1)  // 输出计算结果   
);

new_PE_Unit_conv1 new_PE_Unit_0 (
    .clk(clk),  // PE时钟
    .rst_n(rst_n),  // 复位信号，低有效
    .en(en),  // 使能信号，高有效   

    .Filtr_in(Filtr_in_0),  // 输入权重 4�?*3通道（卷积核�? (Input weights 4-bit * 3 channels, convolution kernel)   
    .Ifmap_shift_in(Ifmap_shift_in_0),  // 输入特征�? 8�?*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Psum_in(20'b0),
    .Filtr_out(Filtr_out_0),

    .Ifmap_shift_out(Ifmap_shift_out_1),  // 输出特征�? 8�?*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Psum_out(Psum_0)  // 输出计算结果   
);

endmodule
