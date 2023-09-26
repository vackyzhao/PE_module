module PingPongBuffer(
    input rst_n,//全局重置信号
    input en,   //全局使能
    
    input input_clk,//输入时钟
    input input_row_clk,//输入行时钟
    input input_frame_clk,//输入帧时钟
    input [7:0]data_in,//输入数据
    
    input ioswitch,//切换信号

    input output_clk,//输出时钟
    input output_column_clk,//输出列时钟
    output reg [271:0]data_out //输出数据

);

reg buffer_clk;//缓存时钟信号
reg data_in_en_A[33:0][33:0];//储存A的写入状态
reg data_in_en_B[33:0][33:0];//储存B的写入状态

reg [7:0]din_A[33:0][33:0];//暂存A输入
reg [7:0]din_B[33:0][33:0];//暂存B输入
wire [7:0]qout_A[33:0][33:0];//暂存A输出
wire [7:0]qout_B[33:0][33:0];//暂存B输出

wire [271:0]data_out_bus_A[33:0];
wire [271:0]data_out_bus_B[33:0];

reg [5:0]data_out_choose;

always@(*)begin//AB时钟控制
    if(ioswitch==1'b1)begin
        buffer_clk<=input_clk;
    end else begin
        buffer_clk<=output_clk;
    end
end


    // Generate block
     genvar i,j,m,n,k;
     generate
        for(i=0; i<34; i=i+1) begin:BLOCKA1
            for(j=0; j<34; j=j+1) begin:BLOCKA2
                always@(*)begin
                    if(data_in_en_A[i][j]==1'b0)begin
                       din_A[i][j] = qout_A[i][j];
                    end
                    else begin
                        din_A[i][j]=data_in;
                    end
                end                
                sirv_gnrl_dfflr #(8) reg_A (
                    .lden(en),
                    .dnxt(din_A[i][j]),
                    .qout(qout_A[i][j]),
                    .clk(buffer_clk),
                    .rst_n(rst_n)
                );
                assign data_out_bus_A[i][271-8*j:264-8*j]=qout_A[i][j];
            end
        end
        for(m=0; m<34; m=m+1) begin:BLOCKB1
            for(n=0; n<34; n=n+1) begin:BLOCKB2
            always@(*)begin
                    if(data_in_en_B[m][n]==1'b0)begin
                       din_B[m][n] = qout_B[m][n];
                    end
                    else begin
                        din_B[m][n]=data_in;
                    end
                end
                sirv_gnrl_dfflr #(8) reg_B (
                    .lden(en),
                    .dnxt(din_B[m][n]),
                    .qout(qout_B[m][n]),
                    .clk(buffer_clk),
                    .rst_n(rst_n)
                );
                assign data_out_bus_B[m][271-8*n:264-8*n]=qout_B[m][n];
            end
        end
        for(k=0; k<34; k=k+1) begin:BLOCKC
        always@(*)begin
            if(ioswitch)begin
            data_out <= data_out_bus_A[integer(data_out_choose)]; 
            end else begin
            data_out <= data_out_bus_B[integer(data_out_choose)]; 
            end           
            end
        end
     endgenerate




endmodule 