`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/08 19:14:10
// Design Name: 
// Module Name: Input_pre_data_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Input_pre_data_module
#
(
	parameter PS_CLEAR_LENGTH=34*34
)
(
	input i_clk,
	input i_rst_n,
	/////////////////////////////////
	input i_ps_clear_buffer,
	output o_pl_buffer_ready,
	/////////////////////////////////
	input i_pre_mode,///0:addr_map 1:all_connect     
	input i_out_choose,
	
	input [15:0] i_fm_row,
	input [15:0] i_fm_col,
	input [15:0] i_fm_n,
	
	input [7:0] i_dma_din,
	input i_dma_din_vld,
	
	input [15:0] i_conv_addr,
	
	output [7:0] o_conv_din,
	output o_dma_write_last
    );

/////////////////////////////////////////// ps_clear
wire ps_clear_posedge;
reg ps_clear_d1;
always@(posedge i_clk)
begin
	if(!i_rst_n)
		begin
			ps_clear_d1<=0;
		end
	else
		begin
			ps_clear_d1<=i_ps_clear_buffer;
		end
end

assign ps_clear_posedge = i_ps_clear_buffer & (~ps_clear_d1);

reg write_ctrl;
reg pl_buf_ready;

always@(posedge i_clk)	
begin
	if(!i_rst_n)
		begin
			write_ctrl<=0;
		end
	else
		begin
			if(ps_clear_posedge)
				begin
					write_ctrl<=1;
				end
			else	
				begin
					if(pl_buf_ready)
						begin
							write_ctrl<=0;
						end
					else
						begin
							write_ctrl<=write_ctrl;
						end
				end
		end
end

reg [31:0] pl_write_data;
reg [15:0] pl_write_addr;
reg pl_write_en;

always@(posedge i_clk)
begin
	if(!i_rst_n)
		begin
			pl_buf_ready<=0;
			pl_write_data<=0;
			pl_write_addr<=0;
			pl_write_en<=0;
		end
	else
		begin
			if(write_ctrl)
				begin
					if(pl_write_addr<PS_CLEAR_LENGTH)
						begin
							pl_write_addr<=pl_write_addr+1;
						end
					else
						begin
							pl_write_addr<=0;
							pl_buf_ready<=1;
						end
					pl_write_data<=0;
					pl_write_en<=1;
				end
			else
				begin
					pl_write_addr<=0;
					pl_write_data<=0;
					pl_write_en<=0;
					
					if(i_dma_din_vld)
						begin
							pl_buf_ready<=0;
						end
				end
		end
end

assign o_pl_buffer_ready=pl_buf_ready;
/////////////////////////////////////////////
parameter ping=1'b0;
parameter pang=1'b1;	

reg buf_state;
reg [1:0] runing_state;
reg [15:0] fm_row;
reg [15:0] fm_col;
reg [15:0] fm_n;

reg [7:0] ps_write_data0;
reg [15:0] ps_write_addr0;
reg ps_write_en0;

reg [7:0] ps_write_data1;
reg [15:0] ps_write_addr1;
reg ps_write_en1;

reg first_flag;
reg dma_over;

always@(posedge i_clk)	
begin
	if(!i_rst_n||ps_clear_posedge)
		begin
			buf_state<=1'b0;
			
			fm_row<=0;
			fm_col<=0;
			fm_n<=0;

			ps_write_data0<=0;
			ps_write_addr0<=0;
			ps_write_en0<=0;
			
			ps_write_data1<=0;
			ps_write_addr1<=0;
			ps_write_en1<=0;
			
			first_flag<=0;
			runing_state<=2'b00;
			dma_over<=0;
			
		end
	else
		begin
			case(i_pre_mode)
			1'b0:
				begin
					case(buf_state)
					ping:
						begin
							case(runing_state)
							2'b00:
								begin
									if(i_dma_din_vld)
										begin
											if(!first_flag)
												begin
													ps_write_addr0<=i_fm_col+3;
													ps_write_data0<=i_dma_din;
													ps_write_en0<=1;
													
													fm_col<=0;
													fm_row<=0;
													fm_n<=0;
													dma_over<=0;
													ps_write_en1<=0;
													first_flag<=1;
												end
											else
												begin
													ps_write_addr0<=ps_write_addr0+1;
													ps_write_data0<=i_dma_din;
													ps_write_en0<=1;
													
													if(fm_col<i_fm_col-2)
														begin
															fm_col<=fm_col+1;
														end
													else
														begin
															fm_col<=fm_col+1;
															if(fm_row==i_fm_row-1)
																begin
																	if(fm_n==i_fm_n-1)
																		begin
																			buf_state<=pang;
																			runing_state<=2'b00;
																			first_flag<=0;
																			dma_over<=1;
																		end
																	else
																		begin
																			runing_state<=2'b10;
																		end
																end
															else
																begin
																	runing_state<=2'b01;
																end
														end
												end
										end
									else
										begin
											ps_write_en0<=0;
											ps_write_en1<=0;
											dma_over<=0;
										end
								end
							2'b01:
								begin
									if(i_dma_din_vld)
										begin
											ps_write_addr0<=ps_write_addr0+3;
											ps_write_data0<=i_dma_din;
											ps_write_en0<=1;
											
											fm_col<=0;
											fm_row<=fm_row+1;
											runing_state<=2'b00;
										end
									else
										begin
											ps_write_en0<=0;
										end
								end
							2'b10:
								begin
									if(i_dma_din_vld)
										begin
											ps_write_addr0=ps_write_addr0+i_fm_col+i_fm_col+2+2+3;
											ps_write_data0<=i_dma_din;
											ps_write_en0<=1;
											
											fm_col<=0;
											fm_row<=0;
											fm_n<=fm_n+1;
											runing_state<=2'b00;
										end
									else
										begin
											ps_write_en0<=0;
										end
								end
							default:
								begin
								end
							endcase
						end
					pang:
						begin
							case(runing_state)
							2'b00:
								begin
									if(i_dma_din_vld)
										begin
											if(!first_flag)
												begin
													ps_write_addr1<=i_fm_col+3;
													ps_write_data1<=i_dma_din;
													ps_write_en1<=1;
													
													fm_col<=0;
													fm_row<=0;
													fm_n<=0;
													dma_over<=0;
													ps_write_en0<=0;
													first_flag<=1;
												end
											else
												begin
													ps_write_addr1<=ps_write_addr1+1;
													ps_write_data1<=i_dma_din;
													ps_write_en1<=1;
													
													if(fm_col<i_fm_col-2)
														begin
															fm_col<=fm_col+1;
														end
													else
														begin
															fm_col<=fm_col+1;
															if(fm_row==i_fm_row-1)
																begin
																	if(fm_n==i_fm_n-1)
																		begin
																			buf_state<=ping;
																			first_flag<=0;
																			dma_over<=1;
																		end
																	else
																		begin
																			runing_state<=2'b10;
																		end
																end
															else
																begin
																	runing_state<=2'b01;
																end
														end
												end
										end
									else
										begin
											ps_write_en1<=0;
											ps_write_en0<=0;
											dma_over<=0;
										end
								end
							2'b01:
								begin
									if(i_dma_din_vld)
										begin
											ps_write_addr1<=ps_write_addr1+3;
											ps_write_data1<=i_dma_din;
											ps_write_en1<=1;
											
											fm_row<=fm_row+1;
											fm_col<=0;
											runing_state<=2'b00;
										end
									else
										begin
											ps_write_en1<=0;
										end
								end
							2'b10:
								begin
									if(i_dma_din_vld)
										begin
											ps_write_addr1<=ps_write_addr1+i_fm_col+i_fm_col+2+2+3;
											ps_write_data1<=i_dma_din;
											ps_write_en1<=1;
											
											fm_col<=0;
											fm_row<=0;
											fm_n<=fm_n+1;
											runing_state<=2'b00;
										end
									else
										begin
											ps_write_en1<=0;
										end
								end
							default:
								begin
								end
							endcase
						end
					endcase	
				end
			1'b1:
				begin
					case(buf_state)
					ping:
						begin
							if(i_dma_din_vld)
								begin
									if(!first_flag)
										begin
											ps_write_addr0<=0;
											ps_write_data0<=i_dma_din;
											ps_write_en0<=1;
													
											fm_col<=0;
											fm_row<=0;
											fm_n<=0;
											dma_over<=0;
											ps_write_en1<=0;
											first_flag<=1;
										end
									else
										begin
											if(ps_write_addr0<(i_fm_row*i_fm_col*i_fm_n)-2)   //shichaofan
												begin
													ps_write_addr0<=ps_write_addr0+1;
												end
											else
												begin
													ps_write_addr0<=ps_write_addr0+1;
													buf_state<=pang;  
													first_flag<=0;
													dma_over<=1;
												end
											ps_write_data0<=i_dma_din;
											ps_write_en0<=1;
										end
								end
							else
								begin
									ps_write_en0<=0;
									ps_write_en1<=0;
									dma_over<=0;
								end
						end
					pang:
						begin
							if(i_dma_din_vld)
								begin
									if(!first_flag)
										begin
											ps_write_addr1<=0;
											ps_write_data1<=i_dma_din;
											ps_write_en1<=1;
													
											fm_col<=0;
											fm_row<=0;
											fm_n<=0;
											ps_write_en0<=0;
											first_flag<=1;
											dma_over<=0;
										end
									else
										begin
											if(ps_write_addr1<i_fm_row-2)
												begin
													ps_write_addr1<=ps_write_addr1+1;
												end
											else
												begin
													ps_write_addr1<=ps_write_addr1+1;
													buf_state<=ping;
													first_flag<=0;
													dma_over<=1;
												end
											ps_write_data1<=i_dma_din;
											ps_write_en1<=1;
										end
								end
							else
								begin
									ps_write_en1<=0;
									ps_write_en0<=0;
									dma_over<=0;
								end
						end
					endcase	
				end
			default:
				begin
				end
			endcase
		end
end

wire write_en0;
wire [7:0] write_data0;
wire [15:0] write_addr0;

wire write_en1;
wire [7:0] write_data1;
wire [15:0] write_addr1;

assign write_en0= write_ctrl?pl_write_en:ps_write_en0;
assign write_addr0= write_ctrl?pl_write_addr:ps_write_addr0;
assign write_data0= write_ctrl?pl_write_data:ps_write_data0;

assign write_en1= write_ctrl?pl_write_en:ps_write_en1;
assign write_addr1= write_ctrl?pl_write_addr:ps_write_addr1;
assign write_data1= write_ctrl?pl_write_data:ps_write_data1;

wire [7:0] read_data0;
wire [7:0] read_data1;

//In_buffer In_buffer_ins0 (
//  .clka(i_clk),    // input wire clka
//  .ena(write_en0),      // input wire ena
//  .wea(write_en0),      // input wire [0 : 0] wea
//  .addra(write_addr0),  // input wire [14 : 0] addra
//  .dina(write_data0),    // input wire [31 : 0] dina
//  .clkb(i_clk),    // input wire clkb
//  .enb(1),      // input wire enb
//  .addrb(i_conv_addr[10:0]),  // input wire [14 : 0] addrb
//  .doutb(read_data0)  // output wire [7 : 0] doutb
//);

//In_buffer In_buffer_ins1 (
//  .clka(i_clk),    // input wire clka
//  .ena(write_en1),      // input wire ena
//  .wea(write_en1),      // input wire [0 : 0] wea
//  .addra(write_addr1),  // input wire [14 : 0] addra
//  .dina(write_data1),    // input wire [31 : 0] dina
//  .clkb(i_clk),    // input wire clkb
//  .enb(1),      // input wire enb
//  .addrb(i_conv_addr[10:0]),  // input wire [14 : 0] addrb
//  .doutb(read_data1)  // output wire [7 : 0] doutb
//);	


wire [15:0] input_pre_sram_addr0;
wire [15:0] input_pre_sram_addr1;

assign input_pre_sram_addr0 = write_en0? write_addr0:i_conv_addr;
assign input_pre_sram_addr1 = write_en1? write_addr1:i_conv_addr;


input_pre_sram input_pre_sram_ins0
            (
             .clk(i_clk), 
             .din(write_data0), 
             .addr(input_pre_sram_addr0),
             .cs(1), //make sure you enable it for both read and write
             .we(write_en0), //enable it when write, disable it when read
             .wem(write_en0),//only uesd when write
             .dout(read_data0)
            );
input_pre_sram input_pre_sram_ins1
            (
             .clk(i_clk), 
             .din(write_data1), 
             .addr(input_pre_sram_addr1),
             .cs(1), //make sure you enable it for both read and write
             .we(write_en1), //enable it when write, disable it when read
             .wem(write_en1),//only uesd when write
             .dout(read_data1)
            );

	
assign o_conv_din=i_out_choose?read_data1:read_data0;	
assign o_dma_write_last=dma_over;
		
	
endmodule
