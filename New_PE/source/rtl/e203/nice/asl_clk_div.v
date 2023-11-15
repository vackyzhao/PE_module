module clock_divider(
    input clk_in, // 输入时钟
    input rst_n,
    output reg clk_out // 输出时钟
);

// 假设输入时钟和系统时钟周期同步
// 初始化计数器
reg [10:0] counter;

always @(posedge clk_in or negedge rst_n) begin
    if(!rst_n) begin 
        counter<=0;
        clk_out<=0;
    end
    else
    begin
            // 每次时钟上升沿计数器增加
            counter <= counter + 1;
        
            // 当计数器达到8，即输入时钟周期的一半时，切换输出时钟的状态
            if (counter == 7) begin
                clk_out <= ~clk_out;
                counter <= 0; // 重置计数器
            end
    end
end
endmodule
