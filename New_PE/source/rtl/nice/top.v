module nice_core_top #(
    parameter DW = 16,  // Data Width
    parameter AW = 16   // Address Width
)(
    input wire i_clk,//输入200M主时??
    input wire i_rst_n,
    input wire i_start,
    output reg o_data_ready,
    output wire o_dma_finish,
    
    input [207:0] i_parallel_data,
    input wire i_fm_data_valid,
    
    output [15:0] o_sram_weight_addr,
    input [15:0] i_sram_weight, 
    //input wire cam_data,

    output [4:0] o_result_data,
    output o_result_data_valid

);
  wire clk ;
  wire rst_n = i_rst_n;

  wire cam_clk,dout_clk;
    wire PE_clk;
  
  wire [207:0] parallel_data;
  wire fm_data_valid;
  
  wire [191:0] conv1_out_0, conv1_out_1, conv1_out_2, conv1_out_3;
  wire [95:0] conv2_out;
  wire [95:0] pool1_out_0, pool1_out_1, pool1_out_2, pool1_out_3;
  wire conv1_dout_vald, pool1_dout_vald, pool2_dout_vald,conv2_dout_vald;
  wire pool1_end, pool2_end;

  wire [95:0] pool2_out;

  wire  [47:0] Filtr_1_2;
  wire  [47:0] Filtr_1_1;
  wire  [47:0] Filtr_1_0;

  wire  [47:0] Filtr_2_2;
  wire  [47:0] Filtr_2_1;
  wire  [47:0] Filtr_2_0;
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
    assign clk=i_clk;
always@(posedge clk or negedge rst_n)
begin
  if(!rst_n)   begin 
    o_data_ready<=0;
    dma_start<=0;
  end
  else begin
    if(o_dma_finish)   begin
        o_data_ready<=1; 
        dma_start<=0;
    end
    else begin
        o_data_ready<=0;
        if(i_start)begin
            dma_start<=1;
        end
    end
  end
end

dma_module dma_module_ins(
    
    // for nice cmd and data
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        
    //for read ITCM 
        .i_itcm_data(i_sram_weight),
        .o_itcm_addr(o_sram_weight_addr),
 
    //mnist module control dma
        .i_dma_start(dma_start),  
    //dma transfer data to acc
        .o_dma_finish(o_dma_finish),
        
        .i_fc_weight_length(16'd1296),
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
    assign fc_sram_addr0 = dma_start? dma_fc_weight_addr0:select_fc_weight_addr;
    assign fc_sram_addr1 = dma_start? dma_fc_weight_addr1:select_fc_weight_addr;
    assign fc_sram_addr2 = dma_start? dma_fc_weight_addr2:select_fc_weight_addr;
    assign fc_sram_addr3 = dma_start? dma_fc_weight_addr3:select_fc_weight_addr;
    
    wire [15:0] conv_sram_addr;
    wire [15:0] conv_weight_addr;
    wire cs_conv;
    wire cs_fc0,cs_fc1,cs_fc2,cs_fc3;
    assign cs_conv = ((write_en&&dma_control[0])|dma_finish);
    assign conv_sram_addr = dma_start? dma_conv_weight_addr:conv_weight_addr;
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

            



//时钟分频器，输入200M时钟，输??470KHz??10M时钟
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
      .cam_data(),
      .input_padding(8'd0),
      .parallel_data(),
      .dout_vald(),
      .PE_clk()
  );


wire dma_finish;
assign fm_data_valid = i_fm_data_valid;
assign parallel_data = i_parallel_data;
assign dma_finish = o_dma_finish;
  top_convlayer1 top_convlayer1_inst (
      .clk(clk),
      .rst_n(rst_n),
      .en(i_start),
      .Ifmap_shift_in(parallel_data),  //26x8=208位数据输??

      .Filtr_in_2(Filtr_1_2),  //权重3x4x4=48??
      .Filtr_in_1(Filtr_1_1),  //权重3x4x4=48??
      .Filtr_in_0(Filtr_1_0),  //权重3x4x4=48??

      .din_vald (fm_data_valid),  //卷积数据输入有效信号
      .dout_vald(conv1_dout_vald),  //卷积数据输出有效信号

      .Psum_d_out_0(conv1_out_0),  //24x8=192 位卷积核0数据输出
      .Psum_d_out_1(conv1_out_1),  //24x8=192 位卷积核1数据输出
      .Psum_d_out_2(conv1_out_2),  //24x8=192 位卷积核2数据输出
      .Psum_d_out_3(conv1_out_3)   //24x8=192 位卷积核3数据输出
  );

  top_pool1 top_pool1_inst (
      .clk     (clk),          // 时钟输入
      .rst_n   (rst_n),           // 复位输入（低电平有效??
      .en      (i_start),              // 使能    
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
      .clk(clk),
      .rst_n(rst_n),
      .en(i_start),

      .din_valid(pool1_dout_vald),  // 输入数据有效信号
      .pool_end (pool1_end),

      .data_in_0(pool1_out_0),  // 输入数据 12x8=96
      .data_in_1(pool1_out_1),  // 输入数据
      .data_in_2(pool1_out_2),  // 输入数据
      .data_in_3(pool1_out_3),  // 输入数据

      .Filtr_in_2(Filtr_2_2),  //权重3x4x4=48??
      .Filtr_in_1(Filtr_2_1),  //权重
      .Filtr_in_0(Filtr_2_0),  //权重

      .Psum_d_out(conv2_out),  //12x8=96 
      .conv_counter(Filtr_2_count),
      .conv_en(conv2_dout_vald)  //卷积数据输出有效信号
  );
  top_pool2 top_pool2_inst (
      .clk      (clk),           // 时钟输入
      .rst_n    (rst_n),            // 复位输入（低电平有效??
      .en       (i_start),               // 使能    
      .valid_in (conv2_dout_vald),  // 输入数据有效信号
      .data_in  (conv2_out),        // 输入数据

      .data_out (pool2_out),        // 输出数据
      .valid_out(pool2_dout_vald),  // 输出数据有效信号
      .pool_end (pool2_end)
  );
  
  wire [15:0] fc_weights0,fc_weights1,fc_weights2,fc_weights3;
  fc_sram fc_sram_ins0
    (
     .clk(clk), 
     .din(dma_weights0), 
     .addr(fc_sram_addr0),
     .cs((write_en&dma_control[1])|dma_finish), //make sure you enable it for both read and write
     .we(dma_control[1]), //enable it when write, disable it when read
     .wem(dma_control[1]),//only uesd when write
     .dout(fc_weights0)
    );
fc_sram fc_sram_ins1
    (
     .clk(clk), 
     .din(dma_weights1), 
     .addr(fc_sram_addr1),
     .cs((write_en&dma_control[2])|dma_finish), //make sure you enable it for both read and write
     .we(dma_control[2]), //enable it when write, disable it when read
     .wem(dma_control[2]),//only uesd when write
     .dout(fc_weights1)
    );
fc_sram fc_sram_ins2
    (
     .clk(clk), 
     .din(dma_weights2), 
     .addr(fc_sram_addr2),
     .cs((write_en&dma_control[3])|dma_finish), //make sure you enable it for both read and write
     .we(dma_control[3]), //enable it when write, disable it when read
     .wem(dma_control[3]),//only uesd when write
     .dout(fc_weights2)
    );
fc_sram fc_sram_ins3
    (
     .clk(clk), 
     .din(dma_weights3), 
     .addr(fc_sram_addr3),
     .cs((write_en&dma_control[4])|dma_finish), //make sure you enable it for both read and write
     .we(dma_control[4]), //enable it when write, disable it when read
     .wem(dma_control[4]),//only uesd when write
     .dout(fc_weights3)
    );                
wire [63:0] fc_weight;
assign fc_weight = {fc_weights0,fc_weights1,fc_weights2,fc_weights3};

fc_top fc_top_inst(
     .i_clk(clk),
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
