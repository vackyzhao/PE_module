`timescale 1ns / 1ps

module new_PE_Unit (
    input clk,               // PE的时钟信号 (Clock signal for the PE)
    input rst_n,             // 复位信号，低电平有效 (Reset signal, active low)
    input en,                // 使能信号 (Enable signal)

    input [7:0] Ifmap_in_1,   // 输入特征图 8位（数据） (Input feature map 8-bit * 3 channels, data)
    input [7:0] Ifmap_in_2,  // 输入特征图 8位（数据） (Input feature map 8-bit * 3 channels, data)
    input [7:0] Ifmap_in_3,  // 输入特征图 8位（数据） (Input feature map 8-bit * 3 channels, data)

    input [4:0] Filtr_in_1,   // 输入权重 4位 (卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    input [4:0] Filtr_in_2,  // 输入权重 4位（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    input [4:0] Filtr_in_3, // 输入权重 4位（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    input [11:0] Psum_in,    // 输入上一个PE的结果 (Input result from the previous PE)

    output reg [7:0] Ifmap_out_1, // 输出特征图 8位（结果） (Output feature map 8-bit * 3 channels, result)
    output reg [7:0] Ifmap_out_2, // 输出特征图 8位（结果） (Output feature map 8-bit * 3 channels, result)
    output reg [7:0] Ifmap_out_3, // 输出特征图 8位（结果） (Output feature map 8-bit * 3 channels, result)

    output reg [11:0] Psum_out   // 输出计算结果 (Output computation result)
);

  reg  current_state, next_state;  // 状态机的当前状态和下一状态 (Current state and next state of the state machine)
  
  wire [11:0] temp_result_1;  // 存储MAC计算的结果 (Store the result of MAC calculation)
  wire [11:0] temp_result_2;  // 存储MAC计算的结果 (Store the result of MAC calculation)
  wire [11:0] temp_result_3;// 存储MAC计算的结果 (Store the result of MAC calculation)

  reg [7:0] next_Ifmap_1;  // 暂存特征图
  reg [7:0] next_Ifmap_2;
  reg [7:0] next_Ifmap_3;


  // 同步复位逻辑 (Synchronous reset logic)
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      current_state <= 1'b0;
      Psum_out <= 12'b0;
      Ifmap_out_1 <= 8'b0;
      Ifmap_out_2 <= 8'b0;
      Ifmap_out_3 <= 8'b0;
    end else begin
      if (en) begin
        current_state <= next_state;        
      end
    end
  end

mult_8x4 mult_8x4_0 (
  .CLK(clk),  // input wire CLK
  .A(Ifmap_in_3),      // input wire [7 : 0] A
  .B(Filtr_in_3),      // input wire [3 : 0] B
  .CE(en),    // input wire CE
  .P(temp_result_3)      // output wire [11 : 0] P
);
mult_8x4 mult_8x4_1 (
  .CLK(clk),  // input wire CLK
  .A(Ifmap_in_1),      // input wire [7 : 0] A
  .B(Filtr_in_1),      // input wire [3 : 0] B
  .CE(en),    // input wire CE
  .P(temp_result_1)      // output wire [11 : 0] P
);

mult_8x4 mult_8x4_2 (
  .CLK(clk),  // input wire CLK
  .A(Ifmap_in_2),      // input wire [7 : 0] A
  .B(Filtr_in_2),      // input wire [3 : 0] B
  .CE(en),    // input wire CE
  .P(temp_result_2)      // output wire [11 : 0] P
);



  always @(*) begin
    case (current_state)
      0: begin
        next_state  = 1;
        next_Ifmap_1<=Ifmap_in_1;
        next_Ifmap_2<=Ifmap_in_2;
        next_Ifmap_3<=Ifmap_in_3;
      end
      1: begin
        next_state  = 0;
        Ifmap_out_1 <= next_Ifmap_1;
        Ifmap_out_2 <= next_Ifmap_3;
        Ifmap_out_3 <= next_Ifmap_3;       
        Psum_out=$signed(temp_result_1)+$signed(temp_result_2)+$signed(temp_result_3);

      end
      default: begin
        next_state  = 0;
        next_Ifmap_1  = {12{1'bx}}; // 默认情况下，保持未定义 (Default to keep undefined)
        next_Ifmap_2  = {12{1'bx}}; // 默认情况下，保持未定义 (Default to keep undefined)
        next_Ifmap_3  = {12{1'bx}}; // 默认情况下，保持未定义 (Default to keep undefined)
      end
    endcase
  end
endmodule