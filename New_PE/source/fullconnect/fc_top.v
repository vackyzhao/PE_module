`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/21 10:56:16
// Design Name: 
// Module Name: Input_pre_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module fc_top(
    input i_clk,
    input i_rst_n,
    
    input [8*12-1:0] i_pool_data_in,
    input i_pool_valid_out,
    input i_pool_end,
    
    output [4:0] o_result_data,
    output o_result_data_valid
    );
//for interact with fc module

wire [15:0]  fc_weight_addr;
wire [31:0]   fc_weight;
wire fc_start;
wire [15:0] fc_fm_addr;
wire signed [8*8-1:0] fc_fm_data;
         pool_fc_buffer pool_fc_buffer_ins(
            .clk(i_clk),
            .rst_n(i_rst_n ),
            .i_pool_data_in(i_pool_data_in),
            .i_pool_valid_out(i_pool_valid_out),
            .i_pool_end(i_pool_end),
            .i_fc_fm_addr(fc_fm_addr),
            
            .o_fc_start(fc_start),
            .o_fc_fm_data(fc_fm_data)
        );
        fc_module fc_module_ins (
        
        .clk(i_clk),
        .rst_n(i_rst_n),
        .i_fc_start(fc_start),
    
        //fm data
        .i_fc_fm_data(fc_fm_data),
        .i_fc_fm_base_addr(0),
        .o_fc_fm_addr(fc_fm_addr),
        //weights
        .i_fc_weight(fc_weight),
        .i_fc_weight_base_addr(0),
        .o_fc_weight_addr(fc_weight_addr),
        
        .o_fc_result_out_valid(o_result_data_valid),
        .o_fc_result_out(o_result_data)
        );
        
fc_sram #(
    .DW(4)
    )fc_sram_ins

    (
     .clk(i_clk), 
     .din(0), 
     .addr(fc_weight_addr),
     .cs(1), //make sure you enable it for both read and write
     .we(0), //enable it when write, disable it when read
     .wem(0),//only uesd when write
     .dout(fc_weight)
    );
endmodule