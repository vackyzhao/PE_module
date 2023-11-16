/**
 * This module is the top-level module for the RISC-V ASL SoC design.
 * It instantiates the e203_soc_top module and connects the necessary inputs and outputs.
 * The module also sets the model select for the bootrom and configures the JTAG pins.
 * Additionally, it uses the LEDs for debugging purposes.
 *
 * Inputs:
 * - clk: the clock signal for the system
 * - en: the signal to enable the crystal pad generated clock
 * - rst_n: the active low reset signal for the system
 * - i_cam_data: the input data for the camera interface
 * - io_pads_jtag_TMS_i_ival: the input value for the JTAG TMS pin
 * - io_pads_jtag_TDI_i_ival: the input value for the JTAG TDI pin
 *
 * Outputs:
 * - io_pads_jtag_TDO_o_oval: the output value for the JTAG TDO pin
 * - io_pads_jtag_TDO_o_oe: the output enable signal for the JTAG TDO pin
 * - pmu_paden: the output enable signal for the PMU pad
 * - pmu_padrst: the output value for the PMU pad reset signal
 */
module riscv_asl_soc (
    input clk, //P16
    input rst_n,
    //UART_CAM
    input i_cam_data,
    //JTAG
    input io_pads_jtag_TMS_i_ival,
    input  io_pads_jtag_TDI_i_ival,
    input  io_pads_jtag_TCK_i_ival,
    output o_io_pads_jtag_TDO_o_oval,
    //result out
    output wire result_data_valid,
    output wire [4:0] result_data,    
    //power led
    output pmu_paden,
    output pmu_padrst
);

wire clk16M,clk32K,clk470K;

Gowin_PLL Gowin_PLL_inst(
        .clkout0(clk16M), //output clkout0
        .clkin(clk), //input clkin
        .reset(rst_n) //input reset
    );
clkdivider clkdivider_inst(
    .clk_in(clk16M),
    .clk_out_32k(clk32K),
    .clk_out_470k(clk470K)
);


// JTAG pins
wire io_pads_jtag_TCK_i_ival;
wire io_pads_jtag_TMS_i_ival;
wire io_pads_jtag_TDI_i_ival;
wire o_io_pads_jtag_TDO_o_oval;
wire io_pads_jtag_TDO_o_oval;
wire io_pads_jtag_TDO_o_oe;

// Set JTAG TDO output to high impedance when output is not enabled
assign o_io_pads_jtag_TDO_o_oval = (io_pads_jtag_TDO_o_oe) ? io_pads_jtag_TDO_o_oval : 1'bz;

// Use the LEDs for some more useful debugging things.
assign pmu_paden = dut_io_pads_aon_pmu_vddpaden_o_oval;
assign pmu_padrst = dut_io_pads_aon_pmu_padrst_o_oval;

// Set model select for bootrom
// 0: internal ROM (0x0000_1000)~0x0000_1FFFF
// 1: from QSPI_FLASH (0x2000_0000)
assign dut_io_pads_bootrom_n_i_ival = 1'b0;

// Set JTAG pins to be pulled up by default
assign dut_io_pads_dbgmode0_n_i_ival = 1'b1;
assign dut_io_pads_dbgmode1_n_i_ival = 1'b1;
assign dut_io_pads_dbgmode2_n_i_ival = 1'b1;

// Instantiate e203_soc_top module and connect inputs and outputs
e203_soc_top e203_soc_top_inst(
    // This clock should comes from the crystal pad generated high speed clock (16MHz)
    .hfextclk(clk16M),//16M
    .hfxoscen(),// The signal to enable the crystal pad generated clock

    // This clock should comes from the crystal pad generated low speed clock (32.768KHz)
    .lfextclk(clk32K),//32767K
    .lfxoscen(),// The signal to enable the crystal pad generated clock

    .i_cam_data(i_cam_data),
    .result_data(result_data),
    .result_data_valid(result_data_valid),
    .cam_clk(clk470K), 

    // The JTAG TCK is input, need to be pull-up
    .io_pads_jtag_TCK_i_ival(io_pads_jtag_TCK_i_ival),

    // The JTAG TMS is input, need to be pull-up
    .io_pads_jtag_TMS_i_ival(io_pads_jtag_TMS_i_ival),

    // The JTAG TDI is input, need to be pull-up
    .io_pads_jtag_TDI_i_ival(io_pads_jtag_TDI_i_ival),

    // The JTAG TDO is output have enable
    .io_pads_jtag_TDO_o_oval(io_pads_jtag_TDO_o_oval),
    .io_pads_jtag_TDO_o_oe(io_pads_jtag_TDO_o_oe),

    // The GPIO are all bidir pad have enables
    .io_pads_gpioA_i_ival(),
    .io_pads_gpioA_o_oval(),
    .io_pads_gpioA_o_oe(),

    .io_pads_gpioB_i_ival(),
    .io_pads_gpioB_o_oval(),
    .io_pads_gpioB_o_oe(),

    // QSPI0 SCK and CS is output without enable
    .io_pads_qspi0_sck_o_oval(),
    .io_pads_qspi0_cs_0_o_oval(),

    // QSPI0 DQ is bidir I/O with enable, and need pull-up enable
    .io_pads_qspi0_dq_0_i_ival(),
    .io_pads_qspi0_dq_0_o_oval(),
    .io_pads_qspi0_dq_0_o_oe(),
    .io_pads_qspi0_dq_1_i_ival(),
    .io_pads_qspi0_dq_1_o_oval(),
    .io_pads_qspi0_dq_1_o_oe(),
    .io_pads_qspi0_dq_2_i_ival(),
    .io_pads_qspi0_dq_2_o_oval(),
    .io_pads_qspi0_dq_2_o_oe(),
    .io_pads_qspi0_dq_3_i_ival(),
    .io_pads_qspi0_dq_3_o_oval(),
    .io_pads_qspi0_dq_3_o_oe(),

    // Erst is input need to be pull-up by default
    .io_pads_aon_erst_n_i_ival(rst_n),

    // dbgmode are inputs need to be pull-up by default
    .io_pads_dbgmode0_n_i_ival(1'b1),
    .io_pads_dbgmode1_n_i_ival(1'b1),
    .io_pads_dbgmode2_n_i_ival(1'b1),

    // BootRom is input need to be pull-up by default
    .io_pads_bootrom_n_i_ival(dut_io_pads_bootrom_n_i_ival),

    // dwakeup is input need to be pull-up by default
    .io_pads_aon_pmu_dwakeup_n_i_ival(1'b1),

    // PMU output is just output without enable
    .io_pads_aon_pmu_padrst_o_oval(dut_io_pads_aon_pmu_padrst_o_oval),
    .io_pads_aon_pmu_vddpaden_o_oval (dut_io_pads_aon_pmu_vddpaden_o_oval)
);

endmodule