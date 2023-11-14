`timescale 1ns/1ps
module Conv2Activation (
    input signed  [19:0] din,
    output reg  [7:0] dout
);
reg signed [19:0] step1_result;
reg signed [19:0] step2_result;
  always @(*) begin
    // 第一步：除以 4（右移 2 位），减去 128
    step1_result = (din >> 2) - 20'd128;
    // 第二步：除以 32（右移 5 位）
   step2_result = step1_result >> 20'd5;
    // 第三步：限制在 -128 到 127 之间 RELU
    dout = (step2_result > 8'd127) ? 8'd127 : ((step2_result < 8'd0) ? 8'd0 : step2_result);
    
  end
endmodule
