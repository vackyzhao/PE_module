`timescale 1ns / 1ps

module new_PE_Unit (
    input clk,               // PE的时钟信 (Clock signal for the PE)
    input rst_n,             // 复位信号，低电平有效 (Reset signal, active low)
    input en,                // 使能信号 (Enable signal)

    input signed [7:0] Filtr_in_0,   // 输入权重 8 *3(卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    input signed [7:0] Filtr_in_1,  
    input signed [7:0] Filtr_in_2,  

    input signed [7:0] Ifmap_shift_in,   // 输入特征 8位（数据 (Input feature map 8-bit * 3 channels, data)    
    input signed [19:0] Psum_in,    // 输入上一个PE的结果 (Input result from the previous PE)

    output  signed [7:0] Ifmap_shift_out, // 输出特征 8位（结果 (Output feature map 8-bit * 3 channels, result)
    output signed  [19:0] Psum_out   // 输出计算结果 (Output computation result)
);

wire signed [15:0] result_0, result_1, result_2; // 中间结果，每个道的卷积结
wire signed [7:0] Ifmap_in_0, Ifmap_in_1, Ifmap_in_2; // 经过移位寄存器后的输入特征图
reg signed [19:0] Psum_tmp;

assign Ifmap_shift_out = Ifmap_in_0; // 输出经过移位寄存器的特征
wire signed [19:0] result_sum;
assign result_sum = result_0 + result_1 + result_2; // 三个道的卷积结果相加
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
mult_ip mult_8x8_0 (
  .CLK(clk),     // 输入时钟信号
  .CE(en),       // 输入使能信号
  .A(Ifmap_in_0), // 输入A�?8位特征图数据
  .B(Filtr_in_0), // 输入B�?4位权重数�?
  .P(result_0)   // 输出P，卷积结�?
);
mult_ip mult_8x8_1 (
  .CLK(clk),
  .CE(en),
  .A(Ifmap_in_1),
  .B(Filtr_in_1),
  .P(result_1)
);
mult_ip mult_8x8_2 (
  .CLK(clk),
  .CE(en),
  .A(Ifmap_in_2),
  .B(Filtr_in_2),
  .P(result_2)
);

// 组合逻辑块：用于计算卷积结果
always @(*) begin
    if (!rst_n) begin
        // 复位状态下的操作
        Psum_tmp <= 20'b0;
        
    end
    else if (en) begin
        // 当使能信号有效时执行计算
        //Psum_tmp <= Psum_in + result_0 + result_1 + result_2;
         Psum_tmp <= Psum_in + result_sum;
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
