`timescale 1ns / 1ps

module BTB #(
    parameter ENTRY_ADDR_LEN = 12
)(
    input wire clk, rst,
    input wire [31:0] PC_origin_IF,
    input wire [31:0] PC_origin_EX,
    input wire [31:0] PC_target_EX,
    input wire br_EX,
    input wire [6:0] opcode_EX,
    output reg [31:0] PC_pred_IF,
    output reg PC_pred_en_IF
);

localparam TAG_ADDR_LEN = 30 - ENTRY_ADDR_LEN;
localparam ENTRY_SIZE = 1 << ENTRY_ADDR_LEN;

wire op_br_EX = (opcode_EX == 7'b1100011) ? 1'b1 : 1'b0;

reg [TAG_ADDR_LEN-1:0] origin_buffer [ENTRY_SIZE];
reg [31:0] target_buffer [ENTRY_SIZE];
reg pred_bit [ENTRY_SIZE];

wire [ENTRY_ADDR_LEN-1:0] entry_addr_IF = PC_origin_IF[ENTRY_ADDR_LEN+1:2];
wire [TAG_ADDR_LEN-1:0] tag_addr_IF = PC_origin_IF[31:32-TAG_ADDR_LEN];
wire [ENTRY_ADDR_LEN-1:0] entry_addr_EX = PC_origin_EX[ENTRY_ADDR_LEN+1:2];
wire [TAG_ADDR_LEN-1:0] tag_addr_EX = PC_origin_EX[31:32-TAG_ADDR_LEN];


always @ (*) begin
    if(rst) begin
        PC_pred_IF  <= 32'b0;
        PC_pred_en_IF <= 1'b0;
    end else begin
        if (origin_buffer[entry_addr_IF] == tag_addr_IF) begin
            PC_pred_IF  <= target_buffer[entry_addr_IF];
            PC_pred_en_IF <= pred_bit[entry_addr_IF];
        end else begin
            PC_pred_IF  <= 32'b0;
            PC_pred_en_IF <= 1'b0;
        end
    end
end


always @ (posedge clk or posedge rst) begin
    if (rst) begin
        for (int i = 0; i < ENTRY_SIZE; i++) begin
            origin_buffer[i] <= 0;
            target_buffer[i] <= 32'b0;
            pred_bit[i] <= 1'b0;
        end
    end else begin
        if (op_br_EX) begin
            origin_buffer[entry_addr_EX] <= tag_addr_EX;
            target_buffer[entry_addr_EX] <= PC_target_EX;
            pred_bit[entry_addr_EX] <= br_EX;
        end
    end
end

endmodule