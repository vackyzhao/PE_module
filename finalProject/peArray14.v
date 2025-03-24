module peArray14(
    input clk,  //PE 时钟(3倍频clk时钟)
    input rst_n,  //复位信号，低有效
    input en,  //使能信号，高有效 

    input [127:0] Ifmap_shift_in,// 输入特征图 8位*16通道（数据）

    input [71:0] Filtr_in,//input kernel,8bit*9=72bit

    output [127:0] Psum_out  //输出计算结果 128
);

wire [7:0] Ifmap_shift_out_2[0:31]; // 创建一个包含32个8位元素的wire数组
wire [7:0] Ifmap_shift_out_1[0:31]; // 创建一个包含32个8位元素的wire数组

wire [7:0] reg0_out;
wire [7:0] Ifmap_shift_in_0_2,Ifmap_shift_in_0_1;

sirv_gnrl_dfflr #(8) Ifmap_shift_in_0_2_reg0 (
  .lden(en),
  .dnxt(Ifmap_shift_in[271:264]),
  .qout(reg0_out),
  .clk(clk),
  .rst_n(rst_n)
);
sirv_gnrl_dfflr #(8) Ifmap_shift_in_0_2_reg1 (
  .lden(en),
  .dnxt(reg0_out),
  .qout(Ifmap_shift_in_0_2),
  .clk(clk),
  .rst_n(rst_n)
);
sirv_gnrl_dfflr #(8) Ifmap_shift_in_0_1_reg0 (
  .lden(en),
  .dnxt(Ifmap_shift_in[263:256]),
  .qout(Ifmap_shift_in_0_1),
  .clk(clk),
  .rst_n(rst_n)
);

    middle_new_PE middle_new_PE_0(
    .clk(clk),  //PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效 

    .Ifmap_shift_in_2(Ifmap_shift_in_0_2),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_shift_in_1(Ifmap_shift_in_0_1),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_shift_in_0(Ifmap_shift_in[255:248]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Filtr_in_2_2(Filtr_in[71:64]), // Unit 2 Channel 2
    .Filtr_in_2_1(Filtr_in[63:56]), // Unit 2 Channel 1
    .Filtr_in_2_0(Filtr_in[55:48]), // Unit 2 Channel 0
    .Filtr_in_1_2(Filtr_in[47:40]), // Unit 1 Channel 2
    .Filtr_in_1_1(Filtr_in[39:32]), // Unit 1 Channel 1
    .Filtr_in_1_0(Filtr_in[31:24]), // Unit 1 Channel 0
    .Filtr_in_0_2(Filtr_in[23:16]), // Unit 0 Channel 2
    .Filtr_in_0_1(Filtr_in[15:8]), // Unit 0 Channel 1
    .Filtr_in_0_0(Filtr_in[7:0]), // Unit 0 Channel 0
    .Ifmap_shift_out_2(Ifmap_shift_out_2[0]),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_shift_out_1(Ifmap_shift_out_1[0]),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)

    .Psum_out(Psum_out[127:120]) //输出计算结果
);

middle_new_PE middle_new_PE_13(
    .clk(clk),  //PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效 

    .Psum_in(14'b0),

    .Ifmap_shift_in_2(Ifmap_shift_out_2[30]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_shift_in_1(Ifmap_shift_out_1[30]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Ifmap_shift_in_0(Ifmap_shift_in[7:0]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

    .Filtr_in_2_2(Filtr_in[71:64]), // Unit 2 Channel 2
    .Filtr_in_2_1(Filtr_in[63:56]), // Unit 2 Channel 1
    .Filtr_in_2_0(Filtr_in[55:48]), // Unit 2 Channel 0
    .Filtr_in_1_2(Filtr_in[47:40]), // Unit 1 Channel 2
    .Filtr_in_1_1(Filtr_in[39:32]), // Unit 1 Channel 1
    .Filtr_in_1_0(Filtr_in[31:24]), // Unit 1 Channel 0
    .Filtr_in_0_2(Filtr_in[23:16]), // Unit 0 Channel 2
    .Filtr_in_0_1(Filtr_in[15:8]), // Unit 0 Channel 1
    .Filtr_in_0_0(Filtr_in[7:0]), // Unit 0 Channel 0

    .Ifmap_shift_out_2(),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Ifmap_shift_out_1(),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)

    .Psum_out(Psum_out[7:0]) //输出计算结果
  
);


      // Generate block
      genvar i;
     generate
        for(i=1; i<13; i=i+1) begin:BLOCK1
        middle_new_PE middle_new_PE_n(
        .clk(clk),  //PE 时钟(3倍频clk时钟)
        .rst_n(rst_n),  //复位信号，低有效
        .en(en),  //使能信号，高有效 

        .Psum_in(14'b0),

        .Ifmap_shift_in_2(Ifmap_shift_out_2[i-1]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
        .Ifmap_shift_in_1(Ifmap_shift_out_1[i-1]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
        .Ifmap_shift_in_0(Ifmap_shift_in[(7+8*(31-i)):8*(31-i)]),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)

     .Filtr_in_2_2(Filtr_in[71:64]), // Unit 2 Channel 2
    .Filtr_in_2_1(Filtr_in[63:56]), // Unit 2 Channel 1
    .Filtr_in_2_0(Filtr_in[55:48]), // Unit 2 Channel 0
    .Filtr_in_1_2(Filtr_in[47:40]), // Unit 1 Channel 2
    .Filtr_in_1_1(Filtr_in[39:32]), // Unit 1 Channel 1
    .Filtr_in_1_0(Filtr_in[31:24]), // Unit 1 Channel 0
    .Filtr_in_0_2(Filtr_in[23:16]), // Unit 0 Channel 2
    .Filtr_in_0_1(Filtr_in[15:8]), // Unit 0 Channel 1
    .Filtr_in_0_0(Filtr_in[7:0]), // Unit 0 Channel 0

        .Ifmap_shift_out_2(Ifmap_shift_out_2[i]),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
        .Ifmap_shift_out_1(Ifmap_shift_out_1[i]),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)

        .Psum_out(Psum_out[(7+8*(31-i)):8*(31-i)])//输出计算结果
    
);
        end
     endgenerate

endmodule