module tb_middle_new_PEx2 ();
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

  // 实例化中间模块
  middle_new_PEx2 tb_middle_new_PEx2_0 (
      .clk(clk),
      .rst_n(rst_n),
      .en(en),

      .Ifmap_shift_in_0_2(Ifmap_shift_in_0_2),
      .Ifmap_shift_in_0_1(Ifmap_shift_in_0_1),
      .Ifmap_shift_in_0_0(Ifmap_shift_in_0_0),
      .Ifmap_shift_in_1_0(Ifmap_shift_in_1_0),

      .Filtr_in_2(Filtr_in_2),
      .Filtr_in_1(Filtr_in_1),
      .Filtr_in_0(Filtr_in_0),

      .Psum_out_0(Psum_out_0),
      .Psum_out_1(Psum_out_1)
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
    Ifmap_shift_in_0_2={8'd0};
    Ifmap_shift_in_0_1={8'd0};
    Ifmap_shift_in_0_0={8'd0};
    Ifmap_shift_in_1_0={8'd4};
    #(Tclk * 1)
    Ifmap_shift_in_0_2={8'd0};
    Ifmap_shift_in_0_1={8'd3};
    Ifmap_shift_in_0_0={8'd3};
    Ifmap_shift_in_1_0={8'd0};
    #(Tclk * 1)
    Ifmap_shift_in_0_2={8'd2};
    Ifmap_shift_in_0_1={8'd2};
    Ifmap_shift_in_0_0={8'd2};
    Ifmap_shift_in_1_0={8'd1};
    #(Tclk * 1)
    Ifmap_shift_in_0_2={8'd4};
    Ifmap_shift_in_0_1={8'd4};
    Ifmap_shift_in_0_0={8'd1};
    Ifmap_shift_in_1_0={8'd2};
    #(Tclk * 1)
    Ifmap_shift_in_0_2={8'd1};
    Ifmap_shift_in_0_1={8'd1};
    Ifmap_shift_in_0_0={8'd1};
    Ifmap_shift_in_1_0={8'd0};
    #(Tclk * 1)
    Ifmap_shift_in_0_2={8'd0};
    Ifmap_shift_in_0_1={8'd0};
    Ifmap_shift_in_0_0={8'd0};
    Ifmap_shift_in_1_0={8'd0};

    // 仿真持续一段时间
    #1000 $finish;
  end

  // 在这里添加您的测试逻辑
endmodule
