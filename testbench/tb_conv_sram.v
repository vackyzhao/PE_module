`timescale 1ns / 1ps

module testbench;

  // 信号声明
  reg clk;
  reg [15:0] din;
  reg [15:0] addr;
  reg cs;
  reg we;
  reg  wem;
  wire [15:0] dout;

  // 模块实例化
  conv_sram uut (
    .clk(clk),
    .din(),
    .addr(addr),
    .cs(1),
    .we(0),
    .wem(0),
    .dout(dout)
  );

  // 初始化
  initial begin
    // 初始化信号
    clk = 0;
    din = 0;
    addr = 0;
    cs = 0;
    we = 0;
    wem = 0;

    // 生成时钟
    forever #5 clk = ~clk;

    // 激活读取操作
    cs = 1;
    we = 0;
    
    #10 addr=16'd0;
    #10 addr=16'd1;
    #10 addr=16'd2;
    #10 addr=16'd3;
    #10 addr=16'd4;
    #10 addr=16'd161;
    

    // 结束仿真
    $finish;
  end

endmodule
