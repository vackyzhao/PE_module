`timescale 1ns / 1ps
module tb_new_PE_Unit();
 
 reg clk;
 reg rst_n;
 reg en;

 reg [7:0] Ifmap_shift_in = 0;
 reg [11:0] Filtr_in = 0;
 reg [13:0] Psum_in=0;
 wire [13:0] Psum_out;

 wire [7:0] Ifmap_shift_out;


new_PE_Unit new_PE_Unit(
    .clk(clk),  //PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效   

    .Filtr_in(Filtr_in),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)   
    .Ifmap_shift_in(Ifmap_shift_in),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Psum_in(Psum_in),

    .Ifmap_shift_out(Ifmap_shift_out),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Psum_out(Psum_out)  //输出计算结果   
);


 parameter Tclk = 10;
 
 initial begin
 // define clk
 clk = 1;
 forever #(Tclk / 2) clk = ~clk;
 end
 
 initial begin
 // define rst and en
 rst_n = 0;
 en = 0;
 Psum_in =1;
 #(Tclk * 2) rst_n = 1;
 #(Tclk) en = 1;
 #(Tclk) Filtr_in = {{4'd4},{4'd3},{4'd1}};
 #(Tclk*10)
 #(Tclk) Ifmap_shift_in=8'd2;
 #(Tclk) Ifmap_shift_in=8'd4;
 #(Tclk) Ifmap_shift_in=8'd1;
 #(Tclk) Ifmap_shift_in=8'd0;
 
 end
 

 
endmodule