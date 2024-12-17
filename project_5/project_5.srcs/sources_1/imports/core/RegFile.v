`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 18:33:01
// Design Name: 
// Module Name: RegFile
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


module RegFile(
    input clk,
    input RegWr,
    input [4:0] rs1, rs2, rd,
    input [31:0] write_data,
    output [31:0] read_data1, read_data2

    );
    reg [31:0] regs [0:31];
    initial begin
        $readmemh("D:/registers.mem", regs); // 预加载寄存器文件
    end

    assign read_data1 = regs[rs1];
    assign read_data2 = regs[rs2];

    always @(posedge clk) begin
        if (RegWr)
            regs[rd] <= write_data;
    end

endmodule
