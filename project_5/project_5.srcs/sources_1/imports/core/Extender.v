`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 18:35:12
// Design Name: 
// Module Name: Extender
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


module Extender(
    input [15:0] imm16,
    input ExtOp,
    output [31:0] imm_ext

    );
    assign imm_ext = ExtOp ? {{16{imm16[15]}}, imm16} : {16'b0, imm16};

endmodule
