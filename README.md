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
