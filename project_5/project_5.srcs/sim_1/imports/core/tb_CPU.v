`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 18:47:34
// Design Name: 
// Module Name: tb_CPU
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


module tb_CPU(

    );

    // 时钟和复位信号
    reg CLR , CLK;


    // CPU 实例化
    
    CPU CPU_inst0(.clk(CLK) , .reset(CLR));

    initial CLK = 0;
    always #50 CLK = !CLK;

    initial 
    begin
    CLR = 0;
    #50;
    CLR = 1;
    #5000;
    $stop;
    end


    //CPU uut (
    //    .clk(clk),
    //    .reset(reset),

    //);

    // 时钟周期定义
    //parameter CLOCK_PERIOD = 10;

   

    // 时钟信号生成
    //initial begin
    //    clk = 0;
    //    forever #(CLOCK_PERIOD/2) clk = ~clk;
    //end

    // 测试初始化
    //initial begin
        // 初始化复位信号
    //    reset = 1;
    //    #(CLOCK_PERIOD) reset = 0;

        // 仿真运行一定时间后结束
    //    #(CLOCK_PERIOD * 100) $finish;
    //end

    // 仿真输出
    //initial begin
        // 输出跟踪文件
    //    $dumpfile("CPU_waveform.vcd");
    //    $dumpvars(0, tb_CPU);

        // 输出监控 PC 和当前指令
    //    $monitor("Time: %0t | PC: %h | Instruction: %h", $time, pc, instr);
    //end

endmodule
