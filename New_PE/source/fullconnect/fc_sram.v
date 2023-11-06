 `timescale 1ns / 1ps
/*                                                                      
Copyright 2018-2020 Nuclei System Technology, Inc.                
                                                                        
Licensed under the Apache License, Version 2.0 (the "License");         
you may not use this file except in compliance with the License.        
You may obtain a copy of the License at                                 
                                                                        
    http://www.apache.org/licenses/LICENSE-2.0                          
                                                                        
 Unless required by applicable law or agreed to in writing, software    
distributed under the License is distributed on an "AS IS" BASIS,       
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and     
limitations under the License.                                          
*/                                                                      
                                                                        
                                                                        
                                                                        
//=====================================================================
//
// Designer   : Bob Hu
//
// Description:
//  The simulation model of SRAM
//
// ====================================================================

module fc_sram
#(parameter DP = 11520,
 parameter FORCE_X2ZERO = 0,
 parameter DW = 8,
 parameter MW = 1,
 parameter AW = 16 
)
(
 input             clk, 
 input  [DW-1  :0] din, 
 input  [AW-1  :0] addr,
 input             cs, //make sure you enable it for both read and write
 input             we, //enable it when write, disable it when read
 input  [MW-1:0]   wem,//only uesd when write
 output [DW*8-1:0]   dout
);

   reg [DW-1:0] mem_r [0:DP-1];
   
   initial begin $readmemh("D:/Downloads/fc_parameter.txt", mem_r); 
   end
   
   reg [AW-1:0] addr_r;
   wire [MW-1:0] wen;
   wire ren;

   assign ren = cs & (~we);
   assign wen = ({MW{cs & we}} & wem);


   always @(posedge clk)
   begin
       if (ren) begin
           addr_r <= addr;
       end
   end
   genvar i;
  
   generate
     for (i = 0; i < MW; i = i+1) begin :mem
       if((8*i+8) > DW ) begin: last
         always @(posedge clk) begin
           if (wen[i]) begin
              mem_r[addr][DW-1:8*i] <= din[DW-1:8*i];
           end
         end
       end
       else begin: non_last
         always @(posedge clk) begin
           if (wen[i]) begin
              mem_r[addr][8*i+7:8*i] <= din[8*i+7:8*i];
           end
         end
       end
     end
   endgenerate
//读取权重
 wire [63:0] dout_pre;
 
 assign dout_pre = {mem_r[addr_r + 7], mem_r[addr_r + 6], mem_r[addr_r + 5], mem_r[addr_r + 4],
                     mem_r[addr_r + 3], mem_r[addr_r + 2], mem_r[addr_r + 1], mem_r[addr_r]}; 

 generate
  if(FORCE_X2ZERO == 1) begin: force_x_to_zero
     for (i = 0; i < DW*8; i = i+1) begin:force_x_gen 
         `ifndef SYNTHESIS//{
        assign dout[i] = (dout_pre[i] === 1'bx) ? 1'b0 : dout_pre[i];
         `else//}{
        assign dout[i] = dout_pre[i];
         `endif//}
     end
  end
  else begin:no_force_x_to_zero
    assign dout = dout_pre;
  end
 endgenerate


endmodule
