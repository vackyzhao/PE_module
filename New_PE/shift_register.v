module shift_register(
  input clk,
  input rst_n,
  input en,
  input [7:0] input_data,
  output [7:0] output_data_0,
  output [7:0] output_data_1,
  output [7:0] output_data_2
);

wire [7:0] reg1_out, reg2_out, reg3_out;

sirv_gnrl_dfflr #(8) reg1 (
  .lden(en),
  .dnxt(input_data),
  .qout(reg1_out),
  .clk(clk),
  .rst_n(rst_n)
);

sirv_gnrl_dfflr #(8) reg2 (
  .lden(en),
  .dnxt(reg1_out),
  .qout(reg2_out),
  .clk(clk),
  .rst_n(rst_n)
);

sirv_gnrl_dfflr #(8) reg3 (
  .lden(en),
  .dnxt(reg2_out),
  .qout(reg3_out),
  .clk(clk),
  .rst_n(rst_n)
);

assign output_data_0 = reg1_out;
assign output_data_1 = reg2_out;
assign output_data_2 = reg3_out;

endmodule
