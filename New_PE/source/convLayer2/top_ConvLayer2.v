`timescale 1ns / 1ps
module top_convlayer2 (
    input clk,
    input rst_n,
    input en,

    input  din_valid,       // 输入数据有效信号
    input  pool_end,
    
    input [95:0]data_in_0, // 输入数据 12x8=96
    input [95:0]data_in_1, // 输入数据
    input [95:0]data_in_2, // 输入数据
    input [95:0]data_in_3, // 输入数据

    input [47:0] Filtr_in_2,  //权重3x4x4=48位
    input [47:0] Filtr_in_1,  //权重
    input [47:0] Filtr_in_0,  //权重

    output [95:0] Psum_d_out_0,  //12x8=96 位卷积核0数据输出    
    output [95:0] Psum_d_out_1,  //12x8=96 位卷积核1数据输出
    output [95:0] Psum_d_out_2,  //12x8=96 位卷积核2数据输出    
    output [95:0] Psum_d_out_3,  //12x8=96 位卷积核3数据输出
    output [95:0] Psum_d_out_4,  //12x8=96 位卷积核4数据输出    
    output [95:0] Psum_d_out_5,  //12x8=96 位卷积核5数据输出
    output [95:0] Psum_d_out_6,  //12x8=96 位卷积核6数据输出    
    output [95:0] Psum_d_out_7,  //12x8=96 位卷积核7数据输出
   
    output reg dout_vald //卷积数据输出有效信号
);
  
  ConvLayer2 ConvLayer2_inst (
      .clk(clk),
      .rst_n(rst_n),
      .en(en),
      .Ifmap_shift_in(Ifmap_shift_in),

      .Filtr_in_2(Filtr_in_2),
      .Filtr_in_1(Filtr_in_1),
      .Filtr_in_0(Filtr_in_0),

      .Psum_out_0(Psum_out_sum)
  );


  genvar i;
  generate
    for (i = 0; i < 12; i = i + 1) begin : BLOCK4
      Conv2Activation Conv2Activation_inst0 (
          .din (Psum_out_tmp_0[335-14*i-:14]),
          .dout(Psum_d_out_0[191-8*i-:8])
      );

    end
  endgenerate


endmodule
