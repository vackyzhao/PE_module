module clockDivider34_tb;

  // 时钟信号
  reg clk;
  // 分频器输出信号
  wire divided;

  // 实例化被测试的Divider34模块
  clockDivider34 divider34_inst (
    .clk(clk),
    .divided(divided)
  );

  // 定义时钟生成器
  always
    begin
      #5 clk = ~clk; // 50% 占空比的时钟
    end

  // 初始化模块
  initial
    begin
      // 初始时钟
      clk = 0;

      // 等待一些时钟周期
      #100;

      // 打印分频后的信号
      $display("Time = %0t: Divided = %b", $time, divided);

      // 模拟运行时间
      #200;

      // 结束模拟
      $finish;
    end

endmodule
