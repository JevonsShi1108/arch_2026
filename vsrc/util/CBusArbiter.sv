`ifndef __CBUSARBITER_SV
`define __CBUSARBITER_SV

`ifdef VERILATOR
`include "include/common.sv"
`else

`endif
// Round-robin arbiter: issues a new request in the same cycle when idle.

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
    int grant_ptr;
    logic [1:0] saved_priv;
    cbus_req_t saved_req, selected_req;

    assign oreq = busy ? saved_req : (selected_req.valid ? selected_req : '0);
    assign opriv = busy ? saved_priv : iprivs[select];
    assign selected_req = ireqs[select];

    always_comb begin
        select = grant_ptr;
        for (int j = 0; j < NUM_INPUTS; j++) begin
            int i = (grant_ptr + j) % NUM_INPUTS;
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
            if ((oresp.ready === 1'b1) && (oresp.last === 1'b1)) begin
                {busy, saved_req} <= '0;
                grant_ptr <= (index == MAX_INDEX) ? 0 : index + 1;
            end
        end else begin
            busy <= selected_req.valid;
            index <= select;
            saved_req <= selected_req;
            saved_priv <= iprivs[select];
        end
    end else begin
        {busy, index, saved_req, saved_priv, grant_ptr} <= '0;
    end

    `UNUSED_OK({saved_req, saved_priv});
endmodule



`endif