`ifndef __PREDICTOR_BHT_SV
`define __PREDICTOR_BHT_SV

`ifdef VERILATOR
`include "include/common.sv"
`endif

// 128-entry 2-bit saturating branch history table (indexed by PC).
module predictor_bht import common::*; #(
    parameter int ENTRIES = 128,
    parameter int IDX_BITS = 7
)(
    input  logic       clk,
    input  logic       reset,
    input  logic       is_branch,
    input  logic       is_jal,
    input  logic       is_jalr,
    input  u64         pc,
    input  u64         target,
    input  logic       train_valid,
    input  logic       train_taken,
    input  u64         train_pc,
    output logic       pred_taken,
    output u64         pred_target
);
    localparam u2 SNT = 2'b00;
    localparam u2 WNT = 2'b01;
    localparam u2 WT  = 2'b10;
    localparam u2 ST  = 2'b11;

    logic [ENTRIES-1:0][1:0] counter;

    logic [IDX_BITS-1:0] idx;
    logic [IDX_BITS-1:0] train_idx;
    logic [1:0]          cnt;
    logic [1:0]          cnt_next;
    logic                jump_pred;
    logic [63:0]         pc_plus4;

    assign idx       = pc[IDX_BITS+1:2];
    assign train_idx = train_pc[IDX_BITS+1:2];
    assign cnt       = counter[idx];
    assign pc_plus4  = pc + 64'd4;
    assign jump_pred = is_jal | is_jalr;

    assign pred_taken  = jump_pred | (is_branch && (cnt == WT || cnt == ST));
    assign pred_target = pred_taken ? target : pc_plus4;

    always_comb begin
        unique case (cnt)
            SNT: cnt_next = train_taken ? WNT : SNT;
            WNT: cnt_next = train_taken ? WT  : SNT;
            WT : cnt_next = train_taken ? ST  : WNT;
            ST : cnt_next = train_taken ? ST  : WT;
            default: cnt_next = WNT;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= '{default: WNT};
        end else if (train_valid) begin
            counter[train_idx] <= cnt_next;
        end
    end
endmodule

`endif
