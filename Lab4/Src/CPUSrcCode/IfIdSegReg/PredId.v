`timescale 1ns / 1ps

module Pred_ID(
    input wire clk, bubbleD, flushD,
    input wire [31:0] PC_pred_IF,
    input wire PC_pred_en_IF,
    output reg [31:0] PC_pred_ID,
    output reg PC_pred_en_ID
    );

    initial begin
        PC_pred_ID = 0;
        PC_pred_en_ID = 0;
    end
    
    always@(posedge clk)
        if (!bubbleD) 
        begin
            if (flushD) begin
                PC_pred_ID <= 0;
                PC_pred_en_ID <= 0;
            end else begin
                PC_pred_ID <= PC_pred_IF;
                PC_pred_en_ID <= PC_pred_en_IF;
            end
        end
    
endmodule