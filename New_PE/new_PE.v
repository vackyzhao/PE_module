`timescale 1ns / 1ps
module new_PE_Unit (
    input clk,               // PE的时钟信号 (Clock signal for the PE)
    input rst_n,             // 复位信号，低电平有效 (Reset signal, active low)
    input en,                // 使能信号 (Enable signal)

    input [11:0] Filtr_in,   // 输入权重 4位 *3(卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    input [7:0] Ifmap_shift_in,   // 输入特征图 8位（数据） (Input feature map 8-bit * 3 channels, data)    
    input [13:0] Psum_in,    // 输入上一个PE的结果 (Input result from the previous PE)

    output reg [11:0]  Filtr_out,   // 输入权重 4位 *3(卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    output  [7:0] Ifmap_shift_out, // 输出特征图 8位（结果） (Output feature map 8-bit * 3 channels, result)
    output reg [13:0] Psum_out   // 输出计算结果 (Output computation result)
);

wire [11:0] result_0,result_1,result_2;
wire [7:0] Ifmap_in_0,Ifmap_in_1,Ifmap_in_2;

assign Ifmap_shift_out = Ifmap_in_0;

shift_register shift_register_0(
  .clk(clk),
  .rst_n(rst_n),
  .en(en),
  .input_data(Ifmap_shift_in),
  .output_data_0(Ifmap_in_0),
  .output_data_1(Ifmap_in_1),
  .output_data_2(Ifmap_in_2)
);

mult_ip mult_8x4_0 (
  .CLK(clk),  // input wire CLK
  .CE(en),    // input wire CE
  .A(Ifmap_in_0),      // input wire [7 : 0] A
  .B(Filtr_in[3:0]),      // input wire [3 : 0] B
  .P(result_0)      // output wire [11 : 0] P
);
mult_ip mult_8x4_1 (
  .CLK(clk),  // input wire CLK
  .CE(en),    // input wire CE
  .A(Ifmap_in_1),      // input wire [7 : 0] A
  .B(Filtr_in[7:4]),      // input wire [3 : 0] B
  .P(result_1)      // output wire [11 : 0] P
);
mult_ip mult_8x4_2 (
  .CLK(clk),  // input wire CLK
  .CE(en),    // input wire CE
  .A(Ifmap_in_2),      // input wire [7 : 0] A
  .B(Filtr_in[11:8]),      // input wire [3 : 0] B
  .P(result_2)      // output wire [11 : 0] P
);
always @(*)
begin
    if (!rst_n) begin
        // 复位状态下的操作
    end
    else begin
        // 非复位状态下的操作
        if (en) begin
            Psum_out <= Psum_in+ result_0 + result_1 + result_2;
            Filtr_out <=Filtr_in;
        end
    end
end
endmodule