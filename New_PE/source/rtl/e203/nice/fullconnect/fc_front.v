`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuqi Guo
// 
// Create Date: 
// Design Name: 
// Module Name: 
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


module fc_front#(
    parameter col_data_length=64,//8*8
    parameter d_8=64,//8*4
    parameter qua_width=8,
    parameter gen_width=25)(
input signed [col_data_length-1:0] d_64bit,
input signed [d_8-1:0] w_64bit,
input signed [gen_width-1:0] bias,
input clk,rstn,
output [20:0] final_out,
output cyc_done
    );

/*
reg [63:0] weight,data;//the buffer stores 8 bytes
reg [2:0] counter0=0;//counter records the amount of acquired number

reg acc_en_flag=0;//launch accumulator
always @(posedge clk or negedge rstn) begin
    if(!rstn)
    begin
        weight<=0;
        data<=0;
        counter0<=0;
        acc_en_flag<=0;
    end
    else
        begin
            counter0<=counter0+1;
            weight[counter0*8+:8]<=w_8bit;
            data[counter0*8+:8]<=d_8bit;
            if(counter0==7) acc_en_flag<=1;
            else acc_en_flag<=0;
        end
end
*/

wire signed [gen_width-1:0] acc_input;
wire ms_valid;
mult_sum ms_ins0(
    .clk(clk),
    .rst_n(rstn),
    .en(1'b1),//need to be optimized
    .weight(w_64bit ),
    .data(d_64bit),
    .d_out(acc_input),
    .ms_valid(ms_valid)
);

//gen an wi*xi
wire norm_flag;
wire signed [gen_width-1:0] acc_out;
wire acc_done;// the tag for launching the sum of bias and result
acc_sum ins0(
    .clk(clk),
    .rstn(rstn),
    .acc_en(ms_valid),
    .d(acc_input),
    .result(acc_out),
    .acc_done(acc_done)
);

reg signed [gen_width:0] ori_out;//the original sum
reg cyc_flag;//the tag denotes accomplishment of 512 bytes computation 
always @(posedge clk or negedge rstn) begin
    if(!rstn) 
    begin
        ori_out<=0;
        cyc_flag<=0;
    end
    else 
    begin
        if (acc_done)
        begin
            ori_out<=bias+acc_out;
            cyc_flag<=1;
        end 
        else
            cyc_flag<=0;
    end
end
assign final_out=ori_out[20:0];
assign cyc_done=cyc_flag;
endmodule
