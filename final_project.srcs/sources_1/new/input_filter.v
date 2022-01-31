`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2021 01:21:09 PM
// Design Name: 
// Module Name: input_filter
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


module input_filter(
    input wire clk,
    input wire [119:0] ascii_raw_input,
    input wire ena,
    output reg [47:0]ascii_whole,
    output reg [47:0]ascii_frac,
    output reg [2:0] ops,
    output clear,
    output reg sign,
    output reg done_state
    );
    
    reg clear = 0;
    
    always @(posedge clk)
    begin
    if(done_state == 1)
        done_state = 0;
    if(ena)
    begin
        if(ascii_raw_input[104+:8] == 8'h63)
            clear = 1;
        else
            begin
                case(ascii_raw_input[112+:8])
                    8'h2B : ops = 2'b00;
                    8'h2D : ops = 2'b01;
                    8'h2A : ops = 2'b10;
                    8'h2F : ops = 2'b11;
                endcase
                case(ascii_raw_input[104+:8])
                    8'h2B : sign = 0;
                    8'h2D : sign = 1;
                endcase
                ascii_whole[47:0] = ascii_raw_input[103:56];
                ascii_frac[47:0] = ascii_raw_input[47:0];
            end
         done_state = 1;
     end
    end
endmodule
