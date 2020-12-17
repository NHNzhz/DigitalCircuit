`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/08 23:00:08
// Design Name: 
// Module Name: Ccount
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


//¿ÉÄæ¼ÆÊýÆ÷
module Ccount(
    _rst,clk,Q,CO
    );
    input _rst,clk;
    output reg CO;
    output reg [3:0] Q;
    parameter limit=4'b1010;
    always @(negedge _rst or posedge clk)
    begin
    if(~_rst) begin
        Q<=4'b0000;
        CO<=0;
    end
    else begin
        if(Q<limit-1) begin
            Q=Q+1;
            CO=0;
        end
        else begin
            Q=0;
            CO=1;
        end
    end
    end
endmodule
