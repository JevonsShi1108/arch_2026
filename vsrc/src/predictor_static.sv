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
    // JAL/JALR：Always-Taken；条件分支：向后跳转（target < pc）预测 Taken。
    logic [63:0] pc_plus4;
    logic        jump_pred;
    logic        branch_backward;
    assign pc_plus4        = pc + 64'd4;
    assign jump_pred       = is_jal | is_jalr;
    assign branch_backward = is_branch && (target < pc);
    assign pred_taken      = jump_pred | branch_backward;
    assign pred_target     = (jump_pred | branch_backward) ? target : pc_plus4;
endmodule

`endif
