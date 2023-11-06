`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uestc
// Engineer: lichao
// 
// Create Date: 2021/08/28 19:46:35
// Design Name: 
// Module Name: acc_sum
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: The component collects 8 25-bit data at once and sum them up.
// It repeats this process for 8 times. When full, it generate a cyc_flag and
// outputs the final result.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module acc_sum#(
parameter gen_width=21
)(
input clk,rstn,acc_en,
input signed [gen_width-1:0] d,
output [gen_width-1:0] result,
output acc_done
    );
    reg [5:0] counter=0;
    reg signed [gen_width-1:0] res_tmp=0;
    reg acc_done_flag=0;
    reg cyc;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) 
        begin
            res_tmp<=0;
            counter<=0;
            acc_done_flag<=0;
        end
        else
            begin
                if(acc_en) 
                begin
                    res_tmp<=res_tmp+d;
                    counter<=counter+1;
                    if(counter==47) 
                    begin
                        acc_done_flag<=1;
                    end
                    else acc_done_flag<=0;
                end
                else 
                begin
                    acc_done_flag<=0;
                end
                if(acc_done_flag) 
                begin
                    res_tmp<=0;
                    counter<=0;
                end 
            end
    end
    
    assign result=res_tmp;
    assign acc_done=acc_done_flag;
endmodule
