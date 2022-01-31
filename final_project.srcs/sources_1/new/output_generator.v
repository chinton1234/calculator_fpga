`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2021 01:36:29 PM
// Design Name: 
// Module Name: output_generator
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


module output_generator(
    input wire clk,
    input wire ena,
    input wire [47:0]ascii_whole_out,ascii_frac_out,
    input wire accu_sign,
    input wire NaN,
    output  [207:0] ascii_fin_out,
    output reg endstate
    );
    
    reg [207:0] ascii_fin_out = 208'h0D2b3030303030302e30303030303020202020202020203e3e20;
    
    always@(posedge clk)
    begin
      if(endstate==1)
        endstate = 0;
      if(ena)
      begin
      if(NaN)
       begin
            ascii_fin_out = 208'h0D4e614e202020202020202020202020202020202020203e3e20;
       end
      else
            ascii_fin_out[207:200] = 8'h0D;
            ascii_fin_out[87:0] = 88'h2020202020202020203E3E20;
            if(accu_sign)
                ascii_fin_out[199:192] = 8'h2D;
            else
                ascii_fin_out[199:192] = 8'h2B;
            ascii_fin_out[191:144] = ascii_whole_out;
            ascii_fin_out[143:136] = 8'h2E;
            ascii_fin_out[135:88] = ascii_frac_out;
            endstate = 1;
       end
      end
endmodule
