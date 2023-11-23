// 50MHz --> 32768Hz ԼΪ1526�� 50MHz/1526=32765.4 HZ,��Ϊ������ʱ��
module clk_div(
   input  clk,
   input  rst_n,
   output reg  clk_div
);
	parameter NUM_DIV = 11'd1526;
    reg    [10:0] cnt;
    
always @(posedge clk or negedge rst_n)
    if(!rst_n) begin
        cnt     <= 11'd0;
        clk_div <= 1'b0;
    end
    else if(cnt < NUM_DIV / 2 - 1) begin
        cnt     <= cnt + 1'b1;
        clk_div <= clk_div;
    end
    else begin
        cnt     <= 11'd0;
        clk_div <= ~clk_div;
    end
endmodule
