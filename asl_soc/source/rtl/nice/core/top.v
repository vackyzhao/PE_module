`timescale 1ns/1ps
module nice_core_top #(
    parameter DW = 16,  // 数据宽度
    parameter AW = 16   // 地址宽度
) (
    input wire i_clk,    // 输入：时钟信号，1500M时钟
    input wire cam_data, // 输入：摄像头数据

    input wire i_rst_n,  // 输入：复位信号
    input wire i_start,  // 输入：开始信号
  
    output wire[15:0] conv_sram_addr,select_fc_weight_addr,
    
    input wire[15:0] conv_weight,fc_weights0,fc_weights1,fc_weights2,fc_weights3,  // 输入：SRAM权重

    output [4:0] o_result_data,  // 输出：结果数据
    output o_result_data_valid  // 输出：结果数据有效信号

);
  wire clk;
  wire rst_n = i_rst_n;

  wire cam_clk, dout_clk;
  wire PE_clk;

  wire [207:0] parallel_data;
  wire fm_data_valid;

  wire [191:0] conv1_out_0, conv1_out_1, conv1_out_2, conv1_out_3;
  wire [95:0] conv2_out;
  wire [95:0] pool1_out_0, pool1_out_1, pool1_out_2, pool1_out_3;
  wire conv1_dout_vald, pool1_dout_vald, pool2_dout_vald, conv2_dout_vald;
  wire pool1_end, pool2_end;

  wire [95:0] pool2_out;

  wire [95:0] Filtr_1_2;
  wire [95:0] Filtr_1_1;
  wire [95:0] Filtr_1_0;

  wire [95:0] Filtr_2_2;
  wire [95:0] Filtr_2_1;
  wire [95:0] Filtr_2_0;
  wire [2:0] Filtr_2_count;

  wire weights_load_finish;
  assign clk = i_clk;
  wire [15:0] fc_sram_addr0;
  wire [15:0] fc_sram_addr1;
  wire [15:0] fc_sram_addr2;
  wire [15:0] fc_sram_addr3;

  wire [15:0] conv_weight_addr;
  assign conv_sram_addr = conv_weight_addr;

  //时钟分频器，将200M时钟分频为470KHz和10M时钟
  clockDivider clockDivider_inst (
      .clk200M_in(clk),  // 时钟信号
      .rst_n(rst_n),
      .clk470k_out(cam_clk),  // 分频后的时钟信号
      .clk10M_out(dout_clk)  // 分频后的时钟信号
  );
  weightloader_conv weightloader_conv_instance (
      .clk(PE_clk),  // 连接到你的时钟信号
      .rst_n(rst_n),  // 连接到你的复位信号
      .weights_load_start(1),  // 连接到启动权重加载的信号
      .i_sram_weight(conv_weight),  // 连接到SRAM权重的输入

      .Filtr_2_count(Filtr_2_count),  // 连接到Filtr_2计数器的输入

      .o_sram_weight_addr(conv_weight_addr),  // 连接到SRAM权重地址的输出

      .Filtr_1_2(Filtr_1_2),  // 连接到Filtr_1_2的输出
      .Filtr_1_1(Filtr_1_1),  // 连接到Filtr_1_1的输出
      .Filtr_1_0(Filtr_1_0),  // 连接到Filtr_1_0的输出

      .Filtr_2_2(Filtr_2_2),  // 连接到Filtr_2_2的输出
      .Filtr_2_1(Filtr_2_1),  // 连接到Filtr_2_1的输出
      .Filtr_2_0(Filtr_2_0),  // 连接到Filtr_2_0的输出

      .weights_load_finish(weights_load_finish)  // 连接到权重加载完成的输出
  );
  top_input top_input_inst (
      .cam_clk(cam_clk),
      .dout_clk(dout_clk),
      .rst_n(rst_n),
      .en(en),
      .cam_data(cam_data),
      .input_padding(8'd0),
      .parallel_data(parallel_data),
      .dout_vald(fm_data_valid),
      .PE_clk(PE_clk)
  );

  top_convlayer1 top_convlayer1_inst (
      .clk(PE_clk),
      .rst_n(rst_n),
      .en(i_start),
      .Ifmap_shift_in(parallel_data),  //26x8=208位数据

      .Filtr_in_2(Filtr_1_2),  //权重3x4x4=48位数据
      .Filtr_in_1(Filtr_1_1),  //权重3x4x4=48位数据
      .Filtr_in_0(Filtr_1_0),  //权重3x4x4=48位数据

      .din_vald(fm_data_valid & weights_load_finish),  //输入数据有效信号
      .dout_vald(conv1_dout_vald),  //输出数据有效信号

      .Psum_d_out_0(conv1_out_0),  //24x8=192 位数据，输出0
      .Psum_d_out_1(conv1_out_1),  //24x8=192 位数据，输出1
      .Psum_d_out_2(conv1_out_2),  //24x8=192 位数据，输出2
      .Psum_d_out_3(conv1_out_3)   //24x8=192 位数据，输出3
  );

  top_pool1 top_pool1_inst (
      .clk     (PE_clk),          // 时钟信号
      .rst_n   (rst_n),           // 复位信号
      .en      (i_start),         // 使能信号
      .valid_in(conv1_dout_vald), // 输入数据有效信号

      .data_in_0(conv1_out_0),  // 输入数据
      .data_in_1(conv1_out_1),  // 输入数据
      .data_in_2(conv1_out_2),  // 输入数据
      .data_in_3(conv1_out_3),  // 输入数据

      .data_out_0(pool1_out_0),  // 输出数据
      .data_out_1(pool1_out_1),  // 输出数据
      .data_out_2(pool1_out_2),  // 输出数据
      .data_out_3(pool1_out_3),  // 输出数据

      .valid_out(pool1_dout_vald),  // 输出数据有效信号
      .pool_end (pool1_end)
  );

  top_convlayer2 top_convlayer2_inst (
      .clk(PE_clk),
      .rst_n(rst_n),
      .en(i_start),

      .din_valid(pool1_dout_vald & weights_load_finish),  // 输入数据有效信号
      .pool_end (pool1_end),

      .data_in_0(pool1_out_0),  // 输入数据 12x8=96
      .data_in_1(pool1_out_1),  // 输入数据
      .data_in_2(pool1_out_2),  // 输入数据
      .data_in_3(pool1_out_3),  // 输入数据

      .Filtr_in_2(Filtr_2_2),  //权重3x4x4=48位数据
      .Filtr_in_1(Filtr_2_1),  //权重
      .Filtr_in_0(Filtr_2_0),  //权重

      .Psum_d_out(conv2_out),  //12x8=96 位数据
      .conv_counter(Filtr_2_count),
      .conv_en(conv2_dout_vald)  //输出数据有效信号
  );
  top_pool2 top_pool2_inst (
      .clk     (PE_clk),           // 时钟信号
      .rst_n   (rst_n),            // 复位信号
      .en      (i_start),          // 使能信号
      .valid_in(conv2_dout_vald),  // 输入数据有效信号
      .data_in (conv2_out),        // 输入数据

      .data_out (pool2_out),        // 输出数据
      .valid_out(pool2_dout_vald),  // 输出数据有效信号
      .pool_end (pool2_end)
  );


  wire [63:0] fc_weight;
  assign fc_weight = {fc_weights0, fc_weights1, fc_weights2, fc_weights3};

  fc_top fc_top_inst (
      .i_clk  (PE_clk),
      .i_rst_n(rst_n),

      .i_pool_data_in(pool2_out),
      .i_pool_valid_out(pool2_dout_vald),
      .i_pool_end(pool2_end),

      .o_fc_weight_addr(select_fc_weight_addr),
      .i_fc_weight(fc_weight),

      .o_result_data(o_result_data),
      .o_result_data_valid(o_result_data_valid)
  );

endmodule
