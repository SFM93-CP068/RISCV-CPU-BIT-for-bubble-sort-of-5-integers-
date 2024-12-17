`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 18:43:45
// Design Name: 
// Module Name: Controller
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


module Controller(
    input [31:0] instr,
    //input [6:0] opcode,      // 操作码
    //input [2:0] funct3,      // 功能码 (仅对分支指令和 R-type 指令有效)
    output reg RegDst,       // 写寄存器地址选择
    output reg ALUSrc,       // ALU 第二操作数选择
    output reg MemtoReg,     // 写寄存器数据选择
    output reg RegWrite,     // 是否写寄存器
    output reg MemWrite,     // 是否写数据存储器
    output reg nPC_sel,      // PC 更新方式选择
    output reg ExtOp,        // 立即数扩展方式
    output reg [3:0] ALUctr,  // ALU 操作选择
    output reg [15:0] imm16,
    output reg [4:0] rd
    );


    // 定义操作码
    parameter R_TYPE  = 7'b0110011;  // R 型指令
    parameter I_TYPE  = 7'b0010011;  // I 型指令 (如 ORI)
    parameter LW      = 7'b0000011;  // LW 指令
    parameter SW      = 7'b0100011;  // SW 指令
    parameter BRANCH  = 7'b1100011;  // 分支指令 (BEQ, BGE)
    parameter LUI    = 7'b0110111;

    // 功能码定义 (分支指令用)
    parameter BEQ_FUNCT3 = 3'b000;   // BEQ 功能码
    parameter BGE_FUNCT3 = 3'b101;   // BGE 功能码
    parameter BNE_FUNCT3 = 3'b001;   // BNE 功能码

    reg [6:0] opcode;
    reg [2:0] funct3;
    always @(*) begin

        opcode = instr[6:0];   // 操作码
        funct3 = instr[14:12]; // 功能码
        // 默认值：防止综合时产生锁存器
        RegDst    = 0;
        ALUSrc    = 0;
        MemtoReg  = 0;
        RegWrite  = 0;
        MemWrite  = 0;
        nPC_sel   = 0;
        ExtOp     = 0;
        ALUctr    = 4'b0000;
        rd=instr[11:7];

        // 根据操作码生成控制信号
        case (opcode)
            LUI: begin
                RegDst    = 1;      // 写目标寄存器为 rd
                ALUSrc    = 0;      // ALU 第二操作数为立即数
                MemtoReg  = 0;      // 写回 ALU 结果
                RegWrite  = 1;      // 写寄存器
                ALUctr    = 4'b1000;  
                //imm16     = instr[31:12];
            end
            R_TYPE: begin
                funct3 = instr[31:29];
                RegDst    = 1;      // 写目标寄存器为 rd
                ALUSrc    = 0;      // ALU 第二操作数为 busB
                MemtoReg  = 0;      // 写回 ALU 结果
                RegWrite  = 1;      // 写寄存器
                ALUctr    = (funct3 == 3'b000) ? 4'b0010 :   // ADD
                            (funct3 == 3'b010) ? 4'b0110 :   // SUB
                            4'b0000; // 默认 ADD
            end
            I_TYPE: begin
                RegDst    = 1;      // 写目标寄存器为 rd
                ALUSrc    = 1;      // ALU 第二操作数为立即数
                MemtoReg  = 0;      // 写回 ALU 结果
                RegWrite  = 1;      // 写寄存器
                ExtOp     = 1;      // 符号扩展
                //ALUctr    = 4'b0011;  // 按位或 (ORI)
                ALUctr    = (funct3 == 3'b000)? 4'b0010 : //addi          
                            4'b0000;
                imm16=0;
                imm16[11:0]  = instr[31:20];
                if(imm16[11]) begin
                    imm16[15:12]=4'b1111;
                end

            end
            LW: begin
                RegDst    = 0;      // 写目标寄存器为 rt
                ALUSrc    = 1;      // ALU 第二操作数为立即数
                MemtoReg  = 1;      // 写回数据存储器内容
                RegWrite  = 1;      // 写寄存器
                ExtOp     = 1;      // 符号扩展
                imm16  = instr[31:20];
                ALUctr    = 4'b0010;  // 加法
            end
            SW: begin
                ALUSrc    = 1;      // ALU 第二操作数为立即数
                MemWrite  = 1;      // 写数据存储器
                ExtOp     = 1;      // 符号扩展
                imm16=0;
                imm16[11:5]=instr[31:25];
                imm16[4:0]=instr[11:7];
                ALUctr    = 4'b0010;  // 加法

            end
            BRANCH: begin

                nPC_sel   = 1;      // 分支跳转
                ExtOp     = 1;      // 符号扩展
                imm16 =0;
                imm16[12]=instr[31];
                imm16[10:5]=instr[30:25];
                imm16[4:1]=instr[11:8];
                imm16[11]=instr[7];
                imm16[13]=imm16[12];
                imm16[14]=imm16[13];
                imm16[15]=imm16[14];
                ALUctr    = (funct3 == BEQ_FUNCT3) ? 4'b0011 :   // BEQ 
                            (funct3 == BGE_FUNCT3) ? 4'b0111 :   // BGE 
                            (funct3 == BNE_FUNCT3) ? 4'b0100 :   // BNE 
                            4'b0000; // 默认加法
            end
            default: begin
                // 其他指令保持默认值
            end
        endcase
    end

endmodule
