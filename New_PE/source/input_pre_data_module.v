`timescale 1ns / 1ps
module Input_pre_data_module
#(parameter buffer_DP = 1024,//输入缓存大小
parameter data_DP = 1156    //经过padding后大小
)
(
	input           din_clk,        //输入 摄像头 时钟
  input  [7:0] i_data_din,        // data 输入数据 
  input    i_data_din_vld,        // data 输入数据有效信号
	///////////////////////////////////////////////////////////////////
  input  [7:0]    input_padding,        //输入padding参数

	input          dout_clk,        //输入输出时钟
	input                en,        //使能
	input 			      rst_n,        //重置
   
	output            PEclk,        //PE时钟
  output reg [271:0] parallel_data  //34*8 272位并行数据输出
);
reg [15:0] i_conv_addr=16'd0; //输出结果地址
reg [5:0]  col_counter=6'b0; //行计数器
reg [271:0] padding_data;  //34*8 272位并行数据
wire [7:0] o_conv_dout;    //输出结果
reg [5:0] row_counter_in;  //行寄存器输入
wire [5:0] row_counter_out;//行寄存器输出
reg [5:0] row_counter;     //当前行
wire o_pl_buffer_ready;
reg buffer_ready;
reg i_switch_pingpong=1'b0;

sirv_gnrl_dfflr #(6) row_counter_inst (
  .lden(en),
  .dnxt(row_counter_in),
  .qout(row_counter_out),
  .clk(PEclk),
  .rst_n(rst_n)
);

//实例化32分频器
clockDivider32 divider32_inst (
    .clk(dout_clk),
    .rst_n(rst_n),
    .divided(PEclk)
  );
  // 实例化PingPongBuffer
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
  always@(*)begin // 每列前后填充padding 
  if (!rst_n) begin
      row_counter_in <= 6'b0;
    end else begin
      if(o_pl_buffer_ready)begin
      buffer_ready=1'b1;
      i_switch_pingpong=~i_switch_pingpong;
      end

      if(row_counter_out<7&&buffer_ready)
      row_counter_in <= row_counter_out+1'b1;
      else begin
      row_counter_in<=1'b0;
      buffer_ready=1'b0;
      end
      parallel_data [271:264] <= input_padding  [7:0]; //对输出数列的首个元素填充padding
      parallel_data     [7:0] <= input_padding  [7:0];     //对输出数列的末尾元素填充padding
      for (i = 0; i < 34; i = i + 1) begin
        padding_data[271 - i * 8 -: 8] <= input_padding[7:0];//首尾两行填充padding
      end
    end   
  end
 
always@(posedge PEclk or negedge rst_n)begin
  if (!rst_n) begin
    row_counter <= 0;
  end else begin    
    row_counter <= row_counter_out;
  end
  
end
always @(posedge dout_clk or negedge rst_n) begin //每个时钟更新数据
  if (!rst_n) begin
    i_conv_addr <= 16'b0;
    col_counter <= 6'b0;
  end else begin
    if()
    
  end
end

endmodule
