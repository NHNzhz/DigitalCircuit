`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/26 23:12:02
// Design Name: 
// Module Name: ALU_simu
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


module ALU_simu(
    );
    reg [31:0] A,B;
    reg[3:0] ALU_OP;
    wire [31:0] res_F;
    wire ZF,SF,CF,OF;
    ALU Simu(.A(A),.B(B),.ALU_OP(ALU_OP),.res_F(res_F),.ZF(ZF),.SF(SF),.CF(CF),.OF(OF));
    initial begin
        A=32'hffffffff;
        B=1;
        ALU_OP=0;
        #50 ALU_OP=1;
        #50 ALU_OP=2;
        #50 ALU_OP=3;
        #50 ALU_OP=4;
        #50 ALU_OP=5;
        #50 ALU_OP=6;
        #50 ALU_OP=7;
        #50 ALU_OP=8;
        #50 ALU_OP=9;
        #50 A=1;
        B=32'hffffffff;
        ALU_OP=0;
        #50 ALU_OP=1;
        #50 ALU_OP=2;
        #50 ALU_OP=3;
        #50 ALU_OP=4;
        #50 ALU_OP=5;
        #50 ALU_OP=6;
        #50 ALU_OP=7;
        #50 ALU_OP=8;
        #50 ALU_OP=9;
    end
endmodule
