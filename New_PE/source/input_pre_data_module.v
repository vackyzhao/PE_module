`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/08 19:14:10
// Design Name: 
// Module Name: Input_pre_data_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Input_pre_data_module
(
	input           din_clk,
	input  [7:0] i_data_din,        // data 输入数据 
    input    i_data_din_vld,    // data 输入数据有效信号
	//////////////////////////////////
	input          dout_clk,
	input                en,
	input 			  rst_n,
	input i_switch_pingpong,
	output PEclk
);
reg [15:0]i_conv_addr;
//34分频
clockDivider34 divider34_inst (
    .clk(dout_clk),
    .divided(PEclk)
  );
  // 实例化被测试的模块
  PingPongBuffer PingPongBuffer_inst (
    .i_clk_input(din_clk),
    .i_clk_output(dout_clk),
    .i_rst_n(i_rst_n),
    .en(en),
    .i_switch_pingpong(i_switch_pingpong),
    .i_data_din(i_data_din),
    .i_data_din_vld(i_data_din_vld),
    .i_conv_addr(i_conv_addr),
    .o_conv_dout(o_conv_dout),
    .o_pl_buffer_ready(o_pl_buffer_ready)
  );
always@(posedge PEclk or negedge rst_n)begin
	if(!rst_n)begin
		i_conv_addr=16'b0;
	end else begin
		
		i_conv_addr=i_conv_addr+1'b1;
	end
endmodule
