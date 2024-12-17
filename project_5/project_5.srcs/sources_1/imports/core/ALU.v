`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 18:38:56
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
    input [31:0] input1, input2,instr,
    input [3:0] ALUctr,
    output reg [31:0] result

    );

    always @(*) begin
        case (ALUctr)
            4'b0000: result = input1 & input2;  // 按位与
            4'b0001: result = input1 | input2;  // 按位或
            4'b0010: result = input1 + input2;  // 加法
            4'b0011: result = (input1 == input2)? 1 : 0; //beq
            4'b0100: result = (input1 == input2)? 0 : 1; //bne
            4'b0110: result = input1 - input2;  // 减法
            4'b0111: result = (input1 >= input2) ? 1 : 0; // 小于比较
            4'b1000: begin
                result=0;
                result[31:12] = instr[31:12];
            end 
            
            
            default: result = 0;
        endcase
    end

endmodule
