`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2021 11:30:22 PM
// Design Name: 
// Module Name: baudrate_generator
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


module baudrate_generator(
    input clk,
    output reg baudrate
    );
    
    integer i;
    always @(posedge clk)
    begin
        i = i + 1;
        if (i == 325) 
        begin 
            i = 0; 
            baudrate = ~baudrate; 
        end
    end
endmodule
