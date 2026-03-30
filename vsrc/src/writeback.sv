`ifndef __WRITEBACK_SV
`define __WRITEBACK_SV

`ifdef VERILATOR
`include "include/common.sv"
`endif

module writeback_stage import common::*;(
    input  logic in_valid,
    input  u64   in_pc,
    input  u32   in_instr,
    input  u5    in_rd,
    input  logic in_reg_write,
    input  u64   in_result,
    input  logic in_is_ebreak,
    input  logic in_is_trap,
    output logic wb_valid,
    output u64   wb_pc,
    output u32   wb_instr,
    output logic wb_wen,
    output u5    wb_wdest,
    output u64   wb_wdata,
    output logic wb_is_ebreak,
    output logic wb_is_trap
);
    assign wb_valid     = in_valid;
    assign wb_pc        = in_pc;
    assign wb_instr     = in_instr;
    assign wb_wen       = in_valid & in_reg_write & (in_rd != 5'd0);
    assign wb_wdest     = in_rd;
    assign wb_wdata     = in_result;
    assign wb_is_ebreak = in_valid & in_is_ebreak;
    assign wb_is_trap   = in_valid & in_is_trap;
endmodule

`endif
