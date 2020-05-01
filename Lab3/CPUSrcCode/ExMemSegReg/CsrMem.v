`timescale 1ns / 1ps

module Csr_MEM(
    input wire clk, bubbleM, flushM,
    input wire csr_write_en_EX,
    input wire [11:0] csr_dest_EX,
    input wire [31:0] csr_data_EX,
    output reg csr_write_en_MEM,
    output reg [11:0] csr_dest_MEM,
    output reg [31:0] csr_data_MEM
    );

    initial 
    begin
        csr_write_en_MEM = 0;
        csr_dest_MEM = 0;
        csr_data_MEM = 0;
    end
    
    always@(posedge clk)
        if (!bubbleM) 
        begin
            if (flushM)
            begin
                csr_write_en_MEM <= 0;
                csr_dest_MEM <= 0;
                csr_data_MEM <= 0;
            end
            else 
            begin
                csr_write_en_MEM <= csr_write_en_EX;
                csr_dest_MEM <= csr_dest_EX;
                csr_data_MEM <= csr_data_EX;
            end
        end
    
endmodule