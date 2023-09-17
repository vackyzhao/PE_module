module tb_shift_register();

reg clk;
reg rst_n;
reg en;
reg [7:0]input_data;
wire [7:0] output_data_0;
wire [7:0] output_data_1;
wire [7:0] output_data_2;


shift_register shift_register_0(
  .clk(clk),
  .rst_n(rst_n),
  .en(en),
  .input_data(input_data),
  .output_data_0(output_data_0),
  .output_data_1(output_data_1),
  .output_data_2(output_data_2)
);
 parameter Tclk = 10;
 initial begin
 // define clk
 clk = 1'b1;
 forever #(Tclk / 2) clk = ~clk;
 end
 
 initial begin
 // define rst and en
 rst_n = 0;
 en = 0;
 #(Tclk * 2) rst_n = 1;
 en = 1;
 #(Tclk) input_data=0;
 #(Tclk) input_data=1;
 #(Tclk) input_data=2;
 #(Tclk) input_data=3;
 #(Tclk) input_data=4;
 #(Tclk) input_data=5;
  #(Tclk ) rst_n = 0;

 end

endmodule