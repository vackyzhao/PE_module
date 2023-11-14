module UART_RX (
    input clk,           // 时钟信号
    input UART_RX,       // UART接收线
    output reg data_valid,
    output reg [7:0] UART_DATA,pre_UART_DATA // 存储接收到的数据
);

// 定义状态
parameter START_BIT   = 4'b0000;
parameter DATA_BITS_0 = 4'b0001;
parameter DATA_BITS_1 = 4'b0010;
parameter DATA_BITS_2 = 4'b0011;
parameter DATA_BITS_3 = 4'b0100;
parameter DATA_BITS_4 = 4'b0101;
parameter DATA_BITS_5 = 4'b0111;
parameter DATA_BITS_6 = 4'b1000;
parameter DATA_BITS_7 = 4'b1001; // 添加第8位数据
parameter STOP_BIT    = 4'b1010; // 停止位状态

reg [3:0] state;        // 状态寄存器
reg [7:0] data_reg;     // 数据寄存器，用于接收8位数据
always @(posedge clk) begin
    case (state)
        START_BIT: begin
            data_valid<=1'b0;
            // 当在空闲状态检测到起始位时，将状态转换为START_BIT
            if (!UART_RX) begin                
                state <= DATA_BITS_0;
            end else begin 
                state <= START_BIT;
                end
        end     
        DATA_BITS_0: begin
            state <= DATA_BITS_1;
            data_reg[0] <= UART_RX;
        end
        DATA_BITS_1: begin
            state <= DATA_BITS_2;
            data_reg[1] <= UART_RX;
        end
        DATA_BITS_2: begin
            state <= DATA_BITS_3;
            data_reg[2] <= UART_RX;
        end
        DATA_BITS_3: begin
            state <= DATA_BITS_4;
            data_reg[3] <= UART_RX;
        end
        DATA_BITS_4: begin
            state <= DATA_BITS_5;
            data_reg[4] <= UART_RX;
        end
        DATA_BITS_5: begin
            state <= DATA_BITS_6;
            data_reg[5] <= UART_RX;
        end
        DATA_BITS_6: begin
            state <= DATA_BITS_7;
            data_reg[6] <= UART_RX; // 添加第8位数据
        end
        DATA_BITS_7: begin
            state <= STOP_BIT;
            data_reg[7] <= UART_RX; // 添加第8位数据
        end
        STOP_BIT: begin            
                    pre_UART_DATA=UART_DATA;
                    UART_DATA <= data_reg;
                    data_valid<=1'b1;
                    state <= START_BIT;                          
        end     
        
        default: state <= START_BIT;
    endcase
end

endmodule
