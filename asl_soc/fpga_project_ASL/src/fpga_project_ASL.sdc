//Copyright (C)2014-2023 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: V1.9.9 Beta-5
//Created Time: 2023-11-16 09:11:07
create_clock -name clk32k -period 31250 -waveform {0 15625} [get_nets {clk_out_32k_3}] -add
create_clock -name clk470k -period 2127.66 -waveform {0 1063.83} [get_nets {clk_out_470k_3}] -add
create_clock -name clk16M -period 62.5 -waveform {0 31.25} [get_nets {clk16M}] -add
