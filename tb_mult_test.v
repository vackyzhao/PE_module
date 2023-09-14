module tb_module_test();

reg clk;
reg rst_n;
reg en;
reg [7:0] A;
reg [3:0] B;
wire [11:0] P;

mult_test mult_test_0(
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .A(A),
    .B(B),
    .P(P)
);

 parameter Tclk = 10;
 
 initial begin
 // define clk
 clk = 1;
 forever #(Tclk / 2) clk = ~clk;
 end

 
 initial begin
 // define rst and en
 rst_n = 0;
 en = 0;
 #(Tclk * 2) rst_n = 1;
 #(Tclk) en = 1;
 end

  initial begin
    #(Tclk * 10)
    A=8'b0000_0001;
    B=4'b001;
    #(Tclk * 1)
    A=8'b0000_0010;
    B=4'b010;
    #(Tclk * 1)
    A=8'b0000_0100;
    B=4'b100;
    #(Tclk * 1)
    A=8'b0000_0001;
    B=4'b001;
  end

endmodule