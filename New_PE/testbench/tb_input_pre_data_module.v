`timescale 10ns / 1ps

module tb_Input_pre_data_module;
  
  reg din_clk;
  reg [7:0] i_data_din;
  reg i_data_din_vld;
  reg [7:0]padding;
  reg dout_clk;
  reg en;
  reg rst_n;
  wire dout_vld;
  wire PEclk;
  wire [207:0]parallel_data;

  // 实例化被测试的模块
  Input_pre_data_module dut (
    .din_clk(din_clk),
    .i_data_din(i_data_din),
    .i_data_din_vld(i_data_din_vld),
    .input_padding(padding),
    .dout_clk(dout_clk),
    .en(en),
    .rst_n(rst_n),
    .PEclk(PEclk),
    .dout_vld(dout_vld),
    .parallel_data(parallel_data)
  );
 parameter Tclk = 2;
 
 initial begin
 // define clk
  dout_clk = 0;
  forever #(Tclk / 2) dout_clk = ~dout_clk;
 end

  initial begin
 // define clk
  din_clk = 0;
  forever #(Tclk / 2) din_clk = ~din_clk;
 end
  // 初始化信号
  initial begin
    din_clk = 1;
    i_data_din = 8'd0;
    i_data_din_vld = 0;
    dout_clk = 0;
    en = 1 ;
    rst_n = 0;
    padding=8'b10000001;
    #(Tclk * 100)
    rst_n = 1;
    // 设置使能信号和其他输入
    en = 1;
    i_data_din_vld = 1;
  end

  

  // 添加任何必要的时序检查或输出结果的代码

endmodule
