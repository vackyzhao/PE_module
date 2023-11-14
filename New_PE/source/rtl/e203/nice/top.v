module nice_core_top #(
    parameter DW = 16,  // 数据宽度
    parameter AW = 16   // 地址宽度
) (
    input wire i_clk,  // 输入：时钟信号，200M时钟
    input wire i_cam_data,  // 输入：摄像头数据
    input wire i_rst_n,  // 输入：复位信�?
    input wire i_start,  // 输入：开始信�?
    output reg o_data_ready,  // 输出：数据准备就绪信�?
    output wire o_dma_finish,  // 输出：DMA完成信号

    //input [207:0] i_parallel_data,  // 输入：并行数�?
    //input wire i_fm_data_valid,  // 输入：特征图数据有效信号
    
    output [15:0] o_sram_weight_addr,  // 输出：SRAM权重地址
    input [15:0] i_sram_weight,  // 输入：SRAM权重

    
    output [4:0] o_result_data,  // 输出：结果数�?
    output o_result_data_valid  // 输出：结果数据有效信�?

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

  wire  [95:0] Filtr_1_2;
  wire  [95:0] Filtr_1_1;
  wire  [95:0] Filtr_1_0;

  wire  [95:0] Filtr_2_2;
  wire  [95:0] Filtr_2_1;
  wire  [95:0] Filtr_2_0;
  wire [2:0] Filtr_2_count;
    //dma transfer
    wire [AW:0] dma_conv_weight_addr;
    wire [DW:0] dma_conv_weight;
    
    reg dma_start;
    wire [AW-1:0] dma_fc_weight_addr0;
    wire [DW-1:0] dma_weights0;
    wire [AW-1:0] dma_fc_weight_addr1;
    wire [DW-1:0] dma_weights1;
    wire [AW-1:0] dma_fc_weight_addr2;
    wire [DW-1:0] dma_weights2;
    wire [AW-1:0] dma_fc_weight_addr3;
    wire [DW-1:0] dma_weights3;
    wire [4:0] dma_control;
    
  wire weights_load_finish;
  assign clk = i_clk;
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin 
    o_data_ready <= 0;
    dma_start <= 0;
  end else begin
    if (o_dma_finish) begin
        o_data_ready <= 1; 
        dma_start <= 0;
    end else begin
        o_data_ready <= 0;
        if (i_start) begin
            dma_start <= 1;
        end
    end
  end
end

dma_module dma_module_ins (
    
    // for nice cmd and data
        .i_clk  (i_clk),
        .i_rst_n(i_rst_n),
        
    //for read ITCM 
        .i_itcm_data(i_sram_weight),
        .o_itcm_addr(o_sram_weight_addr),
 
    //mnist module control dma
        .i_dma_start (dma_start),  
    //dma transfer data to acc
        .o_dma_finish(o_dma_finish),
        
        .i_fc_weight_length  (16'd1296),
        .i_conv_weight_length(16'd162),

    
        .o_dma_control(dma_control),
    
        .o_write_en(write_en),
    
        .o_dma_conv_weight_addr(dma_conv_weight_addr),
        .o_dma_conv_weight(dma_conv_weight),
    
        .o_dma_fc_weight_addr0(dma_fc_weight_addr0),
        .o_dma_weights0(dma_weights0),
        .o_dma_fc_weight_addr1(dma_fc_weight_addr1),
        .o_dma_weights1(dma_weights1),
        .o_dma_fc_weight_addr2(dma_fc_weight_addr2),
        .o_dma_weights2(dma_weights2),
        .o_dma_fc_weight_addr3(dma_fc_weight_addr3),
        .o_dma_weights3(dma_weights3)
    
    );
    wire [15:0] fc_sram_addr0;
    wire [15:0] fc_sram_addr1;
    wire [15:0] fc_sram_addr2;
    wire [15:0] fc_sram_addr3;
    wire [15:0] select_fc_weight_addr;
    assign fc_sram_addr0 = dma_start ? dma_fc_weight_addr0 : select_fc_weight_addr;
    assign fc_sram_addr1 = dma_start ? dma_fc_weight_addr1 : select_fc_weight_addr;
    assign fc_sram_addr2 = dma_start ? dma_fc_weight_addr2 : select_fc_weight_addr;
    assign fc_sram_addr3 = dma_start ? dma_fc_weight_addr3 : select_fc_weight_addr;
    
    wire [15:0] conv_sram_addr;
    wire [15:0] conv_weight_addr;
    wire cs_conv;
    wire cs_fc0, cs_fc1, cs_fc2, cs_fc3;
    assign cs_conv = ((write_en && dma_control[0]) | dma_finish);
    assign conv_sram_addr = dma_start ? dma_conv_weight_addr : conv_weight_addr;
/*
  RAMSP1024X16_rtl_top conv_sram_ins (
      .Q    (conv_weight),           // 输出�?16位数据输�?
      .CLK  (clk),                   // 输入：时钟信�?
      .CEN  (~cs_conv),               // 输入：芯片使能信�?
      .WEN  ({16{~dma_control[0]}}),  // 输入�?16位写使能信号
      .A    (conv_sram_addr[9:0]),   // 输入�?10位地�?输入
      .D    (dma_conv_weight),       // 输入�?16位数据输�?
      .EMA  (3'b000),                // 输入�?3位扩展模式地�?输入
      .EMAW (2'b00),                 // 输入�?2位扩展模式地�?写使能输�?
      .GWEN (1'b0),                  // 输入：全�?写使能输�?
      .RET1N(1'b0)                   // 输入�?1位读使能输入
  );
  */
    conv_sram conv_sram_ins
            (
             .clk(i_clk), 
             .din(dma_conv_weight), 
             .addr(conv_sram_addr),
             .cs(cs_conv ), //make sure you enable it for both read and write
             .we(dma_control[0]), //enable it when write, disable it when read
             .wem(dma_control[0]),//only uesd when write
             .dout(conv_weight)
            );
    
     



//时钟分频器，�?200M时钟分频�?470KHz�?10M时钟
 clockDivider clockDivider_inst (
      .clk200M_in(clk),  // 时钟信号
      .rst_n(rst_n),
      .clk470k_out(cam_clk),  // 分频后的时钟信号
      .clk10M_out(dout_clk)  // 分频后的时钟信号
  );
weightloader_conv weightloader_conv_instance (
    .clk(PE_clk),  // 连接到你的时钟信�?
    .rst_n(rst_n),  // 连接到你的复位信�?
    .weights_load_start(~dma_control[0]),  // 连接到启动权重加载的信号
    .i_sram_weight(conv_weight),  // 连接到SRAM权重的输�?

    .Filtr_2_count(Filtr_2_count),  // 连接到Filtr_2计数器的输入

    .o_sram_weight_addr(conv_sram_addr),  // 连接到SRAM权重地址的输�?

    .Filtr_1_2(Filtr_1_2),  // 连接到Filtr_1_2的输�?
    .Filtr_1_1(Filtr_1_1),  // 连接到Filtr_1_1的输�?
    .Filtr_1_0(Filtr_1_0),  // 连接到Filtr_1_0的输�?

    .Filtr_2_2(Filtr_2_2),  // 连接到Filtr_2_2的输�?
    .Filtr_2_1(Filtr_2_1),  // 连接到Filtr_2_1的输�?
    .Filtr_2_0(Filtr_2_0),  // 连接到Filtr_2_0的输�?

    .weights_load_finish(weights_load_finish)  // 连接到权重加载完成的输出
);
/*
  weightloader_conv weightloader_conv_inst (
    .Filtr_2_count(Filtr_2_count),

    .Filtr_1_2(Filtr_1_2),
    .Filtr_1_1(Filtr_1_1),
    .Filtr_1_0(Filtr_1_0),

    .Filtr_2_2(Filtr_2_2),
    .Filtr_2_1(Filtr_2_1),
    .Filtr_2_0(Filtr_2_0)
);*/
  top_input top_input_inst (
      .cam_clk(cam_clk),
      .dout_clk(dout_clk),
      .rst_n(rst_n),
      .en(en),
      .cam_data(i_cam_data),
      .input_padding(8'd0),
      .parallel_data(parallel_data),
      .dout_vald(fm_data_valid),
      .PE_clk(PE_clk)
  );


wire dma_finish;
//assign fm_data_valid = i_fm_data_valid;
// assign parallel_data = i_parallel_data;
assign dma_finish = o_dma_finish;
  top_convlayer1 top_convlayer1_inst (
      .clk(PE_clk),
      .rst_n(rst_n),
      .en(dma_finish),
      .Ifmap_shift_in(parallel_data),  //26x8=208位数�?

      .Filtr_in_2(Filtr_1_2),  //权重3x4x4=48位数�?
      .Filtr_in_1(Filtr_1_1),  //权重3x4x4=48位数�?
      .Filtr_in_0(Filtr_1_0),  //权重3x4x4=48位数�?

      .din_vald (fm_data_valid&weights_load_finish),   //输入数据有效信号
      .dout_vald(conv1_dout_vald), //输出数据有效信号

      .Psum_d_out_0(conv1_out_0),  //24x8=192 位数据，输出0
      .Psum_d_out_1(conv1_out_1),  //24x8=192 位数据，输出1
      .Psum_d_out_2(conv1_out_2),  //24x8=192 位数据，输出2
      .Psum_d_out_3(conv1_out_3)   //24x8=192 位数据，输出3
  );

  top_pool1 top_pool1_inst (
      .clk     (PE_clk),             // 时钟信号
      .rst_n   (rst_n),           // 复位信号
      .en      (dma_finish),         // 使能信号    
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
      .en(dma_finish),

      .din_valid(pool1_dout_vald&weights_load_finish),  // 输入数据有效信号
      .pool_end (pool1_end),

      .data_in_0(pool1_out_0),  // 输入数据 12x8=96
      .data_in_1(pool1_out_1),  // 输入数据
      .data_in_2(pool1_out_2),  // 输入数据
      .data_in_3(pool1_out_3),  // 输入数据

      .Filtr_in_2(Filtr_2_2),  //权重3x4x4=48位数�?
      .Filtr_in_1(Filtr_2_1),  //权重
      .Filtr_in_0(Filtr_2_0),  //权重

      .Psum_d_out(conv2_out),  //12x8=96 位数�? 
      .conv_counter(Filtr_2_count),
      .conv_en(conv2_dout_vald)  //输出数据有效信号
  );
  top_pool2 top_pool2_inst (
      .clk     (PE_clk),              // 时钟信号
      .rst_n   (rst_n),            // 复位信号
      .en      (dma_finish),          // 使能信号    
      .valid_in(conv2_dout_vald),  // 输入数据有效信号
      .data_in (conv2_out),        // 输入数据

      .data_out (pool2_out),        // 输出数据
      .valid_out(pool2_dout_vald),  // 输出数据有效信号
      .pool_end (pool2_end)
  );
  
  wire [15:0] fc_weights0, fc_weights1, fc_weights2, fc_weights3;
/*
  RAMSP2048X16_rtl_top fc_sram_ins0 (
      .Q(fc_weights0),  // 输出�?16位数据输�?
      .CLK(clk),  // 输入：时钟信�?
      .CEN(~((write_en & dma_control[1]) | dma_finish)),  // 输入：芯片使能信�?
      .WEN({16{~dma_control[1]}}),  // 输入�?16位写使能信号
      .A(fc_sram_addr0[10:0]),  // 输入�?10位地�?输入
      .D(dma_weights0),  // 输入�?16位数据输�?
      .EMA(3'b000),  // 输入�?3位扩展模式地�?输入
      .EMAW(2'b00),  // 输入�?2位扩展模式地�?写使能输�?
      .GWEN(1'b0),  // 输入：全�?写使能输�?
      .RET1N(1'b0)  // 输入�?1位读使能输入
  );
  RAMSP2048X16_rtl_top fc_sram_ins1 (
      .Q(fc_weights1),  // 输出�?16位数据输�?
      .CLK(clk),  // 输入：时钟信�?
      .CEN(~((write_en & dma_control[2]) | dma_finish)),  // 输入：芯片使能信�?
      .WEN({16{~dma_control[2]}}),  // 输入�?16位写使能信号
      .A(fc_sram_addr1[10:0]),  // 输入�?10位地�?输入
      .D(dma_weights1),  // 输入�?16位数据输�?
      .EMA(3'b000),  // 输入�?3位扩展模式地�?输入
      .EMAW(2'b00),  // 输入�?2位扩展模式地�?写使能输�?
      .GWEN(1'b0),  // 输入：全�?写使能输�?
      .RET1N(1'b0)  // 输入�?1位读使能输入
  );
  RAMSP2048X16_rtl_top fc_sram_ins2 (
      .Q(fc_weights2),  // 输出�?16位数据输�?
      .CLK(clk),  // 输入：时钟信�?
      .CEN(~((write_en & dma_control[3]) | dma_finish)),  // 输入：芯片使能信�?
      .WEN({16{~dma_control[3]}}),  // 输入�?16位写使能信号
      .A(fc_sram_addr2[10:0]),  // 输入�?10位地�?输入
      .D(dma_weights2),  // 输入�?16位数据输�?
      .EMA(3'b000),  // 输入�?3位扩展模式地�?输入
      .EMAW(2'b00),  // 输入�?2位扩展模式地�?写使能输�?
      .GWEN(1'b0),  // 输入：全�?写使能输�?
      .RET1N(1'b0)  // 输入�?1位读使能输入
  );
  RAMSP2048X16_rtl_top fc_sram_ins3 (
      .Q(fc_weights3),  // 输出�?16位数据输�?
      .CLK(clk),  // 输入：时钟信�?
      .CEN(~((write_en & dma_control[4]) | dma_finish)),  // 输入：芯片使能信�?
      .WEN({16{~dma_control[4]}}),  // 输入�?16位写使能信号
      .A(fc_sram_addr3[10:0]),  // 输入�?10位地�?输入
      .D(dma_weights3),  // 输入�?16位数据输�?
      .EMA(3'b000),  // 输入�?3位扩展模式地�?输入
      .EMAW(2'b00),  // 输入�?2位扩展模式地�?写使能输�?
      .GWEN(1'b0),  // 输入：全�?写使能输�?
      .RET1N(1'b0)  // 输入�?1位读使能输入
  );*/
  
  fc_sram fc_sram_ins0 (
      .clk(PE_clk), 
     .din(dma_weights0), 
     .addr(fc_sram_addr0),
     .cs((write_en&dma_control[1])|dma_finish), //make sure you enable it for both read and write
     .we(dma_control[1]),  //enable it when write, disable it when read
     .wem(dma_control[1]),  //only uesd when write
     .dout(fc_weights0)
    );
fc_sram fc_sram_ins1 (
     .clk(PE_clk), 
     .din(dma_weights1), 
     .addr(fc_sram_addr1),
     .cs((write_en&dma_control[2])|dma_finish), //make sure you enable it for both read and write
     .we(dma_control[2]),  //enable it when write, disable it when read
     .wem(dma_control[2]),  //only uesd when write
     .dout(fc_weights1)
    );
fc_sram fc_sram_ins2 (
     .clk(PE_clk), 
     .din(dma_weights2), 
     .addr(fc_sram_addr2),
     .cs((write_en&dma_control[3])|dma_finish), //make sure you enable it for both read and write
     .we(dma_control[3]),  //enable it when write, disable it when read
     .wem(dma_control[3]),  //only uesd when write
     .dout(fc_weights2)
    );
fc_sram fc_sram_ins3 (
     .clk(PE_clk), 
     .din(dma_weights3), 
     .addr(fc_sram_addr3),
     .cs((write_en&dma_control[4])|dma_finish), //make sure you enable it for both read and write
     .we(dma_control[4]),  //enable it when write, disable it when read
     .wem(dma_control[4]),  //only uesd when write
     .dout(fc_weights3)
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
