`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/01 21:19:18
// Design Name: 
// Module Name: disp
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


module disp(
    _rst,clk_100M,_key,Out
    );
    input _rst,clk_100M,_key;
    output reg [7:0] Out;
    wire _key_pulse;
    ditheliminater ut(
        ._rst(_rst),
        .clk_100M(clk_100M),
        ._key(_key),
        ._key_pulse(_key_pulse)
    );
    initial begin
        Out=8'b0;
    end
    always @(negedge _key_pulse or negedge _rst)
    begin
        if(~_rst) Out=8'b0;
        else Out=Out+1;
    end
endmodule
