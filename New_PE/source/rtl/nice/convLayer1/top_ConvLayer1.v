`timescale 1ns / 1ps
module top_convlayer1 (
    input clk,
    input rst_n,
    input en,
    input [207:0] Ifmap_shift_in,  //26x8=208位数据输入

    input [47:0] Filtr_in_2,  //权重3x4x4=48位
    input [47:0] Filtr_in_1,  //权重3x4x4=48位
    input [47:0] Filtr_in_0,  //权重3x4x4=48位

    input      din_vald,  //卷积数据输入有效信号
    output reg dout_vald, //卷积数据输出有效信号

    output [191:0] Psum_d_out_0,  //24x8=192 位卷积核0数据输出
    output [191:0] Psum_d_out_1,  //24x8=192 位卷积核0数据输出
    output [191:0] Psum_d_out_2,  //24x8=192 位卷积核0数据输出
    output [191:0] Psum_d_out_3   //24x8=192 位卷积核0数据输出
);
  wire [335:0] Psum_out_tmp_0, Psum_out_tmp_1, Psum_out_tmp_2, Psum_out_tmp_3;
  reg [5:0] data_counter;

  initial begin
    dout_vald = 1'b0;
    data_counter=0;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      dout_vald <= 1'b0;
      data_counter <= 6'b0;
    end else begin
      if (din_vald) begin
        data_counter <= 1;
      end
      if (data_counter != 0) begin
        if (data_counter >= 6 &&data_counter!=37) begin
          dout_vald <= 1'b1;
        end if (data_counter == 37) begin
          dout_vald <= 1'b0;
        end
        if (data_counter <= 36) begin
          data_counter <= data_counter + 1;
        end else begin
          data_counter <= 6'b0;
        end
      end
    end
  end

  ConvLayer1 ConvLayer1_inst (
      .clk(clk),
      .rst_n(rst_n),
      .en(en),
      .Ifmap_shift_in(Ifmap_shift_in),

      .Filtr_in_2(Filtr_in_2),
      .Filtr_in_1(Filtr_in_1),
      .Filtr_in_0(Filtr_in_0),

      .Psum_out_0(Psum_out_tmp_0),
      .Psum_out_1(Psum_out_tmp_1),
      .Psum_out_2(Psum_out_tmp_2),
      .Psum_out_3(Psum_out_tmp_3)
  );


  genvar i;
  generate
    for (i = 0; i < 24; i = i + 1) begin : BLOCK4
      Conv1Activation Conv1Activation_inst0 (
          .din (Psum_out_tmp_0[335-14*i-:14]),
          .dout(Psum_d_out_0[191-8*i-:8])
      );

      Conv1Activation Conv1Activation_inst1 (
          .din (Psum_out_tmp_1[335-14*i-:14]),
          .dout(Psum_d_out_1[191-8*i-:8])
      );

      Conv1Activation Conv1Activation_inst2 (
          .din (Psum_out_tmp_2[335-14*i-:14]),
          .dout(Psum_d_out_2[191-8*i-:8])
      );

      Conv1Activation Conv1Activation_inst3 (
          .din (Psum_out_tmp_3[335-14*i-:14]),
          .dout(Psum_d_out_3[191-8*i-:8])
      );
    end
  endgenerate


endmodule
