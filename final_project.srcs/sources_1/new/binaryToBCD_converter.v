`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2021 12:54:56 PM
// Design Name: 
// Module Name: binaryToBCD_converter
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


module binaryToBCD_converter(
    input wire clk,
    input wire ena,
    input wire [19:0]accu_whole,accu_frac,
    output reg [47:0]ascii_whole_out,ascii_frac_out,
    output reg endstate
    );
    
    reg [7:0]a,b,c,d,e,f;
    
    integer i;
    always@(posedge clk)
    begin
        if(endstate)
            endstate = 0;
        a=0;
        b=0;
        c=0;
        d=0;
        e=0;
        f=0;
        for(i=19;i>=0;i=i-1)
        begin
            if(a>=5)
                a = a+3;
            if(b>=5)
                b = b+3;
            if(c>=5)
                c = c+3;
            if(d>=5)
                d = d+3;
            if(e>=5)
                e = e+3;
            if(f>=5)
                f = f+3;
            a = a<<1;
            a[0] = b[3];
            b = b<<1;
            b[0] = c[3];
            c = c<<1;
            c[0] = d[3];
            d = d<<1;
            d[0] = e[3];
            e = e<<1;
            e[0] = f[3];
            f = f<<1;
            f[0] =  accu_whole[i];
        end
        a = a +30;
        b = b +30;
        c = c +30;
        d = d +30;
        e = e +30;
        f = f +30;
        ascii_whole_out = {a,b,c,d,e,f};
        a=0;
        b=0;
        c=0;
        d=0;
        e=0;
        f=0;
        for(i=19;i>=0;i=i-1)
        begin
            if(a>=5)
                a = a+3;
            if(b>=5)
                b = b+3;
            if(c>=5)
                c = c+3;
            if(d>=5)
                d = d+3;
            if(e>=5)
                e = e+3;
            if(f>=5)
                f = f+3;
            a = a<<1;
            a[0] = b[3];
            b = b<<1;
            b[0] = c[3];
            c = c<<1;
            c[0] = d[3];
            d = d<<1;
            d[0] = e[3];
            e = e<<1;
            e[0] = f[3];
            f = f<<1;
            f[0] =  accu_frac[i];
        end
        a = a +30;
        b = b +30;
        c = c +30;
        d = d +30;
        e = e +30;
        f = f +30;
        ascii_frac_out = {a,b,c,d,e,f};
        endstate = 1;
    end
    
endmodule
