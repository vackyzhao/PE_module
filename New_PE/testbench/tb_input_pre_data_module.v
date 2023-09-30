`timescale 1ns / 1ps

module tb_Input_pre_data_module;
  
  reg din_clk;
  reg [7:0] i_data_din;
  reg i_data_din_vld;
  reg dout_clk;
  reg en;
  reg rst_n;
  reg i_switch_pingpong;
  wire PEclk;
  wire [0:271] prallel_data;

  // 实例化被测试的模块
  Input_pre_data_module dut (
    .din_clk(din_clk),
    .i_data_din(i_data_din),
    .i_data_din_vld(i_data_din_vld),
    .dout_clk(dout_clk),
    .en(en),
    .rst_n(rst_n),
    .i_switch_pingpong(i_switch_pingpong),
    .PEclk(PEclk),
    .prallel_data(prallel_data)
  );

  // 初始化信号
  initial begin
    din_clk = 0;
    i_data_din = 8'h00;
    i_data_din_vld = 0;
    dout_clk = 0;
    en = 1 ;
    rst_n = 1;
    i_switch_pingpong = 0;

    // 模拟时钟
    //forever #5 din_clk = ~din_clk;
    forever #5 dout_clk = ~dout_clk;

    // 初始化其他测试信号
    // 这里可以添加测试用例的代码

    // 停顿一段时间，然后开始测试
    #100;

    // 设置使能信号和其他输入
    en = 1;
    i_data_din_vld = 1;
    // 设置测试用例的输入数据

    // 继续模拟直到完成测试
    #1000;
    
    // 在测试完成后添加任何必要的检查或打印结果的代码

    // 终止仿真
    $finish;
  end

  // 添加任何必要的时序检查或输出结果的代码

endmodule
