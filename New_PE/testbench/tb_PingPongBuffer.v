`timescale 1ns / 1ps
module tb_PingPongBuffer;

  // 参数和信号声明

  reg i_clk_input;
  reg i_clk_output;
  reg i_rst_n;
  reg i_switch_pingpong;
  reg [7:0] i_data_din;
  reg i_data_din_vld;
  reg [9:0] i_conv_addr;
  wire [7:0] o_conv_dout;
  wire o_pl_buffer_ready;

  // 实例化被测试的模块
  PingPongBuffer dut (
    .i_clk_input(i_clk_output),
    .i_clk_output(i_clk_output),
    .i_rst_n(i_rst_n),
    .en(1'b1),
    .i_switch_pingpong(i_switch_pingpong),
    .i_data_din(i_data_din),
    .i_data_din_vld(i_data_din_vld),
    .i_conv_addr(i_conv_addr),
    .o_conv_dout(o_conv_dout),
    .o_pl_buffer_ready(o_pl_buffer_ready)
  );

 parameter Tclk = 4;

 initial begin
 // define clk
  i_clk_output = 1;
 forever #(Tclk / 2) begin 
   i_clk_output = ~i_clk_output;
 end
 end


 initial begin
 // define clk
  i_clk_input = 1;
 forever #(Tclk / 2) begin 
   i_clk_input = ~i_clk_input;
 end
 end

initial begin
  i_rst_n=1'd0;
#(Tclk*1200)
i_rst_n=1'd1;
i_conv_addr=10'd767;
i_switch_pingpong=1'd0;
i_data_din=8'd8;
i_data_din_vld=1'd1;
#(Tclk*1200)
i_switch_pingpong=1'd1;
i_data_din=8'd7;
#(Tclk*1200)
i_switch_pingpong=1'd0;
i_data_din=8'd6;
#(Tclk*1200)
i_switch_pingpong=1'd1;
i_data_din=8'd5;

#(Tclk*1200)
i_rst_n=1'd0;
#(Tclk*1200)
i_rst_n=1'd1;
i_conv_addr=10'd767;
i_switch_pingpong=1'd0;
i_data_din=8'd8;
i_data_din_vld=1'd1;
#(Tclk*1200)
i_switch_pingpong=1'd1;
i_data_din=8'd7;
#(Tclk*1200)
i_switch_pingpong=1'd0;
i_data_din=8'd6;
#(Tclk*1200)
i_switch_pingpong=1'd1;
i_data_din=8'd5;
end
  
endmodule