//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuqi Guo
// 
// Create Date:
// Design Name: 
// Module Name: fc_module
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

module fc_module#(
    parameter gen_width=21
)(
    input           clk,
    input           rst_n,
    input           i_fc_start,

//fm data
    input signed    [63:0] i_fc_fm_data,//-----
    input           [8:0] i_fc_fm_base_addr,//--------
    output          [15:0] o_fc_fm_addr,//---------
    input  signed   [63:0] i_fc_weight,

    input           [12:0] i_fc_weight_base_addr,//-----------
    output          [15:0] o_fc_weight_addr,


    output          o_fc_result_out_valid,
    output          [4:0] o_fc_result_out
    );

    // corresponding to w,d,b
    wire signed [7:0] weight;

    reg [63:0] fc_weight_all;
    //reg [63:0] fc_fm_data;
    reg [15:0] weight_counter;
    reg [15:0] counter0;
    reg [4:0] weight_base;
    reg [8:0] counter1;
    reg [5:0] counter2;
    reg weight_nonhold;
    
    wire signed [20:0]  data_out;
    wire comp;
    wire signed [20:0] out_val;
    wire cyc_done;
    
    assign o_fc_weight_addr=counter0+i_fc_weight_base_addr;//--------
    assign o_fc_fm_addr=counter1+i_fc_fm_base_addr;//---------



reg [2:0] addr_state;

reg [15:0] col_cnt;
reg [15:0] fm_cnt;
reg read_finish ;
///////////////////////
    reg start;reg rstn1;
    wire rstn2;
    reg [4:0] result;
    reg signed [20:0] fc_out; 
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            start<=0;
            fc_out<=0;
            result<=0;
            
        end
        else begin
            if(cyc_done && comp)
            begin
                fc_out<=out_val;
                result<=counter2;
            end
            else if(i_fc_start) 
            begin
                start<=1;
                fc_out<=0;
                result<=0;
            end
            
            if(start) rstn1<=1;
            else rstn1<=0;
            
            if(counter2>26) start<=0;
            
        end
    end
    assign rstn2=rstn1&rst_n;
    


    always@(posedge clk or negedge rst_n)
    begin
    if(!rst_n )
    begin
        addr_state <=0;
        col_cnt<=0;
        read_finish<=0;
        fm_cnt <=0;
        weight_counter <=0;
        weight_base <=0;
        weight_nonhold <=1;
    end
    else begin
        if(i_fc_start|start)
            begin
                //fc_fm_data <= i_fc_fm_data;
                case (addr_state)
                    0: begin
                            
                            if (col_cnt<5) begin
                                col_cnt <= col_cnt+1;
                            end else begin
                                fm_cnt <= fm_cnt+1;
                                col_cnt <= 0;
                            end

                        
                        counter0 <=weight_counter+weight_base *48;
                        if(counter1==376) begin
                            fm_cnt<=0;
                            col_cnt<=0;
                            counter1<=0;
                        end
                        else counter1 <= 48*fm_cnt + 8 * col_cnt;
                        if(weight_counter == 47)begin
                            if(weight_base==28)
                            begin
                                weight_base <=0;   
                            end
                            else begin
                                weight_base<= weight_base +1;    
                            end
                            weight_counter<=0;
                            weight_nonhold <=0;
                        end
                        else begin
                            weight_nonhold <=1;
                            weight_counter <=weight_counter +weight_nonhold;
                        end
                    end
                    1: begin
                        read_finish <= 1;
                    end
                
                    default: begin 
                    end
                endcase

                if(cyc_done) counter2<=counter2+1;//shift bias
                //relaunch the whole process
                if(counter0==1295) 
                begin
                    counter0<=0;
                    weight_counter<=0;
                    weight_base<=0;
                end
            end
        else 
            begin
            //fc_fm_data <= 0;
                counter0<=0;
                counter1<=0;
                counter2<=0;
            end
        end
    end
    fc_front ins0(
    .clk(clk),
    .rstn(rstn2),
    .w_64bit(i_fc_weight),//------------
    .d_64bit(i_fc_fm_data),//----------
    .bias(0),//---------
    .final_out(data_out),
    .cyc_done(cyc_done)
    );
    assign o_fc_result_out_valid= counter2>26? 1:0;
    
    
    wire signed [20:0] out_val_middle;
    assign out_val_middle = (data_out>>>4);
    assign out_val = (out_val_middle < -128) ? -128 : ((out_val_middle>127) ? 127 : out_val_middle);
    
    
    assign comp = out_val>fc_out;

    assign o_fc_result_out=result;
endmodule
