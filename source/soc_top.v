module soc_top  (
    input wire clk_50M,
    input wire i_cam_data,
    input wire i_rst_n,
    output o_rst_n,
    output  wire [4:0] o_result_data,  // 输出：结果数据
    output wire fm_data_valid,conv1_dout_vald, pool1_dout_vald, pool2_dout_vald, conv2_dout_vald,
    output wire o_result_data_valid  // 输出：结果数据有效信号
);
reg [7:0]clk_counter0,clk_counter1  ;
reg asl_clk,uart_clk;

initial begin 
    clk_counter0=8'b0;
    clk_counter0=8'b1;
    asl_clk=0;
    uart_clk=0;
end


asl_top asl_top_inst(
    .clk(asl_clk),
    .uart_clk(uart_clk),  
    .i_cam_data(i_cam_data),
    .i_rst_n(i_rst_n),  

    .o_rst_n(o_rst_n),
    .o_result_data(o_result_data),  // 输出：结果数据

    .fm_data_valid(fm_data_valid),
    .conv1_dout_vald(conv1_dout_vald),
    .pool1_dout_vald(pool1_dout_vald),
    .pool2_dout_vald(pool2_dout_vald), 
    .conv2_dout_vald(conv2_dout_vald),


    .o_result_data_valid(o_result_data_valid)  // 输出：结果数据有效信号
);

    always@(posedge clk_50M or negedge i_rst_n)begin
        if(!i_rst_n)begin
            clk_counter0<=8'b0;
            clk_counter1<=8'b0;
            asl_clk<=0;
            uart_clk<=0;
        end else begin
            if(clk_counter0<8'd24)begin
                clk_counter0<=clk_counter0+1'b1;
            end else begin
                clk_counter0<=0;
                asl_clk<=~asl_clk;
            end

            if(clk_counter1<8'd216)begin
                clk_counter1<=clk_counter1+1'b1;
            end else begin
                clk_counter1<=0;
                uart_clk<=~uart_clk;
            end
            
        end
        
    end
endmodule