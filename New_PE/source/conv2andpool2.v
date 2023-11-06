`timescale 1ns / 1ps
module convandpool (
    input clk,
    input rst_n,
    input en,

    input din_valid,  // 输入数据有效信号
    input pool_end,

    input [95:0] data_in_0,  // 输入数据 12x8=96
    input [95:0] data_in_1,  // 输入数据
    input [95:0] data_in_2,  // 输入数据
    input [95:0] data_in_3,  // 输入数据

    input [47:0] Filtr_in_2,  //权重3x4x4=48位
    input [47:0] Filtr_in_1,  //权重
    input [47:0] Filtr_in_0 //权重

);
  wire [95:0] conv2_out;
  wire conv2_dout_vald;
  wire [2:0] Filtr_2_count;


  top_convlayer2 top_convlayer2_inst (
      .clk(clk),
      .rst_n(rst_n),
      .en(en),

      .din_valid(din_valid),  // 输入数据有效信号
      .pool_end (pool_end),

      .data_in_0(data_in_0),  // 输入数据 12x8=96
      .data_in_1(data_in_1),  // 输入数据
      .data_in_2(data_in_2),  // 输入数据
      .data_in_3(data_in_3),  // 输入数据

      .Filtr_in_2(Filtr_2_2),  //权重3x4x4=48位
      .Filtr_in_1(Filtr_2_1),  //权重
      .Filtr_in_0(Filtr_2_0),  //权重

      .Psum_d_out(conv2_out),  //12x8=96 
      .conv_counter(Filtr_2_count),
      .conv_en(conv2_dout_vald)  //卷积数据输出有效信号
  );
  top_pool2 top_pool2_inst (
      .clk      (clk),           // 时钟输入
      .rst_n    (rst_n),            // 复位输入（低电平有效）
      .en       (en),               // 使能    
      .valid_in (conv2_dout_vald),  // 输入数据有效信号
      .data_in  (conv2_out),        // 输入数据

      .data_out (pool2_out),        // 输出数据
      .valid_out(pool2_dout_vald),  // 输出数据有效信号
      .pool_end (pool2_end)
  );

endmodule 