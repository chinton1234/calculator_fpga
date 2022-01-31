`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2021 11:32:47 PM
// Design Name: 
// Module Name: display_input
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


module display_input(
    input baud,
    input bit_in,
    output send,
    output reg [7:0] data_out
    );
    
    wire ena = 0;
    reg send =0;
    reg rec = 0;
    reg prev_bit;
    reg [7:0] count;
    
    always @(posedge baud)
    begin
        if(send == 1)
            send = 0;
        if(rec == 0 && prev_bit == 1 && bit_in == 0)
        begin
            rec <= 1;
            count <= 0;
        end
        
        prev_bit = bit_in;
        
        if(rec) count <= count + 1;
        else count <= 0;
        
        case (count)
            8'd24: data_out[0] <= bit_in;
            8'd40: data_out[1] <= bit_in;
            8'd56: data_out[2] <= bit_in;
            8'd72: data_out[3] <= bit_in;
            8'd88: data_out[4] <= bit_in;
            8'd104: data_out[5] <= bit_in;
            8'd120: data_out[6] <= bit_in;
            8'd136: data_out[7] <= bit_in;
            8'd152: begin rec <= 0;  send = 1; end
        endcase
    end
            
endmodule
