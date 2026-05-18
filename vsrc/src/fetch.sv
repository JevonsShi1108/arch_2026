`ifndef __FETCH_SV
`define __FETCH_SV

`ifdef VERILATOR
`include "include/common.sv"
`endif

module fetch import common::*;(
    input  logic       clk,
    input  logic       reset,
    input  logic       stop_fetch,
    input  logic       redirect_valid,
    input  u64         redirect_pc,
    output logic       fetch_ok,
    output logic       fetch_valid,
    output logic       fetch_fault,
    output logic       fetch_stale,
    output u64         fetch_pc,
    output u32         fetch_instr,
    output ibus_req_t  ireq,
    input  ibus_resp_t iresp
);
    logic pending;
    logic awaiting_resp;
    u64   req_pc;
    logic redirect_pending;
    u64   redirect_pc_q;

    assign ireq.valid = pending & ~awaiting_resp & ~stop_fetch;
    assign ireq.addr  = req_pc;

    assign fetch_ok    = iresp.data_ok;
    assign fetch_valid = iresp.data_ok & pending & ~iresp.fault;
    assign fetch_fault = iresp.data_ok & pending & iresp.fault;
    assign fetch_pc    = req_pc;
    assign fetch_instr = iresp.data;
    assign fetch_stale = fetch_valid & redirect_pending;

    always_ff @(posedge clk) begin
        if (reset) begin
            pending          <= 1'b1;
            awaiting_resp    <= 1'b0;
            req_pc           <= PCINIT;
            redirect_pending <= 1'b0;
            redirect_pc_q    <= 64'd0;
        end else begin
            if (redirect_valid) begin
                redirect_pending <= 1'b1;
                redirect_pc_q    <= redirect_pc;
                // If there is no outstanding I-bus request, switch fetch PC now.
                if (!awaiting_resp) begin
                    req_pc <= redirect_pc;
                end
            end

            if (pending && iresp.data_ok) begin
                awaiting_resp <= 1'b0;
                if (stop_fetch) begin
                    pending <= 1'b1;
                    req_pc  <= req_pc;
                end else if (iresp.fault) begin
                    // Keep PC stable on fault; core will trap with fetch_fault.
                    pending <= 1'b1;
                    req_pc  <= req_pc;
                end else begin
                    pending <= 1'b1;
                    if (redirect_pending || redirect_valid) begin
                        req_pc           <= redirect_valid ? redirect_pc : redirect_pc_q;
                        redirect_pending <= 1'b0;
                    end else begin
                        req_pc <= req_pc + 64'd4;
                    end
                end
            end else if (ireq.valid) begin
                awaiting_resp <= 1'b1;
            end
        end
    end
endmodule

`endif
