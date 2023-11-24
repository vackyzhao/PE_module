// 设置时钟分辨�?
`timescale 1ns / 1ps

// 定义模块 PingPongBuffer
module PingPongBuffer #(
    parameter DP = 768  // DP 参数，可在模块实例化时配�?
) (
    input             i_clk_input,        // 输入时钟信号
    input             i_clk_output,       // 输出时钟信号
    input             i_rst_n,            // 复位信号输入
    input             en,                 // 片�?�使能信�? 
    //////////////////////////////////
    input             i_switch_pingpong,  // pingpong 切换信号输入，用于切换状�?
    //////////////////////////////////
    input       [7:0] i_data_din,         // data 输入数据 
    input             i_data_din_vld,     // data 输入数据有效信号 
    output reg        o_pl_buffer_ready,  // 输入完成信号，表示数据已经准备好
    //////////////////////////////////
    input       [9:0] i_conv_addr,        // 卷积输出地址	1024=2^10 
    output wire [7:0] o_conv_dout,         // 卷积数据输出  
    output o_state_change 
);

  // 定义状�?�参�?
  parameter STATE_A = 1'b0;
  parameter STATE_B = 1'b1;
  
  // 状�?�寄存器和初始状�?
  reg       current_state;  // 状�?�机寄存器，用于跟踪当前状�??
  reg [9:0] input_counter;  // 输入计数器，用于跟踪输入的数据量


  initial begin
    current_state = STATE_A;  // 初始状�?�为 A
    input_counter = 10'b0;  // 地址寄存器清�?
  end

  reg o_pl_buffer_ready_flag;
  reg sram0_clk, sram1_clk;  // sram0 �? sram1 的时钟信�?
  reg sram0_we, sram1_we;  // sram0 �? sram1 的写使能信号

  reg  [7:0] sram0_din;  // sram0 数据输入
  wire [7:0] sram0_dout;  // sram0 数据输出
  reg  [7:0] sram1_din;  // sram1 数据输入
  wire [7:0] sram1_dout;  // sram1 数据输出
  reg  [7:0] data_out;  // 输出的数�?
  reg  [9:0] sram0_addr;  // sram0 地址
  reg  [9:0] sram1_addr;  // sram1 地址
  reg [9:0] i_sram_addr, o_sram_addr;

  assign o_conv_dout = data_out;  // 将数据输出连接到 o_conv_dout

  // 输入预处�? sram0 模块实例�?
  input_pre_sram sram0 (
      .clk (sram0_clk),
      .din (sram0_din),
      .addr(sram0_addr),
      .cs  (en),
      .we  (sram0_we),
      .wem (1'b1),
      .dout(sram0_dout)
  );

  // 输入预处�? sram1 模块实例�?
  input_pre_sram sram1 (
      .clk (sram1_clk),
      .din (sram1_din),
      .addr(sram1_addr),
      .cs  (en),
      .we  (sram1_we),
      .wem (1'b1),
      .dout(sram1_dout)
  );
reg current_state_ff1;


  // 时序逻辑块，根据时钟信号执行状�?�机的操�?
  always @(posedge i_clk_input) begin
    if (!i_rst_n) begin
      // 如果复位信号 i_rst_n 为低电平，则复位状�?�机到初始状�?
      o_pl_buffer_ready <= 1'b0;
      input_counter = 10'b0;
      current_state = STATE_A;
    end else begin
      if (current_state == STATE_A && i_switch_pingpong == STATE_B) begin
        // 在状�? A 下，如果接收到切换信�? i_switch_pingpong 到状�? B
        input_counter = 10'b0;  // 重置输入计数�?
        current_state = STATE_B;  // 切换到状�? B
      end
      if (current_state == STATE_B && i_switch_pingpong == STATE_A) begin
        // 在状�? B 下，如果接收到切换信�? i_switch_pingpong 到状�? A
        input_counter = 10'b0;  // 重置输入计数�?
        current_state = STATE_A;  // 切换到状�? A
      end
      case (current_state)
        STATE_A: begin
          // 在状�? A 下的操作：sram0 输入，sram1 输出
          i_sram_addr = input_counter;  // 设置 sram0 的地�?
          sram0_din   = i_data_din;  // 输入数据�? sram0
          sram1_we    = 1'b0;
          if (i_data_din_vld && (i_sram_addr < DP )) begin
            // 如果输入数据有效并且计数器小�? DP
            sram0_we      = 1'b1;  // 使能 sram0 写操�?
            input_counter = input_counter + 1;  // 增加计数�?
          end
        end
        STATE_B: begin
          // 在状�? B 下的操作：sram0 输出，sram1 输入
          i_sram_addr = input_counter;  // 设置 sram0 的地�?
          sram1_din   = i_data_din;  // 输入数据�? sram0
          sram0_we    = 1'b0;
          if (i_data_din_vld && (i_sram_addr < DP )) begin
            // 如果输入数据有效并且计数器小�? DP
            sram1_we      = 1'b1;  // 使能 sram0 写操�?
            input_counter = input_counter + 1;  // 增加计数�?
          end
        end
      endcase
      if (i_sram_addr == DP - 1) begin
        o_pl_buffer_ready <= 1'b1;
      end else begin
        o_pl_buffer_ready <= 1'b0;
      end
    end
  end

  // 时序逻辑块，根据时钟信号执行数据输出操作
  always @(posedge i_clk_output) begin
    case (current_state)
      STATE_A: begin
        // 在状�? A 下的操作：sram0 输入，sram1输出   

        o_sram_addr = i_conv_addr;  // 设置 sram1 的地�?为卷积输出地�?
        data_out = sram1_dout;  // 输出数据等于 sram1 的输出数�?
      end
      STATE_B: begin
        // 在状�? B 下的操作：sram0 输出，sram1 输入        
        o_sram_addr = i_conv_addr;  // 设置 sram0 的地�?为卷积输出地�?
        data_out = sram0_dout;  // 输出数据等于 sram0 的输出数�?
      end
    endcase
  end

  // 时序逻辑块，根据状�?��?�择时钟信号连接
  always @(*) begin
    case (current_state)
      STATE_A: begin
        // 在状�? A 下的操作：sram0 输入，sram1输出
        sram1_clk  <= i_clk_output;  // 连接输出时钟�? sram1
        sram0_clk  <= i_clk_input;  // 连接输入时钟�? sram0
        sram0_addr <= i_sram_addr-1;
        sram1_addr <= o_sram_addr;
      end
      STATE_B: begin
        // 在状�? B 下的操作：sram0输出，sram1输入
        sram0_clk  <= i_clk_output;  // 连接输出时钟�? sram0
        sram1_clk  <= i_clk_input;  // 连接输入时钟�? sram1
        sram1_addr <= i_sram_addr-1;
        sram0_addr <= o_sram_addr;
      end
    endcase
  end
always@(posedge i_clk_output or negedge i_rst_n)begin
    if(!i_rst_n) current_state_ff1 <=0;
    else current_state_ff1 <= current_state;
end
assign o_state_change =current_state ^current_state_ff1;

endmodule
