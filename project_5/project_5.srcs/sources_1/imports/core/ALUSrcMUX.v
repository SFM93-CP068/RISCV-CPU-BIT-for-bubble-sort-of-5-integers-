`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 18:37:14
// Design Name: 
// Module Name: ALUSrcMUX
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


module ALUSrcMUX(
    input [31:0] busB,       // 来自寄存器文件的输出
    input [31:0] imm_ext,    // 来自立即数扩展器的输出
    input ALUSrc,            // 控制信号
    output [31:0] ALU_input2 // 输出到 ALU 的第二个操作数

    );
    assign ALU_input2 = (ALUSrc == 1'b1) ? imm_ext : busB;

endmodule
