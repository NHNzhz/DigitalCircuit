`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/22 21:25:31
// Design Name: 
// Module Name: ALU
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

module DivFreq_Display(
    _rst,clk_in,clk_out
    );
    input _rst,clk_in;
    output reg clk_out;
    reg [13:0] n;
    parameter num = 1_00_00;
    always @(negedge _rst or posedge clk_in)
    begin
        if(~_rst) begin n<=14'b0;clk_out<=0; end
        else
        begin
            if(n<num) n<=n+1'b1;
            else
            begin
                n<=0;
                clk_out<=~clk_out;
            end
        end
    end
endmodule

module RegHeap(_rst,R_Addr_A,R_Addr_B,W_Addr,R_write,clk_R,W_Data,R_Data_A,R_Data_B);
    input _rst,R_write,clk_R;
    input [4:0] R_Addr_A,R_Addr_B,W_Addr;
    input [31:0] W_Data;
    output [31:0] R_Data_A,R_Data_B;
    reg [31:0] REG_Heap[31:0];
    always @(negedge _rst or posedge clk_R)
    begin
        if(~_rst) begin
            REG_Heap[0]<=0;
            REG_Heap[1]<=1;
            REG_Heap[2]<=4;
            REG_Heap[3]<=32'h80000000;
            REG_Heap[31]<=32'hFFFFFFFF;
        end
        else if(R_write) begin
            if(W_Addr) REG_Heap[W_Addr]<=W_Data;
        end
    end
    assign R_Data_A=REG_Heap[R_Addr_A];
    assign R_Data_B=REG_Heap[R_Addr_B];
endmodule

module ALU(A,B,ALU_OP,res_F,ZF,SF,CF,OF);
    input [31:0] A,B;
    input [3:0] ALU_OP;
    output reg [31:0] res_F;
    output reg ZF,SF,CF,OF;
    reg [32:0] F;
    parameter ADD=4'b0000,SLL=4'b0001,SLT=4'b0010,SLTU=4'b0011,XOR=4'b0100,SRL=4'b0101,OR=4'b0110,AND=4'b0111,SUB=4'b1000,SRA=4'b1001;
    /*
    ADD:加法
    SLL:左移
    SLT:有符号数比较
    SLTU:无符号数比较
    XOR:异或
    SRL:逻辑右移
    OR:按位或
    AND:按位与
    SUB:减法
    SRA:算术右移
    */
    always @(*)
    begin
        case (ALU_OP)
            ADD:begin
                F=A+B;
                res_F=F[31:0];
            end
            SLL:begin
                F=A<<B;
                res_F=F[31:0];
            end
            SLT:begin
                F=($signed (A) < $signed (B))?1:0;
                res_F=F[31:0];
            end
            SLTU:begin
                F=(A<B)?1:0;
                res_F=F[31:0];
            end
            XOR:begin
                F=A^B;
                res_F=F[31:0];
            end
            SRL:begin   
                F=A>>B;
                res_F=F[31:0];
            end
            OR:begin
                F=A|B;
                res_F=F[31:0];
            end
            AND:begin
                F=A&B;
                res_F=F[31:0];
            end
            SUB:begin
                F=A-B;
                res_F=F[31:0];
            end
            SRA:begin
                F=$signed(A)>>>B;
                res_F=F[31:0];
            end
            default:begin
                res_F=res_F;
            end
        endcase
        if (ALU_OP==ADD) begin
            CF=F[32];
            OF=(~A[31]&~B[31]&F[31])|(A[31]&B[31]&~F[31]);
        end
        else if(ALU_OP==SUB) begin
            CF=F[32];
            OF=(~A[31]&B[31]&F[31])|(A[31]&~B[31]&~F[31]);
        end
        ZF=res_F?0:1;
        SF=F[31];
    end
endmodule

module tubeDisplay(_rst,clk_D,data,An,res);
    input _rst,clk_D;
    input [31:0] data;
    output reg [7:0] An,res;
    reg [2:0] bit_sel;
    integer pls;
    always @(negedge _rst or posedge clk_D) begin
        if(~_rst) begin
            An<=8'b11111111;
            res<=8'b00000011;
            bit_sel=0;
        end
        else begin
            bit_sel=bit_sel+1;
            case (bit_sel)
                3'b000:begin An=8'b01111111;pls=268435456; end
                3'b001:begin An=8'b10111111;pls=16777216; end
                3'b010:begin An=8'b11011111;pls=1048576; end
                3'b011:begin An=8'b11101111;pls=65536; end
                3'b100:begin An=8'b11110111;pls=4096; end
                3'b101:begin An=8'b11111011;pls=256; end
                3'b110:begin An=8'b11111101;pls=16; end
                3'b111:begin An=8'b11111110;pls=1; end
            endcase
            case((data/pls)%16)
                4'b0000:res=8'b00000011;
                4'b0001:res=8'b10011111;
                4'b0010:res=8'b00100101;
                4'b0011:res=8'b00001101;
                4'b0100:res=8'b10011001;
                4'b0101:res=8'b01001001;
                4'b0110:res=8'b01000001;
                4'b0111:res=8'b00011111;
                4'b1000:res=8'b00000001;
                4'b1001:res=8'b00001001;
                4'b1010:res=8'b00010001;
                4'b1011:res=8'b11000001;
                4'b1100:res=8'b01100011;
                4'b1101:res=8'b10000101;
                4'b1110:res=8'b01100001;
                4'b1111:res=8'b01110001;
                default:res=8'b00010000;
            endcase
        end
    end
endmodule

module Reg_Temp(_rst,clk,inp_D,out_D);
    input [31:0] inp_D;
    input _rst,clk;
    output reg [31:0] out_D;
    always @(negedge _rst or posedge clk)
    begin
        if(~_rst) begin
            out_D<=0;
        end
        else begin
            out_D<=inp_D;
        end
    end
endmodule

module Reg_Temp_with_Mark(_rst,clk,inp_D,inp_M,out_D,out_M);
    input [31:0] inp_D;
    input [3:0] inp_M;
    input _rst,clk;
    output reg [31:0] out_D;
    output reg [3:0] out_M;
    always @(negedge _rst or posedge clk)
    begin
        if(~_rst) begin
            out_D<=0;
            out_M<=0;
        end
        else begin
            out_D<=inp_D;
            out_M<=inp_M;
        end
    end
endmodule

module ALU_main(clk_100M,_clk_R,_clk_RR,_clk_F,_rst,swtch,An,res,led);
    input clk_100M,_clk_R,_clk_RR,_clk_F,_rst;
    input [19:0] swtch;
    output [7:0] An,res;
    output [3:0] led;
    wire clk_D;
    wire [31:0] res_F;
    wire [3:0] res_led;
    wire [31:0] data;
    wire [31:0] RA,RB,A,B,temp_F;
    reg [2:0] bit_sel;
    DivFreq_Display(._rst(_rst),.clk_in(clk_100M),.clk_out(clk_D));
    RegHeap REGH(._rst(_rst),.R_Addr_A(swtch[19:15]),.R_Addr_B(swtch[14:10]),.W_Addr(swtch[9:5]),.R_write(swtch[4]),.clk_R(~_clk_R),.W_Data(temp_F),.R_Data_A(RA),.R_Data_B(RB));
    Reg_Temp(._rst(_rst),.clk(~_clk_RR),.inp_D(RA),.out_D(A));
    Reg_Temp(._rst(_rst),.clk(~_clk_RR),.inp_D(RB),.out_D(B));
    ALU(.A(A),.B(B),.ALU_OP(swtch[3:0]),.res_F(res_F),.ZF(res_led[3]),.SF(res_led[2]),.CF(res_led[1]),.OF(res_led[0]));
    Reg_Temp_with_Mark(._rst(_rst),.clk(~_clk_F),.inp_D(res_F),.inp_M(res_led),.out_D(data),.out_M(led));
    assign temp_F=data;
    tubeDisplay(._rst(_rst),.clk_D(clk_D),.data(data),.An(An),.res(res));
endmodule
