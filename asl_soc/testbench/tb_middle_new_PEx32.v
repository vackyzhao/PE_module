module tb_middle_new_PEx32 ();
  // 时钟和复位信号
  reg clk;
  reg rst_n;

  // 使能信号
  reg en;

  // 输入端口
  reg [7:0] Ifmap_shift_in_0_2;
  reg [7:0] Ifmap_shift_in_0_1;
  reg [7:0] Ifmap_shift_in_0_0;
  reg [7:0] Ifmap_shift_in_1_0;
  reg [11:0] Filtr_in_2;
  reg [11:0] Filtr_in_1;
  reg [11:0] Filtr_in_0;

  // 输出端口
  wire [13:0] Psum_out_0;
  wire [13:0] Psum_out_1;
  wire [419:0] Psum_out_x;
  wire [447:0] Psum_out;

  assign Psum_out_0=Psum_out[447:434];
  assign Psum_out_1=Psum_out[433:420];
  assign Psum_out_x=Psum_out[419:0];


  // 实例化中间模块
middle_new_PEx32 middle_new_PEx32_0(
    .clk(clk),  //PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效 

    
    .Ifmap_shift_in({Ifmap_shift_in_0_2[7:0],Ifmap_shift_in_0_1[7:0],Ifmap_shift_in_0_0[7:0], Ifmap_shift_in_1_0[7:0], 240'b0}),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data) 32*8

    .Filtr_in_2(Filtr_in_2),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)    
    .Filtr_in_1(Filtr_in_1),//  输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)
    .Filtr_in_0(Filtr_in_0),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)

    .Psum_out(Psum_out)  //输出计算结果 14*32 
);

  // 时钟生成
  parameter Tclk = 10;

  initial begin
    // define clk
    clk = 1;
    forever #(Tclk / 2) clk = ~clk;
  end

  // 初始化信号
  initial begin
    clk = 0;
    rst_n = 0;
    en = 0;
    Ifmap_shift_in_0_2 = 8'd0;
    Ifmap_shift_in_0_1 = 8'd0;
    Ifmap_shift_in_0_0 = 8'd0;
    Ifmap_shift_in_1_0 = 8'd0;
    Filtr_in_2 = 12'd0;
    Filtr_in_1 = 12'd0;
    Filtr_in_0 = 12'd0;

    // 在时钟上升沿释放复位信号
    #(Tclk * 10) 
    rst_n = 1;
    // 使能信号置高
    #(Tclk * 10) 
    en = 1;
    Filtr_in_2 = {{4'd4},{4'd3},{4'd1}};
    Filtr_in_1 = {{4'd3},{4'd2},{4'd0}};
    Filtr_in_0 = {{4'd0},{4'd4},{4'd1}};
    // 在此添加测试用例或输入信号
    #(Tclk * 1)
    Ifmap_shift_in_0_2={8'd2};
    Ifmap_shift_in_0_1={8'd3};
    Ifmap_shift_in_0_0={8'd1};
    Ifmap_shift_in_1_0={8'd4};
    #(Tclk * 1)
    Ifmap_shift_in_0_2={8'd4};
    Ifmap_shift_in_0_1={8'd2};
    Ifmap_shift_in_0_0={8'd3};
    Ifmap_shift_in_1_0={8'd0};
    #(Tclk * 1)
    Ifmap_shift_in_0_2={8'd1};
    Ifmap_shift_in_0_1={8'd4};
    Ifmap_shift_in_0_0={8'd2};
    Ifmap_shift_in_1_0={8'd1};
    #(Tclk * 1)
    Ifmap_shift_in_0_2={8'd0};
    Ifmap_shift_in_0_1={8'd1};
    Ifmap_shift_in_0_0={8'd1};
    Ifmap_shift_in_1_0={8'd2};
    
    // 仿真持续一段时间
    #300 $finish;
  end

  // 在这里添加您的测试逻辑
endmodule
