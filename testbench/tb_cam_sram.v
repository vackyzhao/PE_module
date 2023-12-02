`timescale 1ns / 1ps

module CAM_SRAM_TB;

  reg clk;
  reg rst_n;
  reg [7:0] datain;
  reg wen;
  reg [9:0] raddr;
  reg [9:0] waddr;
  wire [207:0] dataout;

  // Instantiate the SRAM module
  CAM_SRAM uut (
    .clk(clk),
    .rst_n(rst_n),
    .datain(datain),
    .wen(wen),
    .raddr(raddr),
    .waddr(waddr),
    .dataout(dataout)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test scenario
  initial begin
    // Initialize inputs
    rst_n = 0;
    datain = 8'h00;
    wen = 0;
    raddr = 10'b00000;
    waddr = 10'b0000000000;

    // Release reset after a short delay
    #10 rst_n = 1;
    datain = 8'hAA;
    // Write data to SRAM
    #10 
    wen = 1;
    waddr = 10'd0;
    /*#10 waddr = 10'd1;
    #10 waddr = 10'd2;
    #10 waddr = 10'd3;
    #10 waddr = 10'd4;
    #10 waddr = 10'd5;
    #10 waddr = 10'd6;
    #10 waddr = 10'd7;
    #10 waddr = 10'd8;
    #10 waddr = 10'd9;
*/
    // Read data from SRAM
    #10 raddr = 10'b00000;
    wen = 0;
    #10 raddr = 10'd1;
    #10 raddr = 10'd33;

    // Add more test scenarios as needed...

    // Stop simulation
    #50 $finish;
  end

endmodule
