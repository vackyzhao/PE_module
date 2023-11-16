`timescale 1ns / 1ps
module middle_new_PEx12 (
    input clk,  // PE时钟
    input rst_n,  // 复位信号，低有效
    input en,  // 使能信号，高有效 

    input [111:0] Ifmap_shift_in,  // 列输入特征图 8�?*14通道=112位（数据�? 

    input [23:0] Filtr_in_2,  // 输入权重 4�?*3通道=12位（卷积核）   
    input [23:0] Filtr_in_1,  // 输入权重 4�?*3通道=12位（卷积核）
    input [23:0] Filtr_in_0,  // 输入权重 4�?*3通道=12位（卷积核） 

    output [239:0] Psum_out  // 列输出计算结�? 20�?*12=240�? (结果)
);

  wire [7:0] Ifmap_shift_out_2[0:10];  // 每个middle_PE之间脉动传�?�特征图
  wire [7:0] Ifmap_shift_out_1[0:10];  // 每个middle_PE之间脉动传�?�特征图

  wire [23:0] Filtr_out_2[0:10];  // 每个middle_PE之间传�?�权�?
  wire [23:0] Filtr_out_1[0:10];  // 每个middle_PE之间传�?�权�?
  wire [23:0] Filtr_out_0[0:10];  // 每个middle_PE之间传�?�权�?

  wire [7:0] reg0_out;  // 用于同步数据输入的移位寄存器中间暂存�?
  wire [7:0] Ifmap_shift_in_0_2, Ifmap_shift_in_0_1;

  // Ifmap_shift_in[111:104] 延迟2周期输入
  sirv_gnrl_dfflr #(8) Ifmap_shift_in_0_2_reg0 (
      .lden (en),
      .dnxt (Ifmap_shift_in[111:104]),
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

  // Ifmap_shift_in[103:96] 延迟1周期输入
  sirv_gnrl_dfflr #(8) Ifmap_shift_in_0_1_reg0 (
      .lden (en),
      .dnxt (Ifmap_shift_in[103:96]),
      .qout (Ifmap_shift_in_0_1),
      .clk  (clk),
      .rst_n(rst_n)
  );

  middle_new_PE_conv2 PE_0 (
      .clk(clk),  // PE时钟(3倍频clk时钟)
      .rst_n(rst_n),  // 复位信号，低有效
      .en(en),  // 使能信号，高有效 

      .Ifmap_shift_in_2(Ifmap_shift_in_0_2),// 输入特征�? 8�?*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_shift_in_1(Ifmap_shift_in_0_1),// 输入特征�? 8�?*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_shift_in_0(Ifmap_shift_in[95:88]),// 输入特征�? 8�?*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_2(Filtr_in_2),// 输入权重 4�?*3通道（卷积核�? (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_1(Filtr_in_1),// 输入权重 4�?*3通道（卷积核�? (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_0(Filtr_in_0),// 输入权重 4�?*3通道（卷积核�? (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_shift_out_2(Ifmap_shift_out_2[0]),// 输出特征�? 8�?*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_shift_out_1(Ifmap_shift_out_1[0]),// 输出特征�? 8�?*3通道（数据） (Output feature map 8-bit * 3 channels, data)

      .Psum_out(Psum_out[239:220]),  // 输出20位计算结�?

      .Filtr_out_2(Filtr_out_2[0]),  // 输出权重 4�?*3通道（卷积核�? 
      .Filtr_out_1(Filtr_out_1[0]),  // 输出权重 4�?*3通道（卷积核�? 
      .Filtr_out_0(Filtr_out_0[0])   // 输出权重 4�?*3通道（卷积核�?
  );

  // Generate block
  genvar i;
  generate
    for (i = 1; i < 11; i = i + 1) begin : BLOCK2
      middle_new_PE_conv2 PE_n (
          .clk(clk),  // PE时钟(3倍频clk时钟)
          .rst_n(rst_n),  // 复位信号，低有效
          .en(en),  // 使能信号，高有效 

          .Ifmap_shift_in_2(Ifmap_shift_out_2[i-1]),// 输入特征�? 8�?*3通道（数据） (Input feature map 8-bit * 3 channels, data)
          .Ifmap_shift_in_1(Ifmap_shift_out_1[i-1]),// 输入特征�? 8�?*3通道（数据） (Input feature map 8-bit * 3 channels, data)
          .Ifmap_shift_in_0(Ifmap_shift_in[(7+8*(11-i))-:8]),// 输入特征�? 8�?*3通道（数据） (Input feature map 8-bit * 3 channels, data)

          .Filtr_in_2(Filtr_out_2[i-1]),// 输入权重 4�?*3通道（卷积核�? (Input weights 4-bit * 3 channels, convolution kernel)
          .Filtr_in_1(Filtr_out_1[i-1]),// 输入权重 4�?*3通道（卷积核�? (Input weights 4-bit * 3 channels, convolution kernel)
          .Filtr_in_0(Filtr_out_0[i-1]),// 输入权重 4�?*3通道（卷积核�? (Input weights 4-bit * 3 channels, convolution kernel)

          .Ifmap_shift_out_2(Ifmap_shift_out_2[i]),// 输出特征�? 8�?*3通道（数据） (Output feature map 8-bit * 3 channels, data)
          .Ifmap_shift_out_1(Ifmap_shift_out_1[i]),// 输出特征�? 8�?*3通道（数据） (Output feature map 8-bit * 3 channels, data)

          .Psum_out(Psum_out[(19+20*(11-i))-:20]),  // 输出计算结果

          .Filtr_out_2(Filtr_out_2[i]),  // 输出权重 4�?*3通道（卷积核�? 
          .Filtr_out_1(Filtr_out_1[i]),  // 输出权重 4�?*3通道（卷积核�? 
          .Filtr_out_0(Filtr_out_0[i])   // 输出权重 4�?*3通道（卷积核�?
      );
    end
  endgenerate

  middle_new_PE_conv2 PE_11 (
      .clk(clk),  // PE时钟(3倍频clk时钟)
      .rst_n(rst_n),  // 复位信号，低有效
      .en(en),  // 使能信号，高有效 

      .Ifmap_shift_in_2(Ifmap_shift_out_2[10]),// 输入特征�? 8�?*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_shift_in_1(Ifmap_shift_out_1[10]),// 输入特征�? 8�?*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Ifmap_shift_in_0(Ifmap_shift_in[7:0]),// 输入特征�? 8�?*3通道（数据） (Input feature map 8-bit * 3 channels, data)

      .Filtr_in_2(Filtr_out_2[10]),// 输入权重 4�?*3通道（卷积核�? (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_1(Filtr_out_1[10]),// 输入权重 4�?*3通道（卷积核�? (Input weights 4-bit * 3 channels, convolution kernel)
      .Filtr_in_0(Filtr_out_0[10]),// 输入权重 4�?*3通道（卷积核�? (Input weights 4-bit * 3 channels, convolution kernel)

      .Ifmap_shift_out_2(),// 输出特征�? 8�?*3通道（数据） (Output feature map 8-bit * 3 channels, data)
      .Ifmap_shift_out_1(),// 输出特征�? 8�?*3通道（数据） (Output feature map 8-bit * 3 channels, data)

      .Psum_out(Psum_out[19:0]),  // 输出计算结果

      .Filtr_out_2(),  // 输出权重 4�?*3通道（卷积核�? 
      .Filtr_out_1(),  // 输出权重 4�?*3通道（卷积核�? 
      .Filtr_out_0()   // 输出权重 4�?*3通道（卷积核�?
  );

endmodule
