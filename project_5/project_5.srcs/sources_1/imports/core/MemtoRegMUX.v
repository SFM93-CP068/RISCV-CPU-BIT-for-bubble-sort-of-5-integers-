`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 18:42:09
// Design Name: 
// Module Name: MemtoRegMUX
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


module MemtoRegMUX(
    input [31:0] alu_result, // 来自 ALU 的运算结果
    input [31:0] data_out,   // 来自数据存储器的输出
    input MemtoReg,          // 控制信号
    output [31:0] write_data // 输出到寄存器文件的写入数据

    );
    assign write_data = (MemtoReg) ? data_out : alu_result;

endmodule
