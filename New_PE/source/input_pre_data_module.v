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
#(parameter buffer_DP = 1024,//输入缓存大小
parameter data_DP = 1156    //经过padding后大小
)
(
	input           din_clk,        //输入 摄像头 时钟
  input  [7:0] i_data_din,        // data 输入数据 
  input    i_data_din_vld,        // data 输入数据有效信号
	///////////////////////////////////////////////////////////////////
  input  [7:0]    padding,        //输入padding参数

	input          dout_clk,        //输入输出时钟
	input                en,        //使能
	input 			      rst_n,        //重置
  
  input i_switch_pingpong,        //缓存切换
  
	output            PEclk,        //PE时钟
  output reg [271:0] parallel_data  //34*8 272位并行数据
);
reg [15:0] i_conv_addr=16'd0; //输出结果地址
reg [5:0]  row_counter=6'b0; //行计数器
reg [5:0]  col_counter=6'b0; //行计数器
reg [271:0] padding_data;  //34*8 272位并行数据


//32分频
clockDivider32 divider32_inst (
    .clk(dout_clk),
    .divided(PEclk)
  );
  // 实例化被测试的模块
    PingPongBuffer PingPongBuffer_inst (
    .i_clk_input(din_clk),           // 输入数据时钟
    .i_clk_output(dout_clk),         // 输出数据时钟
    .i_rst_n(rst_n),                 // 复位信号
    .en(en),                         // 使能信号
    .i_switch_pingpong(i_switch_pingpong), // 缓存切换信号
    .i_data_din(i_data_din),         // 输入数据
    .i_data_din_vld(i_data_din_vld), // 输入数据有效信号
    .i_conv_addr(i_conv_addr),       // 输入索引地址
    .o_conv_dout(o_conv_dout),       // 输出转换后的数据
    .o_pl_buffer_ready(o_pl_buffer_ready) // 输出缓冲区就绪信号
);
integer i;
always @(*) begin
  for (i = 0; i < 34; i = i + 1) begin
    padding_data[271 - i * 8 -: 8] = padding[7:0];
  end
end

  always@(*)begin
  parallel_data[271:264] = padding[7:0];
  parallel_data[7:0] = padding[7:0];
  end

  always@(posedge PEclk)begin    //PEclk上升沿重置i_conv_addr输出结果地址
    if(i_conv_addr == data_DP )begin
      i_conv_addr=16'b0;
      row_counter=6'b0;
      col_counter=6'b0;
    end		
  end



 
always @(posedge dout_clk or negedge rst_n) begin
  if (!rst_n) begin
    i_conv_addr <= 16'b0;
    row_counter <= 6'b0;
    col_counter <= 6'b0;
  end else begin
    if (row_counter == 6'd0||row_counter == 6'd33) begin  
      parallel_data <= padding_data; 
    end
  end
end


 

endmodule
