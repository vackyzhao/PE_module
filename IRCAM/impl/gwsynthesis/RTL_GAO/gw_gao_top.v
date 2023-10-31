module gw_gao(
    \data_out_8bit[7] ,
    \data_out_8bit[6] ,
    \data_out_8bit[5] ,
    \data_out_8bit[4] ,
    \data_out_8bit[3] ,
    \data_out_8bit[2] ,
    \data_out_8bit[1] ,
    \data_out_8bit[0] ,
    dout_vald,
    clkout,
    \UART_DATA[7] ,
    \UART_DATA[6] ,
    \UART_DATA[5] ,
    \UART_DATA[4] ,
    \UART_DATA[3] ,
    \UART_DATA[2] ,
    \UART_DATA[1] ,
    \UART_DATA[0] ,
    clk920k,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \data_out_8bit[7] ;
input \data_out_8bit[6] ;
input \data_out_8bit[5] ;
input \data_out_8bit[4] ;
input \data_out_8bit[3] ;
input \data_out_8bit[2] ;
input \data_out_8bit[1] ;
input \data_out_8bit[0] ;
input dout_vald;
input clkout;
input \UART_DATA[7] ;
input \UART_DATA[6] ;
input \UART_DATA[5] ;
input \UART_DATA[4] ;
input \UART_DATA[3] ;
input \UART_DATA[2] ;
input \UART_DATA[1] ;
input \UART_DATA[0] ;
input clk920k;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \data_out_8bit[7] ;
wire \data_out_8bit[6] ;
wire \data_out_8bit[5] ;
wire \data_out_8bit[4] ;
wire \data_out_8bit[3] ;
wire \data_out_8bit[2] ;
wire \data_out_8bit[1] ;
wire \data_out_8bit[0] ;
wire dout_vald;
wire clkout;
wire \UART_DATA[7] ;
wire \UART_DATA[6] ;
wire \UART_DATA[5] ;
wire \UART_DATA[4] ;
wire \UART_DATA[3] ;
wire \UART_DATA[2] ;
wire \UART_DATA[1] ;
wire \UART_DATA[0] ;
wire clk920k;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top_0  u_la0_top(
    .control(control0[9:0]),
    .trig0_i({\UART_DATA[7] ,\UART_DATA[6] ,\UART_DATA[5] ,\UART_DATA[4] ,\UART_DATA[3] ,\UART_DATA[2] ,\UART_DATA[1] ,\UART_DATA[0] }),
    .data_i({\data_out_8bit[7] ,\data_out_8bit[6] ,\data_out_8bit[5] ,\data_out_8bit[4] ,\data_out_8bit[3] ,\data_out_8bit[2] ,\data_out_8bit[1] ,\data_out_8bit[0] ,dout_vald,clkout}),
    .clk_i(clk920k)
);

endmodule
