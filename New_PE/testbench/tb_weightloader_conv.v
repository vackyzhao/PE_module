`timescale 1ns / 1ps

module weightloader_conv_tb;

    // 定义输入信号
    reg clk;
    reg rst_n;
    reg weights_load_start;
    reg [15:0] i_sram_weight;
    reg [2:0] Filtr_2_count;

    // 定义输出信号
    wire [15:0] o_sram_weight_addr;
    wire [95:0] Filtr_1_2;
    wire [95:0] Filtr_1_1;
    wire [95:0] Filtr_1_0;
    wire [95:0] Filtr_2_2;
    wire [95:0] Filtr_2_1;
    wire [95:0] Filtr_2_0;
    wire weights_load_finish;

    // 例化weightloader_conv模块
    weightloader_conv u_weightloader_conv (
        .clk(clk),
        .rst_n(rst_n),
        .weights_load_start(weights_load_start),
        .i_sram_weight(i_sram_weight),
        .Filtr_2_count(Filtr_2_count),
        .o_sram_weight_addr(o_sram_weight_addr),
        .Filtr_1_2(Filtr_1_2),
        .Filtr_1_1(Filtr_1_1),
        .Filtr_1_0(Filtr_1_0),
        .Filtr_2_2(Filtr_2_2),
        .Filtr_2_1(Filtr_2_1),
        .Filtr_2_0(Filtr_2_0),
        .weights_load_finish(weights_load_finish)
    );

    // 时钟生成器
    always begin
        #5 clk = ~clk;
    end

    // 测试序列
    initial begin
        // 初始化输入信号
        clk = 0;
        rst_n = 1;
        weights_load_start = 0;
        i_sram_weight = 0;
        Filtr_2_count = 0;

        // 复位
        #100 rst_n = 0;
        #50 rst_n = 1;

        // 测试序列
        #10 weights_load_start = 1;
        #10 i_sram_weight = 16'h1234;
        #5000 weights_load_start = 0;
        #10 i_sram_weight = 16'h0000;
        #10 Filtr_2_count = 3'b000;

        // 结束测试
       
    end

endmodule