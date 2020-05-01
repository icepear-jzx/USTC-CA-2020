`timescale 1ns / 1ps

module cpu_tb();
    reg clk = 1'b1;
    reg rst = 1'b1;
    reg [31:0] CPU_Debug_DataCache_A2;
    reg [31:0] CPU_Debug_DataCache_WD2;
    reg [3:0] CPU_Debug_DataCache_WE2;
    wire [31:0] CPU_Debug_DataCache_RD2;
    reg [31:0] CPU_Debug_InstCache_A2;
    reg [31:0] CPU_Debug_InstCache_WD2;
    reg [3:0] CPU_Debug_InstCache_WE2;
    wire [31:0] CPU_Debug_InstCache_RD2;
    wire [31:0] PC_ID;
    wire [31:0] Inst_ID;
    wire [31:0] ALU_op1;
    wire [31:0] ALU_op2;
    wire [31:0] ALU_out;
    wire [31:0] Reg2_EX;
    wire [31:0] Reg3_ID;
    wire [31:0] miss_count, hit_count;
    wire [31:0] ram_cell [1<<12];
    always  #2 clk = ~clk;
    initial #8 rst = 1'b0;
    
    RV32ICore RV32ICore_tb_inst(
        .CPU_CLK    ( clk          ),
        .CPU_RST    ( rst          ),
        .CPU_Debug_DataCache_A2(CPU_Debug_DataCache_A2),
        .CPU_Debug_DataCache_WD2(CPU_Debug_DataCache_WD2),
        .CPU_Debug_DataCache_WE2(CPU_Debug_DataCache_WE2),
        .CPU_Debug_DataCache_RD2(CPU_Debug_DataCache_RD2),
        .CPU_Debug_InstCache_A2(CPU_Debug_InstCache_A2),
        .CPU_Debug_InstCache_WD2(CPU_Debug_InstCache_WD2),
        .CPU_Debug_InstCache_WE2(CPU_Debug_InstCache_WE2),
        .CPU_Debug_InstCache_RD2(CPU_Debug_InstCache_RD2),
        .CPU_Debug_PC(PC_ID),
        .CPU_Debug_Inst(Inst_ID),
        .CPU_Debug_ALU_op1(ALU_op1),
        .CPU_Debug_ALU_op2(ALU_op2),
        .CPU_Debug_ALU_out(ALU_out),
        .CPU_Debug_Reg2(Reg2_EX),
        .CPU_Debug_Reg3(Reg3_ID),
        .miss_count(miss_count),
        .hit_count(hit_count),
        .ram_cell(ram_cell)
    );
    
endmodule
