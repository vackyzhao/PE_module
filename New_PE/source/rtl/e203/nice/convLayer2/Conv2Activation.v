module Conv2Activation (
    input  signed [19:0] din,
    output reg  signed [7:0] dout
);
reg  signed [19:0] step0_result;
reg  signed [19:0] step1_result;
reg  signed [19:0] step2_result;
reg  signed [7:0] step3_result;

always @(*) begin
    step0_result = $signed(din >>> 3);
    // 第一步：除以 4（右�? 2 位），减�? 128
    step1_result = $signed(step0_result - 128);
     
    // 第二步：除以 32（右�? 5 位）
    step2_result = $signed(step1_result >>> 5);

    // 第三步：限制�? -128 �? 127 之间
    step3_result = $signed((step2_result > 127) ? 127 : ((step2_result < -128) ? -128 : (step2_result)));

    // 将结果限制在 0 到 127 之间，并应用 RELU
    dout = $signed((step3_result > 127) ? 127 : ((step3_result < 0) ? 0 : step3_result));
end

endmodule
