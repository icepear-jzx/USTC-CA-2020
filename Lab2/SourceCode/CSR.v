`timescale 1ns / 1ps

module CSRFile(
    input wire clk,
    input wire rst,
    input wire read_en,
    input wire write_en,
    input wire [11:0] addr, wb_addr,
    input wire [31:0] wb_data,
    output wire [31:0] csr_out
    );

    reg [31:0] reg_file[4095:0];
    integer i;

    // init register file
    initial
    begin
        for(i = 0; i < 4096; i = i + 1) 
            reg_file[i][31:0] <= 32'b0;
    end

    // write in clk negedge, reset in rst posedge
    // if write register in clk posedge,
    // new wb data also write in clk posedge,
    // so old wb data will be written to register
    always@(negedge clk or posedge rst) 
    begin 
        if (rst)
            for (i = 0; i < 32; i = i + 1) 
                reg_file[i][31:0] <= 32'b0;
        else if(write_en)
            reg_file[wb_addr] <= wb_data;   
    end

    // read data changes when address changes
    assign csr_out = (read_en) ? reg_file[addr] : 32'b0;

endmodule