`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 18:06:29
// Design Name: 
// Module Name: CPU
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


module CPU(
    input clk,                // 时钟信号
    input reset               // 复位信号

    );
    // 信号声明
    wire [31:0] instr, pc, busA, busB, alu_result, data_out, imm_ext;
    wire [31:0] alu_input2, write_data;  // 分别连接 ALUSrcMUX 和 MemtoRegMUX
    wire [4:0] rd;
    //, rs1, rs2;

    // 控制信号
    wire RegDst, RegWr, ALUSrc, MemtoReg, MemWr, ExtOp,nPC_sel,b_res;
    wire [3:0] ALUctr;

    // 控制器输入信号
    //wire [6:0] opcode = instr[6:0];   // 操作码
    //wire [2:0] funct3 = instr[14:12]; // 功能码
    wire [15:0] imm16;
    assign rs1=instr[19:15];
    assign rs2=instr[24:20];
    
    

    // 1. 指令获取单元
    InstrFetchUnit IFU (
        .clk(clk),
        .reset(reset),
        .nPC_sel(nPC_sel),
        .b_res(alu_result[0]),
        .pc_offset(imm_ext),
        .pc_out(pc),
        .instr_out(instr)
    );

    // 2. 寄存器文件
    RegFile RF (
        .clk(clk),
        .RegWr(RegWr),
        .rs1(instr[19:15]),
        .rs2(instr[24:20]),
        .rd(rd),
        .write_data(write_data), // 从 MemtoRegMUX 输出的数据写回
        .read_data1(busA),
        .read_data2(busB)
    );

    // 3. 扩展器
    Extender EXT (
        .imm16(imm16),
        .ExtOp(ExtOp),
        .imm_ext(imm_ext)
    );

    // 4. ALUSrcMUX
    ALUSrcMUX ALUSrcMUX_inst (
        .busB(busB),
        .imm_ext(imm_ext),
        .ALUSrc(ALUSrc),
        .ALU_input2(alu_input2) // 输出连接到 ALU 的第二个操作数
    );

    // 5. 算术逻辑单元 (ALU)
    ALU ALU_inst (
        .input1(busA),          // 第一操作数
        .input2(alu_input2),    // 第二操作数来自 ALUSrcMUX
        .instr(instr),
        .ALUctr(ALUctr),        // ALU 控制信号
        .result(alu_result)     // ALU 运算结果
    );

     // 6. 数据存储器
    DataMemory DM (
        .clk(clk),
        .address(alu_result),
        .write_data(busB),
        .write_enable(MemWr),
        .read_data(data_out)
    );

    // 7. MemtoRegMUX
    MemtoRegMUX MemtoRegMUX_inst (
        .alu_result(alu_result), // 来自 ALU 的运算结果
        .data_out(data_out),     // 来自数据存储器的读出数据
        .MemtoReg(MemtoReg),     // 控制信号
        .write_data(write_data)  // 输出到寄存器文件
    );

     // 8. 控制器模块
    Controller controller (
        .instr(instr),
        //.opcode(opcode),        // 指令的操作码
        //.funct3(funct3),        // 指令的功能码
        .RegDst(RegDst),        // 写回寄存器选择信号
        .RegWrite(RegWr),          // 寄存器写使能信号
        .ALUSrc(ALUSrc),        // ALU 第二操作数选择信号
        .MemtoReg(MemtoReg),    // 数据写回选择信号
        .MemWrite(MemWr),          // 数据存储器写使能信号
        .nPC_sel(nPC_sel),
        .ExtOp(ExtOp),          // 立即数扩展模式
        .ALUctr(ALUctr),         // ALU 控制信号
        .imm16(imm16),
        .rd(rd)
    );

    // 9. 写回寄存器地址选择
    //assign rd = RegDst ? instr[11:7] : instr[20:16]; // 写回寄存器选择


endmodule
