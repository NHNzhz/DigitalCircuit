`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/16 19:25:05
// Design Name: 
// Module Name: tube_display
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

module tube_display(
    _rst,clk_100M,An,res
    );
    input _rst,clk_100M;
    output reg [7:0] An,res;
    wire clk_D,clk_P;
    reg [2:0] bit_sel;
    reg [7:0] CO;
    reg [31:0] data;
    parameter limit=4'b1010;
    DivFreD utd(
        ._rst(_rst),
        .clk_in(clk_100M),
        .clk_out(clk_D)
    );
    DivFreP utp(
        ._rst(_rst),
        .clk_in(clk_100M),
        .clk_out(clk_P)
    );
    //Ccount ut1(._rst(_rst),.clk(clk_P),.Q(tdata[3:0]),.CO(CO[0]));
    //Ccount ut2(._rst(_rst),.clk(CO[0]),.Q(tdata[7:4]),.CO(CO[1]));
    //Ccount ut3(._rst(_rst),.clk(CO[1]),.Q(tdata[11:8]),.CO(CO[2]));
    //Ccount ut4(._rst(_rst),.clk(CO[2]),.Q(tdata[15:12]),.CO(CO[3]));
    //Ccount ut5(._rst(_rst),.clk(CO[3]),.Q(tdata[19:16]),.CO(CO[4]));
    //Ccount ut6(._rst(_rst),.clk(CO[4]),.Q(tdata[23:20]),.CO(CO[5]));
    //Ccount ut7(._rst(_rst),.clk(CO[5]),.Q(tdata[27:24]),.CO(CO[6]));
    //Ccount ut8(._rst(_rst),.clk(CO[6]),.Q(tdata[31:28]),.CO(CO[7]));
    always @(negedge _rst or posedge clk_P)
    begin
    if(~_rst) begin data[31:0]<=0;CO<=0;end
    else begin
        if(data[31:28]<limit-1) begin data[31:28]<=data[31:28]+1;CO[7]<=0;end
        else begin data[31:28]<=0;data[27:24]<=data[27:24]+1;CO[7]<=1;end
        if(CO[7])
            if(data[27:24]<limit-1) begin CO[6]<=0;end
            else begin data[27:24]<=0;data[23:20]<=data[23:20]+1;CO[6]<=1;end
        if(CO[6])
            if(data[23:20]<limit-1) begin CO[5]<=0;end
            else begin data[23:20]<=0;data[19:16]<=data[19:16]+1;CO[5]<=1;end
        if(CO[5])
            if(data[19:16]<limit-1) begin CO[4]<=0;end
            else begin data[19:16]<=0;data[15:12]<=data[15:12]+1;CO[4]<=1;end
        if(CO[4])
            if(data[15:12]<limit-1) begin CO[3]<=0;end
            else begin data[15:12]<=0;data[11:8]<=data[11:8]+1;CO[3]<=1;end
        if(CO[3])
            if(data[11:8]<limit-1) begin CO[2]<=0;end
            else begin data[11:8]<=0;data[7:4]<=data[7:4]+1;CO[2]<=1;end
        if(CO[2])
            if(data[7:4]<limit-1) begin CO[1]<=0;end
            else begin data[7:4]<=0;data[3:0]<=data[3:0]+1;CO[1]<=1;end
        if(CO[1])
            if(data[3:0]<limit-1) begin CO[0]<=0;end
            else begin data[3:0]<=0;CO[0]<=1;end
    end
    end
    always @(negedge _rst or posedge clk_D)
    begin
        if(~_rst) begin
            bit_sel=0;
            res=8'b00000011;
        end
        else
        begin
        bit_sel=bit_sel+1;
        case(bit_sel)
            3'b000:An=8'b01111111;
            3'b001:An=8'b10111111;
            3'b010:An=8'b11011111;
            3'b011:An=8'b11101111;
            3'b100:An=8'b11110111;
            3'b101:An=8'b11111011;
            3'b110:An=8'b11111101;
            3'b111:An=8'b11111110;
        endcase
        case(An)
            8'b01111111:begin
                case(data[3:0])
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
                endcase
            end
            8'b10111111:begin
                case(data[7:4])
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
                endcase
            end
            8'b11011111:begin
                case(data[11:8])
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
                endcase
            end
            8'b11101111:begin
                case(data[15:12])
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
                endcase
            end
            8'b11110111:begin
                case(data[19:16])
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
                endcase
            end
            8'b11111011:begin
                case(data[23:20])
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
                endcase
            end
            8'b11111101:begin
                case(data[27:24])
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
                endcase
            end
            8'b11111110:begin
                case(data[31:28])
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
                endcase
            end
        endcase
        end
    end
endmodule
