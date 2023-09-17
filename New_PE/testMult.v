module testMult(
input CLK,  // input  CLK
input [7:0]A,      // input  [7 : 0] A
input [3:0]B,      // input  [3 : 0] B
input CE,    // input  CE
output reg [11:0]P      // output reg [11 : 0] P
);

reg [11:0] pipeline_reg1,pipeline_reg2;

initial begin
P=12'b0;
end
always@(posedge CLK)
begin
    if(CE)
    begin
    pipeline_reg2=A*B;
    P=pipeline_reg1;
    pipeline_reg1=pipeline_reg2;    
    end
    
end


endmodule