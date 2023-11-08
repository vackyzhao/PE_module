`timescale 1ns/1ps

module tb_top;

    // 时钟信号
    reg tb_camclk;
    reg tb_doutclk;
    
    // 复位信号
    reg tb_rst_n;
    
    // 使能信号
    reg tb_en;
    
    // 输入数据
    reg [207:0] tb_parallel_data;
    
    // 输出数据
    wire [15:0] tb_o_fc_weight_addr;
    wire [31:0] tb_i_fc_weight;
    wire [4:0] tb_o_result_data;
    wire tb_o_result_data_valid;
    
    // 实例化被测设计
    top uut (
        .camclk(tb_camclk),
        .PE_clk(tb_doutclk),
        .rst_n(tb_rst_n),
        .en(tb_en),
        .parallel_data(tb_parallel_data),
        .o_fc_weight_addr(tb_o_fc_weight_addr),
        .i_fc_weight(tb_i_fc_weight),
        .o_result_data(tb_o_result_data),
        .o_result_data_valid(tb_o_result_data_valid)
    );

    // 时钟生成
    always begin
        tb_camclk = 1'b0;
        #5 tb_camclk = 1'b1;
        #5;
    end
    
    // 初始化模块
    initial begin
        tb_doutclk = 1'b0;
        tb_rst_n = 1'b0;
        tb_en = 1'b0;
        tb_parallel_data = 208'b0;
        
        // 复位被测设计
        #10 tb_rst_n = 1'b1;
        
        // 等待一段时间
        #100;
        
        // 启用设计
        tb_en = 1'b1;
        
        
        // 在此添加测试用例，操作输入端口，和检查输出端口
        // 例如，设置输入数据，等待一段时间，然后检查输出数据
        
        // 终止仿真
        $finish;
    end

endmodule
