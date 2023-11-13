module Conv1Activation (
    input [13:0] din,
    output reg [7:0] dout
);

  always @(*) begin
    dout[7:0] = din[7:0];
    /*
    if (din < 64) begin
        // 如果输入小于64，直接将输出设置为输入的低8位
        dout = din[7:0];
    end else if (din < 4096) begin
        // 如果输入在64到4095之间，右移5位（除以32），并加上64-2
        dout = (din >> 5) + 64 - 2;
    end else if (din < 8192) begin
        // 如果输入在4096到8191之间，右移7位（除以128），并加上128+32-2
        dout = (din >> 7) + 128 + 32 - 2;
    end else if (din < 16384) begin
        // 如果输入在8192到16383之间，右移8位（除以256），并加上128+32-2
        dout = (din >> 8) + 128 + 32 - 2;
    end else begin
        // 处理任何其他情况，将输出设置为0
        dout = 8'b0;
    end
    */
  end
endmodule
