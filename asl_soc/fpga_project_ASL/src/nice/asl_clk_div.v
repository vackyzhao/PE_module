module clock_divider(
    input clk_in, // ����ʱ��
    input rst_n,
    output reg clk_out // ���ʱ��
);

// ��������ʱ�Ӻ�ϵͳʱ������ͬ��
// ��ʼ��������
reg [20:0] counter;

always @(posedge clk_in or negedge rst_n) begin
    if(!rst_n) begin 
        counter<=0;
        clk_out<=0;
    end
    else
    begin
            // ÿ��ʱ�������ؼ���������
            counter <= counter + 1;
        
            // ���������ﵽ8��������ʱ�����ڵ�һ��ʱ���л����ʱ�ӵ�״̬
            if (counter == 2) begin
                clk_out <= ~clk_out;
                counter <= 0; // ���ü�����
            end
    end
end
endmodule
