`timescale 1ns / 1ps

module tb_soc_top;

    // 信号声明
    //reg uart_clk;
    reg uart_rx;
    reg clk;
    reg rst_n;
    wire dout_valid;
    wire [4:0] dout;
    wire conv1_dout_vald,fm_data_valid,pool1_dout_vald,pool2_dout_vald,conv2_dout_vald,o_rst_n;

    soc_top uut (
    .clk_50M(clk),

    .i_cam_data(uart_rx),
    .i_rst_n(rst_n),  
    .o_result_data(dout),  // 输出：结果数�?
    .fm_data_valid(fm_data_valid),
    .conv1_dout_vald(conv1_dout_vald),
    .pool1_dout_vald(pool1_dout_vald),
    .pool2_dout_vald(pool2_dout_vald), 
    .conv2_dout_vald(conv2_dout_vald),
    .o_rst_n(o_rst_n),
    .o_result_data_valid(dout_valid)  // 输出：结果数据有效信�?
);
//2,12,868
  //6,434 

    // 时钟生成
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end
/*
    reg [13:0] in_cam_i;
    initial in_cam_i = 0;
    always @(posedge uart_clk) begin
        // Wait for 1704 clock cycles
        if (in_cam_i < 15439)
            in_cam_i <= in_cam_i + 1;
        else
            in_cam_i <= 0;
    end

    reg [7:0] cam_data_array [0:15440]; // Size of the array to match the number of data points

    initial begin
        // Initialize cam_data_array with values from file
        $readmemb("camera_data.txt", cam_data_array);
    end

    assign uart_rx = cam_data_array[in_cam_i][0];
*/
    // Clock generation
    
integer i,j;
    // 初始�?
    initial begin
        rst_n = 1; // 初始化复位信号为高电�?
        uart_rx=1;

        // 模块初始�?
        #100 rst_n = 0; // 持续�?段时间的复位信号低电�?
        #5000 rst_n = 1; // 恢复复位信号为高电平
        
        #868 uart_rx=0;//START_BIT
        
        #868 uart_rx=0;
        #868 uart_rx=1;
        #868 uart_rx=0;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=0;
        #868 uart_rx=1;
        #868 uart_rx=0;

        #868 uart_rx=1;//STOP_BIT 

        #868 uart_rx=0;//START_BIT
        
        #868 uart_rx=0;
        #868 uart_rx=1;
        #868 uart_rx=0;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=0;
        #868 uart_rx=1;
        #868 uart_rx=0;

        #868 uart_rx=1;//STOP_BIT


for(i=0;i<13;i=i+1)begin
         #868 uart_rx=0;//START_BIT
        
        #868 uart_rx=0;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;

        #868 uart_rx=1;//STOP_BIT

    #868 uart_rx=0;//START_BIT
        
        #868 uart_rx=0;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;

        #868 uart_rx=1;//STOP_BIT

end
for(j=1;j<34;j=j+1)begin
for(i=0;i<13;i=i+1)begin
         #868 uart_rx=0;//START_BIT
        
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;

        #868 uart_rx=1;//STOP_BIT

    #868 uart_rx=0;//START_BIT
        
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=1;

        #868 uart_rx=1;//STOP_BIT

end
end

#5000
 #868 uart_rx=0;//START_BIT
        
        #868 uart_rx=0;
        #868 uart_rx=1;
        #868 uart_rx=0;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=0;
        #868 uart_rx=1;
        #868 uart_rx=0;

        #868 uart_rx=1;//STOP_BIT 

        #868 uart_rx=0;//START_BIT
        
        #868 uart_rx=0;
        #868 uart_rx=1;
        #868 uart_rx=0;
        #868 uart_rx=1;
        #868 uart_rx=1;
        #868 uart_rx=0;
        #868 uart_rx=1;
        #868 uart_rx=0;

        #868 uart_rx=1;//STOP_BIT

for(j=0;j<34;j=j+1)begin
for(i=0;i<13;i=i+1)begin
         #868 uart_rx=0;//START_BIT
        
        #868 uart_rx=0;
        #868 uart_rx=0;
        #868 uart_rx=0;
        #868 uart_rx=0;
        #868 uart_rx=0;
        #868 uart_rx=0;
        #868 uart_rx=0;
        #868 uart_rx=0;

        #868 uart_rx=1;//STOP_BIT

    #868 uart_rx=0;//START_BIT
        
        #868 uart_rx=0;
        #868 uart_rx=0;
        #868 uart_rx=0;
        #868 uart_rx=0;
        #868 uart_rx=0;
        #868 uart_rx=0;
        #868 uart_rx=0;
        #868 uart_rx=0;

        #868 uart_rx=1;//STOP_BIT

end
end

   

        // 停止仿真
        //#10 $stop;
    end

endmodule
