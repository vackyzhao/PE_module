`timescale 1ns / 1ps

module tb_Input_pre_data_module;

  // 时钟信号
  reg din_clk;
  reg dout_clk;

  // 输入数据和控制信号
  reg [7:0] i_data_din;
  reg i_data_din_vld;
  reg en;
  reg rst_n;
  reg i_switch_pingpong;

  // 时钟分频信号
  wire PEclk;

  // 实例化被测试的模块
  Input_pre_data_module dut (
    .din_clk(din_clk),
    .i_data_din(i_data_din),
    .i_data_din_vld(i_data_din_vld),
    .dout_clk(dout_clk),
    .en(en),
    .rst_n(rst_n),
    .i_switch_pingpong(i_switch_pingpong),
    .PEclk(PEclk)
  );

  // 初始化
  initial begin
    // 初始化输入信号
    din_clk = 0;
    dout_clk = 0;
    i_data_din = 8'b0;
    i_data_din_vld = 0;
    en = 0;
    rst_n = 1;
    i_switch_pingpong = 0;

    // 启动仿真
    // 可以在这里设置输入信号的值，以及观察模块的输出
    // 例如：
    // i_data_din = 8'b10101010;
    // i_data_din_vld = 1;
    // en = 1;
    // rst_n = 0;
  end

parameter Tclk = 10;
 initial begin
 // define clk
clk = 0;
 forever #(Tclk / 2) dout_clk = ~dout_clk;
 end

  // 时钟生成
  always begin
    

    
  end

endmodule
