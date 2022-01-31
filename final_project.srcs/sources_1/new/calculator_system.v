`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2021 12:08:56 AM
// Design Name: 
// Module Name: calculator_system
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


module calculator_system(
    input wire clk,
    input wire btnC,
    input wire RsRx,
    output wire RsTx
    );
    
    wire [19:0] binary_whole_inp;
    wire [19:0] binary_frac_inp;
    wire [47:0] ascii_whole_inp;
    wire [47:0] ascii_frac_inp;
    wire [119:0] ascii_raw_inp;
    reg [19:0] binary_whole_out;
    reg [19:0] binary_frac_out;
    wire [47:0] ascii_whole_out;
    wire [47:0] ascii_frac_out;
    wire [207:0] ascii_fin_out;
    
    wire [19:0] accu_whole = 0;
    wire [19:0] accu_frac = 0;
    reg accu_sign = 0;
    wire sign;
    
    wire [2:0] alu_ops;
    wire [2:0] ops;
    wire clear;
    wire NaN;
    
    //flag
    reg reset = 0;
    reg printing_result = 1;
    reg reading_input = 0;
    reg filtering_input = 0;
    reg converting_bcd2binary = 0;
    reg decisioning_sign_ops = 0;
    reg calculating_result = 0;
    reg converting_binary2bcd = 0;
    reg generating_output = 0;
    
    //end_state
    wire end1 = 0;
    wire end2 = 0;
    wire end3 = 0;
    wire end4 = 0;
    wire end5 = 0;
    wire end6 = 0;
    wire end7 = 0;
    reg state_end = 0;
    
    //state
    reg [3:0]state = 3'b000;
    
    
    //module
    display_system display_system(clk, printing_result,reading_input,RsRx,ascii_fin_out,RsTx,
                   ascii_raw_inp,endstate);
    
    bcdToBinary_converter bcdToBinary_converter(clk,ascii_whole_inp,ascii_frac_inp
                         ,converting_bcd2binary,binary_whole_inp,binary_frac_inp,end3);
    
    binaryToBCD_converter binaryToBCD_converter(clk,converting_binary2bcd,accu_whole,accu_frac,
                 ascii_whole_out,ascii_frac_out,end6);  
        
    input_filter input_filter(clk,ascii_raw_inp,filtering_input,ascii_whole_inp
                        ,ascii_frac_inp,ops,clear,sign,end2);
    
    sign_ops_decision_unit sign_ops_decision_unit(clk,decisioning_sign_ops,sign,accu_sign,ops,binary_whole_inp
                      ,binary_whole_accu,result_sign,alu_ops,end4);
   
    ALU ALU(clk,calculating_result, binary_whole_accu,binary_frac_accu,binary_whole_inp,binary_frac_inp,
                  alu_ops,whole_out,frac_out,NaN,end5);
                         
    output_generator output_generator(clk,generating_output,ascii_whole_out,ascii_frac_out,
                      ccu_sign,NaN,ascii_fin_out,end7);
    
    
    always @(posedge clk)
    begin
       if(btnC || clear)
       begin
                state = 0;
                state_end = 0;
                printing_result = 1;
                reading_input = 0;
                filtering_input = 0;
                converting_bcd2binary = 0;
                decisioning_sign_ops = 0;
                calculating_result = 0;
                converting_binary2bcd = 0;
                generating_output = 0;
       end
       if(state_end)
           state =  state+1;
       case(state)
         3'b000:
            begin
                generating_output = 0;
                printing_result = 1;
                state_end = end1;         
            end
         3'b001:
            begin
                if(NaN)
                    reading_input = 0;
                else
                    reading_input = 1; 
                printing_result = 0;   
                state_end = end1;             
            end
         3'b010:
            begin 
                reading_input = 0;      
                filtering_input = 1;
                state_end = end2;          
            end
         3'b011:
            begin     
                filtering_input = 0; 
                converting_bcd2binary = 1;
                state_end = end3;         
            end    
         3'b100:
            begin     
                converting_bcd2binary = 0;
                decisioning_sign_ops = 1;
                state_end = end4; 
            end  
         3'b101:
            begin     
                decisioning_sign_ops = 0;
                calculating_result = 1;
                state_end = end5; 
            end  
         3'b110:
            begin     
                calculating_result = 0;
                converting_binary2bcd = 1;
                state_end = end6; 
            end 
         3'b111:
            begin     
                converting_binary2bcd = 0;
                generating_output = 1;
                state_end = end6; 
            end  
       endcase
    end
    
endmodule
