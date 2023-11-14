`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/06 17:31:18
// Design Name: 
// Module Name: pool_fc_buffer
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


module pool_fc_buffer(
    input clk,
    input rst_n,
    input [8*12-1:0] i_pool_data_in,
    input i_pool_valid_out,
    input i_pool_end,
    input [15:0] i_fc_fm_addr,
    
    output  o_fc_start,
    output signed [8*8-1:0] o_fc_fm_data
);
    localparam BUFFER_SIZE = 8*6*8; // Size of the buffer
    localparam ROW_SIZE = 8;        // Size of a row (8 elements per row)
    localparam COLUMN_SIZE = 6;     // Size of a column (6 elements per column)
    
    reg signed [7:0] buffer[BUFFER_SIZE-1:0];
    reg fc_start;
    reg buffer_full;
    reg [15:0] addr_r;
    reg [3:0] base_addr; 
    reg [3:0] counter;
    wire [8*6-1:0]valid_data;
    reg state_entrence;
    reg next_state;
    assign valid_data = i_pool_data_in[47:0];

    // Control logic for buffer writing
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
        begin
            // Reset logic
            base_addr <= 0;
            counter <= 0;
            // Clear the buffer
            for (i = 0; i < BUFFER_SIZE; i = i + 1) begin
                buffer[i] <= 0;
            end
        end 
        else 
        begin 
        //case(state_entrence )

        
            if (i_pool_valid_out) begin
                // Write data to buffer in column-wise order
                for (i = 0; i < COLUMN_SIZE; i = i + 1) begin
                    buffer[base_addr*48+counter + i*ROW_SIZE] <= valid_data[i*8 +: 8];
                end
                // Increment column counter, reset on reaching a row end
                counter<=counter+1;
                
                if(counter == 7) 
                begin
                    base_addr <= base_addr + 1; 
                    counter <=0;
                end

            end 
            else begin

                end
           end
           

    end
    always@(*) begin
        case(state_entrence)
        0: begin
            if(i_pool_valid_out) next_state = 1;
            else next_state  = 0;
           end   
        1: begin
            if(i_pool_end)next_state = 0;
            else next_state  = 1;
        end
        endcase
    end
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_entrence  <= 0;
        end else begin
            state_entrence  <= next_state;
        end
    end 
    
    
    //After the buffer is filled, send the start signal to the fc module.
    wire counter_full;
    assign counter_full = (counter==7);
    wire base_full;
    assign base_full = (base_addr==7);
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n) 
        begin  
            buffer_full<=0; 
        end
        else begin
            if(counter_full&&base_full) buffer_full<=1;
            else begin    
            end
        end   
    end
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n) fc_start <=0;
        else fc_start<=next_fc_start;  
    end
wire next_fc_start ;
assign next_fc_start = i_pool_end && buffer_full ;  
    //read from the buffer
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n) 
        begin
            addr_r<=0;
        end
        else begin
            if(buffer_full)
            begin
                addr_r <= i_fc_fm_addr ;
            end
            else begin
                addr_r<=0;
            end
        end   
    end
    assign o_fc_fm_data = {buffer[addr_r + 7], buffer[addr_r + 6], buffer[addr_r + 5], buffer[addr_r + 4],
                            buffer[addr_r + 3], buffer[addr_r + 2], buffer[addr_r + 1], buffer[addr_r]}; 
    
assign o_fc_start = fc_start; 
endmodule


