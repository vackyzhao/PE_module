`timescale 1ns / 1ps
module PingPongBuffer
(
	input i_clk_input, // 输入时钟信号
  input i_clk_output, // 输出时钟信号
	input i_rst_n, //复位信号输入
	/////////////////////////////////
	input i_switch_pingpong, // pingpong切换信号输入
	/////////////////////////////////	
	input [7:0] i_data_din, // data 输入数据 
	input i_data_din_vld, // data 输入数据有效信号 
  output  reg o_pl_buffer_ready,//输入完成信号 
	/////////////////////////////////
	input [15:0] i_conv_addr, // 卷积输出地址	 
	output [7:0] o_conv_dout// 卷积数据输出  
);
parameter STATE_A = 1'b0;
parameter STATE_B = 1'b1;
  // 状态寄存器和初始状态
  reg current_state;//状态机寄存器 
  reg [15:0] input_counter;

  initial begin
    current_state = STATE_A;//初始状态 
    input_counter=15'b0;//地址寄存器清空
  end
  reg sram0_clk,sram1_clk;//sram0，1时钟信号
  reg sram0_cs,sram1_cs;
  reg sram0_we,sram1_we;

  reg [7:0] sram0_din;
  wire [7:0] sram0_dout;
  reg [7:0] sram1_din;
  wire [7:0] sram1_dout;
  reg [7:0] data_out;
  reg [15:0] sram0_addr;
  reg [15:0] sram1_addr;

  
  
  assign o_conv_dout=data_out;

  input_pre_sram sram0 (
    .clk(sram0_clk),
    .din(sram0_din),
    .addr(sram0_addr),
    .cs(sram0_cs),
    .we(sram0_we),
    .wem(1'b1),
    .dout(sram0_dout)
  );
  input_pre_sram sram1 (
    .clk(sram1_clk),
    .din(sram1_din),
    .addr(sram1_addr),
    .cs(sram1_cs),
    .we(sram1_we),
    .wem(1'b1),
    .dout(sram1_dout)
  );

  always @(*) begin
    if (!i_rst_n) begin
      // 复位状态机到初始状态
      current_state <= STATE_A;
    end else begin
    if(current_state==STATE_A&&i_switch_pingpong==STATE_B) begin
      input_counter=15'b0;
      current_state=STATE_B;
    end  
    if(current_state==STATE_B&&i_switch_pingpong==STATE_A) begin
      input_counter=15'b0;
      current_state=STATE_A;
    end

    end
  end




  // 定义每个状态的操作
  always @(posedge i_clk_input) begin
    case (current_state)
      STATE_A:begin
        // 在状态 A 下的操作 sram0输入，sram1输出
        
        sram0_cs=1'b1;
        sram0_addr=input_counter;
        sram0_din=i_data_din;
        if(i_data_din_vld&&(input_counter<1155))begin
        sram0_we=1;     
        input_counter=input_counter+1;
        end

        if(input_counter==1155)begin
          o_pl_buffer_ready=1'b1;
        end else begin
        if(input_counter<1155)begin
          o_pl_buffer_ready=1'b0;
        end        
        end

      end
      STATE_B:begin
        // 在状态 B 下的操作 sram0输出，sram1输入
        // 在状态 A 下的操作 sram0输入，sram1输出
        
        sram1_cs=1;
        sram1_addr=input_counter;
        sram1_din=i_data_din;
        if(i_data_din_vld&&(input_counter<1155))begin
        sram1_we=1;     
        input_counter=input_counter+1;
        end
        if(input_counter==1155)begin
          o_pl_buffer_ready=1'b1;
        end else begin
        if(input_counter<1155)begin
          o_pl_buffer_ready=1'b0;
        end        
        end
      end
    endcase
  end


 always @(posedge i_clk_output) begin
  case (current_state)
      STATE_A:begin
        // 在状态 A 下的操作 sram0输入，sram1输出        
               
        sram1_cs=1;        
        sram1_we=0;
        sram1_addr=i_conv_addr;
        data_out=sram1_dout;
      end
      STATE_B:begin
        // 在状态 B 下的操作 sram0输出，sram1输入
             
        sram0_cs=1;        
        sram0_we=0;
        sram0_addr=i_conv_addr;
        data_out=sram0_dout;
      end
    endcase
 end

 always @(*) begin
  case (current_state)
      STATE_A:begin
        // 在状态 A 下的操作 sram0输入，sram1输出        
        sram1_clk=i_clk_output; 
        sram0_clk=i_clk_input; 
      end
      STATE_B:begin
        // 在状态 B 下的操作 sram0输出，sram1输入
        sram0_clk=i_clk_output; 
        sram1_clk=i_clk_input; 
      end
    endcase
 end

endmodule 