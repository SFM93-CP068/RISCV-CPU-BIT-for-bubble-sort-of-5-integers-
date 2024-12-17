`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 18:29:12
// Design Name: 
// Module Name: InstrFetchUnit
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


module InstrFetchUnit(
    input clk,
    input reset,
    input nPC_sel,
    input b_res,
    input [31:0] pc_offset,
    output reg [31:0] pc_out,
    output [31:0] instr_out

    );
    reg [31:0] instr_mem [0:255];

    initial begin
        $readmemh("D:/instructions.mem", instr_mem); // 预加载指令内存
    end

    always @(posedge clk or negedge reset) begin
        if (!reset) 
            pc_out <= 32'b0;
        else if(nPC_sel)
        begin
            case(b_res)
                1'b0:pc_out <= pc_out+4;
                1'b1:pc_out <= pc_out+pc_offset;
            endcase
        end
        else
            pc_out <= pc_out + 4;
    end
    
    assign instr_out = instr_mem[pc_out[7:2]]; // 取指

endmodule
