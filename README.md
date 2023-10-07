# PE_module
**new_PE_Unit 输入输出:**

```verilog
module new_PE_Unit (
    input clk,               // PE模块的时钟信号
    input rst_n,             // 复位信号，低电平有效 
    input en,                // 使能信号 

    input [11:0] Filtr_in,   // 输入权重 4位 *3(卷积核）
    input [7:0] Ifmap_shift_in,   // 移位输入特征图 8位（数据）   
    input [13:0] Psum_in,    // 输入上一个PE的结果 

    output reg [11:0] Filtr_out,   // 输出权重 4位 *3(卷积核） 
    output  [7:0] Ifmap_shift_out, // 脉动输出特征图 8位（数据）
    output reg [13:0] Psum_out   // 输出计算结果 14位 (结果) 
);
```
**详细说明:**

该 Verilog 模块描述了一个 PE（处理元件）模块，用于卷积计算。以下是模块的主要输入和输出：
```verilog
    clk：时钟信号，用于同步操作。
    rst_n：复位信号，低电平有效。
    en：使能信号，用于启用或禁用模块的操作。
```
**输入端口：**
```verilog
    Filtr_in：输入权重，共 4 位 * 3（卷积核）。
    Ifmap_shift_in：移位输入特征图，共 8 位（数据）。
    Psum_in：输入上一个 PE 的计算结果，共 14 位（结果）。
```
**输出端口：**
```verilog
    Filtr_out：输出权重，共 4 位 * 3（卷积核）。
    Ifmap_shift_out：脉动输出特征图，共 8 位（数据）。
    Psum_out：输出计算结果，共 14 位（结果）。
```
**内部实现细节:**

该模块内部使用了流水线乘法器 IP 核，每经过 3 个时钟周期，将输出一个乘法结果。同时，由于使用了移位寄存器，因此在启动 3 个时钟周期之后，移位寄存器才会输出有效数据。之后每个时钟周期都会输出有效结果。最终的计算结果 Psum_out 使用寄存器进行存储。

内部移位寄存器的宽度为 24 位（8 位 * 3），用于储存输入数据。输入数据通过移位寄存器左移输入，权重和数据储存方式都为 LSB（最低有效位）。

对于每个时钟周期（n 表示时钟周期），计算 Psum_out 的公式如下：
```math
$$ PsumOut_{(n)}[13:0] = PsumIn_{(n)}[13:0] + FiltrIn_{(n)}[11:8]*IfmapShiftIn_{(n-6)}[7:0] + FiltrIn_{(n)}[7:4]*IfmapShiftIn_{(n-5)}[7:0] + FiltrIn_{(n)}[3:0]*IfmapShiftIn_{(n-4)}[7:0] $$
```

这个公式表示在每个时钟周期中，将上一个 PE 的计算结果 Psum_in 与输入权重 Filtr_in 和移位后的特征图 Ifmap_shift_in 进行乘法运算，并将结果累加到当前的 Psum_out 中。


**tb样例**

见PE_module\New_PE\testbenchnew_PE_tb.png


**PE_module**

new_PE_Unit Input and Output:

```verilog

module new_PE_Unit (
    input clk,               // Clock signal for the PE module
    input rst_n,             // Reset signal, active low
    input en,                // Enable signal

    input [11:0] Filtr_in,   // Input weights, 4 bits * 3 (convolution kernel)
    input [7:0] Ifmap_shift_in,   // Shifted input feature map, 8 bits (data)
    input [13:0] Psum_in,    // Input result from the previous PE

    output reg [11:0] Filtr_out,   // Output weights, 4 bits * 3 (convolution kernel)
    output [7:0] Ifmap_shift_out, // Pulsed output feature map, 8 bits (data)
    output reg [13:0] Psum_out   // Output computed result, 14 bits (result)
);
```
Detailed Description:

This Verilog module describes a Processing Element (PE) module used for convolution calculations. Here are the main inputs and outputs of the module:

```verilog

    clk: Clock signal for synchronization.
    rst_n: Reset signal, active low.
    en: Enable signal to enable or disable the module's operation.
```
Input Ports:

```verilog

    Filtr_in: Input weights, a total of 4 bits * 3 (convolution kernel).
    Ifmap_shift_in: Shifted input feature map, 8 bits (data).
    Psum_in: Input result from the previous PE, 14 bits (result).
```
Output Ports:

```verilog

    Filtr_out: Output weights, a total of 4 bits * 3 (convolution kernel).
    Ifmap_shift_out: Pulsed output feature map, 8 bits (data).
    Psum_out: Output computed result, 14 bits (result).
```
Internal Implementation Details:

The module internally uses a pipeline multiplier IP core, which outputs a multiplication result every 3 clock cycles. Additionally, due to the use of shift registers, valid data is only available after 3 clock cycles have passed. After that, valid results are produced every clock cycle. The final calculated result, Psum_out, is stored using registers.

The width of the internal shift register is 24 bits (8 bits * 3) and is used to store input data. Input data is left-shifted through the shift register, and both weights and data are stored in LSB (Least Significant Bit) order.

For each clock cycle (n denotes the clock cycle), the formula for calculating Psum_out is as follows:

```math

$$ PsumOut_{(n)}[13:0] = PsumIn_{(n)}[13:0] + FiltrIn_{(n)}[11:8]*IfmapShiftIn_{(n-6)}[7:0] + FiltrIn_{(n)}[7:4]*IfmapShiftIn_{(n-5)}[7:0] + FiltrIn_{(n)}[3:0]*IfmapShiftIn_{(n-4)}[7:0] $$
```
This formula indicates that in each clock cycle, the previous PE's computed result, Psum_in, is multiplied with input weights, Filtr_in, and the shifted feature map, Ifmap_shift_in, and the results are accumulated into the current Psum_out.

Testbench Example:

Refer to the image "testbenchnew_PE_tb.png" in the PE_module\New_PE directory for a testbench example.

```
D:.
│  PE_1x3_module.v             - 一个名为PE_1x3_module的Verilog模块文件
│  PE_34x3_module.v            - 一个名为PE_34x3_module的Verilog模块文件
│  PE_unit.v                   - 一个名为PE_unit的Verilog模块文件
│  README.md                   - 项目的说明文档，通常包含项目的概述和使用说明
│  tb_PEx3_module.v            - 用于测试PE_1x3_module和PE_34x3_module的Verilog测试模块
│
└─New_PE                        - 一个名为New_PE的文件夹
    ├─ip                        - 存放IP（知识产权）相关文件的文件夹
    │  └─mult_gen_0             - 一个名为mult_gen_0的文件夹，可能包含IP配置文件
    │          mult_gen_0.xci   - IP配置文件（Xilinx IP核）
    │
    ├─source                    - 存放项目源代码的文件夹
    │      clockDivider34.v     - 时钟分频模块的Verilog文件
    │      input_pre_data_module.v - 输入数据预处理模块的Verilog文件
    │      input_pre_sram.v      - 输入数据预处理SRAM模块的Verilog文件
    │      middle_new_PE.v       - 中间新型PE模块的Verilog文件
    │      middle_new_PEx2.v     - 中间新型PEx2模块的Verilog文件
    │      middle_new_PEx32.v    - 中间新型PEx32模块的Verilog文件
    │      mult_ip.v             - 乘法IP核的Verilog文件
    │      new_PE.v              - 新PE模块的Verilog文件
    │      PingPongBuffer.v      - PingPong缓冲区模块的Verilog文件
    │      shift_register.v      - 移位寄存器模块的Verilog文件
    │      sirv_gnrl_dffs.v      - D型触发器模块的Verilog文件
    │      testMult.v            - 乘法IP核的测试模块的Verilog文件
    │
    └─testbench                  - 存放测试模块的文件夹
            new_PE_tb.png        - New_PE模块的测试图像（波形图）
            tb_clockDivider.v    - 用于测试时钟分频模块的Verilog测试模块
            tb_input_pre_sram.v  - 用于测试输入数据预处理SRAM模块的Verilog测试模块
            tb_middle_new_PE.v    - 用于测试中间新型PE模块的Verilog测试模块
            tb_middle_new_PEx2.v  - 用于测试中间新型PEx2模块的Verilog测试模块
            tb_middle_new_PEx32.v - 用于测试中间新型PEx32模块的Verilog测试模块
            tb_mult_ip.v          - 用于测试乘法IP核的Verilog测试模块
            tb_mult_test.v        - 用于测试乘法IP核的测试模块
            tb_new_PE_module.v    - 用于测试新型PE模块的Verilog测试模块
            tb_PingPongBuffer.v   - 用于测试PingPong缓冲区模块的Verilog测试模块
            tb_shift_register.v   - 用于测试移位寄存器模块的Verilog测试模块
```


# Input_pre_data_module
模块内部例化：sirv_gnrl_dfflr // 实例化通用 DFF 寄存器模块，用于行地址寄存器
            clockDivider32  // 实例化时钟分频器模块，将 dout_clk 32分频为 PEclk
            PingPongBuffer  // 实例化 PingPongBuffer 模块
模块参数：

    buffer_DP（输入缓存大小）：一个整数参数，表示输入数据的缓存大小，默认值为 1024。

    data_DP（经过 padding 后的大小）：一个整数参数，表示经过填充后的数据大小，默认值为 1156。

模块端口：

    din_clk（输入摄像头时钟）：输入的摄像头时钟信号。

    i_data_din（输入摄像头数据）：8位输入数据信号，来自摄像头。

    i_data_din_vld（输入数据有效信号）：输入数据的有效信号，指示数据是否有效。

    input_padding（输入填充参数）：8位输入参数，用于填充数据的首尾。

    dout_clk（输入时钟）：输入输出数据的时钟信号。

    en（使能）：使能信号，控制模块的操作。

    rst_n（复位）：复位信号，用于重置模块的状态和计数器。

    PEclk（输出 PE 时钟）：用于输出的 PE 时钟信号。

    out_data_vld（缓冲就绪标志）：输出的缓冲就绪标志，表示输出数据是否准备就绪。

    parallel_data（272位并行数据输出）：输出的 272 位并行数据。

这个模块的主要任务是接收输入数据并进行数据填充，同时管理时钟，计数器和输出数据的生成。最终，它将填充后的数据以并行方式输出到 parallel_data，并通过 out_data_vld 信号指示数据是否准备好。
以下是模块的主要功能：

    输入数据接收： 模块接收来自摄像头的输入数据，包括图像数据和数据有效信号。

    数据填充： 模块使用输入的填充参数 input_padding 在输出数据的首尾位置进行数据填充。这是为了确保数据在后续处理中具有正确的边界。

    时钟管理： 模块使用 din_clk 和 dout_clk 两个时钟信号来同步输入和输出数据。它还实例化了一个时钟分频器，将输入时钟 dout_clk 分频为PE时钟 PEclk。

    行计数器管理： 模块使用通用DFF寄存器来管理行计数器，以确定当前处理的图像行数。这有助于控制数据流的顺序。

    数据缓存和切换： 模块实例化了 PingPongBuffer 模块，用于数据的缓存和切换功能。具体的缓存和切换操作在模块内部的 PingPongBuffer 模块中进行，但在提供的代码中未包含其详细定义。

    数据输出： 模块根据PE时钟和输入数据流的状态，以及缓存状态，从输入数据流中提取数据，并将处理后的数据以并行方式输出到 parallel_data。out_data_vld 信号用于指示输出数据是否准备就绪。

    复位和状态管理： 模块包括复位逻辑，以确保在启动时，所有计数器和状态都被正确初始化。


# Input_pre_data_module

Internal module instantiations: sirv_gnrl_dfflr // Instantiate the general-purpose DFF register module for row address register
                                clockDivider32 // Instantiate the clock divider module to divide dout_clk by 32
                                PingPongBuffer // Instantiate the PingPongBuffer module

Module parameters:

    buffer_DP (Input buffer size): An integer parameter representing the size of the input data buffer, with a default value of 1024.

    data_DP (Size after padding): An integer parameter representing the size of the data after padding, with a default value of 1156.

Module ports:

    din_clk (Input camera clock): Input signal for the camera clock.

    i_data_din (Input camera data): 8-bit input data signal coming from the camera.

    i_data_din_vld (Input data valid signal): Valid signal for the input data, indicating whether the data is valid.

    input_padding (Input padding parameter): 8-bit input parameter used to pad data at the beginning and end.

    dout_clk (Input clock): Clock signal for input and output data.

    en (Enable): Enable signal to control the module's operation.

    rst_n (Reset): Reset signal to reset the module's state and counters.

    PEclk (Output PE clock): PE clock signal used for output.

    out_data_vld (Buffer ready flag): Output flag indicating whether the output data is ready.

    parallel_data (272-bit parallel data output): Output data in parallel with 272 bits.

The main task of this module is to receive input data and perform data padding while managing clocks, counters, and output data generation. Ultimately, it outputs the padded data in parallel to parallel_data and indicates whether the data is ready through the out_data_vld signal.

Here are the main functionalities of the module:

    Input Data Reception: The module receives input data from the camera, including image data and data valid signals.

    Data Padding: The module uses the input padding parameter input_padding to pad data at the beginning and end of the output data. This ensures that the data has the correct boundaries for subsequent processing.

    Clock Management: The module uses the din_clk and dout_clk clock signals to synchronize input and output data. It also instantiates a clock divider to divide the input clock dout_clk by 32, creating the PE clock PEclk.

    Row Counter Management: The module uses a general-purpose DFF register to manage the row counter, determining the current image row being processed. This helps control the sequence of data flow.

    Data Buffering and Switching: The module instantiates the PingPongBuffer module for data buffering and switching functions. Specific buffering and switching operations are performed within the PingPongBuffer module, but detailed definitions are not included in the provided code.

    Data Output: The module extracts data from the input data stream based on the PE clock and the status of the input data stream, as well as the buffer status. It outputs the processed data in parallel to parallel_data. The out_data_vld signal indicates whether the output data is ready.

    Reset and State Management: The module includes reset logic to ensure that all counters and states are correctly initialized at startup.
