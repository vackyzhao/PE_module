// 设置时钟分辨�?
`timescale 1ns / 1ps

module Input_pre_data_module #(
    parameter buffer_DP = 768,  // 输入缓存大小 24x32
    parameter data_DP   = 884   // 经过 padding 后的大小 26x34
) (
    input        en,              // 使能
    input        rst_n,           // 复位#
    //////////////////////////////////////////////////////
    input        din_clk,         // 输入摄像头时�?
    input  [7:0] i_data_din,      // 输入摄像头数�?
    input        i_data_din_vld,  // 输入数据有效信号
    //////////////////////////////////////////////////////
    input        dout_clk,        // 输出时钟
    input  [7:0] input_padding,   // 输入填充参数       
    output       PEclk,           // PE 时钟

    output reg         out_data_vld,  // 缓冲就绪标志
    output reg [207:0] parallel_data  // 26*8 208位并行数据输�?
);

  // 寄存器和信号定义
  reg val_PEclk, pre_val_PEclk;
  reg  [  9:0] i_conv_addr = 10'd0;  // 输出结果地址
  reg  [207:0] padding_data = 208'd0;  // 26*8 208位并行数�?
  reg  [191:0] sram_o_data = 192'd0;
  wire [  7:0] o_conv_dout;  // 输出结果
  reg  [  5:0] col_counter = 6'b0;  // 列计数器 0-25 �?26�?
  reg  [  5:0] row_counter = 6'b0;  // 行计数器 0-33 �?34�?
  wire         o_pl_buffer_ready;  // 缓冲区就绪信�?
  reg          i_switch_pingpong = 1'b0;  // 缓存切换信号



  // 实例化时钟分频器模块，将 dout_clk 分频�? PEclk
  clockDivider24 divider24_inst (
      .clk(dout_clk),
      .rst_n(rst_n),
      .divided(PEclk)
  );
initial out_data_vld=0;
  // 实例�? PingPongBuffer 模块
  PingPongBuffer PingPongBuffer_inst (
      .i_clk_input      (din_clk),            // 输入数据时钟
      .i_clk_output     (dout_clk),           // 输出数据时钟
      .i_rst_n          (rst_n),              // 复位信号
      .en               (en),                 // 使能信号
      .i_switch_pingpong(i_switch_pingpong),  // 缓存切换信号
      .i_data_din       (i_data_din),         // 输入数据
      .i_data_din_vld   (i_data_din_vld),     // 输入数据有效信号

      .i_conv_addr      (i_conv_addr),       // 输入索引地址
      .o_conv_dout      (o_conv_dout),       // 输出转换后的数据
      .o_pl_buffer_ready(o_pl_buffer_ready),  // 输出缓冲区就绪信�?(写入完成)
      .o_state_change (state_change)
  );
  wire state_change ;
  integer i;
  always @(*) begin
    if (!rst_n) begin
      padding_data <= 208'b0;
    end else begin
      for (i = 0; i < 26; i = i + 1) begin
        padding_data[207-i*8-:8] <= input_padding[7:0];
      end

    end
  end

  always @(posedge din_clk) begin  //摄像头输入时�?
    if (!rst_n) begin
      i_switch_pingpong <= 1'b0;
      //out_data_vld <= 1'b0;
    end else begin
      // 如果读取完并且写入完成成切换pingpong，因为写入比较慢，所以这个切换放在写入部�?
      if (col_counter == 6'd34) begin
        //out_data_vld <= 1'b0;
      end else if (o_pl_buffer_ready && (!out_data_vld)) begin
        i_switch_pingpong <= ~i_switch_pingpong;  //切换pingpong状�??
        //out_data_vld <= 1'b1;  //现在可以读取/输出�?
      end
    end
  end
reg conv_start;
always@(posedge dout_clk or negedge rst_n )
if(!rst_n ) begin
 conv_start<=0;
 out_data_vld <=0;
end
else begin
    if(col_counter==6'd34)begin
        out_data_vld <=0;
    end
    else if(state_change) begin
        conv_start<=1;
        if(!out_data_vld) out_data_vld <=1;
    end
end
reg end_flag;
  always @(posedge dout_clk or negedge rst_n) begin  //sram输出时钟
    if (!rst_n) begin
      i_conv_addr <= 10'b0;
      end_flag <=0;
    end else 
     begin
     if(conv_start)begin
          pre_val_PEclk <= val_PEclk;
          val_PEclk <= PEclk;
        
          if (out_data_vld && (!pre_val_PEclk) && val_PEclk) begin
            row_counter <= 6'd1;
          end else if (row_counter < 6'd28 && row_counter > 6'd0) begin
            row_counter <= row_counter + 6'd1;
          end else begin
            row_counter <= 6'd0;
          end
          if (col_counter >= 1 && col_counter < 33 && row_counter < 24) begin
            i_conv_addr <= row_counter * 32 + col_counter - 1;  //计算输出地址 
          end else begin
            end_flag <=1;
            i_conv_addr <= 0;
          end
          if (row_counter >= 3) begin
            sram_o_data[191-(row_counter-3)*8-:8] <= o_conv_dout[7:0];
          end
        end
        else begin
            row_counter <=0;
            
        end
      end
  end
  always @(posedge PEclk or negedge rst_n) begin  //PE时钟
    if (!rst_n) begin
      col_counter <= 6'd0;
    end else begin
    if(conv_start)begin
      if (!out_data_vld && col_counter == 34) begin
        col_counter <= 0;
      end
      if (out_data_vld) begin
        if (col_counter < 6'd34) begin
          col_counter <= col_counter + 6'd1;
        end else begin
          col_counter <= 6'd0;
        end
        if (col_counter == 1 || col_counter == 34) begin
          parallel_data <= padding_data;
        end else begin
          parallel_data[207:200] <= input_padding[7:0];
          parallel_data[7:0] <= input_padding[7:0];
          parallel_data[199:8] <= sram_o_data[191:0];
        end
      end
    end
    else begin col_counter<=0;
    end
    end
  end



endmodule
