`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuqi Guo
// 
// Create Date: 
// Design Name: 
// Module Name: mult_sum
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


(*use_dsp="yes"*)module mult_sum#(
parameter gen_width=25
)(
input clk,rst_n,en,
input [63:0] weight,
input [63:0] data,
output [gen_width-1:0] d_out,
output ms_valid
    );
    wire signed [7:0] w0=weight[7:0];
    wire signed [7:0] w1=weight[15:8];
    wire signed [7:0] w2=weight[23:16];
    wire signed [7:0] w3=weight[31:24];
    wire signed [7:0] w4=weight[39:32];
    wire signed [7:0] w5=weight[47:40];
    wire signed [7:0] w6=weight[55:48];
    wire signed [7:0] w7=weight[63:56];
    wire signed [7:0] d0=data[7:0];
    wire signed [7:0] d1=data[15:8];
    wire signed [7:0] d2=data[23:16];
    wire signed [7:0] d3=data[31:24];
    wire signed [7:0] d4=data[39:32];
    wire signed [7:0] d5=data[47:40];
    wire signed [7:0] d6=data[55:48];
    wire signed [7:0] d7=data[63:56];

    reg signed [15:0]result0 ;
    reg signed [15:0]result1 ;
    reg signed [15:0]result2 ;
    reg signed [15:0]result3 ;
    reg signed [15:0]result4 ;
    reg signed [15:0]result5 ;
    reg signed [15:0]result6 ;
    reg signed [15:0]result7 ;

    reg valid;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
        begin
            result0<=0;
            result1<=0;
            result2<=0;
            result3<=0;
            result4<=0;
            result5<=0;
            result6<=0;
            result7<=0;
            valid<=0;
        end
        else
            begin
                if(en)
                begin
                    result0<=w0*d0;
                    result1<=w1*d1;
                    result2<=w2*d2;
                    result3<=w3*d3;
                    result4<=w4*d4;
                    result5<=w5*d5;
                    result6<=w6*d6;
                    result7<=w7*d7;
                    valid<=1;
                end
                else 
                    begin
                        result0<=0;
                        result1<=0;
                        result2<=0;
                        result3<=0;
                        result4<=0;
                        result5<=0;
                        result6<=0;
                        result7<=0; 
                        valid<=0;
                    end
            end
    end
    assign ms_valid=valid;
    assign d_out=((result0+result1)+(result2+result3))+((result4+result5)+(result6+result7));
endmodule
