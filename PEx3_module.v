module PEx3_module (
    input PE_clk,  //PE 时钟(3倍频clk时钟)
    input rst_n,  //复位信号，低有效
    input en,  //使能信号，高有效 

    input [23:0] Ifmap_in_1,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_2,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [23:0] Ifmap_in_3,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    input [11:0] Filtr_in_1,// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    input [11:0] Filtr_in_2,//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    input [11:0] Filtr_in_3,// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    output [23:0] Ifmap_out_1,// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    output [23:0] Ifmap_out_2,// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    output [19:0] Conv_result,  //输出计算结果
    output reg PE_out_clk // 输出的3分频时钟信号 (Output 3x frequency clock signal)
);

  wire [19:0] Psum_1;
  wire [19:0] Psum_2;

  // 生成3分频时钟信号
  // Generate a 3x frequency clock signal

  
  reg [1:0] PE_clk_count;    // 时钟计数器，用于控制时钟相位 (Clock counter for controlling clock phase)

  always @(posedge PE_clk or negedge rst_n) begin
    if (!rst_n) begin
      PE_clk_count = 2'b0;  // 复位时将计数器重置为0 (Reset the counter to 0 during reset)
      PE_out_clk = 1'b0;  // 默认输出低电平时钟 (Default output low level clock)
    end else begin
      if (en) begin
        PE_out_clk = 1'b0;  // 默认输出低电平时钟 (Default output low level clock)
        PE_clk_count = PE_clk_count + 1'b1;  // 每个时钟周期递增计数器 (Increment the counter every clock cycle)
        if (PE_clk_count == 2'b11) begin // 当计数器达到3时，重置计数器 (Reset the counter when it reaches 2)
          PE_clk_count = 2'b00;  
          PE_out_clk = 1'b1;  // 输出高电平时钟 (Output high level clock)
        end
      end
    end
  end


  PE_Unit PE_Unit_1 (
      .clk(PE_clk),  // PE的时钟信号 (Clock signal for the PE)
      .rst_n(rst_n),  // 复位信号，低电平有效 (Reset signal, active low)
      .en(en),  // 使能信号 (Enable signal)
      .Ifmap_in(Ifmap_in_1),   // 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Filtr_in(Filtr_in_1),   // 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Psum_in(Psum_1),  // 输入上一个PE的结果 (Input result from the previous PE)
      .Ifmap_out(), // 输出特征图 8位*3通道（结果） (Output feature map 8-bit * 3 channels, result)
      .Psum_out(Conv_result)  // 输出计算结果 (Output computation result)
  );

  PE_Unit PE_Unit_2 (
      .clk(PE_clk),  // PE的时钟信号 (Clock signal for the PE)
      .rst_n(rst_n),  // 复位信号，低电平有效 (Reset signal, active low)
      .en(en),  // 使能信号 (Enable signal)
      .Ifmap_in(Ifmap_in_2),   // 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Filtr_in(Filtr_in_2),   // 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Psum_in(Psum_2),  // 输入上一个PE的结果 (Input result from the previous PE)
      .Ifmap_out(Ifmap_out_1), // 输出特征图 8位*3通道（结果） (Output feature map 8-bit * 3 channels, result)
      .Psum_out(Psum_1)  // 输出计算结果 (Output computation result)
  );

  PE_Unit PE_Unit_3 (
      .clk(PE_clk),  // PE的时钟信号 (Clock signal for the PE)
      .rst_n(rst_n),  // 复位信号，低电平有效 (Reset signal, active low)
      .en(en),  // 使能信号 (Enable signal)
      .Ifmap_in(Ifmap_in_3),   // 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
      .Filtr_in(Filtr_in_3),   // 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
      .Psum_in(20'b0),  // 输入上一个PE的结果 (Input result from the previous PE)
      .Ifmap_out(Ifmap_out_2), // 输出特征图 8位*3通道（结果） (Output feature map 8-bit * 3 channels, result)
      .Psum_out(Psum_2)  // 输出计算结果 (Output computation result)
  );


endmodule
