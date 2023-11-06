module top (
    input wire clk,//输入200M主时钟
    input wire rst_n,
    input wire en,

    input wire cam_data,

    output [4:0] o_result_data,
    output o_result_data_valid

);
  wire cam_clk,dout_clk;
  wire [207:0] parallel_data;
  wire [191:0] conv1_out_0, conv1_out_1, conv1_out_2, conv1_out_3;
  wire [95:0] conv2_out;
  wire [95:0] pool1_out_0, pool1_out_1, pool1_out_2, pool1_out_3;
  wire input_dout_vald, conv1_dout_vald, pool1_dout_vald, pool2_dout_vald,conv2_dout_vald;
  wire pool1_end, pool2_end;
  wire PE_clk;

  wire [95:0] pool2_out;

  wire  [47:0] Filtr_1_2;
  wire  [47:0] Filtr_1_1;
  wire  [47:0] Filtr_1_0;

  wire  [47:0] Filtr_2_2;
  wire  [47:0] Filtr_2_1;
  wire  [47:0] Filtr_2_0;
  wire [2:0] Filtr_2_count;


//时钟分频器，输入200M时钟，输出470KHz和10M时钟
 clockDivider clockDivider_inst (
      .clk200M_in(clk),  // 输入时钟信号
      .rst_n(rst_n),
      .clk470k_out(cam_clk),  // 输出分频后的信号
      .clk10M_out(dout_clk)  // 输出分频后的信号
  );

 weightloader_conv weightloader_conv_inst(
    .Filtr_2_count(Filtr_2_count),

    .Filtr_1_2(Filtr_1_2),
    .Filtr_1_1(Filtr_1_1),
    .Filtr_1_0(Filtr_1_0),

    .Filtr_2_2(Filtr_2_2),
    .Filtr_2_1(Filtr_2_1),
    .Filtr_2_0(Filtr_2_0)
);
  top_input top_input_inst (
      .cam_clk(cam_clk),
      .dout_clk(dout_clk),
      .rst_n(rst_n),
      .en(en),
      .cam_data(cam_data),
      .input_padding(8'd0),
      .parallel_data(parallel_data),
      .dout_vald(input_dout_vald),
      .PE_clk(PE_clk)
  );

  top_convlayer1 top_convlayer1_inst (
      .clk(PE_clk),
      .rst_n(rst_n),
      .en(en),
      .Ifmap_shift_in(parallel_data),  //26x8=208位数据输入

      .Filtr_in_2(Filtr_1_2),  //权重3x4x4=48位
      .Filtr_in_1(Filtr_1_1),  //权重3x4x4=48位
      .Filtr_in_0(Filtr_1_0),  //权重3x4x4=48位

      .din_vald (input_dout_vald),  //卷积数据输入有效信号
      .dout_vald(conv1_dout_vald),  //卷积数据输出有效信号

      .Psum_d_out_0(conv1_out_0),  //24x8=192 位卷积核0数据输出
      .Psum_d_out_1(conv1_out_1),  //24x8=192 位卷积核1数据输出
      .Psum_d_out_2(conv1_out_2),  //24x8=192 位卷积核2数据输出
      .Psum_d_out_3(conv1_out_3)   //24x8=192 位卷积核3数据输出
  );

  top_pool1 top_pool1_inst (
      .clk     (PE_clk),          // 时钟输入
      .rst_n   (rst_n),           // 复位输入（低电平有效）
      .en      (en),              // 使能    
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
      .en(en),

      .din_valid(pool1_dout_vald),  // 输入数据有效信号
      .pool_end (pool1_end),

      .data_in_0(pool1_out_0),  // 输入数据 12x8=96
      .data_in_1(pool1_out_1),  // 输入数据
      .data_in_2(pool1_out_2),  // 输入数据
      .data_in_3(pool1_out_3),  // 输入数据

      .Filtr_in_2(Filtr_2_2),  //权重3x4x4=48位
      .Filtr_in_1(Filtr_2_1),  //权重
      .Filtr_in_0(Filtr_2_0),  //权重

      .Psum_d_out(conv2_out),  //12x8=96 
      .conv_counter(Filtr_2_count),
      .conv_en(conv2_dout_vald)  //卷积数据输出有效信号
  );
  top_pool2 top_pool2_inst (
      .clk      (PE_clk),           // 时钟输入
      .rst_n    (rst_n),            // 复位输入（低电平有效）
      .en       (en),               // 使能    
      .valid_in (conv2_dout_vald),  // 输入数据有效信号
      .data_in  (conv2_out),        // 输入数据

      .data_out (pool2_out),        // 输出数据
      .valid_out(pool2_dout_vald),  // 输出数据有效信号
      .pool_end (pool2_end)
  );

fc_top fc_top_inst(
     .i_clk(PE_clk),
     .i_rst_n(rst_n),
    
     .i_pool_data_in(pool2_out),
     .i_pool_valid_out(pool2_dout_vald),
     .i_pool_end(pool2_end),
    
     .o_result_data(o_result_data),
     .o_result_data_valid(o_result_data_valid)
    );

endmodule
