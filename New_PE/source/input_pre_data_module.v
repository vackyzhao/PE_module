`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/08 19:14:10
// Design Name: 
// Module Name: Input_pre_data_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Input_pre_data_module
(
	input           din_clk,
	input  [7:0] i_data_din,        // data 输入数据 
  input    i_data_din_vld,        // data 输入数据有效信号
	///////////////////////////////////////////////////////////////////
	input          dout_clk,        //输出时钟
	input                en,        //使能
	input 			      rst_n,        //重置
  input i_switch_pingpong,        //缓存切换
	output            PEclk,        //PE时钟
  output reg [0:271]prallel_data  //34*8 272位并行数据
);
reg [15:0]i_conv_addr;

//34分频
clockDivider34 divider34_inst (
    .clk(dout_clk),
    .divided(PEclk)
  );
  // 实例化被测试的模块
  PingPongBuffer PingPongBuffer_inst (
    .i_clk_input(din_clk),
    .i_clk_output(dout_clk),
    .i_rst_n(i_rst_n),
    .en(en),
    .i_switch_pingpong(i_switch_pingpong),
    .i_data_din(i_data_din),
    .i_data_din_vld(i_data_din_vld),
    .i_conv_addr(i_conv_addr),
    .o_conv_dout(o_conv_dout),
    .o_pl_buffer_ready(o_pl_buffer_ready)
  );
  always@(posedge PEclk)begin//PEclk上升沿重置i_conv_addr
		i_conv_addr=16'b0;
  end

  always@(posedge dout_clk or negedge rst_n)//dout_clk上升沿i_conv_addr递增
  if(!rst_n)begin
     i_conv_addr=16'b0;
  end else begin
   if(PEclk==1)begin
    i_conv_addr=i_conv_addr;
    prallel_data[8*i_conv_addr:8*i_conv_addr+7]=o_conv_dout;
    i_conv_addr=i_conv_addr+1'b1;
    end
  end





endmodule
