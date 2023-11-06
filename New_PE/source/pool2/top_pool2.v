module top_pool2(
    input clk,              // 时钟输入
    input rst_n,            // 复位输入（低电平有效）
    input en,          // 使能    
    input valid_in,         // 输入数据有效信号
    input  [95:0]data_in, // 输入数据
    output [95:0]data_out, // 输出数据
    output wire valid_out,       // 输出数据有效信号
    output wire pool_end
);

wire [95:0]data_out_tmp;
 assign data_out[95:0]=data_out_tmp[95:0];

pool_module pool_module_2_0_inst(
    .clk(clk),              // 时钟输入
    .rst_n(rst_n),            // 复位输入（低电平有效）
    .pool_en(en),          // 池化使能
    .layer1(1'd0),           // Layer 1 标志
    .valid_in(valid_in),         // 输入数据有效信号
    .data_in({96'b0,data_in}), // 输入数据
    .col(16'd16),       // 列数

    .data_out(data_out_tmp), // 输出数据
    .valid_out(valid_out),       // 输出数据有效信号
    .pool_end(pool_end)         // 池化结束信号
);

endmodule 