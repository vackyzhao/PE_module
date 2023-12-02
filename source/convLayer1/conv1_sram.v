// 设置时钟分辨率
`timescale 1ns / 1ps

/* 以下部分为版权和作者信息 */
/* 
   Copyright 2018-2020 Nuclei System Technology, Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

// 作者和描述信息
//=====================================================================
//
// Designer   : Bob Hu
//
// Description:
//  The simulation model of SRAM
//
// ====================================================================

// 模块定义：输入预处理 SRAM
module conv1_sram #(
    parameter DP           = 32,  // 数据端口数
    parameter FORCE_X2ZERO = 1,    // 是否将未知值（X）强制置零
    parameter DW           = 192,    // 数据位宽
    parameter MW           = 1,    // 写使能位宽
    parameter AW           = 10    // 地址位宽
) (
    input             clk,   // 时钟信号
    input  [DW-1 : 0] din,   // 数据输入
    input  [AW-1 : 0] addr,  // 地址输入
    input             cs,    // 片选信号（确保在读和写时都启用）
    input             we,    // 写使能信号（在写入时启用，读取时禁用）
    input  [  MW-1:0] wem,   // 写使能脉冲宽度
    output [  DW-1:0] dout   // 数据输出
);

  reg [DW-1:0] mem_r[0:DP-1];  // 存储器数组，用于保存数据

  initial begin
    // 存储器初始化
  end

  reg  [AW-1:0] addr_r;  // 地址寄存器
  wire [MW-1:0] wen;  // 写使能脉冲
  wire          ren;  // 读使能信号

  assign ren = cs & (~we);  // 读使能信号
  assign wen = ({MW{cs & we}} & wem);  // 写使能脉冲

  always @(posedge clk) begin
    if (ren) begin
      addr_r <= addr;  // 读操作时更新地址寄存器
    end
  end

  genvar i;
  generate
    for (i = 0; i < MW; i = i + 1) begin : mem
      if ((192 * i + 192) > DW) begin : last
        always @(posedge clk) begin
          if (wen[i]) begin
            mem_r[addr][191:0] <= din[191:0];  // 写入数据到存储器
          end
        end
      end else begin : non_last
        always @(posedge clk) begin
          if (wen[i]) begin
            mem_r[addr][191:0] <= din[191:0];  // 写入数据到存储器
          end
        end
      end
    end
  endgenerate

  wire [DW-1:0] dout_pre;
  assign dout_pre = mem_r[addr_r];  // 从存储器读取数据

  generate
    if (FORCE_X2ZERO == 1) begin : force_x_to_zero
      for (i = 0; i < DW; i = i + 1) begin : force_x_gen
`ifndef SYNTHESIS  //{
        assign dout[i] = (dout_pre[i] === 1'bx) ? 1'b0 : dout_pre[i]; // 如果未知值（X），则置零
`else  //{
        assign dout[i] = dout_pre[i];
`endif  // }
      end
    end else begin : no_force_x_to_zero
      assign dout = dout_pre;
    end
  endgenerate

endmodule
