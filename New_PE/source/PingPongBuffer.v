module PingPongBuffer#(
parameter STATE_A = 2'b00,
parameter STATE_B = 2'b01
)
(
	input i_clk_input, // 时钟信号输入
  input i_clk_output, // 时钟信号输入
	input i_rst_n, // 复位信号输入
	/////////////////////////////////
	input i_switch_pingpong, // pingpong切换信号输入
	/////////////////////////////////	
	input [15:0] i_fm_addr, // 输入特征图地址	
	input [7:0] i_data_din, // data 输入数据
	input i_data_din_vld, // data 输入数据有效信号
	/////////////////////////////////
	input [15:0] i_conv_addr, // 卷积输出地址	
	output [7:0] o_conv_din// 卷积数据输出
);
  // 状态寄存器和初始状态
  reg [1:0] current_state;//状态机寄存器
  initial current_state = STATE_A;//初始状态
  
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
  
  assign o_conv_din=data_out;

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
      
      if(i_switch_pingpong)begin
        current_state <= STATE_A;
      end
      else begin
        current_state <= STATE_B;
      end
     
    end
  end

  // 定义每个状态的操作
  always @(*) begin
    case (current_state)
      STATE_A:begin
        // 在状态 A 下的操作 sram0输入，sram1输出
        sram0_clk=i_clk_input;
        sram1_clk=i_clk_output;
        sram0_cs=1;
        sram1_cs=1;        
        sram1_we=0;
        sram1_addr=i_conv_addr;
        data_out=sram1_dout;
        if(i_data_din_vld)begin
        sram0_we=1;
        sram0_addr=i_fm_addr;
        sram0_din=i_data_din;

        end

      end
      STATE_B:begin
        // 在状态 B 下的操作 sram0输出，sram1输入
        sram0_clk=i_clk_output;
        sram1_clk=i_clk_input;
        sram0_cs=1;
        sram1_cs=1;
        sram0_we=0;
        sram0_addr=i_conv_addr;
        data_out=sram0_dout;
        if(i_data_din_vld)begin
        sram1_we=1;
        sram1_addr=i_fm_addr;
        sram1_din=i_data_din;
        end

      end
    endcase
  end


endmodule 