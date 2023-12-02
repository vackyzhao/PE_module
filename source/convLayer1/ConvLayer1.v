module ConvLayer1 (
    input clk,
    input rst_n,
    input en,
    input [207:0] Ifmap_shift_in,  //26x8=208位数据输入

    input [23:0] Filtr_in_2,  //权重3x8x=24位
    input [23:0] Filtr_in_1,  //权重3x8x=24位
    input [23:0] Filtr_in_0,  //权重3x8x=24位

    output [479:0] Psum_out  //14*24=336位卷积核0数据输出

);
  middle_new_PEx24 PE_array (
      .clk(clk),  // PE时钟
      .rst_n(rst_n),  // 复位信号，低有效
      .en(en),  // 使能信号，高有效 

      .Ifmap_shift_in(Ifmap_shift_in),  // 列输入特征图 8位*26通道=208位（数据） 

      .Filtr_in_2(Filtr_in_2[23:0]),  // 输入权重 8位*3通道=24位（卷积核）   
      .Filtr_in_1(Filtr_in_1[23:0]),  // 输入权重 4位*3通道=12位（卷积核）
      .Filtr_in_0(Filtr_in_0[23:0]),  // 输入权重 4位*3通道=12位（卷积核） 

      .Psum_out(Psum_out)  // 列输出计算结果 8位*24=192位 (结果)
  );
endmodule
