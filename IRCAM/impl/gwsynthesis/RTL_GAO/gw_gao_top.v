module gw_gao(
    \UART_DATA[7] ,
    \UART_DATA[6] ,
    \UART_DATA[5] ,
    \UART_DATA[4] ,
    \UART_DATA[3] ,
    \UART_DATA[2] ,
    \UART_DATA[1] ,
    \UART_DATA[0] ,
    \UART_RX_inst/data_valid ,
    \data_counter[15] ,
    \data_counter[14] ,
    \data_counter[13] ,
    \data_counter[12] ,
    \data_counter[11] ,
    \data_counter[10] ,
    \data_counter[9] ,
    \data_counter[8] ,
    \data_counter[7] ,
    \data_counter[6] ,
    \data_counter[5] ,
    \data_counter[4] ,
    \data_counter[3] ,
    \data_counter[2] ,
    \data_counter[1] ,
    \data_counter[0] ,
    \data_out[15] ,
    \data_out[14] ,
    \data_out[13] ,
    \data_out[12] ,
    \data_out[11] ,
    \data_out[10] ,
    \data_out[9] ,
    \data_out[8] ,
    \data_out[7] ,
    \data_out[6] ,
    \data_out[5] ,
    \data_out[4] ,
    \data_out[3] ,
    \data_out[2] ,
    \data_out[1] ,
    \data_out[0] ,
    \data_out_tmp[15] ,
    \data_out_tmp[14] ,
    \data_out_tmp[13] ,
    \data_out_tmp[12] ,
    \data_out_tmp[11] ,
    \data_out_tmp[10] ,
    \data_out_tmp[9] ,
    \data_out_tmp[8] ,
    \data_out_tmp[7] ,
    \data_out_tmp[6] ,
    \data_out_tmp[5] ,
    \data_out_tmp[4] ,
    \data_out_tmp[3] ,
    \data_out_tmp[2] ,
    \data_out_tmp[1] ,
    \data_out_tmp[0] ,
    clk920k,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \UART_DATA[7] ;
input \UART_DATA[6] ;
input \UART_DATA[5] ;
input \UART_DATA[4] ;
input \UART_DATA[3] ;
input \UART_DATA[2] ;
input \UART_DATA[1] ;
input \UART_DATA[0] ;
input \UART_RX_inst/data_valid ;
input \data_counter[15] ;
input \data_counter[14] ;
input \data_counter[13] ;
input \data_counter[12] ;
input \data_counter[11] ;
input \data_counter[10] ;
input \data_counter[9] ;
input \data_counter[8] ;
input \data_counter[7] ;
input \data_counter[6] ;
input \data_counter[5] ;
input \data_counter[4] ;
input \data_counter[3] ;
input \data_counter[2] ;
input \data_counter[1] ;
input \data_counter[0] ;
input \data_out[15] ;
input \data_out[14] ;
input \data_out[13] ;
input \data_out[12] ;
input \data_out[11] ;
input \data_out[10] ;
input \data_out[9] ;
input \data_out[8] ;
input \data_out[7] ;
input \data_out[6] ;
input \data_out[5] ;
input \data_out[4] ;
input \data_out[3] ;
input \data_out[2] ;
input \data_out[1] ;
input \data_out[0] ;
input \data_out_tmp[15] ;
input \data_out_tmp[14] ;
input \data_out_tmp[13] ;
input \data_out_tmp[12] ;
input \data_out_tmp[11] ;
input \data_out_tmp[10] ;
input \data_out_tmp[9] ;
input \data_out_tmp[8] ;
input \data_out_tmp[7] ;
input \data_out_tmp[6] ;
input \data_out_tmp[5] ;
input \data_out_tmp[4] ;
input \data_out_tmp[3] ;
input \data_out_tmp[2] ;
input \data_out_tmp[1] ;
input \data_out_tmp[0] ;
input clk920k;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \UART_DATA[7] ;
wire \UART_DATA[6] ;
wire \UART_DATA[5] ;
wire \UART_DATA[4] ;
wire \UART_DATA[3] ;
wire \UART_DATA[2] ;
wire \UART_DATA[1] ;
wire \UART_DATA[0] ;
wire \UART_RX_inst/data_valid ;
wire \data_counter[15] ;
wire \data_counter[14] ;
wire \data_counter[13] ;
wire \data_counter[12] ;
wire \data_counter[11] ;
wire \data_counter[10] ;
wire \data_counter[9] ;
wire \data_counter[8] ;
wire \data_counter[7] ;
wire \data_counter[6] ;
wire \data_counter[5] ;
wire \data_counter[4] ;
wire \data_counter[3] ;
wire \data_counter[2] ;
wire \data_counter[1] ;
wire \data_counter[0] ;
wire \data_out[15] ;
wire \data_out[14] ;
wire \data_out[13] ;
wire \data_out[12] ;
wire \data_out[11] ;
wire \data_out[10] ;
wire \data_out[9] ;
wire \data_out[8] ;
wire \data_out[7] ;
wire \data_out[6] ;
wire \data_out[5] ;
wire \data_out[4] ;
wire \data_out[3] ;
wire \data_out[2] ;
wire \data_out[1] ;
wire \data_out[0] ;
wire \data_out_tmp[15] ;
wire \data_out_tmp[14] ;
wire \data_out_tmp[13] ;
wire \data_out_tmp[12] ;
wire \data_out_tmp[11] ;
wire \data_out_tmp[10] ;
wire \data_out_tmp[9] ;
wire \data_out_tmp[8] ;
wire \data_out_tmp[7] ;
wire \data_out_tmp[6] ;
wire \data_out_tmp[5] ;
wire \data_out_tmp[4] ;
wire \data_out_tmp[3] ;
wire \data_out_tmp[2] ;
wire \data_out_tmp[1] ;
wire \data_out_tmp[0] ;
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
    .data_i({\UART_DATA[7] ,\UART_DATA[6] ,\UART_DATA[5] ,\UART_DATA[4] ,\UART_DATA[3] ,\UART_DATA[2] ,\UART_DATA[1] ,\UART_DATA[0] ,\UART_RX_inst/data_valid ,\data_counter[15] ,\data_counter[14] ,\data_counter[13] ,\data_counter[12] ,\data_counter[11] ,\data_counter[10] ,\data_counter[9] ,\data_counter[8] ,\data_counter[7] ,\data_counter[6] ,\data_counter[5] ,\data_counter[4] ,\data_counter[3] ,\data_counter[2] ,\data_counter[1] ,\data_counter[0] ,\data_out[15] ,\data_out[14] ,\data_out[13] ,\data_out[12] ,\data_out[11] ,\data_out[10] ,\data_out[9] ,\data_out[8] ,\data_out[7] ,\data_out[6] ,\data_out[5] ,\data_out[4] ,\data_out[3] ,\data_out[2] ,\data_out[1] ,\data_out[0] ,\data_out_tmp[15] ,\data_out_tmp[14] ,\data_out_tmp[13] ,\data_out_tmp[12] ,\data_out_tmp[11] ,\data_out_tmp[10] ,\data_out_tmp[9] ,\data_out_tmp[8] ,\data_out_tmp[7] ,\data_out_tmp[6] ,\data_out_tmp[5] ,\data_out_tmp[4] ,\data_out_tmp[3] ,\data_out_tmp[2] ,\data_out_tmp[1] ,\data_out_tmp[0] }),
    .clk_i(clk920k)
);

endmodule
