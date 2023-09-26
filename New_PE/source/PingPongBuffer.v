module PingPongBuffer(
    input rst_n,
    input en,   
    
    input input_clk,
    input input_row_clk,
    input input_frame_clk,
    input [7:0]data_in,
    input ioswitch,

    input output_clk,
    input output_column_clk,
    output reg [271:0]data_out

);

wire buffer_clk;
wire A_in,B_in;
reg [7:0]din_A[33:0][33:0];
reg [7:0]din_B[33:0][33:0];

wire [271:0]data_out_tmp_A[33:0];
wire [271:0]data_out_tmp_B[33:0];

wire [7:0]qout_A[33:0][33:0];
wire [7:0]qout_B[33:0][33:0];
wire data_in_en_A[33:0][33:0];
wire data_in_en_B[33:0][33:0];

wire [33:0]data_choose;



    // Generate block
     genvar i,j,m,n,k;
     generate
        for(i=0; i<34; i=i+1) begin:BLOCKA1
            for(j=0; j<34; j=j+1) begin:BLOCKA2
                always@(*)begin
                    if(data_in_en_A[i][j]==1'b1)begin
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
                assign data_out_tmp_A[i][271-8*j:264-8*j]=qout_A[i][j];
            end
        end
        for(m=0; m<34; m=m+1) begin:BLOCKB1
            for(n=0; n<34; n=n+1) begin:BLOCKB2
            always@(*)begin
                    if(data_in_en_B[m][n]==1'b1)begin
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
                assign data_out_tmp_B[m][271-8*n:264-8*n]=qout_B[m][n];
            end
        end
        for(k=0; k<34; k=k+1) begin:BLOCKC
        always@(*)begin
            if(A_in==0&&B_in==1)begin
                if(data_choose[k]==1)begin
                data_out=data_out_tmp_A[k];
            end
            end else begin
                if(data_choose[k]==1)begin
                data_out=data_out_tmp_B[k];
            end
            end
            
            end
        end
     endgenerate




endmodule 