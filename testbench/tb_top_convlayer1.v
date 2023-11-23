module tb_top_convlayer1 ();
  reg clk;
  reg rst_n;
  reg en;
  reg [207:0] Ifmap_shift_in;
  reg [96:0] Filtr_in_2;
  reg [96:0] Filtr_in_1;
  reg [96:0] Filtr_in_0;
  reg din_vald;
  wire dout_vald;
  wire [191:0] Psum_d_out_0;
  wire [191:0] Psum_d_out_1;
  wire [191:0] Psum_d_out_2;
  wire [191:0] Psum_d_out_3;

  // Instantiate the top_condlayer1 module
  top_convlayer1 uut (
      .clk(clk),
      .rst_n(rst_n),
      .en(en),
      .Ifmap_shift_in(Ifmap_shift_in),
      .Filtr_in_2(Filtr_in_2),
      .Filtr_in_1(Filtr_in_1),
      .Filtr_in_0(Filtr_in_0),
      .din_vald(din_vald),
      .dout_vald(dout_vald),
      .Psum_d_out_0(Psum_d_out_0),
      .Psum_d_out_1(Psum_d_out_1),
      .Psum_d_out_2(Psum_d_out_2),
      .Psum_d_out_3(Psum_d_out_3)
  );


  // 时钟生成
  parameter Tclk = 10;

  initial begin
    // define clk
    clk = 0;
    forever #(Tclk / 2) clk = ~clk;
  end

  initial begin
    clk = 1;
    rst_n = 0;
    en = 0;
    din_vald=0;
    Ifmap_shift_in = 208'b0;
    Filtr_in_2 = 96'd0;
    Filtr_in_1 = 96'd0;
    Filtr_in_0 = 96'd0;

    // 在时钟上升沿释放复位信号
    #(Tclk * 10) rst_n = 1;
    // 使能信号置高
    #(Tclk * 10) en = 1;
    din_vald=1;
    Filtr_in_2=96'h0403ff_0403ff_0403ff_0403ff;  //权重3x4x8=96�?
    Filtr_in_1=96'hfd0200_fd0200_fd0200_fd0200; //权重3x4x8=96�?
    Filtr_in_0=96'h000401_000401_000401_000401;  //权重3x4x8=96�?
    Ifmap_shift_in={{8'h02},{8'h03},{8'h00},{8'h04},{176'h0}};
    #(Tclk) 
    Ifmap_shift_in={{8'h04},{8'h02},{8'h03},{8'h00},{176'h0}};
    #(Tclk) 
    Ifmap_shift_in={{8'h01},{8'h04},{8'h02},{8'h01},{176'h0}};
    #(Tclk) 
    Ifmap_shift_in={{8'h00},{8'h01},{8'h01},{8'h02},{176'h0}};
    #(Tclk) 
    Ifmap_shift_in={208'b0};
    #(Tclk * 32)
     din_vald=0;


  end

endmodule
