module top_input(    
    input  cam_clk,
    input dout_clk,
    input rst_n,
    input en,
    input cam_data,    
    input [7:0]input_padding,

    output [207:0] parallel_data,
    output dout_vald,
    output PE_clk

    );
wire din_clk,i_data_din_vld;
wire [7:0] i_data_din;

IRCAM IRCAM_inst(
    .clk460k(cam_clk),
    .UART_RX(cam_data),
    .clkout(din_clk),
    .dout_vald(i_data_din_vld),
    .data_out_8bit(i_data_din)
);
Input_pre_data_module Input_pre_data_module_inst (
    .din_clk(din_clk),
    .i_data_din(i_data_din),
    .i_data_din_vld(i_data_din_vld),
    .input_padding(input_padding),
    .dout_clk(dout_clk),
    .en(en),
    .rst_n(rst_n),
    .PEclk(PE_clk),
    .out_data_vld(dout_vald),
    .parallel_data(parallel_data)
);


endmodule