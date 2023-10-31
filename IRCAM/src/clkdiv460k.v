module ClockDivider460k (
    input wire clk_in,        // 输入时钟
    output reg clk_out_0,clk_out_1,clk_out_2      // 输出时钟
);

reg [16:0] counter_0,counter_1,counter_2;

parameter N0 = 53;  // 分频比例/2
parameter N1 = 26;  // 分频比例/2
parameter N2 = 1060;  // 分频比例/2



always @(posedge clk_in) begin

    if (counter_0 == N0) begin
        counter_0 <= 0;
        clk_out_0 <= ~clk_out_0;
    end else begin
        counter_0 <= counter_0 + 1;
    end

    if (counter_1 == N1) begin
        counter_1 <= 0;
        clk_out_1 <= ~clk_out_1;
    end else begin
        counter_1 <= counter_1 + 1;
    end

    if (counter_2 == N2) begin
        counter_2 <= 0;
        clk_out_2 <= ~clk_out_2;
    end else begin
        counter_2 <= counter_2 + 1;
    end



end

endmodule
