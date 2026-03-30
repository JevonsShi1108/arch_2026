`ifndef __MEM_SV
`define __MEM_SV

`ifdef VERILATOR
`include "include/common.sv"
`endif

module mem_stage import common::*;(
    input  logic in_valid,
    input  u64   in_pc,
    input  u32   in_instr,
    input  u5    in_rd,
    input  logic in_reg_write,
    input  u64   in_result,
    input  logic in_is_ebreak,
    input  logic in_is_trap,
    output logic out_valid,
    output u64   out_pc,
    output u32   out_instr,
    output u5    out_rd,
    output logic out_reg_write,
    output u64   out_result,
    output logic out_is_ebreak,
    output logic out_is_trap
);
    // 目前先做直通。
    assign out_valid     = in_valid;
    assign out_pc        = in_pc;
    assign out_instr     = in_instr;
    assign out_rd        = in_rd;
    assign out_reg_write = in_reg_write;
    assign out_result    = in_result;
    assign out_is_ebreak = in_is_ebreak;
    assign out_is_trap   = in_is_trap;
endmodule

`endif
