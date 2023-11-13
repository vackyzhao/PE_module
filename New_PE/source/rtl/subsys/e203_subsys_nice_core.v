/*                                                                      
 Copyright 2018-2020 Nuclei System Technology, Inc.                
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
  Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */

//=====================================================================
//
// Designer   : LZB
//
// Description:
//  The Module to realize a simple NICE core
//
// ====================================================================
`include "../core/e203_defines.v"


module e203_subsys_nice_core (
    // System	
    input                         nice_clk             ,
    input                         nice_rst_n	          ,
    output                        nice_active	      ,
    output                        nice_mem_holdup	  ,
//    output                        nice_rsp_err_irq	  ,
    // Control cmd_req
    input                         nice_req_valid       ,
    output                        nice_req_ready       ,
    input  [`E203_XLEN-1:0]       nice_req_inst        ,
    input  [`E203_XLEN-1:0]       nice_req_rs1         ,
    input  [`E203_XLEN-1:0]       nice_req_rs2         ,
    // Control cmd_rsp	
    output                        nice_rsp_valid       ,
    input                         nice_rsp_ready       ,
    output [`E203_XLEN-1:0]       nice_rsp_rdat        ,
    output                        nice_rsp_err    	  ,
    // Memory lsu_req	
    output                        nice_icb_cmd_valid   ,
    input                         nice_icb_cmd_ready   ,
    output [`E203_ADDR_SIZE-1:0]  nice_icb_cmd_addr    ,
    output                        nice_icb_cmd_read    ,
    output [`E203_XLEN-1:0]       nice_icb_cmd_wdata   ,
//    output [`E203_XLEN_MW-1:0]     nice_icb_cmd_wmask   ,  // 
    output [1:0]                  nice_icb_cmd_size    ,
    // Memory lsu_rsp	
    input                         nice_icb_rsp_valid   ,
    output                        nice_icb_rsp_ready   ,
    input  [`E203_XLEN-1:0]       nice_icb_rsp_rdata   ,
    input                         nice_icb_rsp_err	

);

   //   localparam PIPE_NUM = 3;


// here we only use custom3: 
// CUSTOM0 = 7'h0b, R type
// CUSTOM1 = 7'h2b, R tpye
// CUSTOM2 = 7'h5b, R type
// CUSTOM3 = 7'h7b, R type

// RISC-V format  
//	.insn r  0x33,  0,  0, a0, a1, a2       0:  00c58533[ 	]+add [ 	]+a0,a1,a2
//	.insn i  0x13,  0, a0, a1, 13           4:  00d58513[ 	]+addi[ 	]+a0,a1,13
//	.insn i  0x67,  0, a0, 10(a1)           8:  00a58567[ 	]+jalr[ 	]+a0,10 (a1)
//	.insn s   0x3,  0, a0, 4(a1)            c:  00458503[ 	]+lb  [ 	]+a0,4(a1)
//	.insn sb 0x63,  0, a0, a1, target       10: feb508e3[ 	]+beq [ 	]+a0,a1,0 target
//	.insn sb 0x23,  0, a0, 4(a1)            14: 00a58223[ 	]+sb  [ 	]+a0,4(a1)
//	.insn u  0x37, a0, 0xfff                18: 00fff537[ 	]+lui [ 	]+a0,0xfff
//	.insn uj 0x6f, a0, target               1c: fe5ff56f[ 	]+jal [ 	]+a0,0 target
//	.insn ci 0x1, 0x0, a0, 4                20: 0511    [ 	]+addi[ 	]+a0,a0,4
//	.insn cr 0x2, 0x8, a0, a1               22: 852e    [ 	]+mv  [ 	]+a0,a1
//	.insn ciw 0x0, 0x0, a1, 1               24: 002c    [ 	]+addi[ 	]+a1,sp,8
//	.insn cb 0x1, 0x6, a1, target           26: dde9    [ 	]+beqz[ 	]+a1,0 target
//	.insn cj 0x1, 0x5, target               28: bfe1    [ 	]+j   [ 	]+0 targe

   ////////////////////////////////////////////////////////////
   // decode
   ////////////////////////////////////////////////////////////
   wire [6:0] opcode      = {7{nice_req_valid}} & nice_req_inst[6:0];
   wire [2:0] rv32_func3  = {3{nice_req_valid}} & nice_req_inst[14:12];
   wire [6:0] rv32_func7  = {7{nice_req_valid}} & nice_req_inst[31:25];
wire [4:0] rs2 = {5{nice_req_valid}} & nice_req_inst[24:20];
   wire [4:0] rs1 = {5{nice_req_valid}} & nice_req_inst[19:15];
   wire [4:0] rd = {5{nice_req_valid}} & nice_req_inst[11:7];

   

//   wire opcode_custom0 = (opcode == 7'b0001011); 
//   wire opcode_custom1 = (opcode == 7'b0101011); 
//   wire opcode_custom2 = (opcode == 7'b1011011); 
   wire opcode_custom3 = (opcode == 7'b1111011); 

   wire rv32_func3_000 = (rv32_func3 == 3'b000); 
   wire rv32_func3_001 = (rv32_func3 == 3'b001); 
   wire rv32_func3_010 = (rv32_func3 == 3'b010); 
   wire rv32_func3_011 = (rv32_func3 == 3'b011); 
   wire rv32_func3_100 = (rv32_func3 == 3'b100); 
   wire rv32_func3_101 = (rv32_func3 == 3'b101); 
   wire rv32_func3_110 = (rv32_func3 == 3'b110); 
   wire rv32_func3_111 = (rv32_func3 == 3'b111); 

   wire rv32_func7_0000000 = (rv32_func7 == 7'b0000000); 
   wire rv32_func7_0000001 = (rv32_func7 == 7'b0000001); 
   wire rv32_func7_0000010 = (rv32_func7 == 7'b0000010); 
   wire rv32_func7_0000011 = (rv32_func7 == 7'b0000011); 
   wire rv32_func7_0000100 = (rv32_func7 == 7'b0000100); 
   wire rv32_func7_0000101 = (rv32_func7 == 7'b0000101); 
   wire rv32_func7_0000110 = (rv32_func7 == 7'b0000110); 
   wire rv32_func7_0000111 = (rv32_func7 == 7'b0000111); 

   ////////////////////////////////////////////////////////////
   // custom3:
   // Supported format: only R type here
   // Supported instr:
   //  1. custom3 lbuf: load data(in memory) to row_buf
   //     lbuf (a1)
   //     .insn r opcode, func3, func7, rd, rs1, rs2    
   //  2. custom3 sbuf: store data(in row_buf) to memory
   //     sbuf (a1)
   //     .insn r opcode, func3, func7, rd, rs1, rs2    
   //  3. custom3 acc rowsum: load data from memory(@a1), accumulate row datas and write back 
   //     rowsum rd, a1, x0
   //     .insn r opcode, func3, func7, rd, rs1, rs2    
   ////////////////////////////////////////////////////////////
   wire custom3_rdstat     = opcode_custom3 & rv32_func3_110 & rv32_func7_0000001; 
   wire custom3_start     = opcode_custom3 & rv32_func3_111 & rv32_func7_0000010; 
   wire custom3_ldbuf   = opcode_custom3 & rv32_func3_110 & rv32_func7_0000100; 
   ////////////////////////////////////////////////////////////
   //  multi-cyc op 
   ////////////////////////////////////////////////////////////
   wire custom_multi_cyc_op = custom3_rdstat | custom3_start | custom3_ldbuf;
   // need access memory
   wire custom_mem_op = custom3_ldbuf;
   // need return value
   wire custom_ret_op = custom3_rdstat | custom3_start | custom3_ldbuf;
   
   ////////////////////////////////////////////////////////////
   //  rs register 
   ////////////////////////////////////////////////////////////
 
    wire [`E203_XLEN-1:0] rs1_r;
    wire rs1_ena, rs1_rst_n;
    sirv_gnrl_dfflr #(`E203_XLEN)   rs1_dfflr (rs1_ena, nice_req_rs1, rs1_r, nice_clk, rs1_rst_n);
    assign rs1_ena = nice_req_valid;
    assign rs1_rst_n = nice_rst_n;
    wire [`E203_XLEN-1:0] rs2_r;
    wire rs2_ena, rs2_rst_n;
    sirv_gnrl_dfflr #(`E203_XLEN)   rs2_dfflr (rs2_ena, nice_req_rs2, rs2_r, nice_clk, rs2_rst_n);
    assign rs2_ena = nice_req_valid;
    assign rs2_rst_n = nice_rst_n;

//bleow is the index of rs1,rs2,rd, in my program, they stand for number of kernel in layer1,2,3.

    wire [4:0] index_rs1;
    sirv_gnrl_dfflr #(`E203_XLEN)   index_rs1_dfflr (nice_req_valid, rs1, index_rs1, nice_clk, nice_rst_n);
    wire [4:0] index_rs2;
    sirv_gnrl_dfflr #(`E203_XLEN)   index_rs2_dfflr (nice_req_valid, rs2, index_rs2, nice_clk, nice_rst_n);
    wire [4:0] index_rd;
    sirv_gnrl_dfflr #(`E203_XLEN)   index_rd_dfflr (nice_req_valid, rd,  index_rd, nice_clk, nice_rst_n);
 
   ////////////////////////////////////////////////////////////
   // NICE FSM 
   ////////////////////////////////////////////////////////////
   parameter NICE_FSM_WIDTH = 3; 
   parameter IDLE          = 3'b000; 
   parameter RDSTAT        = 3'b100; 
   parameter START         = 3'b001; 
   parameter LDBUF         = 3'b010; 

   wire [NICE_FSM_WIDTH-1:0] state_r; 
   wire [NICE_FSM_WIDTH-1:0] nxt_state; 
   wire [NICE_FSM_WIDTH-1:0] state_idle_nxt; 
   wire [NICE_FSM_WIDTH-1:0] state_rdstat_nxt; 
   wire [NICE_FSM_WIDTH-1:0] state_start_nxt; 
   wire [NICE_FSM_WIDTH-1:0] state_ldbuf_nxt; 

   wire nice_req_hsked;
   wire nice_rsp_hsked;
   wire nice_icb_rsp_hsked;
   wire illgel_instr = ~(custom_multi_cyc_op);

   wire state_idle_exit_ena; 
   wire state_rdstat_exit_ena; 
   wire state_start_exit_ena; 
   wire state_ldbuf_exit_ena; 

   wire state_ena; 

   wire state_is_idle       = (state_r == IDLE); 
   wire state_is_rdstat     = (state_r == RDSTAT); 
   wire state_is_start      = (state_r == START); 
   wire state_is_ldbuf      = (state_r == LDBUF); 

   assign state_idle_exit_ena = state_is_idle & nice_req_hsked & ~illgel_instr; 
   assign state_idle_nxt =  custom3_rdstat    ? RDSTAT   : 
                            custom3_start     ? START    :
                            custom3_ldbuf     ? LDBUF    :
			    IDLE;

   wire rdstat_done; 
   assign state_rdstat_exit_ena = state_is_rdstat & rdstat_done; 
   assign state_rdstat_nxt = IDLE;

   wire start_done; 
   assign state_start_exit_ena = state_is_start & start_done; 
   assign state_start_nxt = IDLE;

   wire ldbuf_done; 
   assign state_ldbuf_exit_ena = state_is_ldbuf & ldbuf_done; 
   assign state_ldbuf_nxt = IDLE;

   assign nxt_state =   ({NICE_FSM_WIDTH{state_idle_exit_ena    }} & state_idle_nxt    )
                      | ({NICE_FSM_WIDTH{state_rdstat_exit_ena  }} & state_rdstat_nxt  ) 
                      | ({NICE_FSM_WIDTH{state_start_exit_ena   }} & state_start_nxt   ) 
                      | ({NICE_FSM_WIDTH{state_ldbuf_exit_ena   }} & state_ldbuf_nxt   ) 
                      ;

   assign state_ena =   state_idle_exit_ena | state_rdstat_exit_ena 
                      | state_start_exit_ena | state_ldbuf_exit_ena;

   sirv_gnrl_dfflr #(NICE_FSM_WIDTH)   state_dfflr (state_ena, nxt_state, state_r, nice_clk, nice_rst_n);

   ////////////////////////////////////////////////////////////
   // instr EXU
   ////////////////////////////////////////////////////////////
   
   //wire [COL_IDX_W-1:0]  rownum;

   //////////// 1. custom3_rdstat////////////////////////////////////////////////////////
   //////////////////////////////////////////////////////////////////////////////////////
 //  wire [`E203_XLEN-1:0] u42a_data;
     wire [`E203_XLEN-1:0] sigma_dp_data;
   //  wire u42a_data_valid;
   wire sigma_dp_data_valid;
     
    // wire [`E203_XLEN-1:0] u42a_r, u42a_nxt;
    // wire u42a_ena, u42a_rst_n;
//    sirv_gnrl_dfflr #(`E203_XLEN)   u42a_dfflr (u42a_ena, u42a_nxt, u42a_r, nice_clk, u42a_rst_n);
   wire [`E203_XLEN-1:0] sigma_r, sigma_nxt;
   wire sigma_ena, sigma_rst_n;
   sirv_gnrl_dfflr #(`E203_XLEN)   sigma_dfflr (sigma_ena, sigma_nxt, sigma_r, nice_clk, sigma_rst_n);
//    wire u42a_status_r;
//    wire u42a_status_ena, u42a_status_rst_n;
//    sirv_gnrl_dfflr #(1)   u42a_status_dfflr (u42a_status_ena, 1'b1, u42a_status_r, nice_clk, u42a_status_rst_n);
   wire sigma_status_r;
   wire sigma_status_ena, sigma_status_rst_n;
   sirv_gnrl_dfflr #(1)   sigma_status_dfflr (sigma_status_ena, 1'b1, sigma_status_r, nice_clk, sigma_status_rst_n);
   wire busy_status_r;
   wire busy_status_ena, busy_status_rst_n;
   sirv_gnrl_dfflr #(1)   busy_status_dfflr (busy_status_ena, 1'b1, busy_status_r, nice_clk, busy_status_rst_n);

   wire [`E203_XLEN-1:0] rdstat_res;
   wire nice_rsp_valid_rdstat;
   assign rdstat_res = state_is_rdstat ? (rs1_r==32'h0000_0000) ? {30'b0,sigma_status_r,busy_status_r} 
                                       : (rs1_r==32'h0000_0001) ? sigma_r
                                       : 32'b0
                                   :32'b0;
   assign nice_rsp_valid_rdstat = state_is_rdstat;
   assign rdstat_done = state_is_rdstat & nice_rsp_hsked;

//   assign u42a_ena = u42a_data_valid;
    assign sigma_ena = sigma_dp_data_valid;
//   assign u42a_status_ena = u42a_data_valid;
    assign sigma_status_ena = sigma_dp_data_valid;
//  assign u42a_status_rst_n = nice_rst_n & ~(state_is_start | state_is_ldbuf);
    assign sigma_status_rst_n = nice_rst_n & ~(state_is_start | state_is_ldbuf);
//   assign u42a_nxt = u42a_data;
    assign sigma_nxt = sigma_dp_data;




   //////////// 2. custom3_start /////////////////////////////////////////////////////////
   //////////////////////////////////////////////////////////////////////////////////////

   wire [`E203_XLEN-1:0] start_res;
   wire nice_rsp_valid_start;
   wire mrt_rstn;


   wire mrt_rstn_ena, mrt_rstn_rst_n;
   sirv_gnrl_dfflr #(1)   mrt_rstn_dfflr (mrt_rstn_ena, 1'b1, mrt_rstn, nice_clk, mrt_rstn_rst_n);
   assign mrt_rstn_ena = state_is_start & ~busy_status_r;
//   assign u42a_rst_n = nice_rst_n;
   assign sigma_rst_n = nice_rst_n;
   assign mrt_rstn_rst_n = (~sigma_dp_data_valid) & nice_rst_n;
   assign start_res = {31'b0,mrt_rstn};    
   assign nice_rsp_valid_start = state_is_start ? mrt_rstn : 0;
   assign start_done = state_is_start & nice_rsp_hsked;




   //////// Core
//       MRT_wrapper u_mrt(
//       .i_clk                  (nice_clk),
//       .i_rstn                 (mrt_rstn),
//       .i_ena                  (u_mrt_ena),
//       .i_wen                  (u_mrt_wen),
//       .i_cfg_data             (u_mrt_cfg_data),
//       .i_cfg_i                (u_mrt_cfg_i),
//       .i_cfg_addr             (u_mrt_cfg_addr),
//       .u42a_data              (u42a_data),
//       .u42a_data_valid        (u42a_data_valid),
//       .sigma_dp_data          (sigma_dp_data),
//       .sigma_dp_data_valid    (sigma_dp_data_valid)
//        );
    


    
///////////////////////////////////////////////////////////////////////////////below is my mnist module
wire ldbuf_load_done; 
    wire mnist_ready;
    //img signal
//    wire [7:0] fm_data;
//    wire fm_data_valid;
//assign fm_data = 0;
//assign fm_data_valid = 0;

    wire [3:0] result_data;
    wire result_data_valid;
assign sigma_dp_data = {28'b0,result_data};
assign sigma_dp_data_valid = result_data_valid;


    wire [15:0] sram_addr;
    wire [31:0] sram_data;


reg mnist_start_ff1;
reg mnist_start_ff2;
reg mnist_rst_n;
   wire mnist_start;

wire mnist_dma_finish;
   wire mnist_dma_finish_posedge;

reg mnist_dma_finish_ff1;
reg mnist_dma_finish_ff2;
assign mnist_dma_finish_posedge = mnist_dma_finish_ff1&(~mnist_dma_finish_ff2);
//generate state singal
always @(posedge nice_clk) begin
    if (!nice_rst_n) begin
        mnist_start_ff1 <= 0;
        mnist_start_ff2 <= 0;
        mnist_dma_finish_ff1 <= 0;
        mnist_dma_finish_ff2 <= 0;
        mnist_rst_n <= 0;
    end else begin
        if(ldbuf_load_done == 1) begin
            mnist_rst_n <=1;
        end else begin
            mnist_rst_n <= mnist_rst_n;
        end
        if(mnist_dma_finish) begin
            mnist_dma_finish_ff1 <=1;
            mnist_dma_finish_ff2 <= mnist_dma_finish_ff1;
        end else begin
            mnist_dma_finish_ff1 <= mnist_dma_finish_ff1;
            mnist_dma_finish_ff2 <= mnist_dma_finish_ff2;
        end
        
        if (start_res[0]) begin
            mnist_start_ff1 <= 1;
            mnist_start_ff2 <= mnist_start_ff1;
        end else begin
            mnist_start_ff1 <= mnist_start_ff1;
            mnist_start_ff2 <= mnist_start_ff2;
        end
    end
end
assign mnist_start = mnist_start_ff1 & (~mnist_start_ff2);


   //below are used as the input for sram
   wire u_mrt_ena;
   wire                          u_mrt_wen           ;
   wire    [32-1: 0]             u_mrt_cfg_data      ;
   wire                          u_mrt_cfg_i         ;
   wire    [32-1: 0]             u_mrt_cfg_addr      ;


wire [31:0] all_parameter_sram_addr;

assign all_parameter_sram_addr = mnist_rst_n? {16'b0,sram_addr}:u_mrt_cfg_addr;




/////////////////////////////////////////////////////the code below is treated as carmer,when camera code is ready, please add it here
reg fm_data_valid;

reg start;
reg [4:0] tb_state;
reg [15:0] i;
reg [15:0] in_i;
integer fm_txt;
reg [7:0] fm_data [1023:0];
reg count;
    

wire pre_ready;
wire [3:0] o_result_data;
wire o_result_data_valid;

initial
begin
fm_txt=$fopen("D:/project/ChipDesign/nice_core/img_test.txt","r");
    for(i=0;i<34*26;i=i+1)
       begin
           count= $fscanf(fm_txt,"%d",fm_data[i]);
       end
    $fclose(fm_txt);


end

always@(posedge nice_clk) begin
    if(!nice_rst_n) begin
        start <=0;
        in_i <= 0;
        fm_data_valid <=0;
        tb_state <= 0;
    end else begin
    case (tb_state)
        0: begin
            start <=1;
            tb_state <=1;
        end
        1: begin
            if(mnist_ready == 1)begin
                start <=0;
                in_i <= 0;
                fm_data_valid <=1;
                tb_state <=2;
            end
        end
        2: begin
            in_i <= in_i+1;
            fm_data_valid <=1;
            if(in_i == 34-1) begin
                tb_state <=3;
                in_i <=0;
                fm_data_valid <=0;
            end
        end              
        default: begin
        end
        
     endcase

    end


end  
wire [207:0] parallel_data;
assign parallel_data = {
    fm_data[in_i*26+25], fm_data[in_i*26+24], fm_data[in_i*26+23], fm_data[in_i*26+22],
    fm_data[in_i*26+21], fm_data[in_i*26+20*26], fm_data[in_i*26+19], fm_data[in_i*26+18],
    fm_data[in_i*26+17], fm_data[in_i+16*26], fm_data[in_i*26+15], fm_data[in_i*26+14],
    fm_data[in_i*26+13], fm_data[in_i+12*26], fm_data[in_i*26+11], fm_data[in_i*26+10],
    fm_data[in_i*26+9], fm_data[in_i+8*26], fm_data[in_i*26+7], fm_data[in_i*26+6],
    fm_data[in_i*26+5], fm_data[in_i+4*26], fm_data[in_i*26+3], fm_data[in_i*26+2],
    fm_data[in_i*26+1], fm_data[in_i*26]
};


    sirv_sim_ram_all_parameter sirv_sim_ram_all_parameter_ins
        (
        .clk(nice_clk), 
        .din(u_mrt_cfg_data), 
        .addr(all_parameter_sram_addr),
        .cs(u_mrt_ena), //make sure you enable it for both read and write
        .we(u_mrt_wen), //enable it when write, disable it when read
        .wem(4'b1111),//only uesd when write
        .dout(sram_data)
        );

    nice_core_top nice_core_top_ins(
    //generanl config
        .i_clk(nice_clk),
        .i_rst_n(mnist_rst_n),
        .i_start(mnist_start),  
        .o_data_ready(mnist_ready),        
        .o_dma_finish(mnist_dma_finish),

    //fm data   
        .i_parallel_data(parallel_data),
        .i_fm_data_valid(fm_data_valid),

    //weight
        .o_sram_weight_addr(sram_addr),
        .i_sram_weight(sram_data[15:0]),

    //cmd from cpu, maxmam 3 layer
//        .i_fm_row(fm_row),
//        .i_fm_col(fm_col),
//        .i_layer1_kernel_num(layer1_kernel_num),
//        .i_layer2_kernel_num(layer2_kernel_num),
//        .i_layer3_kernel_num(layer3_kernel_num),

    //return data back to cpu
        .o_result_data(result_data),
        .o_result_data_valid(result_data_valid)

    );
/////////////////////////////////////////////////////////////////////////////////////////////upper is my mnist module


//////////// 3. custom3_ldbuf/////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////


/////*************************************state part*******************************////      
    parameter LDBUF_FSM_WIDTH     = 3; 
    parameter LDBUF_IDLE          = 3'b000; 
    parameter LDBUF_LOAD          = 3'b100; 
    parameter LDBUF_ANS           = 3'b010; 

    wire [LDBUF_FSM_WIDTH-1:0] ldbuf_state_r; 
    wire [LDBUF_FSM_WIDTH-1:0] ldbuf_nxt_state; 
    wire [LDBUF_FSM_WIDTH-1:0] ldbuf_state_idle_nxt; 
    wire [LDBUF_FSM_WIDTH-1:0] ldbuf_state_load_nxt; 
    wire [LDBUF_FSM_WIDTH-1:0] ldbuf_state_ans_nxt; 
 
   wire ldbuf_state_idle_exit_ena;
   wire ldbuf_state_load_exit_ena;
   wire ldbuf_state_ans_exit_ena; 
    
    wire ldbuf_state_ena; 

    wire ldbuf_state_is_idle      = (ldbuf_state_r == LDBUF_IDLE); 
    wire ldbuf_state_is_load      = (ldbuf_state_r == LDBUF_LOAD); 
    wire ldbuf_state_is_ans       = (ldbuf_state_r == LDBUF_ANS); 

    reg ldbuf_ram_is_i;
    reg [24-1:0] ldbuf_start_addr;
    reg [14-1:0] ldbuf_batch;
    
    always@(posedge nice_clk) begin
        if(~nice_rst_n) begin
            ldbuf_ram_is_i <= 0;
            ldbuf_start_addr <= 0;
            ldbuf_batch <= 0;
        end
        else if(ldbuf_state_is_ans) begin
            ldbuf_ram_is_i   <= rs2_r[0];
            ldbuf_start_addr <= rs2_r[32-1:32-1-24+1];
//                   ldbuf_batch <= (rs2_r[32-1-24:1]==0)? 14'b1
//                                : (rs2_r[32-1-24:1]==1)? 14'b10
//                                : (rs2_r[32-1-24:1]==2)? 14'b100
//                                : 14'd8192;
            ldbuf_batch <= 14'd5640;
        end
    end


    assign ldbuf_state_idle_exit_ena = ldbuf_state_is_idle & state_is_ldbuf & ~busy_status_r; 
    assign ldbuf_state_idle_nxt =  LDBUF_ANS;

 //   wire ldbuf_load_done;  move to a upper position
    assign ldbuf_state_load_exit_ena = ldbuf_state_is_load & ldbuf_load_done; 
    assign ldbuf_state_load_nxt = LDBUF_IDLE;
    
    
    assign ldbuf_state_ans_exit_ena = ldbuf_state_is_ans; 
    assign ldbuf_state_ans_nxt = LDBUF_LOAD;

    assign ldbuf_nxt_state  = ({LDBUF_FSM_WIDTH{ldbuf_state_idle_exit_ena    }} & ldbuf_state_idle_nxt    )
                             | ({LDBUF_FSM_WIDTH{ldbuf_state_load_exit_ena    }} & ldbuf_state_load_nxt    )
                            | ({LDBUF_FSM_WIDTH{ldbuf_state_ans_exit_ena     }} & ldbuf_state_ans_nxt     ) 
                            ;

    assign ldbuf_state_ena =   ldbuf_state_idle_exit_ena | ldbuf_state_load_exit_ena 
                            |   ldbuf_state_ans_exit_ena;

    sirv_gnrl_dfflr #(LDBUF_FSM_WIDTH)   ldbuf_state_dfflr (ldbuf_state_ena, ldbuf_nxt_state, ldbuf_state_r, nice_clk, nice_rst_n);
    
/////*************************************counter part*******************************////      

    wire [14-1:0] ldbuf_cnt_r; 
   wire [14-1:0] ldbuf_cnt_nxt; 
   wire ldbuf_cnt_clr;
   wire ldbuf_cnt_incr;
   wire ldbuf_cnt_ena;
   wire ldbuf_cnt_last;
   wire ldbuf_icb_rsp_hsked;

    assign ldbuf_icb_rsp_hsked = ldbuf_state_is_load & nice_icb_rsp_hsked;
   assign ldbuf_cnt_last = (ldbuf_cnt_r == ldbuf_batch);
   assign ldbuf_cnt_clr = ldbuf_icb_rsp_hsked & ldbuf_cnt_last;
   assign ldbuf_cnt_incr = ldbuf_icb_rsp_hsked & ~ldbuf_cnt_last;
   assign ldbuf_cnt_ena = ldbuf_cnt_clr | ldbuf_cnt_incr;
   assign ldbuf_cnt_nxt =   ({14{ldbuf_cnt_clr }} & {14{1'b0}})
                           | ({14{ldbuf_cnt_incr}} & (ldbuf_cnt_r + 1'b1))
                           ;
   
   sirv_gnrl_dfflr #(14)   rowbuf_cnt_dfflr (ldbuf_cnt_ena, ldbuf_cnt_nxt, ldbuf_cnt_r, nice_clk, nice_rst_n);

   /////*************************************restore data part*******************************////      
 
   wire rcv_data_buf_ena;
   wire rcv_data_buf_set;
   wire rcv_data_buf_clr;
   wire rcv_data_buf_valid;
   wire [`E203_XLEN-1:0] rcv_data_buf; 
   wire [32-1:0] rcv_data_buf_idx; 
   wire [32-1:0] rcv_data_buf_idx_nxt; 

   assign rcv_data_buf_set = ldbuf_icb_rsp_hsked;
   assign rcv_data_buf_clr = ldbuf_state_is_idle;
   assign rcv_data_buf_ena = rcv_data_buf_clr | rcv_data_buf_set;
   assign rcv_data_buf_idx_nxt =   ({32{rcv_data_buf_clr}} & {32{1'b0}})
                                 | ({32{rcv_data_buf_set}} & ldbuf_cnt_r        );

   sirv_gnrl_dfflr #(1)   rcv_data_buf_valid_dfflr (1'b1, rcv_data_buf_ena, rcv_data_buf_valid, nice_clk, nice_rst_n);
   sirv_gnrl_dfflr #(`E203_XLEN)   rcv_data_buf_dfflr (rcv_data_buf_ena, nice_icb_rsp_rdata, rcv_data_buf, nice_clk, nice_rst_n);
   sirv_gnrl_dfflr #(32)   rowbuf_cnt_d_dfflr (rcv_data_buf_ena, rcv_data_buf_idx_nxt, rcv_data_buf_idx, nice_clk, nice_rst_n);

    
   wire [`E203_XLEN-1:0] ldbuf_res;
   wire nice_rsp_valid_ldbuf ;
    wire ldbuf_acc_flag;
   wire nice_icb_cmd_valid_ldbuf ;

   assign ldbuf_res = {31'b0,ldbuf_state_idle_exit_ena};
    assign nice_rsp_valid_ldbuf = mnist_dma_finish_posedge ;  
    assign ldbuf_done = state_is_ldbuf & ldbuf_load_done;     
    
    assign ldbuf_acc_flag = rcv_data_buf_valid ;
    assign nice_icb_cmd_valid_ldbuf = ldbuf_state_is_load & (rcv_data_buf_idx < ldbuf_batch) & ~ldbuf_acc_flag;
    
    assign u_mrt_cfg_addr = rcv_data_buf_idx + {8'b0,ldbuf_start_addr}; 
    assign u_mrt_ena = 1'b1;
    assign u_mrt_wen = rcv_data_buf_valid & ldbuf_state_is_load;
    assign u_mrt_cfg_data = rcv_data_buf;
    assign u_mrt_cfg_i = ldbuf_ram_is_i;
    assign ldbuf_load_done = rcv_data_buf_valid & (rcv_data_buf_idx==ldbuf_batch-1);
    
    assign busy_status_ena = state_is_start | ldbuf_state_is_load;
    assign busy_status_rst_n = mrt_rstn_rst_n & ~ldbuf_state_load_exit_ena & nice_rst_n;


/////*************************************addr control part*******************************////      

   wire [`E203_XLEN-1:0] maddr_acc_r; 
wire nice_icb_cmd_hsked;
   assign nice_icb_cmd_hsked = nice_icb_cmd_valid & nice_icb_cmd_ready; 
   // custom3_rdstat 
   //wire [`E203_XLEN-1:0] lbuf_maddr    = state_is_idle ? nice_req_rs1 : maddr_acc_r ; 
   wire rdstat_maddr_ena    =   1'b0;

   // custom3_start 
   //wire [`E203_XLEN-1:0] sbuf_maddr    = state_is_idle ? nice_req_rs1 : maddr_acc_r ; 
   wire start_maddr_ena     =  1'b0;

   // custom3_ldbuf
   //wire [`E203_XLEN-1:0] rowsum_maddr  = state_is_idle ? nice_req_rs1 : maddr_acc_r ; 
   
   wire ldbuf_maddr_ena  =    ldbuf_state_idle_exit_ena
                            | (ldbuf_state_is_load & nice_icb_cmd_hsked)
                            ;

   // maddr acc 
   //wire  maddr_incr = lbuf_maddr_ena | sbuf_maddr_ena | rowsum_maddr_ena | rbuf_maddr_ena;
   wire  maddr_ena = rdstat_maddr_ena | start_maddr_ena | ldbuf_maddr_ena;
   
   wire [`E203_XLEN-1:0] maddr_acc_op1 = ldbuf_state_idle_exit_ena ? rs1_r : maddr_acc_r; // not reused
   wire [`E203_XLEN-1:0] maddr_acc_op2 = ldbuf_state_idle_exit_ena ? `E203_XLEN'h0 : `E203_XLEN'h4; 

   wire [`E203_XLEN-1:0] maddr_acc_next = maddr_acc_op1 + maddr_acc_op2;
   wire  maddr_acc_ena = maddr_ena;

   sirv_gnrl_dfflr #(`E203_XLEN)   maddr_acc_dfflr (maddr_acc_ena, maddr_acc_next, maddr_acc_r, nice_clk, nice_rst_n);


////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

   ////////////////////////////////////////////////////////////
   // Control cmd_req
   ////////////////////////////////////////////////////////////
   assign nice_req_hsked = nice_req_valid & nice_req_ready;
   assign nice_req_ready = state_is_idle & (custom_mem_op ? nice_icb_cmd_ready : 1'b1);

   ////////////////////////////////////////////////////////////
   // Control cmd_rsp
   ////////////////////////////////////////////////////////////
   assign nice_rsp_hsked = nice_rsp_valid & nice_rsp_ready; 
   assign nice_icb_rsp_hsked = nice_icb_rsp_valid & nice_icb_rsp_ready;
   assign nice_rsp_valid = nice_rsp_valid_rdstat | nice_rsp_valid_start | nice_rsp_valid_ldbuf; //afer all data transfered, rsp valid to
   assign nice_rsp_rdat  = {`E203_XLEN{state_is_rdstat}} & rdstat_res
                         | {`E203_XLEN{state_is_start }} & start_res
                         | {`E203_XLEN{state_is_ldbuf }} & ldbuf_res
                           ;

   // memory access bus error
   //assign nice_rsp_err_irq  =   (nice_icb_rsp_hsked & nice_icb_rsp_err)
   //                          | (nice_req_hsked & illgel_instr)
   //                          ; 
   assign nice_rsp_err   =   (nice_icb_rsp_hsked & nice_icb_rsp_err);

   ////////////////////////////////////////////////////////////
   // Memory lsu
   ////////////////////////////////////////////////////////////
   // memory access list:
   //  1. In IDLE, custom_mem_op will access memory(lbuf/sbuf/rowsum)
   //  2. In LBUF, it will read from memory as long as lbuf_cnt_r is not full
   //  3. In SBUF, it will write to memory as long as sbuf_cnt_r is not full
   //  3. In ROWSUM, it will read from memory as long as rowsum_cnt_r is not full
   //assign nice_icb_rsp_ready = state_is_ldst_rsp & nice_rsp_ready; 
   // rsp always ready
   assign nice_icb_rsp_ready = 1'b1; 
   
   assign nice_icb_cmd_valid =  nice_icb_cmd_valid_ldbuf;
   assign nice_icb_cmd_addr  = maddr_acc_r;
   assign nice_icb_cmd_read  = 1'b1;
   assign nice_icb_cmd_wdata = `E203_XLEN'b0; 

   //assign nice_icb_cmd_wmask = {`sirv_XLEN_MW{custom3_sbuf}} & 4'b1111;
   assign nice_icb_cmd_size  = 2'b10;
   assign nice_mem_holdup    =  ldbuf_state_is_load; 

   ////////////////////////////////////////////////////////////
   // nice_active
   ////////////////////////////////////////////////////////////
   assign nice_active = state_is_idle ? nice_req_valid : 1'b1;

endmodule



