`timescale 1ns / 1ps
module top_convlayer2  #(
  parameter mult_ip_delay = 0
)(
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
    input [47:0] Filtr_in_0,  //权重

    output wire [95:0] Psum_d_out,  //12x8=96 位卷积核
    output  reg [2:0] conv_counter,

    output reg dout_vald  //卷积数据输出有效信号
);
initial begin
  dout_vald=0;
  end

  wire [95:0] sram_dout_0, sram_dout_1, sram_dout_2, sram_dout_3;
  reg [111:0] conv_din_0, conv_din_1, conv_din_2, conv_din_3;  
  wire [191:0] Psum_out_sum;  //卷积输出结果
  reg [9:0] input_addr;
  reg [9:0] output_addr;
  reg we;
  reg [9:0] sram_addr=0; 

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      input_addr   <= 10'd0;
      output_addr  <= 0;
      conv_counter <= 3'b0;
    end else begin
      if (pool_end) begin
        input_addr <= 10'd0;
        we <= 0;
        conv_counter <= 3'b0;
        output_addr <= output_addr + 1'b1;
      end else begin
        if (din_valid) begin
          conv_counter <= 3'b0;
          output_addr <= 0;
          we <= 1;
          input_addr <= input_addr + 1'b1;
          sram_addr <= input_addr+1;
        end else begin
          if (output_addr <= (26+mult_ip_delay) && output_addr > 0) begin
            output_addr <= output_addr + 1'b1;
            sram_addr   <= output_addr - 1'b1;
          end else if (output_addr == (27+mult_ip_delay) && conv_counter < 7) begin
            conv_counter <= conv_counter + 1'b1;
            output_addr  <= 1'b1;
          end
        end
      end
      if (sram_addr >= 1 && sram_addr <= 16&&!we) begin
        conv_din_0<={8'd0,sram_dout_0,8'd0};
        conv_din_1<={8'd0,sram_dout_1,8'd0};
        conv_din_2<={8'd0,sram_dout_2,8'd0};
        conv_din_3<={8'd0,sram_dout_3,8'd0};        
      end else begin
        conv_din_0<=112'b0;
        conv_din_1<=112'b0;
        conv_din_2<=112'b0;
        conv_din_3<=112'b0;        
      end

      if (sram_addr == (7+mult_ip_delay) && !we) begin
        dout_vald=1;
             
      end else if(sram_addr == (22+mult_ip_delay)&& !we)begin
          dout_vald=0;  
      end

    end
  end

  ConvLayer2 ConvLayer2_inst (
      .clk(clk),
      .rst_n(rst_n),
      .en(en),

      .Ifmap_shift_in_0(conv_din_0),
      .Ifmap_shift_in_1(conv_din_1),
      .Ifmap_shift_in_2(conv_din_2),
      .Ifmap_shift_in_3(conv_din_3),

      .Filtr_in_2(Filtr_in_2),
      .Filtr_in_1(Filtr_in_1),
      .Filtr_in_0(Filtr_in_0),

      .Psum_out_sum(Psum_out_sum)  //输出12*16=192
  );

  conv2_sram conv2_sram_inst0 (
      .clk(clk),  // 时钟信号
      .din(data_in_0),  // 数据输入
      .addr(sram_addr),  // 地址输入
      .cs(1'b1),  // 片选信号（确保在读和写时都启用）
      .we(din_valid),  // 写使能信号（在写入时启用，读取时禁用）
      .wem(1'b1),  // 写使能脉冲宽度
      .dout(sram_dout_0)  // 数据输出
  );
  conv2_sram conv2_sram_inst1 (
      .clk(clk),  // 时钟信号
      .din(data_in_1),  // 数据输入
      .addr(sram_addr),  // 地址输入
      .cs(1'b1),  // 片选信号（确保在读和写时都启用）
      .we(din_valid),  // 写使能信号（在写入时启用，读取时禁用）
      .wem(1'b1),  // 写使能脉冲宽度
      .dout(sram_dout_1)  // 数据输出
  );
  conv2_sram conv2_sram_inst2 (
      .clk(clk),  // 时钟信号
      .din(data_in_2),  // 数据输入
      .addr(sram_addr),  // 地址输入
      .cs(1'b1),  // 片选信号（确保在读和写时都启用）
      .we(din_valid),  // 写使能信号（在写入时启用，读取时禁用）
      .wem(1'b1),  // 写使能脉冲宽度
      .dout(sram_dout_2)  // 数据输出
  );
  conv2_sram conv2_sram_inst3 (
      .clk(clk),  // 时钟信号
      .din(data_in_3),  // 数据输入
      .addr(sram_addr),  // 地址输入
      .cs(1'b1),  // 片选信号（确保在读和写时都启用）
      .we(din_valid),  // 写使能信号（在写入时启用，读取时禁用）
      .wem(1'b1),  // 写使能脉冲宽度
      .dout(sram_dout_3)  // 数据输出
  );

  genvar i;
  generate
    for (i = 0; i < 12; i = i + 1) begin : BLOCK4
      Conv2Activation Conv2Activation_inst0 (
          .din (Psum_out_sum[191-16*i-:16]),
          .dout(Psum_d_out[95-8*i-:8])
      );

    end
  endgenerate


endmodule
