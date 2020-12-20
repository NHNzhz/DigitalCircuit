`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/25 21:44:23
// Design Name: 
// Module Name: DivFre
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


module DivFre(
    _rst,clk_in,clk_out
    );
    input _rst,clk_in;
    output reg clk_out;
    reg [20:0] n;
    parameter num = 1_000_000;
    always @(negedge _rst or posedge clk_in)
    begin
        if(~_rst) begin n<=20'b0;clk_out<=0; end
        else
        begin
            if(n<num) n=n+1'b1;
            else
            begin
                n<=0;
                clk_out<=~clk_out;
            end
        end
    end
endmodule
