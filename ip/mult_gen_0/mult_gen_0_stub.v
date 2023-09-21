// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Tue Sep 19 13:09:10 2023
// Host        : Chuqi-MSI running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top mult_gen_0 -prefix
//               mult_gen_0_ mult_8x4_stub.v
// Design      : mult_8x4
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "mult_gen_v12_0_18,Vivado 2022.1" *)
module mult_gen_0(CLK, A, B, CE, P)
/* synthesis syn_black_box black_box_pad_pin="CLK,A[7:0],B[3:0],CE,P[11:0]" */;
  input CLK;
  input [7:0]A;
  input [3:0]B;
  input CE;
  output [11:0]P;
endmodule
