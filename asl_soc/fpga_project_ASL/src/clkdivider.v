
module clkdivider (
    input  wire clk_in,
    output reg  clk_out_32k,
    output reg  clk_out_470k
);

  reg [9:0] counter_32k, counter_470k;
  initial begin
    counter_32k = 10'd0;
    counter_470k = 10'd0;
    clk_out_32k = 1;
    clk_out_470k = 1;
  end

  always @(posedge clk_in) begin
     if (counter_32k == 10'd243) begin
      counter_32k <= 10'd0;
      clk_out_32k <= ~clk_out_32k;
    end else begin
      counter_32k <= counter_32k + 1'd1;

    end
    if (counter_470k == 10'd16) begin
      counter_470k <= 10'd0;
      clk_out_470k <= ~clk_out_470k;
    end else begin
      counter_470k <= counter_470k + 1'd1;
    end
  end
endmodule
