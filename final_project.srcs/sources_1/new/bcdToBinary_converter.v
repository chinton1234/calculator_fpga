`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2021 12:54:04 PM
// Design Name: 
// Module Name: bcdToBinary_converter
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

module bcdToBinary_converter(
    input wire clk,
    input wire [47:0] ascii_whole_inp,ascii_frac_inp,
    input wire ena,
    output reg [19:0] binary_whole_inp,binary_frac_inp,
    output reg state_end
    );
    
    reg count = 0;
    reg [20:0] mul = 1;
    reg [4:0] frac_bin ;
    reg [4:0] whole_bin;
    always@(posedge clk)
    begin
        if(state_end == 1)
            state_end = 0;
        if(ena)
        begin
            if(count == 0)
            begin
                binary_frac_inp = 0;
                binary_whole_inp = 0;
            end
            else if(count==6)
            begin
                count = 0;
                state_end = 1;
                mul = 1;
            end
            else
            begin     
                whole_bin = ascii_whole_inp[8*(count)+:8] - 5'd30;
                frac_bin = ascii_frac_inp[8*(count)+:8] - 5'd30;
                binary_whole_inp = binary_whole_inp + whole_bin*mul;
                binary_frac_inp = binary_frac_inp + frac_bin*mul;
                mul = mul * 5'b1010;
                count = count +1;
            end
        end
   
    end
endmodule

