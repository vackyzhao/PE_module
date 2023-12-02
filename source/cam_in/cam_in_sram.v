module CAM_SRAM (
  input wire clk,          // 时钟信号
  input wire rst_n,        // 复位信号
  input wire [7:0] datain, // 写入数据
  input  wen,          // 读写使能信号
  input wire [9:0] raddr,   // 读地址输入
  input wire [9:0] waddr,   // 写地址输入
  output reg [207:0] dataout // 26个数据的并行输出
);

  reg [7:0] memory [25:0][33:0]; // 26行34列的存储器

  integer i,m,n;
  always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // 在复位时初始化存储器
      for (m = 0; m < 34; m = m + 1) begin
           for (n = 0; n < 26; n = n + 1) begin
           memory[n][m][7:0] <=8'b0;
        end
        end
      end
     else begin
      // 读写操作
      if (!wen) begin
        // 读取数据        
        for (i = 0; i < 26; i = i + 1) begin
          dataout[207-i*8 -: 8] <= memory[i][raddr][7:0];
        end
      end else begin
        //写入数据
        memory[waddr%26][waddr/26][7:0]<=datain[7:0];    

      end
    end
  end
endmodule

