// 设置时钟和时间刻度
`timescale 1ns / 1ps

module PE_Unit (
    input clk,       // PE的时钟信号
    input rst_n,     // 复位信号，低电平有效
    input en,        // 使能信号
    input [23:0] Ifmap_in,  // 输入特征图 8位*3通道（数据）
    input [11:0] Filtr_in,  // 输入权重 4位*3通道（卷积核）
    input [19:0] Psum_in,   // 输入上一个PE的结果
    output reg [23:0] Ifmap_out, // 输出特征图 8位*3通道（结果）
    output reg [19:0] Psum_out   // 输出计算结果
);

  reg [1:0] current_state, next_state;  // 状态机的当前状态和下一状态
  reg [19:0] temp_result;  // 存储MAC计算的结果
  reg [23:0] next_Ifmap;  // 每3个时钟周期更新Ifmap_out

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      current_state <= 2'b00;
      Psum_out <= 0;
      Ifmap_out <= 0;
    end else begin
      if (en) begin
        current_state <= next_state;
        Ifmap_out <= next_Ifmap;
        Psum_out <= temp_result;
        // Psum_out 和 MAC_result 是同一个寄存器
      end
    end
  end

  always @(*) begin
    case (current_state)
      0: begin
        next_state  = 1;
        next_Ifmap  = Ifmap_out;
        temp_result = $signed(Psum_in) + $signed(Filtr_in[11:8] * Ifmap_in[23:16]);
      end
      1: begin
        next_state  = 2;
        next_Ifmap  = Ifmap_out;
        temp_result = $signed(Psum_out) + $signed(Filtr_in[7:4] * Ifmap_in[15:8]);
      end
      2: begin
        next_state  = 0;
        next_Ifmap  = Ifmap_in;
        temp_result = $signed(Psum_out) + $signed(Filtr_in[3:0] * Ifmap_in[7:0]);
      end
      default: begin
        next_state  = 0;
        next_Ifmap  = {24{1'bx}}; // 默认情况下，保持未定义
        temp_result = {20{1'bx}}; // 默认情况下，保持未定义
      end
    endcase
  end

endmodule
