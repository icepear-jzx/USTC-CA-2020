`timescale 1ns / 1ps

module Pred_EX(
    input wire clk, bubbleE, flushE,
    input wire [6:0] opcode_ID,
    input wire [31:0] PC_pred_ID,
    input wire PC_pred_en_ID,
    output reg [6:0] opcode_EX,
    output reg [31:0] PC_pred_EX,
    output reg PC_pred_en_EX
    );

    initial begin
        opcode_EX = 0;
        PC_pred_EX = 0;
        PC_pred_en_EX = 0;
    end
    
    always@(posedge clk)
        if (!bubbleE) 
        begin
            if (flushE) begin
                opcode_EX <= 0;
                PC_pred_EX <= 0;
                PC_pred_en_EX <= 0;
            end else begin
                opcode_EX <= opcode_ID;
                PC_pred_EX <= PC_pred_ID;
                PC_pred_en_EX <= PC_pred_en_ID;
            end
        end
    
endmodule