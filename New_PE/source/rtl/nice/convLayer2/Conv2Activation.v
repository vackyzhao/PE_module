module Conv2Activation (
    input signed  [15:0] din,
    output signed   [7:0] dout
);
reg [7:0] dout;
reg signed [15:0] step1_result;
reg signed [15:0] step2_result;
  always @(*) begin
     // 第一步：除以 8（右移 3 位），减去 128
    step1_result = (din >> 3) - 128;
    // 第二步：除以 32（右移 5 位）
   step2_result = step1_result >> 5;
    // 第三步：限制在 -128 到 127 之间
    dout = (step2_result > 127) ? 127 : ((step2_result < -128) ? -128 : step2_result);
    
  end
endmodule
