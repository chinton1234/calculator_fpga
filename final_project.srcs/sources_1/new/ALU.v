`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2021 02:31:27 AM
// Design Name: 
// Module Name: ALU
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


module ALU(
        input wire clk,
        input wire ena,
        input wire [19:0] binary_whole_accu,binary_frac_accu
                            ,binary_whole_inp,binary_frac_inp,
        input wire [2:0] alu_ops,
        output reg [19:0] whole_out,frac_out,
        output NaN,
        output end_state
    );
    reg [79:0]alu_result;
    reg [39:0]A,B;
    reg [39:0] tmp;
    reg end_state = 0;
    reg NaN = 0;
    
    always@(posedge clk)
    begin
        if(end_state == 1)
            end_state = 0;
        if(ena)
        begin
            
            A = {binary_whole_accu,binary_frac_accu};
            B = {binary_whole_inp,binary_frac_inp};
            
            case(alu_ops)
            2'b00:
            begin
                alu_result = A+B;
                if(alu_result[40:0]  > 40'd999999999999)
                    NaN = 1;
                else
                begin
                    whole_out = alu_result[39:20];
                    frac_out = alu_result[19:0];
                end
            end
            2'b01:
            begin
                if(B>A)
                begin
                    tmp = A;
                    A = B;
                    B = tmp;
                end
                    whole_out = alu_result[39:20];
                    frac_out = alu_result[19:0];
                    NaN = 0;
            end 
            2'b10:
            begin
                alu_result = A*B;
                if(alu_result[79:20] > 40'd999999999999)
                    NaN = 1;
                else
                begin
                    whole_out = alu_result[59:40];
                    frac_out = alu_result[39:20];
                end
            end 
            2'b11:
            begin
                alu_result = A/B;
                whole_out = alu_result[39:20];
                frac_out = alu_result[19:0];
            end
            endcase
           end_state = 1; 
         end
      end 
endmodule