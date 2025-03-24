module activation_layer #(
    parameter ACT_TYPE = "RELU"  // 激活函数类型: "RELU", "LEAKY_RELU", "SIGMOID", "TANH"
)(
    input  signed [19:0] x,  // 20-bit 输入数据
    output reg signed [7:0] y // 8-bit 输出数据
);

    wire signed [7:0] x_high = x[19:12]; // 取高 8 位

    always @(*) begin
        case (ACT_TYPE)
            "RELU": begin
                y = (x_high > 0) ? x_high : 8'd0;
            end
            
            "LEAKY_RELU": begin
                y = (x_high > 0) ? x_high : (x_high >>> 3); // Leaky factor = 1/8
            end

            "SIGMOID": begin
                // 使用 x[19:14]（6-bit）作为查表索引
                case (x[19:14])
                    6'b000000: y = 8'd0;   // x << 0
                    6'b000001: y = 8'd16;
                    6'b000010: y = 8'd32;
                    6'b000011: y = 8'd48;
                    6'b000100: y = 8'd64;
                    6'b000101: y = 8'd80;
                    6'b000110: y = 8'd96;
                    6'b000111: y = 8'd112;
                    6'b001000: y = 8'd128; // 中心点 x = 0
                    6'b001001: y = 8'd144;
                    6'b001010: y = 8'd160;
                    6'b001011: y = 8'd176;
                    6'b001100: y = 8'd192;
                    6'b001101: y = 8'd208;
                    6'b001110: y = 8'd224;
                    6'b001111: y = 8'd240;
                    default  : y = 8'd255;
                endcase
            end

            "TANH": begin
                // 近似 Tanh 函数：使用 x[19:14]（6-bit）作为查表索引
                case (x[19:14])
                    6'b000000: y = -8'd127;
                    6'b000001: y = -8'd96;
                    6'b000010: y = -8'd64;
                    6'b000011: y = -8'd32;
                    6'b000100: y = -8'd16;
                    6'b000101: y = 8'd0;
                    6'b000110: y = 8'd16;
                    6'b000111: y = 8'd32;
                    6'b001000: y = 8'd64;
                    6'b001001: y = 8'd96;
                    6'b001010: y = 8'd127;
                    default  : y = 8'd127;
                endcase
            end

            default: begin
                y = x_high;  // 未知激活函数，直接输出
            end
        endcase
    end

endmodule
