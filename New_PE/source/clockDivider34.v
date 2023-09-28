module clockDivider34(
    input wire clk,       // 输入时钟信号
    output wire divided  // 输出分频后的信号
);

reg [5:0] counter=6'd0;       // 6位计数器，可以分频到2^6 = 64
reg clk_out=1'd1;            // 分频后的时钟输出

always @(posedge clk) begin
    if (counter == 6'd16)begin
        counter <= 6'd0;
        clk_out=~clk_out;
    end
    else
        counter <= counter + 1'd1; // 计数器加1
end

assign divided = clk_out; // 输出分频后的信号

endmodule
