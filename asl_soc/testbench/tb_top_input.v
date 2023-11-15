module tb_top_input (
    input clk,//50MHz
    input rst_n,
    input cam_data,
    output wire dout_vald,
    output wire [207:0] parallel_data,
    output wire PE_clk,i_data_din_vld
);
  wire cam_clk, dout_clk, din_clk;
  wire i_data_din_vld;
  wire [7:0] i_data_din;


 


  clockDivider_50M clockDivider_50M_inst (
      .clk50M_in(clk),
      .rst_n(rst_n),
      .clk470k_out(cam_clk),
      .clk5M_out(dout_clk)
  );
/*
  IRCAM IRCAM_inst (
      .clk460k(cam_clk),
      .UART_RX(cam_data),
      .clkout(din_clk),
      .dout_vald(i_data_din_vld),
      .data_out_8bit(i_data_din)
  );
*/

  
 top_input top_input_dut(    
     .cam_clk(cam_clk),//470KHz
     .dout_clk(dout_clk),
     .rst_n(rst_n),
     .en(1'b1),
     .cam_data(cam_data), 
     .parallel_data(parallel_data),
     .dout_vald(dout_vald),
     .PE_clk(PE_clk),
     .i_data_din_vld(i_data_din_vld)
    );
endmodule
