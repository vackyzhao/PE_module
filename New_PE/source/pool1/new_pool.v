`timescale 1ns / 1ps
module pool_module(
    input clk,              // 时钟输入
    input rst_n,            // 复位输入（低电平有效）
    input pool_en,          // 池化使能
    input layer1,           // Layer 1 标志
    input valid_in,         // 输入数据有效信号
    input unsigned [8*24-1:0] data_in, // 输入数据
    input [15:0] col,       // 列数

    output unsigned [8*12-1:0] data_out, // 输出数据
    output valid_out,       // 输出数据有效信号
    output pool_end         // 池化结束信号
);

// Flip-flop 块 1：处理输入数据的寄存器
reg valid_in_ff1;            
reg unsigned [8*24-1:0] data_in_ff1;
reg valid_in_ff2;            
reg unsigned [8*24-1:0] data_in_ff2;
reg start;                   
reg nopool_end;              

always@(posedge clk)
begin
    if (!rst_n)
    begin
        // 复位时，将寄存器清零
        valid_in_ff1 <= 0;
        data_in_ff1 <= 0;
        valid_in_ff2 <= 0;
        data_in_ff2 <= 0;
        start <= 0;
        nopool_end <= 0;
    end
    else
    begin
        // 当没有复位信号时，数据从输入传递到输出
        data_in_ff1 <= data_in;
        data_in_ff2 <= data_in_ff1;
        valid_in_ff1 <= valid_in;
        valid_in_ff2 <= valid_in_ff1;
        // 计算 nopool_end 信号，表示没有池化操作
        nopool_end <= (!valid_in) & valid_in_ff1;
        // 计算 start 信号，表示池化操作的开始
        start <= (!valid_in_ff1) & valid_in;
    end
end

// Flip-flop 块 2：处理池化操作开始和结束的寄存器
reg start_reg;               
reg pool_over;               
reg pool_over_ff1;           

always@(posedge clk)
begin
    if (!rst_n)
    begin
        // 在复位时，将 start_reg 重置为 0
        start_reg <= 0;
    end
    else
    begin
        if (start)
        begin
            // 当开始池化操作时，设置 start_reg 为 1
            start_reg <= 1;
        end
        else
        begin
            if (pool_over)
            begin
                // 当池化操作结束时，重置 start_reg 为 0
                start_reg <= 0;
            end
            else
            begin
                // 在其他情况下，保持 start_reg 不变
                start_reg <= start_reg;
            end
        end
    end
end

// Flip-flop 块 3：处理列数和池化结果的寄存器
reg [15:0] col_num;          
reg pool_valid;              
reg unsigned [7:0] pool_temp[0:23]; 
integer i;
integer j;
integer k;
integer m;
integer n;
integer a;
integer b;
integer c;
integer d;
integer e;

always@(posedge clk)
begin
    if (!rst_n)
    begin
        // 复位时，将列数和池化临时数据清零
        col_num <= 0;
        for (i = 0; i < 24; i = i + 1)
        begin
            pool_temp[i] <= 0;
        end
        pool_valid <= 0;
        pool_over <= 0;
        pool_over_ff1 <= 0;
    end
    else
    begin
        if (start_reg)
        begin
            if (col_num <= col - 1)
            begin
                // 处理输入数据并判断是否需要池化
                for (j = 0; j < 24; j = j + 1)
                begin
                    pool_temp[j] <= data_in_ff2[8 * j+:8];
                end
                if (col_num < col - 1)
                begin
                    if (col_num % 2 == 1)
                    begin
                        pool_valid <= 1;
                    end
                    else
                    begin
                        pool_valid <= 0;
                    end
                    col_num <= col_num + 1;
                    pool_over <= 0;
                end
                else
                begin
                    pool_valid <= 1;
                    col_num <= 0;
                    pool_over <= 1;
                end
            end
            else
            begin
                col_num <= 0;
                pool_valid <= pool_valid;
                pool_over <= pool_over;
            end
            pool_over_ff1 <= pool_over;
        end
        else
        begin
            // 如果未开始池化操作，重置相关寄存器
            col_num <= 0;
            pool_valid <= 0;
            for (k = 0; k < 24; k = k + 1)
            begin
                pool_temp[k] = 0;
            end
            pool_over <= 0;
            pool_over_ff1 <= 0;
        end
    end
end

// Flip-flop 块 4：处理池化结果和相关信号的寄存器
reg unsigned [7:0] pool1[0:11]; 
reg unsigned [7:0] pool2[0:11]; 
reg unsigned [8*12-1:0] pool_result;
reg pool_result_valid;       
reg pool_ff1;                
reg start_regff1;            
reg pool_overff2;            
reg pool_overff3;           

always@(posedge clk)
begin
    if (!rst_n)
    begin
        // 复位时，重置相关寄存器
        for (b = 0; b < 12; b = b + 1)
        begin
            pool1[b] <= 0;
        end
        for (c = 0; c < 12; c = c + 1)
        begin
            pool2[c] <= 0;
        end
        pool_result <= 0;
        pool_result_valid <= 0;
        pool_ff1 <= 0;
        start_regff1 <= 0;
        pool_overff2 <= 0;
        pool_overff3 <= 0;
    end
    else
    begin
        start_regff1 <= start_reg;
        pool_overff2 <= pool_over_ff1;
        pool_overff3 <= pool_overff2;
        if (start_regff1)
        begin
            // 如果池化操作开始，计算池化结果
            for (m = 0; m < 12; m = m + 1)
            begin
                if (pool_temp[2 * m] < pool_temp[2 * m + 1])
                begin
                    pool1[m] <= pool_temp[2 * m + 1];
                end
                else
                begin
                    pool1[m] <= pool_temp[2 * m];
                end
            end
            for (n = 0; n < 12; n = n + 1)
            begin
                pool2[n] <= pool1[n];
            end
            for (a = 0; a < 12; a = a + 1)
            begin
                if (pool1[a] < pool2[a])
                begin
                    pool_result[8 * a+:8] <= pool2[a];
                end
                else
                begin
                    pool_result[8 * a+:8] <= pool1[a];
                end
            end
            pool_ff1 <= pool_valid;
            pool_result_valid <= pool_ff1;
        end
        else
        begin
            // 如果未开始池化操作，重置相关寄存器
            for (d = 0; d < 12; d = d + 1)
            begin
            pool1[d] <= 0;
            end
            for (e = 0; e< 12; e = e + 1)
            begin
            pool2[e]<= 0;
            end
            pool_result <= 0;
            pool_result_valid <= 0;
            pool_ff1 <= 0;
            pool_overff2 <= 0;
        end
    end
end

// 计算池化结束信号和输出数据
assign pool_end = pool_en ? pool_overff3 : nopool_end;
assign data_out = pool_en ? (layer1 ? pool_result : pool_result[6 * 8 - 1:0]) : data_in;
assign valid_out = pool_en ? pool_result_valid : valid_in;

endmodule
