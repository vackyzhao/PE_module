module top(
    input wire clk50M,
    input UART_RX,
    output [207:0] parallel_data,
    output dout_vld,PEclk
    );
wire din_clk,i_data_din_vld,PEclk,dout_vld;
wire [7:0] i_data_din;
wire  [207:0] parallel_data;



IRCAM IRCAM_inst(
    .clk50M(clk50M),
    .UART_RX(UART_RX),
    .clkout(din_clk),
    .dout_vald(i_data_din_vld),
    .data_out_8bit(i_data_din)
);
Input_pre_data_module Input_pre_data_module_inst (
    .din_clk(din_clk),
    .i_data_din(i_data_din),
    .i_data_din_vld(i_data_din_vld),
    .input_padding(input_padding),
    .dout_clk(din_clk),
    .en(1),
    .rst_n(1),
    .PEclk(PEclk),
    .dout_vld(dout_vld),
    .parallel_data(parallel_data)
);

endmodule