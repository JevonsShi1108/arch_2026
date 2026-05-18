`ifndef __CBUSARBITER_SV
`define __CBUSARBITER_SV

`ifdef VERILATOR
`include "include/common.sv"
`else

`endif
/**
 * this implementation is not efficient, since
 * it adds one cycle lantency to all requests.
 */

module CBusArbiter
	import common::*;#(
    parameter int NUM_INPUTS = 2,  // NOTE: NUM_INPUTS >= 1

    localparam int MAX_INDEX = NUM_INPUTS - 1
) (
    input logic clk, reset,

    input  cbus_req_t  [MAX_INDEX:0] ireqs,
    output cbus_resp_t [MAX_INDEX:0] iresps,
    output cbus_req_t  oreq,
    input  cbus_resp_t oresp
);
    logic busy;
    int index, select;
    cbus_req_t saved_req, selected_req;
    logic pending_fetch_valid;
    cbus_req_t pending_fetch_req;

    // Latch selected request, then hold it until response last.
    assign oreq = busy ? saved_req : '0;
    assign selected_req = ireqs[select];

    // select a preferred request
    always_comb begin
        select = 0;

        for (int i = 0; i < NUM_INPUTS; i++) begin
            if (ireqs[i].valid) begin
                select = i;
                break;
            end
        end
    end

    // feedback to selected request
    always_comb begin
        iresps = '0;

        if (busy) begin
            for (int i = 0; i < NUM_INPUTS; i++) begin
                if (index == i)
                    iresps[i] = oresp;
            end
        end
    end

    always_ff @(posedge clk)
    if (~reset) begin
        if (busy) begin
            // Capture one in-flight fetch pulse while another requester is busy.
            if (!pending_fetch_valid) begin
                for (int i = 0; i < NUM_INPUTS; i++) begin
                    if ((index != i) && ireqs[i].valid && ireqs[i].is_fetch) begin
                        pending_fetch_valid <= 1'b1;
                        pending_fetch_req <= ireqs[i];
                    end
                end
            end
            if (oresp.last)
                {busy, saved_req} <= '0;
        end else begin
            if (selected_req.valid) begin
                busy <= 1'b1;
                index <= select;
                saved_req <= selected_req;
            end else if (pending_fetch_valid) begin
                busy <= 1'b1;
                // fetch is connected as input 1 in current two-input topology
                index <= 1;
                saved_req <= pending_fetch_req;
                pending_fetch_valid <= 1'b0;
                pending_fetch_req <= '0;
            end else begin
                busy <= 1'b0;
                saved_req <= '0;
            end
        end
    end else begin
        {busy, index, saved_req} <= '0;
        pending_fetch_valid <= 1'b0;
        pending_fetch_req <= '0;
    end

    `UNUSED_OK({saved_req, pending_fetch_req});
endmodule



`endif