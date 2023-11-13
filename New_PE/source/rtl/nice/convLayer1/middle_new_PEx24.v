`timescale 1ns / 1ps
module middle_new_PEx24 (
    input clk,  // PE时钟
    input rst_n,  // 复位信号，低有效
    input en,  // 使能信号，高有效 

    input [207:0] Ifmap_shift_in,  // 列输入特征图 8位*26通道=208位（数据） 

    input [11:0] Filtr_in_2,  // 输入权重 4位*3通道=12位（卷积核）   
    input [11:0] Filtr_in_1,  // 输入权重 4位*3通道=12位（卷积核）
    input [11:0] Filtr_in_0,  // 输入权重 4位*3通道=12位（卷积核） 

    output [335:0] Psum_out  // 列输出计算结果 14位*24=336位 (结果)
);

  wire [7:0] Ifmap_shift_out_2[0:22];  // 每个middle_PE之间脉动传递特征图
  wire [7:0] Ifmap_shift_out_1[0:22];  // 每个middle_PE之间脉动传递特征图

  wire [11:0] Filtr_out_2[0:22];  // 每个middle_PE之间传递权重
  wire [11:0] Filtr_out_1[0:22];  // 每个middle_PE之间传递权重
  wire [11:0] Filtr_out_0[0:22];  // 每个middle_PE之间传递权重

  wire [7:0] reg0_out;  // 用于同步数据输入的移位寄存器中间暂存值
  wire [7:0] Ifmap_shift_in_0_2, Ifmap_shift_in_0_1;

  // Ifmap_shift_in[207:200] 延迟2周期输入
  sirv_gnrl_dfflr #(8) Ifmap_shift_in_0_2_reg0 (
      .lden (en),
      .dnxt (Ifmap_shift_in[207:200]),
      .qout (reg0_out),
      .clk  (clk),
      .rst_n(rst_n)
  );
  sirv_gnrl_dfflr #(8) Ifmap_shift_in_0_2_reg1 (
      .lden (en),
      .dnxt (reg0_out),
      .qout (Ifmap_shift_in_0_2),
      .clk  (clk),
      .rst_n(rst_n)
  );

  // Ifmap_shift_in[199:192] 延迟1周期输入
  sirv_gnrl_dfflr #(8) Ifmap_shift_in_0_1_reg0 (
      .lden (en),
      .dnxt (Ifmap_shift_in[199:192]),
      .qout (Ifmap_shift_in_0_1),
      .clk  (clk),
      .rst_n(rst_n)
  );

  middle_new_PE_conv1 PE_0 (
      .clk(clk),  // PE时钟(3倍频clk时钟)
      .rst_n(rst_n),  // 复位信号，低有效
      .en(en),  // 使能信号，高有效 

      .Ifmap_shift_in_2(Ifmap_shift_in_0_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_shift_in_1(Ifmap_shift_in_0_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_shift_in_0(Ifmap_shift_in[191:184]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_2(Filtr_in_2),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_1(Filtr_in_1),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_0(Filtr_in_0),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_shift_out_2(Ifmap_shift_out_2[0]),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_shift_out_1(Ifmap_shift_out_1[0]),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)

      .Psum_out(Psum_out[335:322]),  // 输出8位计算结果

      .Filtr_out_2(Filtr_out_2[0]),  // 输出权重 4位*3通道（卷积核） 
      .Filtr_out_1(Filtr_out_1[0]),  // 输出权重 4位*3通道（卷积核） 
      .Filtr_out_0(Filtr_out_0[0])   // 输出权重 4位*3通道（卷积核）
  );

  // Generate block
  genvar i;
  generate
    for (i = 1; i < 23; i = i + 1) begin : BLOCK1
      middle_new_PE_conv1 PE_n (
          .clk(clk),  // PE时钟(3倍频clk时钟)
          .rst_n(rst_n),  // 复位信号，低有效
          .en(en),  // 使能信号，高有效 

          .Ifmap_shift_in_2(Ifmap_shift_out_2[i-1]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
          .Ifmap_shift_in_1(Ifmap_shift_out_1[i-1]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
          .Ifmap_shift_in_0(Ifmap_shift_in[(7+8*(23-i))-:8]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

          .Filtr_in_2(Filtr_out_2[i-1]),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
          .Filtr_in_1(Filtr_out_1[i-1]),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
          .Filtr_in_0(Filtr_out_0[i-1]),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

          .Ifmap_shift_out_2(Ifmap_shift_out_2[i]),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
          .Ifmap_shift_out_1(Ifmap_shift_out_1[i]),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)

          .Psum_out(Psum_out[(13+14*(23-i))-:14]),  // 输出计算结果

          .Filtr_out_2(Filtr_out_2[i]),  // 输出权重 4位*3通道（卷积核） 
          .Filtr_out_1(Filtr_out_1[i]),  // 输出权重 4位*3通道（卷积核） 
          .Filtr_out_0(Filtr_out_0[i])   // 输出权重 4位*3通道（卷积核）
      );
    end
  endgenerate

  middle_new_PE_conv1 PE_23 (
      .clk(clk),  // PE时钟(3倍频clk时钟)
      .rst_n(rst_n),  // 复位信号，低有效
      .en(en),  // 使能信号，高有效 

      .Ifmap_shift_in_2(Ifmap_shift_out_2[22]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_shift_in_1(Ifmap_shift_out_1[22]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_shift_in_0(Ifmap_shift_in[7:0]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_2(Filtr_out_2[22]),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_1(Filtr_out_1[22]),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_0(Filtr_out_0[22]),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_shift_out_2(),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_shift_out_1(),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)

      .Psum_out(Psum_out[13:0]),  // 输出计算结果

      .Filtr_out_2(),  // 输出权重 4位*3通道（卷积核） 
      .Filtr_out_1(),  // 输出权重 4位*3通道（卷积核） 
      .Filtr_out_0()   // 输出权重 4位*3通道（卷积核）
  );

endmodule
