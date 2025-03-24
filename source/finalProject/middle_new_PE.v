`timescale 1ns / 1ps
module middle_new_PE(
    input clk,  //PE 时钟(3倍频clk时钟)
    input rst_n,  //复位信号，低有效
    input en,  //使能信号，高有效 

    input signed [7:0] Ifmap_shift_in_2,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input signed [7:0] Ifmap_shift_in_1,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input signed [7:0] Ifmap_shift_in_0,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    input signed[7:0] Filtr_in_2_2, // Unit 2 Channel 2
    input signed[7:0] Filtr_in_2_1, // Unit 2 Channel 1
    input signed[7:0] Filtr_in_2_0, // Unit 2 Channel 0
    input signed[7:0] Filtr_in_1_2, // Unit 1 Channel 2
    input signed[7:0] Filtr_in_1_1, // Unit 1 Channel 1
    input signed[7:0] Filtr_in_1_0, // Unit 1 Channel 0
    input signed[7:0] Filtr_in_0_2, // Unit 0 Channel 2
    input signed[7:0] Filtr_in_0_1, // Unit 0 Channel 1
    input signed[7:0] Filtr_in_0_0, // Unit 0 Channel 0
        
    output signed[7:0] Ifmap_shift_out_2,// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    output signed[7:0] Ifmap_shift_out_1,// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
   
    output  signed[7:0] Psum_out//输出计算结果


);
  wire signed[19:0] Psum_1; //内部传递运算结果
  wire signed[19:0] Psum_0; //内部传递运算结果
  wire signed[19:0] Psum_2; //内部传递运算结果

activation_layer #(.ACT_TYPE("RELU")) relu_inst (
        .x(Psum_2),
        .y(Psum_out)
    );

new_PE_Unit new_PE_Unit_2(
    .clk(clk),  //PE 时钟
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效   

    .Filtr_in_0(Filtr_in_2_2),
    .Filtr_in_1(Filtr_in_2_1),  
    .Filtr_in_2(Filtr_in_2_0),

    .Ifmap_shift_in(Ifmap_shift_in_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Psum_in(Psum_1),

    .Ifmap_shift_out(),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Psum_out(Psum_2)  //输出计算结果   
);
new_PE_Unit new_PE_Unit_1(
    .clk(clk),  //PE 时钟
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效   

    .Filtr_in_0(Filtr_in_1_2),
    .Filtr_in_1(Filtr_in_1_1),  
    .Filtr_in_2(Filtr_in_1_0), 
    .Ifmap_shift_in(Ifmap_shift_in_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Psum_in(Psum_0),

    .Ifmap_shift_out(Ifmap_shift_out_2),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Psum_out(Psum_1)  //输出计算结果   
);

new_PE_Unit new_PE_Unit_0(
    .clk(clk),  //PE 时钟
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效   

    .Filtr_in_0(Filtr_in_0_2),
    .Filtr_in_1(Filtr_in_0_1),  
    .Filtr_in_2(Filtr_in_0_0),

    .Ifmap_shift_in(Ifmap_shift_in_0),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Psum_in(20'b0),

    .Ifmap_shift_out(Ifmap_shift_out_1),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Psum_out(Psum_0)  //输出计算结果   
);
endmodule