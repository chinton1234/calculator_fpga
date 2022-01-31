`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2021 11:48:57 PM
// Design Name: 
// Module Name: display_output
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


module display_output(
     input baud,
    input [7:0] data_in,
    input wire send,
    output reg bit_out
    );
    
    reg senting = 0;
    reg [7:0] count;
    reg [7:0] temp;
    
    
    always@(posedge baud ) 
    begin
        if (senting == 0 & send == 1) 
        begin
            temp <= data_in;
            senting <= 1;
            count <= 0;
        end
            
        if (senting) count <= count + 1;
        else begin count <= 0; bit_out <= 1; end
        
        case (count)
            8'd8: bit_out <= 0;
            8'd24: bit_out <= temp[0];  
            8'd40: bit_out <= temp[1];
            8'd56: bit_out <= temp[2];
            8'd72: bit_out <= temp[3];
            8'd88: bit_out <= temp[4];
            8'd104: bit_out <= temp[5];
            8'd120: bit_out <= temp[6];
            8'd136: bit_out <= temp[7];
            8'd152: begin senting <= 0; end
        endcase
    end
endmodule
