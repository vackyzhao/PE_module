module asl_top #(
    parameter DW = 16,  // 数据宽度
    parameter AW = 16   // 地址宽度
) (
    input wire clk,
    input wire uart_clk,  
    input wire i_cam_data,
    input wire i_rst_n,  

    output o_rst_n,
    output reg [4:0] o_result_data,  // 输出：结果数据

    output wire fm_data_valid,conv1_dout_vald, pool1_dout_vald, pool2_dout_vald, conv2_dout_vald,


    output o_result_data_valid  // 输出：结果数据有效信号
);
assign o_rst_n = i_rst_n;
  //wire clk;
  wire rst_n = i_rst_n;
 
  wire [207:0] parallel_data;
 // wire fm_data_valid;
  
  wire [191:0] conv1_out_0, conv1_out_1, conv1_out_2, conv1_out_3;
  wire [95:0] conv2_out;
  wire [95:0] pool1_out_0, pool1_out_1, pool1_out_2, pool1_out_3;
  //wire conv1_dout_vald, pool1_dout_vald, pool2_dout_vald, conv2_dout_vald;
  wire pool1_end, pool2_end;

  wire [95:0] pool2_out;

  wire  [95:0] Filtr_1_2;
  wire  [95:0] Filtr_1_1;
  wire  [95:0] Filtr_1_0;

  wire  [95:0] Filtr_2_2;
  wire  [95:0] Filtr_2_1;
  wire  [95:0] Filtr_2_0;
  wire   [2:0] Filtr_2_count;
  
  wire weights_load_finish;

    wire [15:0] fc_sram_addr0;
    wire [15:0] fc_sram_addr1;
    wire [15:0] fc_sram_addr2;
    wire [15:0] fc_sram_addr3;
    wire [15:0] select_fc_weight_addr;

    assign fc_sram_addr0 = select_fc_weight_addr;
    assign fc_sram_addr1 =  select_fc_weight_addr;
    assign fc_sram_addr2 = select_fc_weight_addr;
    assign fc_sram_addr3 = select_fc_weight_addr;
    
    wire [15:0] conv_sram_addr;
    wire [15:0] conv_weight_addr;
    //wire cs_conv;
    //wire cs_fc0, cs_fc1, cs_fc2, cs_fc3;
  
    assign conv_sram_addr = conv_weight_addr;
    wire [15:0] conv_weight;
    //wire uart_clk;

    
  wire [15:0] fc_weights0, fc_weights1, fc_weights2, fc_weights3;
  wire [63:0] fc_weight;
assign fc_weight = {fc_weights0, fc_weights1, fc_weights2, fc_weights3};
  fc_sram0 fc_sram_ins0 (
      .clk(clk), 
     .din(16'd0), 
     .addr(fc_sram_addr0),
     .cs(1), // 确保在读写时都启用
     .we(0),  // 写入时启用，读取时禁用
     .wem(0),  // 仅在写入时使用
     .dout(fc_weights0)
    );
fc_sram1 fc_sram_ins1 (
     .clk(clk), 
     .din(16'd0), 
     .addr(fc_sram_addr1),
     .cs(1), // 确保在读写时都启用
     .we(0),  // 写入时启用，读取时禁用
     .wem(0),  // 仅在写入时使用
     .dout(fc_weights1)
    );
fc_sram2 fc_sram_ins2 (
     .clk(clk), 
     .din(16'd0), 
     .addr(fc_sram_addr2),
     .cs(1), // 确保在读写时都启用
     .we(0),  // 写入时启用，读取时禁用
     .wem(0),  // 仅在写入时使用
     .dout(fc_weights2)
    );
fc_sram3 fc_sram_ins3 (
     .clk(clk), 
     .din(16'd0), 
     .addr(fc_sram_addr3),
     .cs(1), // 确保在读写时都启用
     .we(0),  // 写入时启用，读取时禁用
     .wem(0),  // 仅在写入时使用
     .dout(fc_weights3)
    );              

conv_sram conv_sram_ins
     (
     .clk(clk), 
     .din(16'd0), 
     .addr(conv_sram_addr),
     .cs(1), // 确保在读写时都启用
     .we(0), // 写入时启用，读取时禁用
     .wem(0),// 仅在写入时使用
     .dout(conv_weight)
    );

weightloader_conv weightloader_conv_instance (
    .clk(clk),  // 时钟信号
    .rst_n(rst_n),  // 复位信号
    .weights_load_start(1),  // 权重加载开始信号
    .i_sram_weight(conv_weight),  // SRAM权重输入

    .Filtr_2_count(Filtr_2_count),  // 连接到Filtr_2计数器的输入

    .o_sram_weight_addr(conv_weight_addr),  // 连接到SRAM权重地址的输出

    .Filtr_1_2(Filtr_1_2),  // 连接到Filtr_1_2的输出
    .Filtr_1_1(Filtr_1_1),  // 连接到Filtr_1_1的输出
    .Filtr_1_0(Filtr_1_0),  // 连接到Filtr_1_0的输出

    .Filtr_2_2(Filtr_2_2),  // 连接到Filtr_2_2的输出
    .Filtr_2_1(Filtr_2_1),  // 连接到Filtr_2_1的输出
    .Filtr_2_0(Filtr_2_0),  // 连接到Filtr_2_0的输出

    .weights_load_finish(weights_load_finish)  // 权重加载完成信号
);
/*
 clockDivider clockDivider_inst (
    .clk50M_in(i_clk), 
    .rst_n(rst_n),
    .clk115k_out(uart_clk), 
    .clk1M_out(clk)    
);
*/
wire dout_valid,dout_cycle_valid;
wire [1:0] cam_out_counter;

cam_in cam_in_inst(
    //camera part
    .uart_clk(uart_clk),//115200
    .uart_rx(i_cam_data),//camera data in
    //accelerator part
    .clk(clk),//every clock output 26*8 data
    .rst_n(rst_n),
    .dout_counter(cam_out_counter),
    //.dout_valid(dout_valid),
    .dout_valid_cycle(dout_cycle_valid),
    .dout_valid(fm_data_valid),//dout valid signal, high enable,continue 34clock;
    .dout(parallel_data) //26
);


  top_convlayer1 top_convlayer1_inst (
      .clk(clk),
      .rst_n(rst_n),
      .en(1),
      .Ifmap_shift_in(parallel_data),  // 输入数据


      .cam_out_counter(cam_out_counter),
      .dout_cycle_valid(dout_cycle_valid),

      .Filtr_in_2(Filtr_1_2),  //权重
      .Filtr_in_1(Filtr_1_1),  //权重
      .Filtr_in_0(Filtr_1_0),  //权重

      .din_vald (fm_data_valid),   //输入数据有效信号
      .dout_vald(conv1_dout_vald), //输出数据有效信号

      .Psum_d_out_0(conv1_out_0),  // 输出数据
      .Psum_d_out_1(),  // 输出数据
      .Psum_d_out_2(),  // 输出数据
      .Psum_d_out_3()   // 输出数据
  );

  top_pool1 top_pool1_inst (
      .clk     (clk),             // 时钟信号
      .rst_n   (rst_n),           // 复位信号
      .en      (1),         // 使能信号    
      .valid_in(conv1_dout_vald), // 输入数据有效信号

      .data_in_0(conv1_out_0),  // 输入数据
      .data_in_1(),  // 输入数据
      .data_in_2(0),  // 输入数据
      .data_in_3(0),  // 输入数据

      .data_out_0(pool1_out_0),  // 输出数据
      .data_out_1(),  // 输出数据
      .data_out_2(),  // 输出数据
      .data_out_3(),  // 输出数据

      .valid_out(pool1_dout_vald),  // 输出数据有效信号
      .pool_end (pool1_end)
  );

  top_convlayer2 top_convlayer2_inst (
      .clk(clk),
      .rst_n(rst_n),
      .en(1),

      .din_valid(pool1_dout_vald&weights_load_finish),  // 输入数据有效信号
      .pool_end (pool1_end),

      .data_in_0(pool1_out_0),  // 输入数据
      .data_in_1(0),  // 输入数据
      .data_in_2(0),  // 输入数据
      .data_in_3(0),  // 输入数据

      .Filtr_in_2(Filtr_2_2),  //权重
      .Filtr_in_1(Filtr_2_1),  //权重
      .Filtr_in_0(Filtr_2_0),  //权重

      .Psum_d_out(conv2_out),  // 输出数据
      .conv_counter(Filtr_2_count),
      .conv_en(conv2_dout_vald)  //输出数据有效信号
  );
  top_pool2 top_pool2_inst (
      .clk     (clk),              // 时钟信号
      .rst_n   (rst_n),            // 复位信号
      .en      (1),          // 使能信号    
      .valid_in(conv2_dout_vald),  // 输入数据有效信号
      .data_in (conv2_out),        // 输入数据

      .data_out (pool2_out),        // 输出数据
      .valid_out(pool2_dout_vald),  // 输出数据有效信号
      .pool_end (pool2_end)
  );
  
wire [4:0] result_data;
fc_top fc_top_inst (
     .i_clk  (clk),
     .i_rst_n(rst_n),
    
     .i_pool_data_in(pool2_out),
     .i_pool_valid_out(pool2_dout_vald),
     .i_pool_end(pool2_end),
     
     .o_fc_weight_addr(select_fc_weight_addr),
     .i_fc_weight(fc_weight),
    
     .o_result_data(result_data),
     .o_result_data_valid(o_result_data_valid)
    );

    always@(posedge clk)begin
        if(!rst_n)begin
            o_result_data <= 0;
        end else if(o_result_data_valid)begin
            o_result_data <= result_data;
        end
        
    end

endmodule
