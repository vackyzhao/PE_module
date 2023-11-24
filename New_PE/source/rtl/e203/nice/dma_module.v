module dma_module#(
    parameter DW = 16,  // Data Width
    parameter AW = 16   // Address Width
)(

// for nice cmd and data
    input i_clk,
    input i_rst_n,
    

//for read ITCM 
    input  [DW-1:0] i_itcm_data,
    output [AW-1:0] o_itcm_addr,


//for mnist controller
    input  i_dma_start,
    output o_dma_finish,
 
    input [AW-1:0] i_fc_weight_length,
    input [AW-1:0] i_conv_weight_length,

    
    output [4:0] o_dma_control,
output reg o_dma_conv_load_finish,
//for acc module
    output o_write_en,
    output [AW-1:0] o_dma_conv_weight_addr,
    output [DW-1:0] o_dma_conv_weight,
    output [AW-1:0] o_dma_fc_weight_addr0,
    output [DW-1:0] o_dma_weights0,
    output [AW-1:0] o_dma_fc_weight_addr1,
    output [DW-1:0] o_dma_weights1,
    output [AW-1:0] o_dma_fc_weight_addr2,
    output [DW-1:0] o_dma_weights2,
    output [AW-1:0] o_dma_fc_weight_addr3,
    output [DW-1:0] o_dma_weights3


);

reg [3:0] dma_state;
reg [8:0] dma_control;
reg dma_finish;
reg write_en;
reg write_en_ff;

reg [AW-1:0] read_in_addr_cnt;
reg [DW-1:0]  read_in_data;


reg [AW-1:0] write_out_addr_cnt;
reg [AW-1:0] write_out_addr_cnt_ff1;
reg [AW-1:0] write_out_addr_cnt_ff2;

reg [DW-1:0]  write_out_data;



assign o_dma_control = dma_control;
assign o_write_en = write_en;
assign o_dma_finish = dma_finish;

//read 8bit fc and conv weights out
assign o_itcm_addr = read_in_addr_cnt;

//write 8bit fc and conv weights out
assign o_dma_conv_weight_addr      = dma_control[0]? write_out_addr_cnt:0;
assign o_dma_conv_weight = dma_control[0]? write_out_data:0;

assign o_dma_fc_weight_addr0 = dma_control[1]? write_out_addr_cnt:0;
assign o_dma_weights0 = dma_control[1]? write_out_data:0;


assign o_dma_fc_weight_addr1 = dma_control[2]? write_out_addr_cnt:0;
assign o_dma_weights1 = dma_control[2]? write_out_data:0;


assign o_dma_fc_weight_addr2 = dma_control[3]? write_out_addr_cnt:0;
assign o_dma_weights2 = dma_control[3]? write_out_data:0;


assign o_dma_fc_weight_addr3 = dma_control[4]? write_out_addr_cnt:0;
assign o_dma_weights3 = dma_control[4]? write_out_data:0;



always @(posedge i_clk ) begin
    if (!i_rst_n) begin
        dma_state <= 0;
        dma_control <=1;
        dma_finish <=0;
        write_en <=0;
        write_en_ff <=0;
        read_in_addr_cnt <= 0;
        read_in_data <= 0;
        write_out_addr_cnt <=0;
        write_out_addr_cnt_ff1 <=0;
        write_out_addr_cnt_ff2 <=0;
        write_out_data <=0;
o_dma_conv_load_finish <=0;
    end else begin
        case (dma_state)
            0: begin
                if (i_dma_start) begin
                    dma_state <= 1;
                end else begin
                    dma_state <= dma_state;
                end
            end

            1: begin
                if (write_out_addr_cnt < i_conv_weight_length-1) begin
                    write_en_ff <=1;
                    write_en <= write_en_ff;
                    read_in_addr_cnt <= read_in_addr_cnt+1; 
                    write_out_addr_cnt_ff1 <= write_out_addr_cnt_ff1+1;
                    write_out_addr_cnt_ff2 <= write_out_addr_cnt_ff1;
                    write_out_addr_cnt <= write_out_addr_cnt_ff2;
                    write_out_data <= i_itcm_data;                                   
                end else begin
                    write_en <=0;
                    read_in_addr_cnt <= i_conv_weight_length;
                    read_in_data <= 0;
                    write_out_addr_cnt <= 0;
                    write_out_addr_cnt_ff1 <=0;
                    write_out_addr_cnt_ff2 <=0;
                    write_out_data <= 0;
                    dma_control <= dma_control<<1;
                    dma_state <= dma_state+1;
                    o_dma_conv_load_finish<=1;
                end
                
            end

            2: begin
                if (write_out_addr_cnt < i_fc_weight_length-1) begin
                    write_en_ff <=1;
                    write_en <= write_en_ff;
                    read_in_addr_cnt <= read_in_addr_cnt+1; 
                    write_out_addr_cnt_ff1 <= write_out_addr_cnt_ff1+1;
                    write_out_addr_cnt_ff2 <= write_out_addr_cnt_ff1;
                    write_out_addr_cnt <= write_out_addr_cnt_ff2;
                    write_out_data <= i_itcm_data;                                   
                end else begin
                    write_en <=0;
                    read_in_addr_cnt <= i_fc_weight_length+i_conv_weight_length;
                    read_in_data <= 0;
                    write_out_addr_cnt <= 0;
                    write_out_addr_cnt_ff1 <=0;
                    write_out_addr_cnt_ff2 <=0;
                    write_out_data <= 0;
                    dma_control <= dma_control<<1;
                    dma_state <= dma_state+1;
                end 
            end

            3: begin
                if (write_out_addr_cnt < i_fc_weight_length-1) begin
                    write_en_ff <=1;
                    write_en <= write_en_ff;
                    read_in_addr_cnt <= read_in_addr_cnt+1; 
                    write_out_addr_cnt_ff1 <= write_out_addr_cnt_ff1+1;
                    write_out_addr_cnt_ff2 <= write_out_addr_cnt_ff1;
                    write_out_addr_cnt <= write_out_addr_cnt_ff2;
                    write_out_data <= i_itcm_data;                                   
                end else begin
                    write_en <=0;
                    read_in_addr_cnt <= 2*i_fc_weight_length+i_conv_weight_length;
                    read_in_data <= 0;
                    write_out_addr_cnt <= 0;
                    write_out_addr_cnt_ff1 <=0;
                    write_out_addr_cnt_ff2 <=0;
                    write_out_data <= 0;
                    dma_control <= dma_control<<1;
                    dma_state <= dma_state+1;
                end  
            end

            4: begin
                if (write_out_addr_cnt < i_fc_weight_length-1) begin
                    write_en_ff <=1;
                    write_en <= write_en_ff;
                    read_in_addr_cnt <= read_in_addr_cnt+1; 
                    read_in_addr_cnt <= read_in_addr_cnt+1; 
                    write_out_addr_cnt_ff1 <= write_out_addr_cnt_ff1+1;
                    write_out_addr_cnt_ff2 <= write_out_addr_cnt_ff1;
                    write_out_addr_cnt <= write_out_addr_cnt_ff2;
                    write_out_data <= i_itcm_data;                                   
                end else begin
                    write_en <=0;
                    read_in_addr_cnt <= 3*i_fc_weight_length+i_conv_weight_length;
                    read_in_data <= 0;
                    write_out_addr_cnt <= 0;
                    write_out_addr_cnt_ff1 <=0;
                    write_out_addr_cnt_ff2 <=0;
                    write_out_data <= 0;
                    dma_control <= dma_control<<1;
                    dma_state <= dma_state+1;
                end               
            end

            5: begin
                if (write_out_addr_cnt < i_fc_weight_length-1) begin
                    write_en_ff <=1;
                    write_en <= write_en_ff;
                    read_in_addr_cnt <= read_in_addr_cnt+1; 
                    write_out_addr_cnt_ff1 <= write_out_addr_cnt_ff1+1;
                    write_out_addr_cnt_ff2 <= write_out_addr_cnt_ff1;
                    write_out_addr_cnt <= write_out_addr_cnt_ff2;
                    write_out_data <= i_itcm_data;                                   
                end else begin
                    write_en <=0;
                    read_in_addr_cnt <= 4*i_fc_weight_length+i_conv_weight_length;
                    read_in_data <= 0;
                    write_out_addr_cnt <= 0;
                    write_out_addr_cnt_ff1 <=0;
                    write_out_addr_cnt_ff2 <=0;
                    write_out_data <= 0;
                    dma_control <= dma_control<<1;
                    dma_state <= dma_state+1;
                    dma_finish<=1;
                end  
            end


           


            default: begin
            end
        endcase


    end

    
end


endmodule