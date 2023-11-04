module ConvLayer1 (
    input clk,
    input rst_n,
    input en,
    input [207:0] Ifmap_shift_in,  //26x8=208位数据输入

    input [47:0] Filtr_in_2,  //权重3x4x4=48位
    input [47:0] Filtr_in_1,  //权重3x4x4=48位
    input [47:0] Filtr_in_0,  //权重3x4x4=48位

    output [335:0] Psum_out_0,  //14*24=336位卷积核0数据输出
    output [335:0] Psum_out_1,  //14*24=336位卷积核1数据输出
    output [335:0] Psum_out_2,  //14*24=336位卷积核2数据输出
    output [335:0] Psum_out_3   //14*24=336位卷积核3数据输出
);

  middle_new_PEx24 PE_array_0 (
      .clk(clk),  // PE时钟
      .rst_n(rst_n),  // 复位信号，低有效
      .en(en),  // 使能信号，高有效 

      .Ifmap_shift_in(Ifmap_shift_in),  // 列输入特征图 8位*26通道=208位（数据） 

      .Filtr_in_2(Filtr_in_2[47:36]),  // 输入权重 4位*3通道=12位（卷积核）   
      .Filtr_in_1(Filtr_in_1[47:36]),  // 输入权重 4位*3通道=12位（卷积核）
      .Filtr_in_0(Filtr_in_0[47:36]),  // 输入权重 4位*3通道=12位（卷积核） 

      .Psum_out(Psum_out_0)  // 列输出计算结果 8位*24=192位 (结果)
  );
  middle_new_PEx24 PE_array_1 (
      .clk(clk),  // PE时钟
      .rst_n(rst_n),  // 复位信号，低有效
      .en(en),  // 使能信号，高有效 

      .Ifmap_shift_in(Ifmap_shift_in),  // 列输入特征图 8位*26通道=208位（数据） 

      .Filtr_in_2(Filtr_in_2[35:24]),  // 输入权重 4位*3通道=12位（卷积核）   
      .Filtr_in_1(Filtr_in_1[35:24]),  // 输入权重 4位*3通道=12位（卷积核）
      .Filtr_in_0(Filtr_in_0[35:24]),  // 输入权重 4位*3通道=12位（卷积核） 

      .Psum_out(Psum_out_1)  // 列输出计算结果 8位*24=192位 (结果)
  );
  middle_new_PEx24 PE_array_2 (
      .clk(clk),  // PE时钟
      .rst_n(rst_n),  // 复位信号，低有效
      .en(en),  // 使能信号，高有效 

      .Ifmap_shift_in(Ifmap_shift_in),  // 列输入特征图 8位*26通道=208位（数据） 

      .Filtr_in_2(Filtr_in_2[23:12]),  // 输入权重 4位*3通道=12位（卷积核）   
      .Filtr_in_1(Filtr_in_1[23:12]),  // 输入权重 4位*3通道=12位（卷积核）
      .Filtr_in_0(Filtr_in_0[23:12]),  // 输入权重 4位*3通道=12位（卷积核） 

      .Psum_out(Psum_out_2)  // 列输出计算结果 8位*24=192位 (结果)
  );
  middle_new_PEx24 PE_array_3 (
      .clk(clk),  // PE时钟
      .rst_n(rst_n),  // 复位信号，低有效
      .en(en),  // 使能信号，高有效 

      .Ifmap_shift_in(Ifmap_shift_in),  // 列输入特征图 8位*26通道=208位（数据） 

      .Filtr_in_2(Filtr_in_2[11:0]),  // 输入权重 4位*3通道=12位（卷积核）   
      .Filtr_in_1(Filtr_in_1[11:0]),  // 输入权重 4位*3通道=12位（卷积核）
      .Filtr_in_0(Filtr_in_0[11:0]),  // 输入权重 4位*3通道=12位（卷积核） 

      .Psum_out(Psum_out_3)  // 列输出计算结果 8位*24=192位 (结果)
  );
endmodule
