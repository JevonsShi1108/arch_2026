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
    input  logic [MAX_INDEX:0][1:0] iprivs,
    output cbus_resp_t [MAX_INDEX:0] iresps,
    output logic [1:0] opriv,
    output cbus_req_t  oreq,
    input  cbus_resp_t oresp
);
    logic busy;
    int index, select;
    logic [1:0] saved_priv;
    cbus_req_t saved_req, selected_req;

    // Latch selected request, then hold it until response last.
    assign oreq = busy ? saved_req : '0;
    assign opriv = busy ? saved_priv : 2'b11;
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
            if ((oresp.ready === 1'b1) && (oresp.last === 1'b1))
                {busy, saved_req} <= '0;
        end else begin
            busy <= selected_req.valid;
            index <= select;
            saved_req <= selected_req;
            saved_priv <= iprivs[select];
        end
    end else begin
        {busy, index, saved_req, saved_priv} <= '0;
    end

    `UNUSED_OK({saved_req, saved_priv});
endmodule



`endif