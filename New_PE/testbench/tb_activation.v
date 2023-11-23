`timescale 1ns/1ns

module tb_activation;

  // 定义时钟和复位信号
  reg clk;
  reg rst;

  // 定义输入信号
  reg [19:0] din;

  // 定义输出信号
  wire [7:0] dout;

  // 实例化被测试的模块
  Conv1Activation dut (
    .din(din),
    .dout(dout)
  );

  // 时钟生成模块
  always begin
    #5 clk = ~clk; // 周期为 10 个时间单位
  end

  // 初始化时钟和复位
  initial begin
    clk = 0;
    rst = 1;
    // 等待 20 个时间单位，然后将复位信号拉低
    #20 rst = 0;
  end

  // 测试输入序列
  initial begin
    // 在时钟上升沿时提供输入数据
    #5 din = 20'd1;
    #5 din = 20'd512;
    #5 din = 20'd640;
    #5 din = 20'h01234; // 示例输入数据 1
    #5 din = 20'h89ABC; // 示例输入数据 2
    #5 din = 20'h80000; // 示例输入数据 3 (最小负数)
    #5 din = 20'h7FFFF; // 示例输入数据 4 (最大正数)
    // 添加更多测试数据...

    // 等待一段时间，然后结束仿真
    #100 $finish;
  end

endmodule
