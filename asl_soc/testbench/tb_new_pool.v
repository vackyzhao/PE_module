`timescale 1ns/1ps

module tb_pool_module();

  reg clk;
  reg rst_n;
  reg pool_en;
  reg layer1;
  reg valid_in;
  reg [8*24-1:0] data_in;
  reg [15:0] col;

  wire [8*12-1:0] data_out;
  wire valid_out;
  wire pool_end;

  // Instantiate the pool_module
  pool_module pool_inst (
    .clk(clk),
    .rst_n(rst_n),
    .pool_en(pool_en),
    .layer1(layer1),
    .valid_in(valid_in),
    .data_in(data_in),
    .col(col),
    .data_out(data_out),
    .valid_out(valid_out),
    .pool_end(pool_end)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  // Testbench
  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 0;
    pool_en = 0;
    layer1 = 0;
    valid_in = 0;
    data_in = 0;
    col = 16'b0;

    // Release reset
    rst_n = 1;
    #10;

    // Test case 1: Input valid, layer1 enabled
    pool_en = 1;
    layer1 = 1;
    valid_in = 1;
    data_in = {16'b11111111_11111111,176'b0}; // Example input data
    col = 16'd32;  // Example column count
    #10;
    // Check the expected output

    // Test case 2: Another test case
    // ... (Add more test cases as needed)

    // Finish simulation
    $finish;
  end

endmodule
