module IRCAMtop(
    input wire clk460k,    
    input UART_RX,
    output reg[15:0]data_out
);
wire data_valid;
wire [7:0]UART_DATA;
wire [7:0]pre_UART_DATA;
reg [15:0] data_counter;
reg[15:0] data_out_tmp=16'b0;

//串口接收模块
 UART_RX UART_RX_inst(
     .clk(clk460k),
     .UART_RX(UART_RX),
     .data_valid(data_valid),
     .UART_DATA(UART_DATA),
     .pre_UART_DATA(pre_UART_DATA)
);
always @(posedge clk460k)begin
    if(data_valid)begin
        if(UART_DATA==8'h5A&&pre_UART_DATA==8'h5A)begin 
                data_counter<=16'd2;
                data_out_tmp<=16'd0;
            end
        else begin
                data_counter<=data_counter+1'b1;
            end   
    if(data_counter>16'd3&&data_counter<16'd1540)begin
        if(data_counter[0]==0)
            begin 
            data_out<=data_out_tmp; 
            data_out_tmp<=UART_DATA;
            end else begin 
             data_out_tmp<=data_out_tmp+256*UART_DATA;             
            end
        end else begin
            data_out<=16'd0;
            
        end
    end
    
end

endmodule