`ifndef __REGFILE_SV
`define __REGFILE_SV

`ifdef VERILATOR
`include "include/common.sv"
`endif

module regfile import common::*;(
    input  logic clk,
    input  logic reset,
    input  logic wen,
    input  u5    waddr,
    input  u64   wdata,
    input  u5    raddr1,
    input  u5    raddr2,
    output u64   rdata1,
    output u64   rdata2,
    output u64   next_reg[31:0]
);
    u64 REG[31:0];
    u64 next_reg_int[31:0];
    integer i;
    integer j;

    always_comb begin
        for (i = 0; i < 32; i = i + 1) begin
            next_reg_int[i] = REG[i];
        end

        if (wen && (waddr != 5'd0)) begin
            next_reg_int[waddr] = wdata;
        end
        next_reg_int[0] = 64'd0;
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            for (j = 0; j < 32; j = j + 1) begin
                REG[j] <= 64'd0;
            end
        end else begin
            for (j = 0; j < 32; j = j + 1) begin
                REG[j] <= next_reg_int[j];
            end
        end
    end

    assign rdata1 = (raddr1 == 5'd0) ? 64'd0 : REG[raddr1];
    assign rdata2 = (raddr2 == 5'd0) ? 64'd0 : REG[raddr2];

    generate
        genvar gi;
        for (gi = 0; gi < 32; gi = gi + 1) begin : GEN_NEXT_REG
            assign next_reg[gi] = next_reg_int[gi];
        end
    endgenerate
endmodule

`endif
