`timescale 1ns / 1ps

module new_PE_Unit_conv1 (
    input clk,               // PE的时钟信�? (Clock signal for the PE)
    input rst_n,             // 复位信号，低电平有效 (Reset signal, active low)
    input en,                // 使能信号 (Enable signal)

    input [23:0] Filtr_in,   // 输入权重 8�? *3(卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    input [7:0] Ifmap_shift_in,   // 输入特征�? 8位（数据�? (Input feature map 8-bit * 3 channels, data)    
    input [19:0] Psum_in,    // 输入上一个PE的结�? (Input result from the previous PE)

    output reg [23:0] Filtr_out,   // 输出权重 4�? *3(卷积核） (Output weights 4-bit * 3 channels, convolution kernel)
    output  [7:0] Ifmap_shift_out, // 输出特征�? 8位（结果�? (Output feature map 8-bit * 3 channels, result)
    output wire [19:0] Psum_out   // 输出计算结果 (Output computation result)
);

wire [19:0] result_0, result_1, result_2; // 中间结果，每个�?�道的卷积结�?
wire [7:0] Ifmap_in_0, Ifmap_in_1, Ifmap_in_2; // 经过移位寄存器后的输入特征图
reg [19:0] Psum_tmp;

assign Ifmap_shift_out = Ifmap_in_0; // 输出经过移位寄存器的特征�?

// 实例化移位寄存器模块
shift_register shift_register_0(
  .clk(clk),
  .rst_n(rst_n),
  .en(en),
  .input_data(Ifmap_shift_in),
  .output_data_0(Ifmap_in_0),
  .output_data_1(Ifmap_in_1),
  .output_data_2(Ifmap_in_2)
);

// 实例化乘法器模块，用于计算卷积结�?
mult_ip_conv1 mult_8x4_0 (
  .CLK(),     // 输入时钟信号
  .CE(),       // 输入使能信号
  .A(Ifmap_in_0), // 输入A�?8位特征图数据
  .B(Filtr_in[7:0]), // 输入B�?4位权重数�?
  .P(result_0)   // 输出P，卷积结�?
);
mult_ip_conv1 mult_8x4_1 (
  .CLK(),
  .CE(),
  .A(Ifmap_in_1),
  .B(Filtr_in[15:8]),
  .P(result_1)
);
mult_ip_conv1 mult_8x4_2 (
  .CLK(),
  .CE(),
  .A(Ifmap_in_2),
  .B(Filtr_in[23:16]),
  .P(result_2)
);
// 初始化输出为�?
initial begin
    Filtr_out = 24'b0; // 输出权重初始化为�?
    Psum_tmp = 20'b0;  // 输出计算结果初始化为�?
end
// 组合逻辑块：用于计算卷积结果
always @(*) begin
    if (!rst_n) begin
        // 复位状�?�下的操�?
        // 在复位状态下，可以设置默认的输出�?
        Psum_tmp <= 0; // 复位后计算结果清�?
        Filtr_out <= 0; // 复位后权重清�?
    end
    else begin
        // 非复位状态下的操�?
        if (en) begin
            // 当使能信号高电平有效时执行计�?
            Psum_tmp <= $signed(Psum_in) + $signed(result_0) +  $signed(result_1) +  $signed(result_2); // 计算卷积结果
            Filtr_out <= Filtr_in; // 输出权重数据不变
        end
    end
end

sirv_gnrl_dfflr #(20) Psum_reg (
  .lden(en),
  .dnxt(Psum_tmp),
  .qout(Psum_out),
  .clk(clk),
  .rst_n(rst_n)
);

endmodule
