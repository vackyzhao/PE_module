module tb_new_PE_Unit();
 
 reg clk;
 reg rst_n;
 reg en;

 reg [7:0] Ifmap_shift_in = 0;
 reg [11:0] Filtr_in = 0;
 reg [13:0] Psum_in = 0;

 wire [7:0]  ref_Ifmap_shift_out, Ifmap_shift_out;
 wire [11:0] ref_Filtr_out, Filtr_out;
 wire [13:0] ref_Psum_out, Psum_out;


/////////////////////////////////////////
// Open Files
integer read_file;
integer write_file;

initial 
	begin

	read_file  = $fopen("/home/ICer/XUtest/PE/goldenbrick3.txt", "r");
	write_file = $fopen("/home/ICer/XUtest/PE/testbench3.txt", "w");

/////////////////////////////////////////
// Set up signals

	clk = 1'b0;
    rst_n = 0;
    en = 0;

    #10 
    rst_n = 1;
    #10 
    en = 1; 

	end

/////////////////////////////////////////
// Do file IO 
always @(posedge clk) 
	begin	
	$fscanf(read_file, "Ifmap_shift_in = %b\t Filter_in = %b\t Psum_in = %b\t Psum_out = %b\t", 
            Ifmap_shift_in, Filtr_in, Psum_in, ref_Psum_out); 
	if (!$feof(read_file))
		begin
		if (ref_Psum_out == Psum_out)
		$fdisplay(write_file, "Ifmap_shift_in = %b\t Filter_in = %b\t Psum_in = %b\t RefPsum_out = %b\t Psum_out = %b pass", 
            Ifmap_shift_in, Filtr_in, Psum_in, ref_Psum_out, Psum_out); 
		else
		$fdisplay(write_file, "Ifmap_shift_in = %b\t Filter_in = %b\t Psum_in = %b\t RefPsum_out = %b\t Psum_out = %b fail", 
            Ifmap_shift_in, Filtr_in, Psum_in, ref_Psum_out, Psum_out); 
		end
	else	
		begin
		$fclose(read_file);
		$fclose(write_file);
		$finish;
		end
	end

/////////////////////////////////////////
// Set up DUT
new_PE_Unit new_PE_Unit(
    .clk(clk),  //PE 时钟(3倍频clk时钟)
    .rst_n(rst_n),  //复位信号，低有效
    .en(en),  //使能信号，高有效   

    .Filtr_in(Filtr_in),// 输入权重 4位*3通道（卷积核） (Input weights 4-bit * 3 channels, convolution kernel)   
    .Ifmap_shift_in(Ifmap_shift_in),// 输入特征图 8位*3通道（数据） (Input feature map 8-bit * 3 channels, data)
    .Psum_in(Psum_in),

    .Ifmap_shift_out(Ifmap_shift_out),// 输出特征图 8位*3通道（数据） (Output feature map 8-bit * 3 channels, data)
    .Filtr_out(Filtr_out),
    .Psum_out(Psum_out)  //输出计算结果   
);

/////////////////////////////////////////
// Run Simulation
always @(*)
begin
#5 clk <= ~ clk;
end
 
endmodule