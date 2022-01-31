`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2021 11:41:49 PM
// Design Name: 
// Module Name: display_system
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


module display_system(
    input wire clk, 
    input wire  printing_result,reading_input,
    input wire RsRx,
    input  wire [207:0]ascii_fin_out,
    output wire RsTx,
    output reg [119:0] ascii_raw_inp,
    output reg endstate
    );
    
    wire send;
    reg prev_send = 0;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire baud;
    reg write;
    reg [5:0]i = 0;
    reg [7:0]count = 0;
    baudrate_generator baudrate_generator(clk, baud);
    display_input display_input(baud,RsRx,send,data_out);
    display_output display_output(baud,data_in,write,RsTx);
    
    
    always @(posedge baud)
    begin
        if(endstate == 1)
            endstate = 0;
        if(printing_result)
        begin
            if(count == 8'd152)
            begin
                i = i + 1;
                count = 0;
            end
            if(i >= 14)
            begin
                endstate = 1;
                i = 0;
                write = 0;
            end
            else
            begin
                write = 1;
                data_in = ascii_fin_out[8*(26-i-1)+:8];
                count = count+ 1;
            end 
        end
        if(reading_input)
        begin
            write = prev_send;
            if (write == 1)
            begin
                if(count == 8'd152)
                begin
                    i = i + 1;
                    count = 0;
                end
                if(data_out == 8'h0D)          
                begin
                    data_in = 8'h0A;
                    endstate = 1;
                    count = 0;
                    i = 0;
                end
                else
                begin
                    data_in = data_out;
                    ascii_raw_inp[8*(15-i-1)+:8] = data_out;
                    count = count + 1;
                end
            end
            prev_send = send;
        end
    end
endmodule
