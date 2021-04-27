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

module ALU(A,B,ALU_OP,res_F,ZF,SF,CF,OF);
    input [31:0] A,B;
    input [3:0] ALU_OP;
    output reg [31:0] res_F;
    output reg ZF,SF,CF,OF;
    reg [32:0] F;
    parameter ADD=4'b0000,SLL=4'b0001,SLT=4'b0010,SLTU=4'b0011,XOR=4'b0100,SRL=4'b0101,OR=4'b0110,AND=4'b0111,SUB=4'b1000,SRA=4'b1001;
    always @(*)
    begin
        case (ALU_OP)
            ADD:begin
                F<=A+B;
                res_F<=F[31:0];
                ZF<=(F|0)?0:1;
                SF<=F[31];
                CF<=F[32];
                OF<=(~A[31]&~B[31]&F[31])|(A[31]&B[31]&~F[31]);
            end
            SLL:begin
                F<=A<<B;
                res_F<=F[31:0];
                ZF<=(F|0)?0:1;
                SF<=F[31];
                CF<=A[31];
                OF<=A[31]^A[30];
            end
            SLT:begin
                F<=($signed (A) < $signed (B))?1:0;
                res_F<=F[31:0];
                ZF<=(F|0)?0:1;
                SF<=F[31];
                CF<=0;
                OF<=0;
            end
            SLTU:begin
                F<=(A<B)?1:0;
                res_F<=F[31:0];
                ZF<=(F|0)?0:1;
                SF<=F[31];
                CF<=0;
                OF<=0;
            end
            XOR:begin
                F<=A^B;
                res_F<=F[31:0];
                ZF<=(F|0)?0:1;
                SF<=F[31];
                CF<=0;
                OF<=0;
            end
            SRL:begin   
                F<=A>>B;
                res_F<=F[31:0];
                ZF<=(F|0)?0:1;
                SF<=F[31];
                CF<=0;
                OF<=0;
            end
            OR:begin
                F<=A|B;
                res_F<=F[31:0];
                ZF<=(F|0)?0:1;
                SF<=F[31];
                CF<=0;
                OF<=0;
            end
            AND:begin
                F<=A&B;
                res_F<=F[31:0];
                ZF<=(F|0)?0:1;
                SF<=F[31];
                CF<=0;
                OF<=0;
            end
            SUB:begin
                F<=A-B;
                res_F<=F[31:0];
                ZF<=(F|0)?0:1;
                SF<=F[31];
                CF<=F[32];
                OF<=(~A[31]&B[31]&F[31])|(A[31]&~B[31]&~F[31]);
            end
            SRA:begin
                F<=$signed(A)>>>B;
                res_F<=F[31:0];
                ZF<=(F|0)?0:1;
                SF<=F[31];
                CF<=0;
                OF<=0;
            end
            default:begin
                res_F<=res_F;
                ZF<=ZF;
                SF<=SF;
                CF<=CF;
                OF<=OF;
            end
        endcase
    end
endmodule

module ALU_main(clk_100M,_clk_A,_clk_B,_clk_F,_rst,swtch,An,res,led);
    input clk_100M,_clk_A,_clk_B,_clk_F,_rst;
    input [19:0] swtch;
    output reg [7:0] An,res;
    output reg [3:0] led;
    wire clk_D;
    wire [31:0] res_F;
    wire [3:0] res_led;
    reg [31:0] data;
    reg [31:0] A,B;
    reg [2:0] bit_sel;
    DivFreq_Display(._rst(_rst),.clk_in(clk_100M),.clk_out(clk_D));
    always @(negedge _rst or negedge _clk_A)
    begin
        if(~_rst) begin
            A<=0;
        end
        else if(~swtch[19]) begin
            A[15:0]<=swtch[15:0];
        end
        else begin
            A[31:16]<=swtch[15:0];
        end
    end

    always @(negedge _rst or negedge _clk_B)
    begin
        if(~_rst) begin
            B<=0;
        end
        else if(~swtch[19]) begin
            B[15:0]<=swtch[15:0];
        end
        else begin
            B[31:16]<=swtch[15:0];
        end
    end

    ALU(.A(A),.B(B),.ALU_OP(swtch[19:16]),.res_F(res_F),.ZF(res_led[3]),.SF(res_led[2]),.CF(res_led[1]),.OF(res_led[0]));

    always @(negedge _rst or negedge _clk_F)
    begin
        if(~_rst) begin
            data<=0;
            led<=0;
        end
        else begin
            data<=res_F[31:0];
            led<=res_led;
        end
    end

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
