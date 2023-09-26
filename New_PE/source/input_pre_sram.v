module input_pre_sram
#(
  parameter DP = 1156,           // 存储器深度（SRAM的单元数） 34x34
  parameter FORCE_X2ZERO = 0,    // 是否强制未初始化的位为零
  parameter DW = 8,              // 数据宽度
  parameter MW = 1,              // 写使能位宽度
  parameter AW = 16              // 地址位宽度
)
(
  input             clk,         // 时钟信号
  input  [DW-1  :0] din,         // 数据输入
  input  [AW-1  :0] addr,        // 地址输入
  input             cs,          // 芯片选择信号（使能信号），确保在读和写时都启用
  input             we,          // 写使能信号（写入时启用，读取时禁用）
  input  [MW-1:0]   wem,         // 写使能掩码，仅在写入时使用，确定哪些位可以在写操作中被激活或写入
  output [DW-1:0]   dout         // 数据输出
);

  reg [DW-1:0] mem_r [0:DP-1];    // 存储器数组，存储SRAM数据 数组

  integer ii;
  
  reg [AW-1:0] addr_r;             // 存储地址
  wire [MW-1:0] wen;               // 写使能信号
  wire ren;                        // 读使能信号

  assign ren = cs & (~we);         // 读使能信号等于芯片选择信号与写使能信号的反
  assign wen = ({MW{cs & we}} & wem); // 写使能信号，使用写使能信号和掩码

  always @(posedge clk)
  begin
      if (ren) begin
          addr_r <= addr;           // 在读使能信号下存储地址
      end
  end

  genvar i;
  generate
    for (i = 0; i < MW; i = i+1) begin : mem
      if((8*i+8) > DW ) begin : last
        always @(posedge clk) begin
          if (wen[i]) begin
             mem_r[addr][DW-1:8*i] <= din[DW-1:8*i]; // 写入数据到存储器的高字节
          end
        end
      end
      else begin : non_last
        always @(posedge clk) begin
          if (wen[i]) begin
             mem_r[addr][8*i+7:8*i] <= din[8*i+7:8*i]; // 写入数据到存储器的低字节
          end
        end
      end
    end
  endgenerate

  wire [DW-1:0] dout_pre;
  assign dout_pre = mem_r[addr_r]; // 从存储器读取数据

  generate
    if (FORCE_X2ZERO == 1) begin : force_x_to_zero
      for (i = 0; i < DW; i = i+1) begin : force_x_gen
        `ifndef SYNTHESIS//{
        assign dout[i] = (dout_pre[i] === 1'bx) ? 1'b0 : dout_pre[i]; // 如果数据未初始化，则强制为0
        `else//}{
        assign dout[i] = dout_pre[i]; // 在综合时不强制为0
        `endif//}
      end
    end
    else begin : no_force_x_to_zero
      assign dout = dout_pre; // 不强制为0，直接输出读取到的数据
    end
  endgenerate

endmodule
