`ifndef __PREDICTOR_STATIC_SV
`define __PREDICTOR_STATIC_SV

`ifdef VERILATOR
`include "include/common.sv"
`endif

module predictor_static import common::*;(
    input  logic is_branch,
    input  logic is_jal,
    input  logic is_jalr,
    input  u64   pc,
    input  u64   target,
    output logic pred_taken,
    output u64   pred_target
);
    // Lab1: 固定静态预测策略，统一采用 Always-Not-Taken。
    // TODO(Lab2+): 在这里替换为可插拔动态预测器（BHT/BTB/RAS）。
    logic [63:0] pc_plus4;
    assign pc_plus4  = pc + 64'd4;
    assign pred_taken = 1'b0;
    assign pred_target = pc_plus4;

    `UNUSED_OK({is_branch, is_jal, is_jalr, target})
endmodule

`endif
