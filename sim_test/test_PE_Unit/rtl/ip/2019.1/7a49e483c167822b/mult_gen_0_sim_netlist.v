// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Thu Oct  5 17:02:18 2023
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

  (* C_A_TYPE = "1" *) 
  (* C_A_WIDTH = "8" *) 
  (* C_B_TYPE = "1" *) 
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

(* C_A_TYPE = "1" *) (* C_A_WIDTH = "8" *) (* C_B_TYPE = "1" *) 
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
  (* C_A_TYPE = "1" *) 
  (* C_A_WIDTH = "8" *) 
  (* C_B_TYPE = "1" *) 
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
K8ETaIDhmEyCliljy1y5HYf9h7wE3k0cj5laopUB/GEaSIXJSs1+tJ8pf6Wx5QP5lsU7Vk3GVA11
6fiPxLcuEjXGLFy6VqMLQW7nWF6qZvRVsL4V5XOFJvQTRI0gYTJSiRdfMUXKIx05C3YMw9I68mxU
f9RKYsaXWZtOTFMQZsxlJb9QGR7cJuq6hGs6mnlglULMu11iZndGpHTX9rfcE6erkRnqLuE9qmJf
MdBSjsSiViWwcSV9GSG3AzdyrTM3uujWmvUuI3D9jDeP9Rq5D0B369w22Y5HfBQndEvxvBgbnJ0K
ZZRCZsQ8wqRMSCXnXxmFs+jHMLbcpooWI0x9OQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PUjByCLwAlejjHWasmMSU4WCJYsXJmqGI8t2pBvkBV6NwBelj2ctz9VeYfgFwrLbxHfEuZ8ie1qr
f+a/R06y+doqIlOTciFNcNsGLu3Fn1flBga61/ZbJ5BeFkei+WOY1A3oJjPnZCDLoeK0nMJNzYTk
tXX5c96FB0xChF7BF2+YHD/hSIvapXtWhEWClWxfZdRzKxwGsIRvB/8rZhvF9Aq/vg4V0zbQu/yt
OA+YuXmJaB67eTMJjWDnlhJrLgZUy76MTXvEqxgAKA5ciX785l3zr3e/7fxBZWI7jsTsjFtVfOsi
aUUatoRWJub2STlUPDLXcA209ptpdYmSuh2U6w==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 37008)
`pragma protect data_block
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
rXfgpSsLt/RTA8qyeNFy
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
