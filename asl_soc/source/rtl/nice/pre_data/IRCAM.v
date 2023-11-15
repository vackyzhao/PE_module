`timescale 1ns/1ps
module IRCAM (
    input wire clk460k,
    input UART_RX,
    output reg clkout,
    output reg dout_vald,
    output reg [7:0] data_out_8bit,
    output  [15:0] data_counter
);
  wire data_valid;
  reg [15:0] data_out,temp_max, pre_temp_max,max_temperature;
  wire [ 7:0] UART_DATA;
  wire [ 7:0] pre_UART_DATA;
  reg  [15:0] data_counter;
  reg  [15:0] data_out_tmp = 16'b0;
  /*
  //生成串口时钟和串口采样时钟
  ClockDivider460k ClockDivider460k_inst (
      .clk_in   (clk50M),   // 输入时钟
      .clk_out_0(clk460k),  // 输出时钟
      .clk_out_1(clk920k),   // 输出时钟
      .clk_out_2()   // 输出时钟
  );
  //生成100M采样时钟
  Gowin_PLL Gowin_PLL100M_inst (
      .clkout0(clk100M),  //output clkout0
      .clkin  (clk50M)    //input clkin
  );
  */
  //串口接收模块
  UART_RX UART_RX_inst (
      .clk(clk460k),
      .UART_RX(UART_RX),
      .data_valid(data_valid),
      .UART_DATA(UART_DATA),
      .pre_UART_DATA(pre_UART_DATA)
  );
  always @(posedge clk460k) begin
    if (data_valid) begin
      if (UART_DATA == 8'h5A && pre_UART_DATA == 8'h5A) begin
        pre_temp_max = temp_max;  
        data_counter <= 16'd2;
        data_out_tmp <= 16'd0;
        temp_max <= 16'b0;
        if(pre_temp_max>3300)begin
            max_temperature<=pre_temp_max;
        end else begin
            max_temperature<=3300;
        end
      end else begin
        data_counter <= data_counter + 1'b1;
      end
      if (data_counter > 16'd3 && data_counter < 16'd1540) begin
        if (data_counter[0] == 0) begin
          dout_vald <= 1;
          data_out <= data_out_tmp;
          data_out_tmp <= UART_DATA;
          if ((data_out_tmp > temp_max)&& (data_out_tmp<16'd3900) ) begin
            temp_max <= data_out_tmp;
          end

          if (data_out_tmp <= 16'd2700) begin
            data_out_8bit <= 8'd0;
          end else if (data_out_tmp >= max_temperature) begin
            data_out_8bit <= 8'd255;
          end else begin
            data_out_8bit <= 255 * (data_out_tmp - 16'd2700) / (max_temperature-2700);
          end
        end else begin
          data_out_tmp <= data_out_tmp + 256 * UART_DATA;
        end
      end else begin
        data_out <= 16'd0;
        dout_vald <= 0;                     
      end
    end
  end

  always@(posedge data_valid)begin
    clkout=~clkout;
  end

endmodule
