`timescale 1ns / 1ps

`include "Parameters.v"  
module CSRMask(
    input wire [31:0] csr_op1,
    input wire [31:0] csr_op2,
    input wire [1:0] Mask_func,
    output reg [31:0] Mask_out
    );

    always @ (*)
    begin
        case(Mask_func)
            `NOCSR: Mask_out <= 32'b0;
            `CSRRW: Mask_out <= csr_op2;
            `CSRRS: Mask_out <= csr_op1 | csr_op2;
            `CSRRC: Mask_out <= csr_op1 & (~csr_op2);
        endcase
    end

endmodule

