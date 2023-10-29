`timescale 1ns / 1ps
module clockDivider24 (
    input  wire clk,     // 输入时钟信号
    input  wire rst_n,
    output wire divided  // 输出分频后的信号
);

  reg [5:0] counter = 6'd0;  // 6位计数器，可以分频到64
  reg       clk_out = 1'd0;  // 分频后的时钟输出，初始为高电平

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_out <= 1'd0;
    end else begin
        if (counter == 6'd11) begin
            counter <= 6'd0;
        end else begin
            counter <= counter + 1'd1;
        end
    end
end


  assign divided = clk_out;  // 输出分频后的信号

endmodule
