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
        A=1;B=0;ALU_OP=0;
    end
    always #50 {ALU_OP,A,B}={ALU_OP,A,B}+1;
endmodule
