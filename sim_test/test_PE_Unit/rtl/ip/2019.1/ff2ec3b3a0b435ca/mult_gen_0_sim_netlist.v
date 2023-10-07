// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Fri Oct  6 10:25:52 2023
// Host        : IC_EDA running 64-bit CentOS Linux release 7.9.2009 (Core)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ mult_gen_0_sim_netlist.v
// Design      : mult_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k70tfbv676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mult_gen_0,mult_gen_v12_0_15,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_15,Vivado 2019.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (CLK,
    A,
    B,
    CE,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:b_intf:a_intf, ASSOCIATED_RESET sclr, ASSOCIATED_CLKEN ce, FREQ_HZ 10000000, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [7:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [3:0]B;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) (* x_interface_parameter = "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_LOW" *) input CE;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [11:0]P;

  wire [7:0]A;
  wire [3:0]B;
  wire CE;
  wire CLK;
  wire [11:0]P;
  wire [47:0]NLW_U0_PCASC_UNCONNECTED;
  wire [1:0]NLW_U0_ZERO_DETECT_UNCONNECTED;

  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "8" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "4" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "2" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "0" *) 
  (* C_OUT_HIGH = "11" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "kintex7" *) 
  (* c_optimize_goal = "1" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_mult_gen_v12_0_15 U0
       (.A(A),
        .B(B),
        .CE(CE),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule

(* C_A_TYPE = "0" *) (* C_A_WIDTH = "8" *) (* C_B_TYPE = "0" *) 
(* C_B_VALUE = "10000001" *) (* C_B_WIDTH = "4" *) (* C_CCM_IMP = "0" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_HAS_CE = "1" *) (* C_HAS_SCLR = "0" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "2" *) (* C_MODEL_TYPE = "0" *) 
(* C_MULT_TYPE = "0" *) (* C_OPTIMIZE_GOAL = "1" *) (* C_OUT_HIGH = "11" *) 
(* C_OUT_LOW = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "kintex7" *) (* downgradeipidentifiedwarnings = "yes" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_mult_gen_v12_0_15
   (CLK,
    A,
    B,
    CE,
    SCLR,
    ZERO_DETECT,
    P,
    PCASC);
  input CLK;
  input [7:0]A;
  input [3:0]B;
  input CE;
  input SCLR;
  output [1:0]ZERO_DETECT;
  output [11:0]P;
  output [47:0]PCASC;

  wire \<const0> ;
  wire [7:0]A;
  wire [3:0]B;
  wire CE;
  wire CLK;
  wire [11:0]P;
  wire [47:0]NLW_i_mult_PCASC_UNCONNECTED;
  wire [1:0]NLW_i_mult_ZERO_DETECT_UNCONNECTED;

  assign PCASC[47] = \<const0> ;
  assign PCASC[46] = \<const0> ;
  assign PCASC[45] = \<const0> ;
  assign PCASC[44] = \<const0> ;
  assign PCASC[43] = \<const0> ;
  assign PCASC[42] = \<const0> ;
  assign PCASC[41] = \<const0> ;
  assign PCASC[40] = \<const0> ;
  assign PCASC[39] = \<const0> ;
  assign PCASC[38] = \<const0> ;
  assign PCASC[37] = \<const0> ;
  assign PCASC[36] = \<const0> ;
  assign PCASC[35] = \<const0> ;
  assign PCASC[34] = \<const0> ;
  assign PCASC[33] = \<const0> ;
  assign PCASC[32] = \<const0> ;
  assign PCASC[31] = \<const0> ;
  assign PCASC[30] = \<const0> ;
  assign PCASC[29] = \<const0> ;
  assign PCASC[28] = \<const0> ;
  assign PCASC[27] = \<const0> ;
  assign PCASC[26] = \<const0> ;
  assign PCASC[25] = \<const0> ;
  assign PCASC[24] = \<const0> ;
  assign PCASC[23] = \<const0> ;
  assign PCASC[22] = \<const0> ;
  assign PCASC[21] = \<const0> ;
  assign PCASC[20] = \<const0> ;
  assign PCASC[19] = \<const0> ;
  assign PCASC[18] = \<const0> ;
  assign PCASC[17] = \<const0> ;
  assign PCASC[16] = \<const0> ;
  assign PCASC[15] = \<const0> ;
  assign PCASC[14] = \<const0> ;
  assign PCASC[13] = \<const0> ;
  assign PCASC[12] = \<const0> ;
  assign PCASC[11] = \<const0> ;
  assign PCASC[10] = \<const0> ;
  assign PCASC[9] = \<const0> ;
  assign PCASC[8] = \<const0> ;
  assign PCASC[7] = \<const0> ;
  assign PCASC[6] = \<const0> ;
  assign PCASC[5] = \<const0> ;
  assign PCASC[4] = \<const0> ;
  assign PCASC[3] = \<const0> ;
  assign PCASC[2] = \<const0> ;
  assign PCASC[1] = \<const0> ;
  assign PCASC[0] = \<const0> ;
  assign ZERO_DETECT[1] = \<const0> ;
  assign ZERO_DETECT[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "8" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "4" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "2" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "0" *) 
  (* C_OUT_HIGH = "11" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "kintex7" *) 
  (* c_optimize_goal = "1" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_mult_gen_v12_0_15_viv i_mult
       (.A(A),
        .B(B),
        .CE(CE),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_i_mult_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_i_mult_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2019.1"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
KGg++J83s0yJ7o2/XMVLkRRTRjS0oC9h86tQjl1+xE1m53Uwmm0+K41skiYHo3Urr6lMQ4q2jL5Y
R/1NOu1WGg==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jCBx8aLaNWpgdwu0tsffQfmLNKET4Uy44Upxw9AlkO9Ma9Y+tqZHrHroYhGJUxa/dyJZ7Z0HDJ1t
hUhVV6SjuhVMs1NLM1MVw9F3MTSW7MB/qx7j0WAj62FJgoxsCtt6g392p1JAAosX8yACeLKiQ0KF
mnMpugzqSRDI445k7So=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
zdO8kU0uCj5Mggk0oLUcYcllNQJVD7vxIj25evesPPwBvXuv6EUsbKmUaCAlFUyG0YQ0mxWxXmzV
V/dRqKxqZ1ZI8+mX4IFaTJSCcYctMZsCl+2EWvQQHakV4QzWuCyca1phNacrRJfur8Ssc/Mhbez3
GLQCRrSfyBYyi3u9J+SAJRcJapyB1syXXhclDtup6m1z2C5S+NX/ql6kVXkcd9P+C5ordunfutgU
6uco8UymF/9QFYiBCWlTkHAgd7DH3dCI1E72N2H/KpX0/0xFBk++NCVuNucOwd9h4/hAyr4L+SI0
6Dzmn6kaBO4lnMAj5P58GIeWO/EtqrPeWg4UJw==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
FdbUT4bIXyyFULrG0eEn0kqX6tjVoWssNb1FURO5jvyN5IkvkkDKCSLsd4J+2RE35ttJ20+4IZm2
p3H/UGCxkuCYtlZzovVpVf93DlhFUM2iSGd/L3evdLLL8VYETZTScGFdFXqiqe4ggXPHQCSEPD+e
PmMIJTGQka0DD3H+w+9t5Po/+M8b4r1y70l3Py7aYMeCEsZ/yHRmk8szsOjUbwvFEJk8SPXrEERg
EYMIrbryPHXq5E2fCL7hTgHa+bzIdFQOc2/8wn8YMVTmIJCZLBZDXvGSSm16cifWzXKHbPSly8js
RAoD2yYva4rr9cUy8jEyEpUcPGnaJXBDnB7lsQ==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_02", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
eGYl/A3vBqVYodgklvBXVlduDkQKDOe941//b/7D71XaDbW1Cqv7m5eqy+I7bUTyBfnKRV6WeTtg
K2eZlSMADPLNGmIEawb1T81kHA95L4SgxCaMDbzt0t5pO+IQTca0KxjvPFPjj860AZ/Y4IJCgD9Z
vZNfcSeez7bqGB9kVNzxh40hdeBm7XY8a+5R/yPufF2S8KSSaiPSvYwD8yXOBzVoRhqA9q5PWKTd
u6qoeWMnQ1r/hIDsge5oDE06b6+zC7odC460K8KIOtKzeCrfWezkynmD7wBR1fdIwh9FGe2Uq4lO
ZbT2QFx8Ga5NQIwIIZZci/uL4Tw/7+CPKEoddw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
k1GN+kT7KgRIHJs5Cw+hQb7EZrReCsvXgXeCjz4o0RyqpPm8XlxoPCNX4kR8BSaVxBTPm8qGrOj8
IkQcLP4XpLGNjMzOE8knGvgjraCBhhY/bboSihIYbJYXuKW0k/ErxcqbMup3dsmp8N5M+ZYpiEuF
88HraBjchDshDh5xlcY=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
jzBUDUoUQBD0tzi9B/VXNwpoyjUIKBzxkVyikkxc/QHKpaIlgud+eCQD6psG9RUWZouQN8CQmJEY
0K5qgvfm7GxXMbjLUwnVBRg4Uzfc4OTySfJMu1k9/qGISvYwf4r0rzMMp9aPgp+ElEwTGx3z9N0A
vWNdEjCI2mqdxmP3Q9AYUPTudILppELRMP4SJijczuRIhtAKpxFjTP2gL8zQE0aq1kkWRZfaHW1t
wV7tZ/jCUxkX8uj8DL6Bei6oBC1nTm/FjPhi+htKla8XNUEftaqUre2/0Sxhsxl/FTAzaex9fCj4
AMt2l6o0FpW5JlLhGnTYhWm/bgsyGCPBg6lSjQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
eYt662dKIQD+5AbKfjiA5UK6rEX0Hjzdm0p94FsVDWvDezgtpvmJZ1JQiZDNgiTvTdDIVYyXCkc2
SgBCHLQI9or6VKNC9Psb6DoSFkNOuHJc15qssVLuEncr297RQlqgqgJ+qJ81Wolj6hI1St3mgnvI
c1pP0uiTVp63algLxIrJ1h/5L4eqmeIN843LXdE3lDmLB35QhqbI/ptFnL9dHfEPn611BeTMfkaZ
oOnFTxB1sww1mqXMBn8ot936ZbdB1kI/WCfYE1kDrf3K+aoYmWrT2YxRQsrLeN50B9riacutPPFk
5LBf2YL+Pn5ut1YpznfVSwY4dVDGg/44BayI5A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
5zNebWtUhwqu2S5V7A7wpLIqgEQY+RYp3dom1dUHTBVCfBYj/kI0QPOVE1EF+EZqblKnNXXtrKWT
rlXNWsWpvpmBcJ66Qz8lwgemABMfycsieaNCvZ+XiNEJlVAZrksYyu3ftOq1suJEIOsLK1NEMIhf
AsYUrPISJ2WkRjBUog2fv2SyfczgXFw3TRDELpuG4DinwYsxFi1607cIQ0WcSaok+UIlq9NgS+pO
oI7xk1vmUwFkgTpmmHM0+N+h9sVPl8evDW5WzlpHoi4nMGwVapPwifvC+U1yVyDFL3oIyaw2un+4
9f/qnDF23nYfm4v4mGWeRfLkj6OwMAfk3fWHcg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 39408)
`pragma protect data_block
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
e+9UCY058WYOTUGraZg+VCk2zueK
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
