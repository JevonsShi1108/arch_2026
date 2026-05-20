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
    // 条件分支：Always-Not-Taken；JAL/JALR：Always-Taken（目标由译码级提供）。
    logic [63:0] pc_plus4;
    logic        jump_pred;
    assign pc_plus4   = pc + 64'd4;
    assign jump_pred  = is_jal | is_jalr;
    assign pred_taken = jump_pred;
    assign pred_target = jump_pred ? target : pc_plus4;

    `UNUSED_OK({is_branch})
endmodule

`endif
