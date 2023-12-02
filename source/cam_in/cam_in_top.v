module cam_in (
    //camera part
    input uart_clk,//115200
    input uart_rx,//camera data in
    //accelerator part
    input clk,//every clock output 26*8 data
    input rst_n,
    output reg[1:0] dout_counter,
    output reg dout_valid,
    output reg dout_valid_cycle,//dout valid signal, high enable,continue 34clock;
    output  reg [207:0] dout //26
);
reg [7:0]data_counter;
wire  [207:0] dout_o;
reg [9:0] raddr,waddr;
wire [9:0] waddr_i;
reg wen;
wire uart_data_valid;
wire [7:0] uart_data,pre_uart_data;
reg dout_finish_flag;
UART_RX UART_RX_inst(
     .clk(uart_clk),           // 时钟信号
     .UART_RX(uart_rx),       // UART接收线
     .data_valid(uart_data_valid),
     .UART_DATA(uart_data),
     .pre_UART_DATA(pre_uart_data) // 存储接收到的数据
);  
CAM_SRAM CAM_SRAM_inst(
  .clk(clk),          // 时钟信号
  .rst_n(rst_n),        // 复位信号
  .datain(uart_data), // 写入数据
  .wen(wen),          // 读写使能信号
  .raddr(raddr),   // 读地址输入
  .waddr(waddr_i),   // 写地址输入
 .dataout(dout_o) // 26个数据的并行输出
);

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin        
    raddr<=10'b0;
    wen<=1'b0;
    dout_valid<=1'b0;
    dout_finish_flag<=1;
    dout_valid_cycle<=0;
    data_counter<=8'b0;
    dout_counter<=2'b0;
    end
    else begin
        
        if(uart_data_valid&&uart_data==8'h5A&&pre_uart_data==8'h5A&&wen==1'b0&&dout_finish_flag) begin
            wen<=1'b1;
            dout_finish_flag<=0;
        end else if(waddr==10'd884&&!dout_finish_flag) begin
            wen<=1'b0;            
        end
        if(!wen&&waddr==10'd884&&dout_finish_flag==0)begin
            dout_valid<=1'b1;
            if(data_counter<10'd165)begin
            data_counter<=data_counter+1'b1;
            if((data_counter%44)<34)begin
                dout_valid_cycle<=1;
                raddr<=data_counter%44+1;
                dout_counter<=data_counter/44;
            end else begin
                dout_valid_cycle<=0;
                raddr<=0;
            end
            end else begin
                raddr<=0;
                data_counter<=10'd0;
                dout_valid<=1'b0;
                dout_valid_cycle<=0;
                dout_finish_flag<=1;
                dout_counter<=2'b0;
            end
        end
        
    end
end

//写入操作
always@(posedge uart_data_valid or negedge rst_n)begin
    if(!rst_n)begin  
        waddr<=10'b0;
    end
    else begin


        if(wen==1'b1)  begin
            if(waddr<10'd884)begin
            waddr<=waddr+1'b1;
            end else begin
                waddr<=10'd0;
            end
        end  
        if(dout_finish_flag==1)begin
            waddr<=10'd0;
        end
        
        
    end
    
end

assign waddr_i=waddr-1'b1;

always@(*)begin
    if(dout_valid&&dout_valid_cycle) begin
        dout<=dout_o;
    end else begin
        dout<=208'b0;
    end
end
endmodule