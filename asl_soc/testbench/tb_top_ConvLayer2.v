module tb_top_convlayer2;

  reg clk;
  reg rst_n;
  reg en;
  reg din_valid;
  reg pool_end;
  reg [95:0] data_in_0;
  reg [95:0] data_in_1;
  reg [95:0] data_in_2;
  reg [95:0] data_in_3;
  reg [47:0] Filtr_in_2;
  reg [47:0] Filtr_in_1;
  reg [47:0] Filtr_in_0;

  wire [95:0] Psum_d_out;

wire [2:0]conv_counter;
  wire dout_vald;

  top_convlayer2 uut (
      .clk(clk),
      .rst_n(rst_n),
      .en(en),
      .din_valid(din_valid),
      .pool_end(pool_end),
      .data_in_0(data_in_0),
      .data_in_1(data_in_1),
      .data_in_2(data_in_2),
      .data_in_3(data_in_3),
      .Filtr_in_2(Filtr_in_2),
      .Filtr_in_1(Filtr_in_1),
      .Filtr_in_0(Filtr_in_0),
      .Psum_d_out(Psum_d_out),
     .conv_counter(conv_counter),
      .dout_vald(dout_vald)
  );

  // 时钟生成
  always begin
    #5 clk = ~clk;
  end
  initial begin
    clk = 0;
    rst_n = 0;
    en = 0;
    din_valid = 0;
    pool_end = 0;
    data_in_0 = {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
    data_in_1 = 96'b0;
    data_in_2 = 96'b0;
    data_in_3 = 96'b0;
    Filtr_in_2 = {4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1};
    Filtr_in_1 = {4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1};
    Filtr_in_0 = {4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1};
    #10 rst_n = 1;
    #10 en = 1;
    #5 din_valid = 1;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    data_in_0 = 96'b1;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    data_in_0 = 96'b0;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    data_in_0 = 96'b1;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    data_in_0 = 96'b0;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    data_in_0 = 96'b1;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    data_in_0 = 96'b0;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    data_in_0 = 96'b1;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    data_in_0 = 96'd5;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    data_in_0 = 96'd5;
    #10 din_valid = ~din_valid;
    pool_end = ~pool_end;
    #10 pool_end = ~pool_end;
    // 设置输入数据和权重数�?
    data_in_0  = 96'b1101010101101010110101010110101011010101011010101101010101101010;
    data_in_1  = 96'b0011001100110011001100110011001100110011001100110011001100110011;
    data_in_2  = 96'b1111000011110000111100001111000011110000111100001111000011110000;
    data_in_3  = 96'b0000000011111111000000001111111100000000111111110000000011111111;
    Filtr_in_2 = 48'b110011001100110011001100110011001100110011001100;
    Filtr_in_1 = 48'b001100110011001100110011001100110011001100110011;
    Filtr_in_0 = 48'b111100001111000011110000111100001111000011110000;
    // 等待�?段时间，模拟运行
    #5000;

    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    #10 din_valid = ~din_valid;
    pool_end = ~pool_end;
    #10 pool_end = ~pool_end;
    #5000;
    // 在这里添加其他测试操�?
    // �?查模拟结束条�?
    $finish;
  end

endmodule
