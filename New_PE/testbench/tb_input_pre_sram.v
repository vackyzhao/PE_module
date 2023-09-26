`timescale 1ns / 1ps

module tb_input_pre_sram;
  // 时钟信号
  reg clk;
  // 输入信号
  reg [7:0] din;
  reg [15:0] addr;
  reg cs;
  reg we;
  reg wem;
  // 输出信号
  wire [7:0] dout;

  // 实例化被测试模块
  input_pre_sram dut (
    .clk(clk),
    .din(din),
    .addr(addr),
    .cs(cs),
    .we(we),
    .wem(wem),
    .dout(dout)
  );
parameter Tclk = 10;
 initial begin
 // define clk
clk = 0;
 forever #(Tclk / 2) clk = ~clk;
 end

  // 初始化输入信号
  initial begin
    // 初始化时钟
    // 初始化输入信号
    din = 8'd8; // 8位数据
    addr = 16'd1155; // 地址
    cs = 1; // 使能信号
    we = 1; // 写使能信号
    wem = 1'b1; // 写使能掩码
   
    #(Tclk*10) 
    we = 0;
    //wem = 1'b0;
din = 8'd0; // 8位数据

  end
endmodule