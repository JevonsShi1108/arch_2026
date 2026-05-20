`ifndef __MMU_SV
`define __MMU_SV

`ifdef VERILATOR
`include "include/common.sv"
`endif

// Sv39 MMU for unified CBus requests.
// - up_req/up_resp: virtual-address side (from arbiter)
// - dn_req/dn_resp: physical-address side (to memory)
// - translation is enabled when priv_mode != M and satp.mode == Sv39(8)
module MMU import common::*;(
    input  logic      clk,
    input  logic      reset,
    input  cbus_req_t up_req,
    output cbus_resp_t up_resp,
    output cbus_req_t dn_req,
    input  cbus_resp_t dn_resp,
    input  u2         priv_mode,
    input  u64        satp
);
    localparam u2 PRV_M = 2'b11;
    localparam u2 PRV_U = 2'b00;
    localparam u4 SATP_MODE_SV39 = 4'd8;

    typedef enum logic [2:0] {
        MMU_IDLE = 3'd0,
        MMU_CHECK = 3'd1,
        MMU_PTW_L2 = 3'd2,
        MMU_PTW_L1 = 3'd3,
        MMU_PTW_L0 = 3'd4,
        MMU_FINAL_REQ = 3'd5,
        MMU_FAULT = 3'd6
    } mmu_state_t;

    mmu_state_t state;
    cbus_req_t req_q;
    u64 pte_addr_q;
    u64 pte_data_q;
    u64 phys_addr_q;
    u2  priv_mode_q;
    u64 satp_q;

    logic translate_en_q;
    logic dn_done;
    logic dn_resp_fire;
    logic resp_armed_q;
    u9 req_vpn2;
    u9 req_vpn1;
    u9 req_vpn0;

    function automatic u64 make_pte_addr(
        input u44 base_ppn_i,
        input u9 vpn_idx_i
    );
        begin
            make_pte_addr = {8'd0, base_ppn_i, 12'b0} + {52'd0, vpn_idx_i, 3'b000};
        end
    endfunction

    function automatic logic pte_is_leaf(input u64 pte_i);
        begin
            pte_is_leaf = pte_i[0] && (pte_i[1] || pte_i[2] || pte_i[3]);
        end
    endfunction

    function automatic logic pte_is_nonleaf(input u64 pte_i);
        begin
            pte_is_nonleaf = pte_i[0] && !(pte_i[1] || pte_i[2] || pte_i[3]);
        end
    endfunction

    function automatic logic pte_allow_fetch(input u64 pte_i, input u2 mode_i);
        begin
            pte_allow_fetch = pte_i[3];
            if (mode_i == PRV_U) begin
                pte_allow_fetch = pte_allow_fetch && pte_i[4];
            end
        end
    endfunction

    function automatic logic pte_allow_load(input u64 pte_i, input u2 mode_i);
        begin
            pte_allow_load = pte_i[1];
            if (mode_i == PRV_U) begin
                pte_allow_load = pte_allow_load && pte_i[4];
            end
        end
    endfunction

    function automatic logic pte_allow_store(input u64 pte_i, input u2 mode_i);
        begin
            pte_allow_store = pte_i[2];
            if (mode_i == PRV_U) begin
                pte_allow_store = pte_allow_store && pte_i[4];
            end
        end
    endfunction

    assign translate_en_q = (priv_mode_q != PRV_M) && (satp_q[63:60] == SATP_MODE_SV39);
    assign dn_resp_fire = (dn_resp.ready === 1'b1) && (dn_resp.last === 1'b1);
    // For read responses, require one armed cycle before consuming data on FPGA.
    // Keep write path immediate so MMIO writes are not delayed.
`ifdef VERILATOR
    assign dn_done = dn_resp_fire;
`else
    assign dn_done = (state == MMU_FINAL_REQ && req_q.is_write) ? dn_resp_fire : (resp_armed_q && dn_resp_fire);
`endif
    assign req_vpn2 = req_q.addr[38:30];
    assign req_vpn1 = req_q.addr[29:21];
    assign req_vpn0 = req_q.addr[20:12];

    always_comb begin
        dn_req = '0;
        unique case (state)
            MMU_PTW_L2,
            MMU_PTW_L1,
            MMU_PTW_L0: begin
                dn_req.valid    = 1'b1;
                dn_req.is_write = 1'b0;
                dn_req.is_fetch = 1'b0;
                dn_req.size     = MSIZE8;
                dn_req.addr     = pte_addr_q;
                dn_req.strobe   = 8'd0;
                dn_req.data     = 64'd0;
                dn_req.len      = MLEN1;
                dn_req.burst    = AXI_BURST_FIXED;
            end
            MMU_FINAL_REQ: begin
                dn_req          = req_q;
                dn_req.addr     = phys_addr_q;
            end
            default: begin
                dn_req = '0;
            end
        endcase
    end

    always_comb begin
        up_resp = '0;
        if (state == MMU_FINAL_REQ) begin
            if (dn_done) begin
                up_resp = dn_resp;
            end
        end else if (state == MMU_FAULT) begin
            up_resp.ready = 1'b1;
            up_resp.last = 1'b1;
            up_resp.fault = 1'b1;
            up_resp.data = 64'd0;
        end
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= MMU_IDLE;
            req_q <= '0;
            pte_addr_q <= 64'd0;
            pte_data_q <= 64'd0;
            phys_addr_q <= 64'd0;
            priv_mode_q <= PRV_M;
            satp_q <= 64'd0;
            resp_armed_q <= 1'b0;
        end else begin
            resp_armed_q <= 1'b0;
            unique case (state)
                MMU_IDLE: begin
                    if (up_req.valid) begin
                        req_q <= up_req;
                        priv_mode_q <= priv_mode;
                        satp_q <= satp;
                        state <= MMU_CHECK;
                    end
                end
                MMU_CHECK: begin
                    if (translate_en_q) begin
                        pte_addr_q <= make_pte_addr(satp_q[43:0], req_vpn2);
                        state <= MMU_PTW_L2;
                    end else begin
                        phys_addr_q <= req_q.addr;
                        state <= MMU_FINAL_REQ;
                    end
                end
                MMU_PTW_L2: begin
                    if (dn_done) begin
                        pte_data_q <= dn_resp.data;
                        if (pte_is_nonleaf(dn_resp.data)) begin
                            pte_addr_q <= make_pte_addr(dn_resp.data[53:10], req_vpn1);
                            state <= MMU_PTW_L1;
                        end else begin
                            state <= MMU_FAULT;
                        end
                    end
                    else begin
                        resp_armed_q <= 1'b1;
                    end
                end
                MMU_PTW_L1: begin
                    if (dn_done) begin
                        pte_data_q <= dn_resp.data;
                        if (pte_is_nonleaf(dn_resp.data)) begin
                            pte_addr_q <= make_pte_addr(dn_resp.data[53:10], req_vpn0);
                            state <= MMU_PTW_L0;
                        end else begin
                            state <= MMU_FAULT;
                        end
                    end
                    else begin
                        resp_armed_q <= 1'b1;
                    end
                end
                MMU_PTW_L0: begin
                    if (dn_done) begin
                        pte_data_q <= dn_resp.data;
                        if (pte_is_leaf(dn_resp.data)) begin
                            if (req_q.is_fetch ? pte_allow_fetch(dn_resp.data, priv_mode_q) :
                                (req_q.is_write ? pte_allow_store(dn_resp.data, priv_mode_q)
                                                : pte_allow_load(dn_resp.data, priv_mode_q))) begin
                                phys_addr_q <= {8'd0, dn_resp.data[53:10], req_q.addr[11:0]};
                                state <= MMU_FINAL_REQ;
                            end else begin
                                state <= MMU_FAULT;
                            end
                        end else begin
                            state <= MMU_FAULT;
                        end
                    end
                    else begin
                        resp_armed_q <= 1'b1;
                    end
                end
                MMU_FINAL_REQ: begin
                    if (dn_done) begin
                        req_q <= '0;
                        state <= MMU_IDLE;
                    end
                    else begin
                        resp_armed_q <= 1'b1;
                    end
                end
                MMU_FAULT: begin
                    req_q <= '0;
                    state <= MMU_IDLE;
                end
                default: begin
                    state <= MMU_IDLE;
                end
            endcase
        end
    end

    `UNUSED_OK({pte_data_q, satp_q})
endmodule

`endif
