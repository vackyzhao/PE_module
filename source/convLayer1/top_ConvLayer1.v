`timescale 1ns / 1ps
module top_convlayer1 (
    input clk,
    input rst_n,
    input en,

    input [1:0]cam_out_counter,
    input dout_cycle_valid,
    input [207:0] Ifmap_shift_in,  //26x8=208位数据输入

    input [95:0] Filtr_in_2,  //权重3x4x4=48位
    input [95:0] Filtr_in_1,  //权重3x4x4=48位
    input [95:0] Filtr_in_0,  //权重3x4x4=48位

    input      din_vald,  //卷积数据输入有效信号
    output reg dout_vald, //卷积数据输出有效信号

    output [191:0] Psum_d_out_0,  //24x8=192 位卷积核0数据输出
    output [191:0] Psum_d_out_1,  //24x8=192 位卷积核0数据输出
    output [191:0] Psum_d_out_2,  //24x8=192 位卷积核0数据输出
    output [191:0] Psum_d_out_3   //24x8=192 位卷积核0数据输出
);
reg data_vald;
  wire [191:0]Psum_d_out;
  wire [479:0] Psum_out_tmp;
  reg [5:0] data_counter;
  reg [1:0] sram_counter;

  initial begin
    dout_vald =1'b0;
    data_vald = 1'b0;
    data_counter=0;
  end
reg read_flag;
reg [3:0]sram_we;
reg [9:0]sram_addr,sram_addr_out;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      data_vald <= 1'b0;
      data_counter <= 6'b0;
      sram_counter<=2'b0;
    end else begin
      if (din_vald) begin
        data_counter <= 1;
      end
      if (data_counter != 0) begin
        if (data_counter >= 5 &&data_counter!=37&&dout_cycle_valid==1) begin
          sram_counter<=cam_out_counter;
          data_vald <= 1'b1;
        end if (data_counter == 37) begin
          data_vald <= 1'b0;
        end
        if (data_counter <= 42) begin
          data_counter <= data_counter + 1;
        end else begin
          data_counter <= 6'b0;
        end
      end

      if(read_flag==1&&sram_addr_out<33)begin
      sram_addr_out<=sram_addr_out+1;        
      end else if(read_flag==0)begin
        sram_addr_out<=0;
      end

      if(read_flag==1&&sram_addr_out>=0)begin
        dout_vald<=1;
      end
      if(sram_addr_out>=0&&sram_addr_out<32)begin
        //dout_vald<=1;
      end else begin
        dout_vald<=0;
      end

    end
  end

  ConvLayer1 ConvLayer1_inst (
      .clk(clk),
      .rst_n(rst_n),
      .en(en),
      .Ifmap_shift_in(Ifmap_shift_in),

      .Filtr_in_2(Filtr_in_2[95-24*cam_out_counter-:24]),
      .Filtr_in_1(Filtr_in_1[95-24*cam_out_counter-:24]),
      .Filtr_in_0(Filtr_in_0[95-24*cam_out_counter-:24]),

      .Psum_out(Psum_out_tmp)
  );

always@(*)begin
  if(!rst_n)begin
     read_flag<=0;
  end
  else if(data_vald)begin
    case(sram_counter)
      2'b00:sram_we=4'b0001;
      2'b01:sram_we=4'b0010;
      2'b10:sram_we=4'b0100;
      2'b11:sram_we=4'b1000;
    endcase
  sram_addr<={4'b0,data_counter}-10'd6;
  read_flag<=0;    
  end else begin

    sram_we<=4'b0;
    sram_addr<=sram_addr_out;
    if(din_vald==0&&sram_counter==3)begin
      read_flag<=1;
      
    end
  end
end

 conv1_sram conv1_sram_0 (
    .clk(clk),   // 时钟信号
    .din(Psum_d_out),   // 数据输入
    .addr(sram_addr),  // 地址输入
    .cs(1),    // 片选信号（确保在读和写时都启用）
    .we(sram_we[0]),    // 写使能信号（在写入时启用，读取时禁用）
    .wem(1),   // 写使能脉冲宽度
    .dout(Psum_d_out_0)   // 数据输出
);
 conv1_sram conv1_sram_1 (
    .clk(clk),   // 时钟信号
    .din(Psum_d_out),   // 数据输入
    .addr(sram_addr),  // 地址输入
    .cs(1),    // 片选信号（确保在读和写时都启用）
    .we(sram_we[1]),    // 写使能信号（在写入时启用，读取时禁用）
    .wem(1),   // 写使能脉冲宽度
    .dout(Psum_d_out_1)   // 数据输出
);
 conv1_sram conv1_sram_2 (
    .clk(clk),   // 时钟信号
    .din(Psum_d_out),   // 数据输入
    .addr(sram_addr),  // 地址输入
    .cs(1),    // 片选信号（确保在读和写时都启用）
    .we(sram_we[2]),    // 写使能信号（在写入时启用，读取时禁用）
    .wem(1),   // 写使能脉冲宽度
    .dout(Psum_d_out_2)   // 数据输出
);
 conv1_sram conv1_sram_3 (
    .clk(clk),   // 时钟信号
    .din(Psum_d_out),   // 数据输入
    .addr(sram_addr),  // 地址输入
    .cs(1),    // 片选信号（确保在读和写时都启用）
    .we(sram_we[3]),    // 写使能信号（在写入时启用，读取时禁用）
    .wem(1),   // 写使能脉冲宽度
    .dout(Psum_d_out_3)   // 数据输出
);
  genvar i;
  generate
    for (i = 0; i < 24; i = i + 1) begin : BLOCK4
      Conv1Activation Conv1Activation_inst0 (
          .din (Psum_out_tmp[479-20*i-:20]),
          .dout(Psum_d_out[191-8*i-:8])
      );

    end
  endgenerate


endmodule
