`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Controller Decoder
// Tool Versions: Vivado 2017.4.1
// Description: Controller Decoder Module
// 
//////////////////////////////////////////////////////////////////////////////////

//  功能说明
    //  对指令进行译码，将其翻译成控制信号，传输给各个部件
// 输入
    // Inst              待译码指令
// 输出
    // jal               jal跳转指令
    // jalr              jalr跳转指令
    // op2_src           ALU的第二个操作数来源。为1时，op2选择imm，为0时，op2选择reg2
    // ALU_func          ALU执行的运算类型
    // br_type           branch的判断条件，可以是不进行branch
    // load_npc          写回寄存器的值的来源（PC或者ALU计算结果）, load_npc == 1时选择PC
    // wb_select         写回寄存器的值的来源（Cache内容或者ALU计算结果），wb_select == 1时选择cache内容
    // load_type         load类型
    // src_reg_en        指令中src reg的地址是否有效，src_reg_en[1] == 1表示reg1被使用到了，src_reg_en[0]==1表示reg2被使用到了
    // reg_write_en      通用寄存器写使能，reg_write_en == 1表示需要写回reg
    // cache_write_en    按字节写入data cache
    // imm_type          指令中立即数类型
    // alu_src1          alu操作数1来源，alu_src1 == 0表示来自reg1，alu_src1 == 1表示来自PC
    // alu_src2          alu操作数2来源，alu_src2 == 2’b00表示来自reg2，alu_src2 == 2'b01表示来自reg2地址，alu_src2 == 2'b10表示来自立即数
// 实验要求
    // 补全模块


`include "Parameters.v"   
module ControllerDecoder(
    input wire [31:0] inst,
    output wire jal,
    output wire jalr,
    output wire csr_op1_src,
    output wire op1_src,
    output wire op2_src,
    output reg [1:0] Mask_func,
    output reg [3:0] ALU_func,
    output reg [2:0] br_type,
    output wire load_npc,
    output wire wb_select,
    output reg [2:0] load_type,
    output reg [1:0] src_reg_en,
    output reg reg_write_en,
    output reg csr_read_en,
    output reg csr_write_en,
    output reg [3:0] cache_write_en,
    output wire alu_src1,
    output wire [1:0] alu_src2,
    output reg [2:0] imm_type
    );

    // TODO: Complete this module
    
    wire [6:0] opcode = inst[6:0];
    wire [2:0] func3 = inst[14:12];
    wire [4:0] zimm = inst[19:15];
    wire [4:0] rs1 = inst[19:15];
    wire [4:0] rd = inst[11:7];

    wire op_slli = (opcode == 7'b0010011 && func3[1:0] == 2'b01) ? 1 : 0; // SLLI SRLI SRAI
    wire op_addi = (opcode == 7'b0010011 && func3[1:0] != 2'b01) ? 1 : 0; // ADDI SLTI SLTIU XORI ORI ANDI
    wire op_add = (opcode == 7'b0110011) ? 1 : 0; // ADD SUB SLL SRL SRA SLT SLTU XOR OR AND
    wire op_lui = (opcode == 7'b0110111) ? 1 : 0; // LUI
    wire op_auipc = (opcode == 7'b0010111) ? 1 : 0; // AUIPC
    wire op_jal = (opcode == 7'b1101111) ? 1 : 0; // JAL
    wire op_jalr = (opcode == 7'b1100111) ? 1 : 0; // JALR
    wire op_beq = (opcode == 7'b1100011) ? 1 : 0; // BEQ BNE BLT BGE BLTU BGEU
    wire op_lb = (opcode == 7'b0000011) ? 1 : 0; // LB LH LW LBU LHU
    wire op_sb = (opcode == 7'b0100011) ? 1 : 0; // SB SH SW
    wire op_csrr = (opcode == 7'b1110011 && !func3[2]) ? 1 : 0; // CSRR
    wire op_csri = (opcode == 7'b1110011 && func3[2]) ? 1 : 0; // CSRI
    wire op_csrr_sc = (op_csrr && func3[1:0] != 2'b01) ? 1 : 0; // CSRRS CSRRC
    wire op_csrr_w = (op_csrr && func3[1:0] == 2'b01) ? 1 : 0; // CSRRW
    wire op_csri_sc = (op_csri && func3[1:0] != 2'b01) ? 1 : 0; // CSRRSI CSRRCI
    wire op_csri_w = (op_csri && func3[1:0] == 2'b01) ? 1: 0; // CSRRWI

    assign jal = op_jal;
    assign jalr = op_jalr;

    assign csr_op1_src = (op_csri) ? 1 : 0;

    assign op1_src = ~(op_csrr | op_csri);
    assign op2_src = ~op_add;

    assign load_npc = op_jal | op_jalr;

    assign wb_select = op_lb;

    assign alu_src1 = op_auipc;
    assign alu_src2 = (op_add) ? 2'b00 : ((op_slli) ? 2'b01 : 2'b10);
    
    always@(*) 
    begin
        // Mask_func
        if (op_csrr | op_csri) 
        begin
            case (func3[1:0])
                2'b00: Mask_func <= `NOCSR;
                2'b01: Mask_func <= `CSRRW;
                2'b10: Mask_func <= `CSRRS;
                2'b11: Mask_func <= `CSRRC;
            endcase
        end
        else
        begin
            Mask_func <= `NOCSR;
        end
        // ALU_func
        if (op_slli | op_addi | op_add) 
        begin
            case (func3)
                3'b000: 
                begin
                    if (op_slli | op_add)
                        ALU_func <= (inst[30]) ? `SUB : `ADD;
                    else
                        ALU_func <= `ADD;
                end
                3'b001: ALU_func <= `SLL;
                3'b010: ALU_func <= `SLT;
                3'b011: ALU_func <= `SLTU;
                3'b100: ALU_func <= `XOR;
                3'b101: ALU_func <= (inst[30]) ? `SRA : `SRL;
                3'b110: ALU_func <= `OR;
                3'b111: ALU_func <= `AND;
                default: ALU_func <= `ADD;
            endcase
        end
        else if (op_lui)
        begin
            ALU_func <= `LUI;
        end
        else
        begin
            ALU_func <= `ADD;
        end
        // br_type
        if (op_beq)
        begin
            case (func3)
                3'b000: br_type <= `BEQ;
                3'b001: br_type <= `BNE;
                3'b100: br_type <= `BLT;
                3'b101: br_type <= `BGE;
                3'b110: br_type <= `BLTU;
                3'b111: br_type <= `BGEU;
                default: br_type <= `NOBRANCH;
            endcase
        end
        else
        begin
            br_type <= `NOBRANCH;
        end
        // load_type
        if (op_lb)
        begin
            case (func3)
                3'b000: load_type <= `LB;
                3'b001: load_type <= `LH;
                3'b010: load_type <= `LW;
                3'b100: load_type <= `LBU;
                3'b101: load_type <= `LHU;
                default: load_type <= `NOREGWRITE;
            endcase
        end
        else
        begin
            load_type <= `NOREGWRITE;
        end
        // src_reg_en
        if (op_add | op_beq | op_sb)
            src_reg_en <= 2'b11;
        else if (op_addi | op_slli | op_jalr | op_lb | op_csrr)
            src_reg_en <= 2'b10;
        else
            src_reg_en <= 2'b00;
        // reg_write_en
        if (op_beq | op_sb)
            reg_write_en <= 1'b0;
        else
            reg_write_en <= 1'b1;
        // csr_read_en
        if ((op_csri_w | op_csrr_w) && rd == 5'b0)
            csr_read_en <= 1'b0;
        else if (op_csrr | op_csri)
            csr_read_en <= 1'b1;
        else
            csr_read_en <= 1'b0;
        // csr_write_en
        if ((op_csrr_sc && rs1 == 0) || (op_csri_sc && zimm == 0))
            csr_write_en <= 1'b0;
        else if (op_csrr | op_csri)
            csr_write_en <= 1'b1;
        else
            csr_write_en <= 1'b0;
        // cache_write_en
        if (op_sb)
        begin
            case(func3)
                3'b000: cache_write_en <= 4'b0001; // SB
                3'b001: cache_write_en <= 4'b0011; // SH
                3'b010: cache_write_en <= 4'b1111; // SW
                default: cache_write_en <= 4'b0000;
            endcase
        end
        else
        begin
            cache_write_en <= 4'b0000;
        end
        // imm_type
        if (op_add)
            imm_type <= `RTYPE;
        else if (op_slli | op_addi | op_jalr | op_lb)
            imm_type <= `ITYPE;
        else if (op_sb)
            imm_type <= `STYPE;
        else if (op_beq)
            imm_type <= `BTYPE;
        else if (op_lui | op_auipc)
            imm_type <= `UTYPE;
        else if (op_jal)
            imm_type <= `JTYPE;
        else if (op_csrr | op_csri)
            imm_type <= `ZTYPE;
        else
            imm_type <= `RTYPE;
    end

endmodule
