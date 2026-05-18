`ifndef __VTOP_SV
`define __VTOP_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "src/core.sv"
`include "util/IBusToCBus.sv"
`include "util/DBusToCBus.sv"
`include "util/CBusArbiter.sv"
`include "util/MMU.sv"

`endif
module VTop 
	import common::*;(
	input logic clk, reset,

	output cbus_req_t  oreq,
	input  cbus_resp_t oresp,
	input logic trint, swint, exint
);

    ibus_req_t  ireq;
    ibus_resp_t iresp;
    dbus_req_t  dreq;
    dbus_resp_t dresp;
    cbus_req_t  icreq,  dcreq;
    cbus_resp_t icresp, dcresp;
    cbus_req_t  mmu_ireq;
    cbus_resp_t mmu_iresp;
    u2          mmu_priv;
    u2          ireq_priv;
    u2          dreq_priv;
    u2          priv_mode_o;
    u64         satp_o;

    core core(.*);
    IBusToCBus icvt(.*);

    DBusToCBus dcvt(.*);


    CBusArbiter mux(
        .ireqs({icreq, dcreq}),
        .iprivs({ireq_priv, dreq_priv}),
        .iresps({icresp, dcresp}),
        .opriv(mmu_priv),
        .oreq(mmu_ireq),
        .oresp(mmu_iresp),
        .clk,
        .reset
    );

    MMU mmu(
        .clk,
        .reset,
        .up_req(mmu_ireq),
        .up_resp(mmu_iresp),
        .dn_req(oreq),
        .dn_resp(oresp),
        .priv_mode(mmu_priv),
        .satp(satp_o)
    );

	always_ff @(posedge clk) begin
		if (~reset) begin
			// $display("icreq %x, %x", icreq.valid, icreq.addr);
			// if (oreq.valid || dcreq.addr == 64'h40600004) $display("dcreq %x, %x, oreq %x, %x, dcresp %x", dcreq.addr, dcreq.valid, oreq.valid, oreq.addr, dcresp.ready);
		end
	end
	

endmodule



`endif