`ifndef __FETCH_SV
`define __FETCH_SV

`ifdef VERILATOR
`include "include/common.sv"
`endif

module fetch import common::*;(
    input  logic       clk,
    input  logic       reset,
    input  logic       stop_fetch,
    input  logic       flush,
    input  logic       redirect_valid,
    input  u64         redirect_pc,
    input  logic       fetch_accept,
    input  u2          current_priv,
    output logic       fetch_ok,
    output logic       fetch_valid,
    output logic       fetch_fault,
    output logic       fetch_stale,
    output u64         fetch_pc,
    output u32         fetch_instr,
    output u2          req_priv,
    output ibus_req_t  ireq,
    input  ibus_resp_t iresp
);
    u64   pc_q;
    u64   req_pc_q;
    u64   data_pc_q;
    logic [1:0] req_priv_q;
    logic req_pending_q;
    logic data_valid_q;
    logic drop_resp_q;
    logic data_ok_prev_q;
    u32   instr_q;
    logic fault_q;
    logic start_request;
    logic response_fire;

    // Keep request stable until response returns.
    assign start_request = !stop_fetch && !flush && !redirect_valid && !req_pending_q && !data_valid_q;
    assign response_fire = req_pending_q && (iresp.data_ok === 1'b1) && !data_ok_prev_q;

    assign ireq.valid = req_pending_q;
    assign ireq.addr  = req_pc_q;
    assign req_priv   = req_priv_q;

    assign fetch_ok    = response_fire;
    assign fetch_valid = data_valid_q;
    assign fetch_fault = fault_q;
    assign fetch_pc    = data_pc_q;
    assign fetch_instr = instr_q;
    assign fetch_stale = 1'b0;

    always_ff @(posedge clk) begin
        if (reset) begin
            pc_q             <= PCINIT;
            req_pc_q         <= PCINIT;
            data_pc_q        <= 64'd0;
            req_priv_q       <= 2'b11;
            req_pending_q    <= 1'b0;
            data_valid_q     <= 1'b0;
            drop_resp_q      <= 1'b0;
            data_ok_prev_q   <= 1'b0;
            instr_q          <= 32'd0;
            fault_q          <= 1'b0;
        end else if (redirect_valid) begin
            data_ok_prev_q <= iresp.data_ok;
            fault_q <= 1'b0;
            pc_q <= redirect_pc;
            data_valid_q <= 1'b0;
            if (response_fire) begin
                req_pending_q <= 1'b0;
                drop_resp_q <= 1'b0;
            end else if (req_pending_q) begin
                drop_resp_q <= 1'b1;
            end
        end else if (flush) begin
            data_ok_prev_q <= iresp.data_ok;
            fault_q <= 1'b0;
            pc_q <= redirect_pc;
            data_valid_q <= 1'b0;
            if (response_fire) begin
                req_pending_q <= 1'b0;
                drop_resp_q <= 1'b0;
            end else if (req_pending_q) begin
                drop_resp_q <= 1'b1;
            end
        end else begin
            data_ok_prev_q <= iresp.data_ok;
            fault_q <= 1'b0;
            if (response_fire) begin
                req_pending_q <= 1'b0;
                if (drop_resp_q) begin
                    drop_resp_q <= 1'b0;
                    data_valid_q <= 1'b0;
                end else if (iresp.fault) begin
                    data_valid_q <= 1'b0;
                    fault_q <= 1'b1;
                end else begin
                    data_valid_q <= 1'b1;
                    data_pc_q <= req_pc_q;
                    instr_q <= iresp.data;
                end
            end else if (start_request) begin
                req_pending_q <= 1'b1;
                req_pc_q <= pc_q;
                req_priv_q <= current_priv;
            end

            if (fetch_accept && data_valid_q) begin
                data_valid_q <= 1'b0;
                pc_q <= data_pc_q + 64'd4;
            end
        end
    end
endmodule

`endif
