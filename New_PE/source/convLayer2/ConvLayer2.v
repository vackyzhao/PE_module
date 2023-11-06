module ConvLayer2 (
    input clk,
    input rst_n,
    input en,
    input [111:0] Ifmap_shift_in_0,  // 列输入特征图 8位*14通道=112位（数据） 
    input [111:0] Ifmap_shift_in_1,  // 列输入特征图 8位*14通道=112位（数据） 
    input [111:0] Ifmap_shift_in_2,  // 列输入特征图 8位*14通道=112位（数据） 
    input [111:0] Ifmap_shift_in_3,  // 列输入特征图 8位*14通道=112位（数据） 

    input [47:0] Filtr_in_2,  // 4x输入权重 4位*3通道=48位（卷积核）
    input [47:0] Filtr_in_1,  // 4x输入权重 4位*3通道=48位（卷积核）
    input [47:0] Filtr_in_0,  // 4x输入权重 4位*3通道=48位（卷积核）

    output reg [191:0] Psum_out_sum  // 列输出计算结果 16位*12=192位 (结果)
);
  wire [167:0] Psum_out[0:3];  // 14位*12=168位 (结果)


  middle_new_PEx12 PE_array_0 (
      .clk(clk),  // PE时钟
      .rst_n(rst_n),  // 复位信号，低有效
      .en(en),  // 使能信号，高有效 

      .Ifmap_shift_in(Ifmap_shift_in_0),  // 列输入特征图 8位*14通道=112位（数据） 

      .Filtr_in_2(Filtr_in_2[47:36]),  // 输入权重 4位*3通道=12位（卷积核）   
      .Filtr_in_1(Filtr_in_1[47:36]),  // 输入权重 4位*3通道=12位（卷积核）
      .Filtr_in_0(Filtr_in_0[47:36]),  // 输入权重 4位*3通道=12位（卷积核） 

      .Psum_out(Psum_out[0])  // 列输出计算结果 14位*12=168位 (结果)
  );

  middle_new_PEx12 PE_array_1 (
      .clk(clk),  // PE时钟
      .rst_n(rst_n),  // 复位信号，低有效
      .en(en),  // 使能信号，高有效 

      .Ifmap_shift_in(Ifmap_shift_in_1),  // 列输入特征图 8位*14通道=112位（数据）


      .Filtr_in_2(Filtr_in_2[35:24]),  // 输入权重 4位*3通道=12位（卷积核）   
      .Filtr_in_1(Filtr_in_1[35:24]),  // 输入权重 4位*3通道=12位（卷积核）
      .Filtr_in_0(Filtr_in_0[35:24]),  // 输入权重 4位*3通道=12位（卷积核）

      .Psum_out(Psum_out[1])  // 列输出计算结果 8位*12=96位 (结果)
  );
  middle_new_PEx12 PE_array_2 (
      .clk(clk),  // PE时钟
      .rst_n(rst_n),  // 复位信号，低有效
      .en(en),  // 使能信号，高有效 

      .Ifmap_shift_in(Ifmap_shift_in_2),  // 列输入特征图 8位*14通道=112位（数据）


      .Filtr_in_2(Filtr_in_2[23:12]),  // 输入权重 4位*3通道=12位（卷积核）   
      .Filtr_in_1(Filtr_in_1[23:12]),  // 输入权重 4位*3通道=12位（卷积核）
      .Filtr_in_0(Filtr_in_0[23:12]),  // 输入权重 4位*3通道=12位（卷积核）

      .Psum_out(Psum_out[2])  // 列输出计算结果 8位*12=96位 (结果)
  );
  middle_new_PEx12 PE_array_3 (
      .clk(clk),  // PE时钟
      .rst_n(rst_n),  // 复位信号，低有效
      .en(en),  // 使能信号，高有效 

      .Ifmap_shift_in(Ifmap_shift_in_3),  // 列输入特征图 8位*14通道=112位（数据）


      .Filtr_in_2(Filtr_in_2[11:0]),  // 输入权重 4位*3通道=12位（卷积核）   
      .Filtr_in_1(Filtr_in_1[11:0]),  // 输入权重 4位*3通道=12位（卷积核）
      .Filtr_in_0(Filtr_in_0[11:0]),  // 输入权重 4位*3通道=12位（卷积核）

      .Psum_out(Psum_out[3])  // 列输出计算结果 8位*12=96位 (结果)
  );
  integer i;
  always @(*) begin
    Psum_out_sum <= 192'd0;  // 初始化 Psum_out_sum 为全零
    for (i = 0; i < 12; i = i + 1) begin
      //Psum_out_sum[191-16*i-:16]<={2'b00,Psum_out[0] [167-14*i-:14]} + {2'b00, Psum_out[1][167-14*i-:14]} + {2'b00, Psum_out[2][167-14*i-:14]}+ {2'b00, Psum_out[3][167-14*i-:14]};
      Psum_out_sum[191-16*i-:16] <= Psum_out[0][167-14*i-:14] + Psum_out[1][167-14*i-:14] + Psum_out[2][167-14*i-:14] + Psum_out[3][167-14*i-:14];

    end
  end
endmodule
