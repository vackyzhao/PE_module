module middle_new_PEx32(
    input clk,  //PE 时钟(3倍频clk时钟)
    input rst_n,  //复位信号，低有效
    input en,  //使能信号，高有效 

    
    input [7:0] Ifmap_shift_in_0_2,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [7:0] Ifmap_shift_in_0_1,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    input [255:0] Ifmap_shift_in_n_0,// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data) 32*8

    input [11:0] Filtr_in_2,// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)    
    input [11:0] Filtr_in_1,//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    input [11:0] Filtr_in_0,// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    output [447:0] Psum_out  //输出计算结果 14*32
);

wire [7:0] Ifmap_shift_out_2[0:31]; // 创建一个包含32个8位元素的wire数组
wire [7:0] Ifmap_shift_out_1[0:31]; // 创建一个包含32个8位元素的wire数组

wire [11:0] Filtr_out_2[0:31]; // 创建一个包含32个8位元素的wire数组
wire [11:0] Filtr_out_1[0:31]; // 创建一个包含32个8位元素的wire数组
wire [11:0] Filtr_out_0[0:31]; // 创建一个包含32个8位元素的wire数组

    middle_new_PE middle_new_PE_0(
    .clk(clk),  //PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效 

    .Psum_in(14'b0),

    .Ifmap_shift_in_2(Ifmap_shift_in_0_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_shift_in_1(Ifmap_shift_in_0_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_shift_in_0(Ifmap_shift_in_n_0[255:248]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    .Filtr_in_2(Filtr_in_2),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_1(Filtr_in_1),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_0(Filtr_in_0),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .Ifmap_shift_out_2(Ifmap_shift_out_2[0]),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_shift_out_1(Ifmap_shift_out_1[0]),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)

    .Psum_out(Psum_out[447:434]),  //输出计算结果
    
    .Filtr_out_2(Filtr_out_2[0]),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_out_1(Filtr_out_1[0]),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_out_0(Filtr_out_0[0]),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .result_out_en()
);

middle_new_PE middle_new_PE_31(
    .clk(clk),  //PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效 

    .Psum_in(14'b0),

    .Ifmap_shift_in_2(Ifmap_shift_out_2[30]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_shift_in_1(Ifmap_shift_out_1[30]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_shift_in_0(Ifmap_shift_in_n_0[7:0]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    .Filtr_in_2(Filtr_out_2[30]),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_1(Filtr_out_1[30]),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_0(Filtr_out_0[30]),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .Ifmap_shift_out_2(),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_shift_out_1(),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)

    .Psum_out(Psum_out[13:0]),  //输出计算结果
    
    .Filtr_out_2(),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_out_1(),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_out_0(),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .result_out_en()
);


      // Generate block
      genvar i;
     generate
        for(i=1; i<31; i=i+1) begin:BLOCK1
        middle_new_PE middle_new_PE_n(
        .clk(clk),  //PE 时钟(3倍频clk时钟)
        .rst_n(rst_n),  //复位信号，低有效
        .en(en),  //使能信号，高有效 

        .Psum_in(14'b0),

        .Ifmap_shift_in_2(Ifmap_shift_out_2[i-1]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
        .Ifmap_shift_in_1(Ifmap_shift_out_1[i-1]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
        .Ifmap_shift_in_0(Ifmap_shift_in_n_0[(7+8*(31-i)):8*(31-i)]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

        .Filtr_in_2(Filtr_out_2[i-1]),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
        .Filtr_in_1(Filtr_out_1[i-1]),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
        .Filtr_in_0(Filtr_out_0[i-1]),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

        .Ifmap_shift_out_2(Ifmap_shift_out_2[i]),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
        .Ifmap_shift_out_1(Ifmap_shift_out_1[i]),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)

        .Psum_out(Psum_out[(13+14*(31-i)):14*(31-i)]),  //输出计算结果
    
        .Filtr_out_2(Filtr_out_2[i]),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
        .Filtr_out_1(Filtr_out_1[i]),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
        .Filtr_out_0(Filtr_out_0[i]),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

        .result_out_en()
);
        end
     endgenerate

endmodule