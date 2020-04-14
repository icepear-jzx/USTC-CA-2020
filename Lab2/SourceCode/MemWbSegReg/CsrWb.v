`timescale 1ns / 1ps

module Csr_WB(
    input wire clk, bubbleW, flushW,
    input wire csr_write_en_MEM,
    input wire [11:0] csr_dest_MEM,
    input wire [31:0] csr_data_MEM,
    output reg csr_write_en_WB,
    output reg [11:0] csr_dest_WB,
    output reg [31:0] csr_data_WB
    );

    initial 
    begin
        csr_write_en_WB = 0;
        csr_dest_WB = 0;
        csr_data_WB = 0;
    end
    
    always@(posedge clk)
        if (!bubbleW) 
        begin
            if (flushW)
            begin
                csr_write_en_WB <= 0;
                csr_dest_WB <= 0;
                csr_data_WB <= 0;
            end
            else 
            begin
                csr_write_en_WB <= csr_write_en_MEM;
                csr_dest_WB <= csr_dest_MEM;
                csr_data_WB <= csr_data_MEM;
            end
        end
    
endmodule