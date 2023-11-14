/* common_memcomp Version: 4.0.5-beta22 */
/* lang compiler Version: 4.1.6-beta1 Jul 19 2012 13:55:19 */
//
//       CONFIDENTIAL AND PROPRIETARY SOFTWARE OF ARM PHYSICAL IP, INC.
//      
//       Copyright (c) 1993 - 2022 ARM Physical IP, Inc.  All Rights Reserved.
//      
//       Use of this Software is subject to the terms and conditions of the
//       applicable license agreement with ARM Physical IP, Inc.
//       In addition, this Software is protected by patents, copyright law 
//       and international treaties.
//      
//       The copyright notice(s) in this Software does not indicate actual or
//       intended publication of this Software.
//
//       Repair Verilog RTL for Synchronous Single-Port Register File
//
//       Instance Name:              RAMSP1024X16_rtl_top
//       Words:                      1024
//       User Bits:                  16
//       Mux:                        4
//       Drive:                      6
//       Write Mask:                 On
//       Extra Margin Adjustment:    On
//       Redundancy:                 off
//       Redundant Rows:             0
//       Redundant Columns:          0
//       Test Muxes                  Off
//       Ser:                        none
//       Retention:                  on
//       Power Gating:               off
//
//       Creation Date:  Wed Sep 14 09:51:17 2022
//       Version:      r1p1
//
//       Verified
//
//       Known Bugs: None.
//
//       Known Work Arounds: N/A
//
`timescale 1ns/1ps

module RAMSP1024X16_rtl_top (
          Q, 
          CLK, 
          CEN, 
          WEN, 
          A, 
          D, 
          EMA, 
          EMAW, 
          GWEN, 
          RET1N
   );

   output [15:0]            Q;
   input                    CLK;
   input                    CEN;
   input [15:0]             WEN;
   input [9:0]              A;
   input [15:0]             D;
   input [2:0]              EMA;
   input [1:0]              EMAW;
   input                    GWEN;
   input                    RET1N;
   wire [15:0]             DI;
   wire [15:0]             QO;

   assign Q = QO;
   assign DI = D;
   RAMSP1024X16_fr_top u0 (
         .QO(QO),
         .CLK(CLK),
         .CEN(CEN),
         .WEN(WEN),
         .A(A),
         .DI(DI),
         .EMA(EMA),
         .EMAW(EMAW),
         .GWEN(GWEN),
         .RET1N(RET1N)
);

endmodule

module RAMSP1024X16_fr_top (
          QO, 
          CLK, 
          CEN, 
          WEN, 
          A, 
          DI, 
          EMA, 
          EMAW, 
          GWEN, 
          RET1N
   );

   output [15:0]            QO;
   input                    CLK;
   input                    CEN;
   input [15:0]             WEN;
   input [9:0]              A;
   input [15:0]             DI;
   input [2:0]              EMA;
   input [1:0]              EMAW;
   input                    GWEN;
   input                    RET1N;

   wire [15:0]    D;
   wire [15:0]    Q;

   assign D=DI;
   assign QO=Q;
   RAMSP1024X16 u0 (
         .Q(Q),
         .CLK(CLK),
         .CEN(CEN),
         .WEN(WEN),
         .A(A),
         .D(D),
         .EMA(EMA),
         .EMAW(EMAW),
         .GWEN(GWEN),
         .RET1N(RET1N)
   );

endmodule // RAMSP1024X16_fr_top

