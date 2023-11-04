module top_pool1(
    input clk,              // 时钟输入
    input rst_n,            // 复位输入（低电平有效）
    input en,          // 使能    
    input valid_in,         // 输入数据有效信号
    input  [191:0]data_in, // 输入数据

    output [95:0]data_out_0, // 输出数据
    output [95:0]data_out_1, // 输出数据
    output [95:0]data_out_2, // 输出数据
    output [95:0]data_out_3, // 输出数据
    output wire valid_out,       // 输出数据有效信号
    output wire pool_end
);
wire valid_out_0,valid_out_1,valid_out_2,valid_out_3;
wire pool_end_0,pool_end_1,pool_end_2,pool_end_3;

assign valid_out=valid_out_0&valid_out_1&valid_out_2&valid_out_3;
assign pool_end=pool_end_0&pool_end_1&pool_end_2&pool_end_3;

pool_module pool_module_0_inst(
    .clk(clk),              // 时钟输入
    .rst_n(rst_n),            // 复位输入（低电平有效）
    .pool_en(en),          // 池化使能
    .layer1(1'd1),           // Layer 1 标志
    .valid_in(valid_in),         // 输入数据有效信号
    .data_in(data_in), // 输入数据
    .col(16'd32),       // 列数

    .data_out(data_out_0), // 输出数据
    .valid_out(valid_out_0),       // 输出数据有效信号
    .pool_end(pool_end_0)         // 池化结束信号
);

pool_module pool_module_1_inst(
    .clk(clk),              // 时钟输入
    .rst_n(rst_n),            // 复位输入（低电平有效）
    .pool_en(en),          // 池化使能
    .layer1(1'd1),           // Layer 1 标志
    .valid_in(valid_in),         // 输入数据有效信号
    .data_in(data_in), // 输入数据
    .col(16'd32),       // 列数

    .data_out(data_out_1), // 输出数据
    .valid_out(valid_out_1),       // 输出数据有效信号
    .pool_end(pool_end_1)         // 池化结束信号
);
pool_module pool_module_2_inst(
    .clk(clk),              // 时钟输入
    .rst_n(rst_n),            // 复位输入（低电平有效）
    .pool_en(en),          // 池化使能
    .layer1(1'd1),           // Layer 1 标志
    .valid_in(valid_in),         // 输入数据有效信号
    .data_in(data_in), // 输入数据
    .col(16'd32),       // 列数

    .data_out(data_out_2), // 输出数据
    .valid_out(valid_out_2),       // 输出数据有效信号
    .pool_end(pool_end_2)         // 池化结束信号
);
pool_module pool_module_3_inst(
    .clk(clk),              // 时钟输入
    .rst_n(rst_n),            // 复位输入（低电平有效）
    .pool_en(en),          // 池化使能
    .layer1(1'd1),           // Layer 1 标志
    .valid_in(valid_in),         // 输入数据有效信号
    .data_in(data_in), // 输入数据
    .col(16'd32),       // 列数

    .data_out(data_out_3), // 输出数据
    .valid_out(valid_out_3),       // 输出数据有效信号
    .pool_end(pool_end_3)         // 池化结束信号
);

endmodule 