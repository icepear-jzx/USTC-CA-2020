`timescale 1ns / 1ps

module Csr_EX(
    input wire clk, bubbleE, flushE,
    input wire [1:0] Mask_func_ID,
    input wire csr_read_en_ID,
    input wire csr_write_en_ID,
    input wire [11:0] csr_dest_ID,
    input wire [31:0] csr_out_ID,
    input wire [31:0] reg1_or_zimm_ID,
    output reg [1:0] Mask_func_EX,
    output reg csr_read_en_EX,
    output reg csr_write_en_EX,
    output reg [11:0] csr_dest_EX,
    output reg [31:0] csr_out_EX,
    output reg [31:0] reg1_or_zimm_EX
    );

    initial 
    begin
        Mask_func_EX = 0;
        csr_read_en_EX = 0;
        csr_write_en_EX = 0;
        csr_dest_EX = 0;
        csr_out_EX = 0;
        reg1_or_zimm_EX = 0;
    end
    
    always@(posedge clk)
        if (!bubbleE) 
        begin
            if (flushE)
            begin
                Mask_func_EX <= 0;
                csr_read_en_EX <= 0;
                csr_write_en_EX <= 0;
                csr_dest_EX <= 0;
                csr_out_EX <= 0;
                reg1_or_zimm_EX <= 0;
            end
            else 
            begin
                Mask_func_EX <= Mask_func_ID;
                csr_read_en_EX <= csr_read_en_ID;
                csr_write_en_EX <= csr_write_en_ID;
                csr_dest_EX <= csr_dest_ID;
                csr_out_EX <= csr_out_ID;
                reg1_or_zimm_EX <= reg1_or_zimm_ID;
            end
        end
    
endmodule