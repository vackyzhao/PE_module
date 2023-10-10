module top(
    input                           clk,               // clk
    input                           rst_n,             // 复位信号
    inout                           cmos_scl,          // CMOS I2C 时钟
    inout                           cmos_sda,          // CMOS I2C 数据
    input                           cmos_vsync,        // CMOS 垂直同步信号
    input                           cmos_href,         // CMOS 水平同步和数据有效信号
    input                           cmos_pclk,         // CMOS 像素时钟
    output                          cmos_xclk,         // CMOS 外部时钟
    input   [7:0]                   cmos_db,           // CMOS 数据
    output                          cmos_rst_n,        // CMOS 复位信号
    output                          cmos_pwdn,         // CMOS 电源关闭

    output clkout100M,clkout400M,clkout200M,

    output  sys_run, cam_run, rst_led              // 系统运行、相机运行、复位 LED
);


wire                                video_clk;         // 视频像素时钟
wire                                hs;                // 水平同步
wire                                vs;                // 垂直同步
wire                                de;                // 数据有效
wire[15:0]                          vout_data;         // 视频输出数据
wire[15:0]                          cmos_16bit_data;   // CMOS 16位数据
wire[15:0]                          write_data;        // 写入数据

wire[9:0]                           lut_index;         // 查找表地址
wire[31:0]                          lut_data;          // 查找表数据

assign lcd_hs = hs;                                    // 将 LCD 水平同步连接到 hs 信号
assign lcd_vs = vs;                                    // 将 LCD 垂直同步连接到 vs 信号
assign lcd_de = de;                                    // 将 LCD 数据有效连接到 de 信号
assign lcd_r  = vout_data[15:11];                      // 将 LCD 红色通道连接到 vout_data 的相应位
assign lcd_g  = vout_data[10: 5];                      // 将 LCD 绿色通道连接到 vout_data 的相应位
assign lcd_b  = vout_data[ 4: 0];                      // 将 LCD 蓝色通道连接到 vout_data 的相应位
assign lcd_dclk = ~video_clk;                          // LCD 数据时钟与视频像素时钟取反连接

assign cmos_xclk = cmos_clk;                           // 将 CMOS 外部时钟连接到 cmos_clk 信号
assign cmos_pwdn = 1'b0;                               // 将 CMOS 电源关闭连接到低电平
assign cmos_rst_n = 1'b1;                              // 将 CMOS 复位信号连接到高电平
assign rst_led = rst_n;                                // 将复位 LED 信号连接到 rst_n 信号
assign write_data = {cmos_16bit_data[4:0], cmos_16bit_data[10:5], cmos_16bit_data[15:11]}; // 将写入数据连接到 CMOS 16 位数据

reg [5:0] vs_running;                                  // 垂直同步运行计数器
assign sys_run = vs_running[5];                        // 将系统运行信号连接到 vs_running 的最高位
always @(posedge lcd_vs)
    vs_running <= vs_running + 6'd1;                  // 在 LCD 垂直同步上升沿计数

reg [5:0] cam_running;                                // 相机运行计数器
assign cam_run = cam_running[5];                      // 将相机运行信号连接到 cam_running 的最高位
always @(posedge cmos_vsync)
    cam_running <= cam_running + 6'd1;                // 在 CMOS 垂直同步上升沿计数

Gowin_PLL Gowin_PLL_instance100M(
        .clkout0(clkout100M), //output clkout0
        .clkin(clk) //input clkin
    );

Gowin_PLL_200M Gowin_PLL_200M_instance(
        .clkout0(clkout200M), //output clkout0
        .clkin(clk) //input clkin
    );
Gowin_PLL400M Gowin_PLL400M_instance(
        .clkout0(clkout400M), //output clkout0
        .clkin(clk) //input clkin
    );

// 生成 CMOS 传感器时钟和 SDRAM 控制器时钟
cmos_pll cmos_pll_m0(
    .clkin                     (video_clk                ), // 输入时钟
    .clkout                    (cmos_clk                 )  // 输出时钟
);



// I2C 主控制器
i2c_config i2c_config_m0(
    .rst                        (~rst_n                   ), // 复位信号
    .clk                        (clk                      ), // 输入时钟
    .clk_div_cnt                (16'd500                  ), // 时钟分频计数
    .i2c_addr_2byte             (1'b1                     ), // I2C 地址为两字节
    .lut_index                  (lut_index                ), // 查找表地址
    .lut_dev_addr               (lut_data[31:24]          ), // 查找表中的设备地址
    .lut_reg_addr               (lut_data[23:8]           ), // 查找表中的寄存器地址
    .lut_reg_data               (lut_data[7:0]            ), // 查找表中的寄存器数据
    .error                      (                         ), // 错误信号
    .done                       (                         ), // 完成信号
    .i2c_scl                    (cmos_scl                 ), // I2C 时钟线
    .i2c_sda                    (cmos_sda                 )  // I2C 数据线
);

// 配置查找表
lut_ov5640_rgb565_480_272 lut_ov5640_rgb565_480_272_m0(
    .lut_index                  (lut_index                ), // 查找表地址
    .lut_data                   (lut_data                 )  // 查找表数据
);




endmodule
