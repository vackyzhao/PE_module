`timescale 1ns / 1ps
module clockDivider (
    input  wire clk50M_in,   // 输入时钟信号
    input  wire rst_n,
    output reg clk115k_out,  // 输出分频后的信号
    output reg clk1M_out    // 输出分频后的信号
);

  reg [7:0] counter_1 = 8'd0;
  reg [7:0] counter_2 = 8'd0;

  always @(posedge clk50M_in or negedge rst_n) begin
    if (!rst_n) begin
      clk115k_out = 1'd0;
      clk1M_out  = 1'd0;
    end else begin

      if (counter_1 == 8'd216) begin  //计数器到216切换
        counter_1 <= 8'd0;
        clk115k_out = ~clk115k_out;
      end else begin
        counter_1 <= counter_1 + 1'd1;  // 计数器加1
      end

      if (counter_2 == 8'd24) begin  //计数器到24切换
        counter_2 <=8'd0;
        clk1M_out = ~clk1M_out;
      end else begin
        counter_2 <= counter_2 + 1'd1;  // 计数器加1
      end
    end
  end


endmodule
