/**
 * 模块名称：weightloader_conv
 * 文件路径�?/D:/document/GitHub/PE_module/New_PE/source/rtl/nice/weightLoader.v
 * 作�?�：Unknown
 * 日期：Unknown
 * 版本：Unknown
 * 说明：该模块用于从SRAM中加载卷积核权重
 *
 * 输入�?
 *   clk：时钟信�?
 *   rst_n：异步复位信�?
 *   weights_load_start：权重加载开始信�?
 *   i_sram_weight：SRAM中的权重数据
 *   Filtr_2_count：卷积核2的计数器
 *
 * 输出�?
 *   o_sram_weight_addr：SRAM中的权重地址
 *   Filtr_1_2：卷积核1的第2个滤波器
 *   Filtr_1_1：卷积核1的第1个滤波器
 *   Filtr_1_0：卷积核1的第0个滤波器
 *   Filtr_2_2：卷积核2的第2个滤波器
 *   Filtr_2_1：卷积核2的第1个滤波器
 *   Filtr_2_0：卷积核2的第0个滤波器
 *   weights_load_finish：权重加载完成信�?
 */
module weightloader_conv (
    input clk,
    input rst_n,
    input wire weights_load_start,

    input [15:0] i_sram_weight,

    input [2:0] Filtr_2_count,

    output wire [15:0] o_sram_weight_addr,

    output wire [95:0] Filtr_1_2,
    output wire [95:0] Filtr_1_1,
    output wire [95:0] Filtr_1_0,

    output wire [95:0] Filtr_2_2,
    output wire [95:0] Filtr_2_1,
    output wire [95:0] Filtr_2_0,

    output reg weights_load_finish


);
  reg [8:0] weights_load_counter;
  reg [7:0] weights_conv1[35:0];
  reg [7:0] weights_conv2[287:0];
  initial begin
    weights_load_finish  = 0;
    weights_load_counter = 9'b0;    
  end

  assign    Filtr_1_2 = {
        weights_conv1[0],//0
        weights_conv1[1],//3
        weights_conv1[2],//6
        weights_conv1[9],
        weights_conv1[10],
        weights_conv1[11],
        weights_conv1[18],
        weights_conv1[19],
        weights_conv1[20],
        weights_conv1[27],
        weights_conv1[28],
        weights_conv1[29]
      };

    assign  Filtr_1_1 = {
        weights_conv1[3],
        weights_conv1[4],
        weights_conv1[5],
        weights_conv1[12],
        weights_conv1[13],
        weights_conv1[14],
        weights_conv1[21],
        weights_conv1[22],
        weights_conv1[23],
        weights_conv1[30],
        weights_conv1[31],
        weights_conv1[32]
      };
    assign  Filtr_1_0 = {
        weights_conv1[6],
        weights_conv1[7],
        weights_conv1[8],
        weights_conv1[15],
        weights_conv1[16],
        weights_conv1[17],
        weights_conv1[24],
        weights_conv1[25],
        weights_conv1[26],
        weights_conv1[33],
        weights_conv1[34],
        weights_conv1[35]
      };
   assign   Filtr_2_2 = {
        weights_conv2[Filtr_2_count*36+0],
        weights_conv2[Filtr_2_count*36+1],
        weights_conv2[Filtr_2_count*36+2],
        weights_conv2[Filtr_2_count*36+9],
        weights_conv2[Filtr_2_count*36+10],
        weights_conv2[Filtr_2_count*36+11],
        weights_conv2[Filtr_2_count*36+18],
        weights_conv2[Filtr_2_count*36+19],
        weights_conv2[Filtr_2_count*36+20],
        weights_conv2[Filtr_2_count*36+27],
        weights_conv2[Filtr_2_count*36+28],
        weights_conv2[Filtr_2_count*36+29]
      };
    assign  Filtr_2_1 = {
        weights_conv2[Filtr_2_count*36+3],
        weights_conv2[Filtr_2_count*36+4],
        weights_conv2[Filtr_2_count*36+5],
        weights_conv2[Filtr_2_count*36+12],
        weights_conv2[Filtr_2_count*36+13],
        weights_conv2[Filtr_2_count*36+14],
        weights_conv2[Filtr_2_count*36+21],
        weights_conv2[Filtr_2_count*36+22],
        weights_conv2[Filtr_2_count*36+23],
        weights_conv2[Filtr_2_count*36+30],
        weights_conv2[Filtr_2_count*36+31],
        weights_conv2[Filtr_2_count*36+32]
      };
    assign  Filtr_2_0 = {
        weights_conv2[Filtr_2_count*36+6],
        weights_conv2[Filtr_2_count*36+7],
        weights_conv2[Filtr_2_count*36+8],
        weights_conv2[Filtr_2_count*36+15],
        weights_conv2[Filtr_2_count*36+16],
        weights_conv2[Filtr_2_count*36+17],
        weights_conv2[Filtr_2_count*36+24],
        weights_conv2[Filtr_2_count*36+25],
        weights_conv2[Filtr_2_count*36+26],
        weights_conv2[Filtr_2_count*36+33],
        weights_conv2[Filtr_2_count*36+34],
        weights_conv2[Filtr_2_count*36+35]
      };


  integer m, n;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      weights_load_finish  <= 0;
      weights_load_counter <= 9'b0;

      for (m = 0; m < 4; m = m + 1) begin
        weights_conv1[m] <= 72'b0;
      end
      for (n = 0; n < 32; n = n + 1) begin
        weights_conv2[n] <= 72'b0;
      end
    end else begin
      if (weights_load_start==1 && weights_load_finish==0) begin
        
        if (weights_load_counter >= 0) begin
          if (weights_load_counter < 19&&weights_load_counter>0) begin
            weights_conv1[(weights_load_counter-1)*2]   <= i_sram_weight[15:8];
            weights_conv1[(weights_load_counter-1)*2+1] <= i_sram_weight[7:0];
          end else if (weights_load_counter < 163) begin
            weights_conv2[(weights_load_counter-19)*2]   <= i_sram_weight[15:8];
            weights_conv2[(weights_load_counter-19)*2+1] <= i_sram_weight[7:0];
          end else begin
            weights_load_finish <= 1;
          end
        end
        weights_load_counter <= weights_load_counter + 1;
      end else begin

      end
    end
  end
assign o_sram_weight_addr = {7'b0, weights_load_counter};
endmodule
