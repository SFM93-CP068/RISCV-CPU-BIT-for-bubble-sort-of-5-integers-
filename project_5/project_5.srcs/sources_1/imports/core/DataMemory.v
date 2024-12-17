`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 18:40:28
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
    input clk,
    input [31:0] address,
    input [31:0] write_data,
    input write_enable,
    output reg [31:0] read_data

    );

    reg [31:0] data_mem [0:255];
    initial begin
        $readmemh("D:/data_memory.mem", data_mem); // 预加载数据内存
    end

    always @(posedge clk) begin
        if (write_enable)
            data_mem[address[7:2]] <= write_data;
    end
    
    always @(*) begin
        read_data = data_mem[address[7:2]];
    end

endmodule
