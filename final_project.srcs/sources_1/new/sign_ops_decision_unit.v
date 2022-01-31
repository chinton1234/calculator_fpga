`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2021 02:43:56 PM
// Design Name: 
// Module Name: sign_ops_decision_unit
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


module sign_ops_decision_unit(
    input wire clk,
    input wire ena,
    input wire sign,
    input wire accu_sign,
    input wire ops,
    input wire [19:0] a,
    input wire [19:0] b,
    output reg result_sign,
    output reg alu_ops,
    output reg state_end
    );

    
    always @(posedge clk)
    begin
        if(state_end)
            state_end = 0;
        if(ena)
        begin
            state_end = 1;
            if(ops == 2'b10 || ops == 2'b11)
            begin
                alu_ops = ops;
                result_sign = accu_sign ^ sign;
            end
            else if(ops == 2'b00)
            begin
                if(sign == accu_sign)
                begin
                    result_sign = sign;
                    alu_ops = 2'b00;
                end
                else
                begin
                    alu_ops = 2'b01;
                    if(sign == 1)
                    begin
                        if(b>a)
                            result_sign = 1;
                        else
                            result_sign = 0;                            
                    end
                    else
                    begin
                    if(b>a)
                            result_sign = 0;
                        else
                            result_sign = 1;
                    end
                end
            end
            else if(ops == 2'b01)
            begin
                if(sign !=accu_sign)
                begin
                    alu_ops = 2'b00;
                    if(accu_sign == 1)
                        result_sign = 1;
                    else 
                        result_sign = 0;
                end
                else
                begin
                    alu_ops = 2'b01;
                    if(accu_sign == 1)
                    begin
                        if(b>a)
                            result_sign = 0;
                        else
                            result_sign = 1;
                    end
                   begin
                        if(b>a)
                            result_sign = 1;
                        else
                            result_sign = 0;
                    end
                end
        end
    end
    end
endmodule
