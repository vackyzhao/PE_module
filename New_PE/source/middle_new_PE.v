`timescale 1ns / 1ps

module middle_new_PE (
    input clk,          // PE时钟 (3倍频clk时钟)
    input rst_n,        // 复位信号，低有效
    input en,           // 使能信号，高有效    

    input [7:0] Ifmap_shift_in_2,  // 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [7:0] Ifmap_shift_in_1,  // 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [7:0] Ifmap_shift_in_0,  // 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    input [11:0] Filtr_in_2,       // 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)    
    input [11:0] Filtr_in_1,       // 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    input [11:0] Filtr_in_0,       // 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    output [7:0] Ifmap_shift_out_2,  // 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    output [7:0] Ifmap_shift_out_1,  // 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)

    output reg [7:0]  Psum_out,           // 输出计算结果

    output [11:0] Filtr_out_2,       // 输出权重 4位*3通道（卷积核）
    output [11:0] Filtr_out_1,       // 输出权重 4位*3通道（卷积核）
    output [11:0] Filtr_out_0        // 输出权重 4位*3通道（卷积核）
);

wire [13:0] Psum_1;  // 内部传递运算结果
wire [13:0] Psum_0;  // 内部传递运算结果

// 输入信号，范围为0到2^13-1
wire [13:0] Psum_out_tmp;

wire [7:0] unused_signal;  // 创建一个无连接的临时信号

// 组合逻辑块，根据输入范围设置输出
always @(*) begin
    if (Psum_out_tmp < 64) begin
        // 如果输入小于64，直接将输出设置为输入的低8位
        Psum_out = Psum_out_tmp[7:0];
    end else if (Psum_out_tmp < 4096) begin
        // 如果输入在64到4095之间，右移5位（除以32），并加上64-2
        Psum_out = (Psum_out_tmp >> 5) + 64 - 2;
    end else if (Psum_out_tmp < 8192) begin
        // 如果输入在4096到8191之间，右移7位（除以128），并加上128+32-2
        Psum_out = (Psum_out_tmp >> 7) + 128 + 32 - 2;
    end else if (Psum_out_tmp < 16384) begin
        // 如果输入在8192到16383之间，右移8位（除以256），并加上128+32-2
        Psum_out = (Psum_out_tmp >> 8) + 128 + 32 - 2;
    end else begin
        // 处理任何其他情况，将输出设置为0
        Psum_out = 8'b0;
    end
end

new_PE_Unit new_PE_Unit_2 (
    .clk(clk),  // PE时钟
    .rst_n(rst_n),  // 复位信号，低有效
    .en(en),  // 使能信号，高有效   

    .Filtr_in(Filtr_in_2),  // 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)   
    .Ifmap_shift_in(Ifmap_shift_in_2),  // 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Psum_in(Psum_1),
    .Filtr_out(Filtr_out_2),

    .Ifmap_shift_out(unused_signal),  // 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Psum_out(Psum_out_tmp)  // 输出计算结果   
);

new_PE_Unit new_PE_Unit_1 (
    .clk(clk),  // PE时钟
    .rst_n(rst_n),  // 复位信号，低有效
    .en(en),  // 使能信号，高有效   

    .Filtr_in(Filtr_in_1),  // 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)   
    .Ifmap_shift_in(Ifmap_shift_in_1),  // 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Psum_in(Psum_0),
    .Filtr_out(Filtr_out_1),

    .Ifmap_shift_out(Ifmap_shift_out_2),  // 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Psum_out(Psum_1)  // 输出计算结果   
);

new_PE_Unit new_PE_Unit_0 (
    .clk(clk),  // PE时钟
    .rst_n(rst_n),  // 复位信号，低有效
    .en(en),  // 使能信号，高有效   

    .Filtr_in(Filtr_in_0),  // 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)   
    .Ifmap_shift_in(Ifmap_shift_in_0),  // 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Psum_in(14'b0),
    .Filtr_out(Filtr_out_0),

    .Ifmap_shift_out(Ifmap_shift_out_1),  // 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Psum_out(Psum_0)  // 输出计算结果   
);

endmodule
