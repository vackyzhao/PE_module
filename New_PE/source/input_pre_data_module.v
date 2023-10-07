// 设置时钟分辨率
`timescale 1ns / 1ps

module Input_pre_data_module
#(
  parameter buffer_DP = 1024, // 输入缓存大小
  parameter data_DP = 1156    // 经过 padding 后的大小
)
(
  input din_clk,               // 输入摄像头时钟
  input [7:0] i_data_din,      // 输入摄像头数据
  input i_data_din_vld,        // 输入数据有效信号

  //////////////////////////////////////////////////////
  input [7:0] input_padding,   // 输入填充参数

  input dout_clk,              // 输入时钟
  input en,                    // 使能
  input rst_n,                 // 复位

  output PEclk,                // 输出PE 时钟
  output reg out_data_vld,     // 缓冲就绪标志
  output reg [271:0] parallel_data // 34*8 272位并行数据输出
);

reg [15:0] i_conv_addr = 16'd0; // 输出结果地址
reg [5:0] col_counter = 6'b0;   // 列计数器
reg [271:0] padding_data;        // 34*8 272位并行数据
wire [7:0] o_conv_dout;          // 输出结果

reg [5:0] row_counter_in;        // 行寄存器输入
wire [5:0] row_counter_out;      // 行寄存器输出
reg [5:0] row_counter;           // 当前行

wire o_pl_buffer_ready;          // 缓冲区就绪信号
reg i_switch_pingpong = 1'b0;    // 缓存切换信号

// 实例化通用 DFF 寄存器模块，用于行寄存器
sirv_gnrl_dfflr #(6) row_counter_inst (
  .lden(en),
  .dnxt(row_counter_in),
  .qout(row_counter_out),
  .clk(PEclk),
  .rst_n(rst_n)
);

// 实例化时钟分频器模块，将 dout_clk 分频为 PEclk
clockDivider32 divider32_inst (
  .clk(dout_clk),
  .rst_n(rst_n),
  .divided(PEclk)
);

// 实例化 PingPongBuffer 模块
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
  // 每列前后填充 padding 数据
  if (!rst_n) begin
    row_counter_in <= 6'b0;
  end else begin
    // 根据条件设置缓冲就绪标志和缓存切换信号
    if (o_pl_buffer_ready && out_data_vld == 0) begin
      out_data_vld <= 1'b1;
      i_switch_pingpong <= ~i_switch_pingpong;
    end

    // 根据条件更新行寄存器
    if (row_counter_out < 34 && out_data_vld) begin
      row_counter_in <= row_counter_out + 1'b1;
    end else begin
      row_counter_in <= 1'b0;
      out_data_vld = 1'b0;
    end

    // 对输出数据列的首尾元素填充 padding 数据
    parallel_data[271:264] <= input_padding[7:0];
    parallel_data[7:0] <= input_padding[7:0];

    // 首尾两行填充 padding 数据
    for (i = 0; i < 34; i = i + 1) begin
      padding_data[271 - i * 8 -: 8] <= input_padding[7:0];
    end
  end
end

always @(posedge PEclk or negedge rst_n) begin
  // PE 时钟边沿触发的逻辑
  if (!rst_n) begin
    row_counter <= 0;
  end else begin
    // 根据行寄存器输出设置当前行和列计数器
    row_counter <= row_counter_out;
    col_counter <= 6'b0;

    // 如果当前行是第一行或最后一行，则将 parallel_data 设置为 padding_data
    if (row_counter == 0 || row_counter == 33) begin
      parallel_data <= padding_data;
    end
  end
end

always @(posedge dout_clk or negedge rst_n) begin
  // 输出时钟边沿触发的逻辑，用于更新数据
  if (!rst_n) begin
    i_conv_addr <= 16'b0;
    col_counter <= 6'b0;
  end else begin
    // 根据缓存状态、行号和列计数器更新 parallel_data
    if (out_data_vld && row_counter != 0 && row_counter < 33) begin
      i_conv_addr = col_counter*32+(row_counter-1);//计算输出地址
      parallel_data[263 - col_counter * 8 -: 8] <= o_conv_dout[7:0];
      col_counter <= col_counter + 1;
    end
  end
end

endmodule
