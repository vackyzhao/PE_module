`timescale 1ns / 1ps
module shift_register (
    input clk,
    input rst_n,
    input en,
    input [7:0] input_data,
    output wire [7:0] output_data_0,
    output wire[7:0] output_data_1,
    output wire[7:0] output_data_2
);

  wire [7:0] reg0_out, reg1_out, reg2_out;



  sirv_gnrl_dfflr #(8) reg0 (
      .lden (en),
      .dnxt (input_data),
      .qout (reg0_out),
      .clk  (clk),
      .rst_n(rst_n)
  );

  sirv_gnrl_dfflr #(8) reg1 (
      .lden (en),
      .dnxt (reg0_out),
      .qout (reg1_out),
      .clk  (clk),
      .rst_n(rst_n)
  );

  sirv_gnrl_dfflr #(8) reg2 (
      .lden (en),
      .dnxt (reg1_out),
      .qout (reg2_out),
      .clk  (clk),
      .rst_n(rst_n)
  );

  assign output_data_0 = reg0_out;
  assign output_data_1 = reg1_out;
  assign output_data_2 = reg2_out;

endmodule
