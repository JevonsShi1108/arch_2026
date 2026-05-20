`ifndef __CORE_SV
`define __CORE_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "include/csr.sv"
`include "src/predictor_static.sv"
`include "src/regfile.sv"
`include "src/muldiv_stub.sv"
`include "src/fetch.sv"
`include "src/decode.sv"
`include "src/execute.sv"
`include "src/mem.sv"
`include "src/writeback.sv"
`endif

module core import common::*; import csr_pkg::*;(
	input  logic       clk, reset,
	output ibus_req_t  ireq,
	input  ibus_resp_t iresp,
	output dbus_req_t  dreq,
	input  dbus_resp_t dresp,
	output u2          ireq_priv,
	output u2          dreq_priv,
	output u2          priv_mode_o,
	output u64         satp_o,
	input  logic       trint, swint, exint
);
	typedef struct packed {
		logic valid;
		u64   pc;
		u32   instr;
	} if_id_t;

	typedef struct packed {
		logic valid;
		u64   pc;
		u32   instr;
		u5    rd;
		u5    rs1;
		u5    rs2;
		u64   op1;
		u64   rs2_val;
		u64   imm;
		logic reg_write;
		logic is_imm;
		logic is_word;
		logic is_branch;
		logic is_jal;
		logic is_jalr;
		logic is_auipc;
		logic is_lui;
		logic is_load;
		logic is_store;
		msize_t mem_size;
		logic load_unsigned;
		logic is_ebreak;
		logic is_trap;
		logic is_ecall;
		logic is_mret;
		logic is_muldiv;
		logic is_csr;
		u12   csr_addr;
		u2    csr_op;
		logic csr_use_imm;
		logic csr_we_intent;
		u3    br_funct3;
		u4    alu_op;
		logic pred_taken;
		u64   pred_target;
	} id_ex_t;

	typedef struct packed {
		logic valid;
		u64   pc;
		u32   instr;
		u5    rd;
		logic reg_write;
		u64   result;
		logic is_load;
		logic is_store;
		msize_t mem_size;
		logic load_unsigned;
		u64   mem_addr;
		u64   store_data;
		logic is_ebreak;
		logic is_trap;
		logic is_csr;
		logic csr_we;
		u12   csr_addr;
		u64   csr_old_data;
		u64   csr_new_data;
	} ex_mem_t;

	typedef struct packed {
		logic valid;
		u64   pc;
		u32   instr;
		u5    rd;
		logic reg_write;
		u64   result;
		logic is_load;
		logic is_store;
		logic is_mmio;
		u64   mem_addr;
		logic is_ebreak;
		logic is_trap;
		logic is_csr;
		logic csr_we;
		u12   csr_addr;
		u64   csr_old_data;
		u64   csr_new_data;
	} mem_wb_t;

	localparam u4 ALU_ADD = 4'd0;
	localparam u4 ALU_SUB = 4'd1;
	localparam u4 ALU_AND = 4'd2;
	localparam u4 ALU_OR  = 4'd3;
	localparam u4 ALU_XOR = 4'd4;
	localparam u2 PRV_U = 2'b00;
	localparam u2 PRV_M = 2'b11;
	localparam int MSTATUS_UIE_BIT  = 0;
	localparam int MSTATUS_SIE_BIT  = 1;
	localparam int MSTATUS_MIE_BIT  = 3;
	localparam int MSTATUS_UPIE_BIT = 4;
	localparam int MSTATUS_SPIE_BIT = 5;
	localparam int MSTATUS_MPIE_BIT = 7;
	localparam int MSTATUS_SPP_BIT  = 8;
	localparam int MSTATUS_MPP_LSB  = 11;
	localparam int MSTATUS_MPP_MSB  = 12;
	localparam int MSTATUS_MPRV_BIT = 17;
	localparam u2 CSR_OP_NONE  = 2'd0;
	localparam u2 CSR_OP_WRITE = 2'd1;
	localparam u2 CSR_OP_SET   = 2'd2;
	localparam u2 CSR_OP_CLEAR = 2'd3;

	if_id_t  if_id;
	id_ex_t  id_ex;
	ex_mem_t ex_mem;
	mem_wb_t mem_wb;

	// Fetch
	logic fetch_ok;
	logic fetch_valid;
	logic fetch_fault;
	logic fetch_stale;
	u64   fetch_pc;
	u32   fetch_instr;
	logic branch_mispredict;
	u64   branch_correct_pc;
	logic csr_redirect_valid;
	u64   csr_redirect_pc;
	logic redirect_valid;
	logic fetch_redirect_valid;
	logic fetch_redirect_valid_gated;
	logic fetch_accept;
	u64   redirect_pc;
	logic cpu_halt;
	logic mem_wait;
	u64   csr_mstatus, csr_mtvec, csr_mip, csr_mie;
	u64   csr_mscratch, csr_mcause, csr_mtval, csr_mepc;
	u64   csr_mcycle, csr_satp;
	u64   csr_mhartid;
	u2    priv_mode;
	u2    mmu_priv;
	logic ecall_fire;
	logic instr_fault_fire;
	logic mem_fault_fire;
	logic mem_fault_is_store;
	u64   mem_fault_pc;
	u64   mem_fault_addr;
	logic mret_fire;
	logic trap_redirect_valid;
	u64   trap_redirect_pc;
	u64   exec_mepc_view;
	u64   exec_mtvec_view;
	u64   ecall_mstatus_new;
	u64   mret_mstatus_new;
	u2    mret_target_mode;
	u64   ecall_mcause;

	function automatic u64 set_mstatus_field(
		input u64 old_val_i,
		input int lsb_i,
		input int msb_i,
		input u64 field_val_i
	);
		u64 mask;
		begin
			mask = ((64'h1 << (msb_i - lsb_i + 1)) - 64'h1) << lsb_i;
			set_mstatus_field = (old_val_i & ~mask) | ((field_val_i << lsb_i) & mask);
		end
	endfunction

	function automatic u64 ecall_cause_by_mode(input u2 mode_i);
		begin
			unique case (mode_i)
				PRV_U:   ecall_cause_by_mode = 64'd8;
				2'b01:   ecall_cause_by_mode = 64'd9;
				default: ecall_cause_by_mode = 64'd11;
			endcase
		end
	endfunction

	function automatic u64 csr_read_data(
		input u12 csr_addr_i,
		input u64 mstatus_i,
		input u64 mtvec_i,
		input u64 mip_i,
		input u64 mie_i,
		input u64 mscratch_i,
		input u64 mcause_i,
		input u64 mtval_i,
		input u64 mepc_i,
		input u64 mcycle_i,
		input u64 mhartid_i,
		input u64 satp_i
	);
		begin
			unique case (csr_addr_i)
				CSR_MSTATUS:  csr_read_data = mstatus_i & MSTATUS_MASK;
				CSR_MTVEC:    csr_read_data = mtvec_i & MTVEC_MASK;
				CSR_MIP:      csr_read_data = mip_i & MIP_MASK;
				CSR_MIE:      csr_read_data = mie_i;
				CSR_MSCRATCH: csr_read_data = mscratch_i;
				CSR_MCAUSE:   csr_read_data = mcause_i;
				CSR_MTVAL:    csr_read_data = mtval_i;
				CSR_MEPC:     csr_read_data = mepc_i;
				CSR_MCYCLE:   csr_read_data = mcycle_i;
				CSR_MHARTID:  csr_read_data = mhartid_i;
				CSR_SATP:     csr_read_data = satp_i;
				default:      csr_read_data = 64'd0;
			endcase
		end
	endfunction

	function automatic u64 csr_apply_mask(
		input u12 csr_addr_i,
		input u64 old_val_i,
		input u64 cand_val_i
	);
		begin
			unique case (csr_addr_i)
				CSR_MSTATUS:  csr_apply_mask = (old_val_i & ~MSTATUS_MASK) | (cand_val_i & MSTATUS_MASK);
				CSR_MTVEC:    csr_apply_mask = (old_val_i & ~MTVEC_MASK) | (cand_val_i & MTVEC_MASK);
				CSR_MIP:      csr_apply_mask = (old_val_i & ~MIP_MASK) | (cand_val_i & MIP_MASK);
				CSR_MIE:      csr_apply_mask = cand_val_i;
				CSR_MHARTID:  csr_apply_mask = old_val_i;
				CSR_MSCRATCH,
				CSR_MCAUSE,
				CSR_MTVAL,
				CSR_MEPC,
				CSR_MCYCLE,
				CSR_SATP:     csr_apply_mask = cand_val_i;
				default:      csr_apply_mask = old_val_i;
			endcase
		end
	endfunction

	function automatic logic csr_write_needs_flush(input u12 csr_addr_i);
		begin
			unique case (csr_addr_i)
				CSR_MSTATUS,
				CSR_MTVEC,
				CSR_SATP: csr_write_needs_flush = 1'b1;
				default:  csr_write_needs_flush = 1'b0;
			endcase
		end
	endfunction

	assign csr_mhartid = 64'd0;
	assign priv_mode_o = mmu_priv;
	assign satp_o = csr_satp;
	assign ecall_fire = id_ex.valid & id_ex.is_ecall & ~mem_wait & ~cpu_halt;
	assign instr_fault_fire = fetch_fault & ~cpu_halt;
	assign mret_fire  = id_ex.valid & id_ex.is_mret  & ~mem_wait & ~cpu_halt;
	assign trap_redirect_valid = ecall_fire | instr_fault_fire | mem_fault_fire | mret_fire;

	always_comb begin
		exec_mepc_view  = csr_mepc;
		exec_mtvec_view = csr_mtvec;
		if (mem_wb.valid && mem_wb.is_csr && mem_wb.csr_we) begin
			if (mem_wb.csr_addr == CSR_MEPC)  exec_mepc_view  = mem_wb.csr_new_data;
			if (mem_wb.csr_addr == CSR_MTVEC) exec_mtvec_view = mem_wb.csr_new_data & MTVEC_MASK;
		end
		if (ex_mem.valid && ex_mem.is_csr && ex_mem.csr_we) begin
			if (ex_mem.csr_addr == CSR_MEPC)  exec_mepc_view  = ex_mem.csr_new_data;
			if (ex_mem.csr_addr == CSR_MTVEC) exec_mtvec_view = ex_mem.csr_new_data & MTVEC_MASK;
		end
	end

	assign trap_redirect_pc = (ecall_fire | instr_fault_fire | mem_fault_fire) ? exec_mtvec_view :
	                          exec_mepc_view;

	logic decode_jal_redirect;
	assign decode_jal_redirect = if_id.valid && (dec_is_jal || dec_is_jalr) && ~mem_wait && ~cpu_halt;

	assign fetch_redirect_valid = ecall_fire | mem_fault_fire | mret_fire | csr_redirect_valid |
	                              branch_mispredict | decode_jal_redirect;
	assign fetch_redirect_valid_gated = fetch_redirect_valid & ~mem_wait & ~cpu_halt;
	assign redirect_valid = trap_redirect_valid | csr_redirect_valid | branch_mispredict;
	assign redirect_pc = trap_redirect_valid ? trap_redirect_pc :
	                     (csr_redirect_valid ? csr_redirect_pc :
	                     (branch_mispredict ? branch_correct_pc :
	                     (decode_jal_redirect ? dec_pred_target : 64'd0)));
	assign fetch_accept = fetch_valid && !fetch_stale && !cpu_halt && !mem_wait &&
	                     !fetch_redirect_valid_gated && !instr_fault_fire;

	logic stop_fetch;
	assign stop_fetch = cpu_halt;

	fetch u_fetch(
		.clk,
		.reset,
		.stop_fetch,
		.flush(instr_fault_fire),
		.redirect_valid(fetch_redirect_valid_gated),
		.redirect_pc(redirect_pc),
		.fetch_accept(fetch_accept),
		.current_priv(mmu_priv),
		.fetch_ok,
		.fetch_valid,
		.fetch_fault,
		.fetch_stale,
		.fetch_pc,
		.fetch_instr,
		.req_priv(ireq_priv),
		.ireq,
		.iresp
	);

	// Decode + Predictor
	u5    dec_rs1, dec_rs2, dec_rd;
	u64   dec_imm;
	logic dec_use_rs1, dec_use_rs2, dec_reg_write, dec_is_imm, dec_is_word;
	logic dec_is_branch, dec_is_jal, dec_is_jalr, dec_is_auipc, dec_is_lui, dec_is_load, dec_is_store;
	msize_t dec_mem_size;
	logic dec_load_unsigned;
	logic dec_is_ebreak, dec_is_trap, dec_is_ecall, dec_is_mret, dec_is_muldiv;
	logic dec_is_csr, dec_csr_use_imm, dec_csr_we_intent;
	u12   dec_csr_addr;
	u2    dec_csr_op;
	u3    dec_br_funct3;
	u4    dec_alu_op;
	logic dec_pred_taken;
	u64   dec_pred_target;

	decode u_decode(
		.pc(if_id.pc),
		.instr(if_id.instr),
		.rs1(dec_rs1),
		.rs2(dec_rs2),
		.rd(dec_rd),
		.imm(dec_imm),
		.use_rs1(dec_use_rs1),
		.use_rs2(dec_use_rs2),
		.reg_write(dec_reg_write),
		.is_imm(dec_is_imm),
		.is_word(dec_is_word),
		.is_branch(dec_is_branch),
		.is_jal(dec_is_jal),
		.is_jalr(dec_is_jalr),
		.is_auipc(dec_is_auipc),
		.is_lui(dec_is_lui),
		.is_load(dec_is_load),
		.is_store(dec_is_store),
		.mem_size(dec_mem_size),
		.load_unsigned(dec_load_unsigned),
		.is_ebreak(dec_is_ebreak),
		.is_trap(dec_is_trap),
		.is_ecall(dec_is_ecall),
		.is_mret(dec_is_mret),
		.is_muldiv(dec_is_muldiv),
		.is_csr(dec_is_csr),
		.csr_addr(dec_csr_addr),
		.csr_op(dec_csr_op),
		.csr_use_imm(dec_csr_use_imm),
		.csr_we_intent(dec_csr_we_intent),
		.br_funct3(dec_br_funct3),
		.alu_op(dec_alu_op)
	);

	predictor_static u_predictor(
		.is_branch(dec_is_branch),
		.is_jal(dec_is_jal),
		.is_jalr(dec_is_jalr),
		.pc(if_id.pc),
		.target(if_id.pc + dec_imm),
		.pred_taken(dec_pred_taken),
		.pred_target(dec_pred_target)
	);

	// Register file + forwarding
	u64 rf_rdata1, rf_rdata2;
	u64 rf_reg_state[31:0];
	u64 rf_next_reg[31:0];
	logic wb_wen;
	u5    wb_wdest;
	u64   wb_wdata;

	regfile u_regfile(
		.clk,
		.reset,
		.wen(wb_wen),
		.waddr(wb_wdest),
		.wdata(wb_wdata),
		.raddr1(dec_rs1),
		.raddr2(dec_rs2),
		.rdata1(rf_rdata1),
		.rdata2(rf_rdata2),
		.reg_state(rf_reg_state),
		.next_reg(rf_next_reg)
	);

	u64 id_op1_pre;
	u64 id_rs2_pre;

	logic ex_fwd_valid;
	u5    ex_fwd_rd;
	u64   ex_fwd_data;
	assign ex_fwd_valid = ex_valid & ex_out_reg_write & !ex_out_is_load & (ex_out_rd != 5'd0);
	assign ex_fwd_rd    = ex_out_rd;
	assign ex_fwd_data  = ex_out_result;

	always_comb begin
		id_op1_pre = rf_rdata1;
		if (dec_use_rs1 && (dec_rs1 != 5'd0)) begin
			if (ex_fwd_valid && (ex_fwd_rd == dec_rs1)) begin
				id_op1_pre = ex_fwd_data;
			end else if (ex_mem.valid && ex_mem.reg_write && !ex_mem.is_load &&
			             (ex_mem.rd != 5'd0) && (ex_mem.rd == dec_rs1)) begin
				id_op1_pre = ex_mem.result;
			end else if (mem_wb.valid && mem_wb.reg_write && (mem_wb.rd != 5'd0) && (mem_wb.rd == dec_rs1)) begin
				id_op1_pre = mem_wb.result;
			end
		end

		id_rs2_pre = rf_rdata2;
		if (dec_use_rs2 && (dec_rs2 != 5'd0)) begin
			if (ex_fwd_valid && (ex_fwd_rd == dec_rs2)) begin
				id_rs2_pre = ex_fwd_data;
			end else if (ex_mem.valid && ex_mem.reg_write && !ex_mem.is_load &&
			             (ex_mem.rd != 5'd0) && (ex_mem.rd == dec_rs2)) begin
				id_rs2_pre = ex_mem.result;
			end else if (mem_wb.valid && mem_wb.reg_write && (mem_wb.rd != 5'd0) && (mem_wb.rd == dec_rs2)) begin
				id_rs2_pre = mem_wb.result;
			end
		end
	end

	// Execute
	logic muldiv_busy, muldiv_ready, muldiv_result_valid;
	u64   muldiv_result;

	muldiv_stub u_muldiv_stub(
		.clk,
		.reset,
		.req_valid(id_ex.valid & id_ex.is_muldiv),
		.op_a(id_ex.op1),
		.op_b(id_ex.rs2_val),
		.op_sel(3'd0),
		.busy(muldiv_busy),
		.ready(muldiv_ready),
		.result_valid(muldiv_result_valid),
		.result(muldiv_result)
	);

	logic ex_valid, ex_out_reg_write, ex_out_is_load, ex_out_is_store;
	logic ex_out_load_unsigned, ex_out_is_ebreak, ex_out_is_trap;
	msize_t ex_out_mem_size;
	u64   ex_out_pc, ex_out_result;
	u64   ex_out_mem_addr, ex_out_store_data;
	u32   ex_out_instr;
	u5    ex_out_rd;

	execute u_execute(
		.valid(id_ex.valid),
		.pc(id_ex.pc),
		.instr(id_ex.instr),
		.rd(id_ex.rd),
		.op1(id_ex.op1),
		.rs2_val(id_ex.rs2_val),
		.imm(id_ex.imm),
		.reg_write(id_ex.reg_write),
		.is_imm(id_ex.is_imm),
		.is_word(id_ex.is_word),
		.is_branch(id_ex.is_branch),
		.is_jal(id_ex.is_jal),
		.is_jalr(id_ex.is_jalr),
		.is_auipc(id_ex.is_auipc),
		.is_lui(id_ex.is_lui),
		.is_load(id_ex.is_load),
		.is_store(id_ex.is_store),
		.mem_size(id_ex.mem_size),
		.load_unsigned(id_ex.load_unsigned),
		.is_ebreak(id_ex.is_ebreak),
		.is_trap(id_ex.is_trap),
		.is_muldiv(id_ex.is_muldiv),
		.br_funct3(id_ex.br_funct3),
		.alu_op(id_ex.alu_op),
		.pred_taken(id_ex.pred_taken),
		.pred_target(id_ex.pred_target),
		.muldiv_busy,
		.muldiv_ready,
		.muldiv_result_valid,
		.muldiv_result,
		.out_valid(ex_valid),
		.out_pc(ex_out_pc),
		.out_instr(ex_out_instr),
		.out_rd(ex_out_rd),
		.out_reg_write(ex_out_reg_write),
		.out_result(ex_out_result),
		.out_is_load(ex_out_is_load),
		.out_is_store(ex_out_is_store),
		.out_mem_size(ex_out_mem_size),
		.out_load_unsigned(ex_out_load_unsigned),
		.out_mem_addr(ex_out_mem_addr),
		.out_store_data(ex_out_store_data),
		.out_is_ebreak(ex_out_is_ebreak),
		.out_is_trap(ex_out_is_trap),
		.branch_mispredict,
		.branch_correct_pc
	);

	u64   ex_csr_src_data;
	u64   ex_csr_old_data;
	u64   ex_csr_candidate_new;
	u64   ex_csr_new_data;
	logic ex_csr_we;
	u64   ex_result_final;

	assign ex_csr_src_data = id_ex.csr_use_imm ? {59'd0, id_ex.rs1} : id_ex.op1;

	u64 csr_fwd_mstatus, csr_fwd_mtvec, csr_fwd_mip, csr_fwd_mie;
	u64 csr_fwd_mscratch, csr_fwd_mcause, csr_fwd_mtval, csr_fwd_mepc;
	u64 csr_fwd_mcycle, csr_fwd_satp;

	always_comb begin
		csr_fwd_mstatus  = csr_mstatus;
		csr_fwd_mtvec    = csr_mtvec;
		csr_fwd_mip      = csr_mip;
		csr_fwd_mie      = csr_mie;
		csr_fwd_mscratch = csr_mscratch;
		csr_fwd_mcause   = csr_mcause;
		csr_fwd_mtval    = csr_mtval;
		csr_fwd_mepc     = csr_mepc;
		csr_fwd_mcycle   = csr_mcycle;
		csr_fwd_satp     = csr_satp;

		if (mem_wb.valid && mem_wb.is_csr && mem_wb.csr_we) begin
			unique case (mem_wb.csr_addr)
				CSR_MSTATUS:  csr_fwd_mstatus  = mem_wb.csr_new_data;
				CSR_MTVEC:    csr_fwd_mtvec    = mem_wb.csr_new_data;
				CSR_MIP:      csr_fwd_mip      = mem_wb.csr_new_data;
				CSR_MIE:      csr_fwd_mie      = mem_wb.csr_new_data;
				CSR_MSCRATCH: csr_fwd_mscratch = mem_wb.csr_new_data;
				CSR_MCAUSE:   csr_fwd_mcause   = mem_wb.csr_new_data;
				CSR_MTVAL:    csr_fwd_mtval    = mem_wb.csr_new_data;
				CSR_MEPC:     csr_fwd_mepc     = mem_wb.csr_new_data;
				CSR_MCYCLE:   csr_fwd_mcycle   = mem_wb.csr_new_data;
				CSR_SATP:     csr_fwd_satp     = mem_wb.csr_new_data;
				default: begin
				end
			endcase
		end

		if (ex_mem.valid && ex_mem.is_csr && ex_mem.csr_we) begin
			unique case (ex_mem.csr_addr)
				CSR_MSTATUS:  csr_fwd_mstatus  = ex_mem.csr_new_data;
				CSR_MTVEC:    csr_fwd_mtvec    = ex_mem.csr_new_data;
				CSR_MIP:      csr_fwd_mip      = ex_mem.csr_new_data;
				CSR_MIE:      csr_fwd_mie      = ex_mem.csr_new_data;
				CSR_MSCRATCH: csr_fwd_mscratch = ex_mem.csr_new_data;
				CSR_MCAUSE:   csr_fwd_mcause   = ex_mem.csr_new_data;
				CSR_MTVAL:    csr_fwd_mtval    = ex_mem.csr_new_data;
				CSR_MEPC:     csr_fwd_mepc     = ex_mem.csr_new_data;
				CSR_MCYCLE:   csr_fwd_mcycle   = ex_mem.csr_new_data;
				CSR_SATP:     csr_fwd_satp     = ex_mem.csr_new_data;
				default: begin
				end
			endcase
		end
	end

	assign ex_csr_old_data = csr_read_data(
		id_ex.csr_addr,
		csr_fwd_mstatus,
		csr_fwd_mtvec,
		csr_fwd_mip,
		csr_fwd_mie,
		csr_fwd_mscratch,
		csr_fwd_mcause,
		csr_fwd_mtval,
		csr_fwd_mepc,
		csr_fwd_mcycle,
		csr_mhartid,
		csr_fwd_satp
	);

	always_comb begin
		ex_csr_candidate_new = ex_csr_old_data;
		unique case (id_ex.csr_op)
			CSR_OP_WRITE: ex_csr_candidate_new = ex_csr_src_data;
			CSR_OP_SET:   ex_csr_candidate_new = ex_csr_old_data | ex_csr_src_data;
			CSR_OP_CLEAR: ex_csr_candidate_new = ex_csr_old_data & ~ex_csr_src_data;
			default:      ex_csr_candidate_new = ex_csr_old_data;
		endcase
	end

	assign ex_csr_new_data = csr_apply_mask(id_ex.csr_addr, ex_csr_old_data, ex_csr_candidate_new);
	assign ex_csr_we = id_ex.valid & id_ex.is_csr & id_ex.csr_we_intent & (id_ex.csr_addr != CSR_MHARTID);
	assign ex_result_final = id_ex.is_csr ? ex_csr_old_data : ex_out_result;
	assign csr_redirect_valid = ex_csr_we & csr_write_needs_flush(id_ex.csr_addr);
	assign csr_redirect_pc = id_ex.pc + 64'd4;
	assign ecall_mcause = ecall_cause_by_mode(priv_mode);

	always_comb begin
		ecall_mstatus_new = csr_mstatus;
		ecall_mstatus_new[MSTATUS_MPIE_BIT] = csr_mstatus[MSTATUS_MIE_BIT];
		ecall_mstatus_new[MSTATUS_MIE_BIT] = 1'b0;
		ecall_mstatus_new = set_mstatus_field(ecall_mstatus_new, MSTATUS_MPP_LSB, MSTATUS_MPP_MSB, {62'd0, priv_mode});

		mret_target_mode = csr_mstatus[MSTATUS_MPP_MSB:MSTATUS_MPP_LSB];
		mret_mstatus_new = csr_mstatus;
		mret_mstatus_new[MSTATUS_MIE_BIT] = csr_mstatus[MSTATUS_MPIE_BIT];
		mret_mstatus_new[MSTATUS_MPIE_BIT] = 1'b1;
		mret_mstatus_new = set_mstatus_field(mret_mstatus_new, MSTATUS_MPP_LSB, MSTATUS_MPP_MSB, {62'd0, PRV_U});
		if (mret_target_mode != PRV_M) begin
			mret_mstatus_new[MSTATUS_MPRV_BIT] = 1'b0;
		end
	end

	// MEM
	logic mem_out_valid, mem_out_reg_write, mem_out_is_load, mem_out_is_store, mem_out_is_ebreak, mem_out_is_trap;
	logic mem_out_is_mmio;
	logic mem_out_fault;
	logic mem_out_fault_is_store;
	u64   mem_out_pc, mem_out_result;
	u64   mem_out_mem_addr;
	u32   mem_out_instr;
	u5    mem_out_rd;

	mem_stage u_mem(
		.clk,
		.reset,
		.flush(wb_is_trap),
		.in_valid(ex_mem.valid),
		.in_pc(ex_mem.pc),
		.in_instr(ex_mem.instr),
		.in_rd(ex_mem.rd),
		.in_reg_write(ex_mem.reg_write),
		.in_result(ex_mem.result),
		.in_is_load(ex_mem.is_load),
		.in_is_store(ex_mem.is_store),
		.in_mem_size(ex_mem.mem_size),
		.in_load_unsigned(ex_mem.load_unsigned),
		.in_mem_addr(ex_mem.mem_addr),
		.in_store_data(ex_mem.store_data),
		.in_is_ebreak(ex_mem.is_ebreak),
		.in_is_trap(ex_mem.is_trap),
		.current_priv(mmu_priv),
		.dreq,
		.dresp,
		.req_priv(dreq_priv),
		.mem_wait,
		.out_valid(mem_out_valid),
		.out_pc(mem_out_pc),
		.out_instr(mem_out_instr),
		.out_rd(mem_out_rd),
		.out_reg_write(mem_out_reg_write),
		.out_result(mem_out_result),
		.out_is_load(mem_out_is_load),
		.out_is_store(mem_out_is_store),
		.out_mem_addr(mem_out_mem_addr),
		.out_fault(mem_out_fault),
		.out_fault_is_store(mem_out_fault_is_store),
		.out_is_ebreak(mem_out_is_ebreak),
		.out_is_trap(mem_out_is_trap),
		.out_is_mmio(mem_out_is_mmio)
	);
	assign mem_fault_fire = mem_out_valid & mem_out_fault & ~cpu_halt;
	assign mem_fault_is_store = mem_out_fault_is_store;
	assign mem_fault_pc = mem_out_pc;
	assign mem_fault_addr = mem_out_mem_addr;

	// WB
	logic wb_valid, wb_is_ebreak, wb_is_trap;
	u64   wb_pc;
	u32   wb_instr;

	writeback_stage u_wb(
		.in_valid(mem_wb.valid),
		.in_pc(mem_wb.pc),
		.in_instr(mem_wb.instr),
		.in_rd(mem_wb.rd),
		.in_reg_write(mem_wb.reg_write),
		.in_result(mem_wb.result),
		.in_is_ebreak(mem_wb.is_ebreak),
		.in_is_trap(mem_wb.is_trap),
		.wb_valid,
		.wb_pc,
		.wb_instr,
		.wb_wen,
		.wb_wdest,
		.wb_wdata,
		.wb_is_ebreak,
		.wb_is_trap
	);

	// Commit register for Difftest
	logic commit_valid, commit_wen, commit_is_trap, commit_is_mem, commit_skip;
	u64   commit_pc, commit_wdata, commit_mem_addr;
	u32   commit_instr;
	u5    commit_wdest;

`ifdef VERILATOR
	localparam u64 JALR_RET_PC = 64'h0000_0000_8000_1f18;

	// Board panic("") path: mret fell through to usertrapret jalr return site.
	always_ff @(posedge clk) begin
		if (!reset && mret_fire && (redirect_pc == JALR_RET_PC)) begin
			$fatal(1, "mret redirect_pc=0x%016h (jalr return), exec_mepc_view=0x%016h csr_mepc=0x%016h",
			       redirect_pc, exec_mepc_view, csr_mepc);
		end
	end
`endif

`ifdef VERILATOR
	task automatic debug_log_core(
		input string run_id,
		input string hypothesis_id,
		input string location,
		input string message,
		input u64 pc,
		input u64 addr,
		input u64 extra0,
		input u64 extra1,
		input logic flag0,
		input logic flag1,
		input logic flag2
	);
		integer fd;
		string payload;
		begin
			fd = $fopen("/home/jevonsshi/arch_2026/.cursor/debug-f06466.log", "a");
			if (fd != 0) begin
				payload = $sformatf(
					"{\"sessionId\":\"f06466\",\"runId\":\"%s\",\"hypothesisId\":\"%s\",\"location\":\"%s\",\"message\":\"%s\",\"data\":{\"pc\":\"0x%016h\",\"addr\":\"0x%016h\",\"extra0\":\"0x%016h\",\"extra1\":\"0x%016h\",\"flag0\":%0d,\"flag1\":%0d,\"flag2\":%0d},\"timestamp\":%0t}",
					run_id, hypothesis_id, location, message, pc, addr, extra0, extra1, flag0, flag1, flag2, $time
				);
				$fdisplay(fd, "%s", payload);
				$fclose(fd);
			end
		end
	endtask
`endif

	// Pipeline registers update
	u64 cycle_cnt, instr_cnt;
	u64 cycle_cnt_n, instr_cnt_n;
	assign cycle_cnt_n = cycle_cnt + 64'd1;
	assign instr_cnt_n = instr_cnt + (wb_valid ? 64'd1 : 64'd0);

`ifdef VERILATOR
	u64 cyc_mem_wait, cyc_stop_fetch, cnt_branch_mispredict, cnt_csr_redirect, cnt_trap_redirect;
	logic perf_reported;
`endif

	logic load_use_hazard;
	logic load_use_hazard_idex;
	logic load_use_hazard_exmem;
	u8    mem_wait_cycles;
	assign load_use_hazard_idex = if_id.valid && id_ex.valid && id_ex.is_load && (id_ex.rd != 5'd0) &&
	                              ((dec_use_rs1 && (dec_rs1 == id_ex.rd)) ||
	                               (dec_use_rs2 && (dec_rs2 == id_ex.rd)));
	assign load_use_hazard_exmem = if_id.valid && ex_mem.valid && ex_mem.is_load && (ex_mem.rd != 5'd0) &&
	                               ((dec_use_rs1 && (dec_rs1 == ex_mem.rd)) ||
	                                (dec_use_rs2 && (dec_rs2 == ex_mem.rd)));
	assign load_use_hazard = load_use_hazard_idex | load_use_hazard_exmem;

	always_ff @(posedge clk) begin
		if (reset) begin
			if_id        <= '0;
			id_ex        <= '0;
			ex_mem       <= '0;
			mem_wb       <= '0;
			commit_valid <= 1'b0;
			commit_pc    <= 64'd0;
			commit_instr <= 32'd0;
			commit_wen   <= 1'b0;
			commit_wdest <= 5'd0;
			commit_wdata <= 64'd0;
			commit_is_trap <= 1'b0;
			commit_is_mem  <= 1'b0;
			commit_skip    <= 1'b0;
			commit_mem_addr<= 64'd0;
			cpu_halt     <= 1'b0;
			cycle_cnt <= 64'd0;
			instr_cnt <= 64'd0;
`ifdef VERILATOR
			cyc_mem_wait <= 64'd0;
			cyc_stop_fetch <= 64'd0;
			cnt_branch_mispredict <= 64'd0;
			cnt_csr_redirect <= 64'd0;
			cnt_trap_redirect <= 64'd0;
			perf_reported <= 1'b0;
`endif
			mem_wait_cycles <= '0;
			csr_mstatus  <= 64'd0;
			csr_mtvec    <= 64'd0;
			csr_mip      <= 64'd0;
			csr_mie      <= 64'd0;
			csr_mscratch <= 64'd0;
			csr_mcause   <= 64'd0;
			csr_mtval    <= 64'd0;
			csr_mepc     <= 64'd0;
			csr_mcycle   <= 64'd0;
			csr_satp     <= 64'd0;
			priv_mode    <= PRV_M;
			mmu_priv     <= PRV_M;
		end else begin
			if (id_ex.valid && fetch_redirect_valid_gated && id_ex.is_ecall) begin
				mmu_priv <= PRV_M;
			end else if (id_ex.valid && fetch_redirect_valid_gated && id_ex.is_mret) begin
				mmu_priv <= mret_target_mode;
			end else begin
				mmu_priv <= priv_mode;
			end
			cycle_cnt <= cycle_cnt_n;
			instr_cnt <= instr_cnt_n;
			csr_mcycle <= csr_mcycle + 64'd1;
`ifdef VERILATOR
			if (mem_wait) begin
				cyc_mem_wait <= cyc_mem_wait + 64'd1;
			end
			if (stop_fetch) begin
				cyc_stop_fetch <= cyc_stop_fetch + 64'd1;
			end
			if (branch_mispredict) begin
				cnt_branch_mispredict <= cnt_branch_mispredict + 64'd1;
			end
			if (csr_redirect_valid) begin
				cnt_csr_redirect <= cnt_csr_redirect + 64'd1;
			end
			if (trap_redirect_valid) begin
				cnt_trap_redirect <= cnt_trap_redirect + 64'd1;
			end
			if (wb_is_trap && !perf_reported) begin
				perf_reported <= 1'b1;
				$display("[PERF] mem_wait cycles=%0d (%.1f%%), stop_fetch cycles=%0d (%.1f%%)",
				         cyc_mem_wait, 100.0 * cyc_mem_wait / cycle_cnt_n,
				         cyc_stop_fetch, 100.0 * cyc_stop_fetch / cycle_cnt_n);
				$display("[PERF] branch_mispredict=%0d (%.3f/inst), csr_redirect=%0d, trap_redirect=%0d",
				         cnt_branch_mispredict, cnt_branch_mispredict * 1.0 / instr_cnt_n,
				         cnt_csr_redirect, cnt_trap_redirect);
			end
`endif
			if (mem_wait) begin
				mem_wait_cycles <= mem_wait_cycles + 8'd1;
			end else begin
				mem_wait_cycles <= '0;
			end
			if (mem_wb.valid && mem_wb.is_csr && mem_wb.csr_we) begin
				unique case (mem_wb.csr_addr)
					CSR_MSTATUS:  csr_mstatus  <= mem_wb.csr_new_data;
					CSR_MTVEC:    csr_mtvec    <= mem_wb.csr_new_data;
					CSR_MIP:      csr_mip      <= mem_wb.csr_new_data;
					CSR_MIE:      csr_mie      <= mem_wb.csr_new_data;
					CSR_MSCRATCH: csr_mscratch <= mem_wb.csr_new_data;
					CSR_MCAUSE:   csr_mcause   <= mem_wb.csr_new_data;
					CSR_MTVAL:    csr_mtval    <= mem_wb.csr_new_data;
					CSR_MEPC:     csr_mepc     <= mem_wb.csr_new_data;
					CSR_MCYCLE:   csr_mcycle   <= mem_wb.csr_new_data;
					CSR_SATP:     csr_satp     <= mem_wb.csr_new_data;
					default: begin
					end
				endcase
			end

			if (ecall_fire) begin
				csr_mepc    <= id_ex.pc;
				csr_mcause  <= ecall_mcause;
				csr_mtval   <= 64'd0;
				csr_mstatus <= ecall_mstatus_new;
				priv_mode   <= PRV_M;
				mmu_priv    <= PRV_M;
			end

			if (instr_fault_fire) begin
				csr_mepc    <= fetch_pc;
				csr_mcause  <= 64'd12;
				csr_mtval   <= fetch_pc;
				csr_mstatus <= ecall_mstatus_new;
				priv_mode   <= PRV_M;
				mmu_priv    <= PRV_M;
			end

			if (mem_fault_fire) begin
				csr_mepc    <= mem_fault_pc;
				csr_mcause  <= mem_fault_is_store ? 64'd15 : 64'd13;
				csr_mtval   <= mem_fault_addr;
				csr_mstatus <= ecall_mstatus_new;
				priv_mode   <= PRV_M;
				mmu_priv    <= PRV_M;
			end

			if (mret_fire) begin
				csr_mstatus <= mret_mstatus_new;
				priv_mode   <= mret_target_mode;
				mmu_priv    <= mret_target_mode;
			end

`ifdef VERILATOR
			// #region agent log
			if (ex_valid && (ex_out_pc >= 64'h0000_0000_8000_0fa8) && (ex_out_pc <= 64'h0000_0000_8000_1020) &&
			    (ex_out_is_load || ex_out_is_store || id_ex.is_branch || id_ex.is_jal || id_ex.is_jalr)) begin
				debug_log_core("pre-fix", "H4", "core.sv:exec_window", "execute window around stuck PC",
				               ex_out_pc, ex_out_mem_addr, id_ex.op1, id_ex.imm,
				               ex_out_is_load, ex_out_is_store, branch_mispredict);
			end
			// #endregion
`endif

`ifdef VERILATOR
			// #region agent log
			if (mem_wait && (mem_wait_cycles == 8'd32)) begin
				debug_log_core("pre-fix", "H1", "core.sv:memwait_long", "mem_wait stayed high for 32 cycles",
				               ex_mem.pc, ex_mem.mem_addr, {63'd0, dreq.valid}, {62'd0, dresp.data_ok, mem_out_valid},
				               ex_mem.is_load, ex_mem.is_store, cpu_halt);
			end
			// #endregion
`endif

			// commit 寄存：将 WB 提交点打一拍后提供给 Difftest
			commit_valid   <= wb_valid & !cpu_halt;
			commit_pc      <= wb_pc;
			commit_instr   <= wb_instr;
			commit_wen     <= wb_wen;
			commit_wdest   <= wb_wdest;
			commit_wdata   <= wb_wdata;
			commit_is_trap <= wb_is_trap;
			commit_is_mem  <= mem_wb.valid & (mem_wb.is_load | mem_wb.is_store);
			commit_skip    <= mem_wb.valid & mem_wb.is_mmio & (mem_wb.is_load | mem_wb.is_store);
			commit_mem_addr<= mem_wb.mem_addr;

`ifdef VERILATOR
			// #region agent log
			if (wb_is_trap || cpu_halt) begin
				debug_log_core("pre-fix", "H5", "core.sv:trap_or_halt", "trap or halt reached in WB path",
				               wb_pc, mem_wb.mem_addr, cycle_cnt, instr_cnt, wb_is_trap, cpu_halt, wb_valid);
			end
			// #endregion
`endif

			if (wb_is_trap) begin
				// trap 指令在 WB 到达后，下一周期彻底停机，避免继续提交
				cpu_halt     <= 1'b1;
				if_id.valid <= 1'b0;
				id_ex.valid <= 1'b0;
				ex_mem.valid<= 1'b0;
				mem_wb.valid<= 1'b0;
			end else if (mem_wait) begin
				// 访存未完成：冻结前级，避免重复发射与乱序提交
				mem_wb.valid <= 1'b0;
			end else begin
`ifdef VERILATOR
				// #region agent log
				if (branch_mispredict) begin
					debug_log_core("pre-fix", "H3", "core.sv:branch_flush", "execute reported branch mispredict",
					               ex_out_pc, branch_correct_pc, id_ex.pred_target, ex_out_mem_addr,
					               id_ex.pred_taken, ex_valid, ex_out_is_store);
				end
				// #endregion
`endif

`ifdef VERILATOR
				// #region agent log
				if (load_use_hazard && ex_valid) begin
					debug_log_core("pre-fix", "H2", "core.sv:hazard_overlap", "load-use hazard overlapped with EX advance",
					               if_id.pc, ex_mem.mem_addr, id_ex.pc, ex_out_mem_addr,
					               load_use_hazard_idex, load_use_hazard_exmem, ex_valid);
				end
				// #endregion
`endif

				// WB pipeline register
				mem_wb.valid    <= mem_out_valid;
				mem_wb.pc       <= mem_out_pc;
				mem_wb.instr    <= mem_out_instr;
				mem_wb.rd       <= mem_out_rd;
				mem_wb.reg_write<= mem_out_reg_write;
				mem_wb.result   <= mem_out_result;
				mem_wb.is_load  <= mem_out_is_load;
				mem_wb.is_store <= mem_out_is_store;
				mem_wb.is_mmio  <= mem_out_is_mmio;
				mem_wb.mem_addr <= mem_out_mem_addr;
				mem_wb.is_ebreak<= mem_out_is_ebreak;
				mem_wb.is_trap  <= mem_out_is_trap;
				mem_wb.is_csr   <= ex_mem.is_csr;
				mem_wb.csr_we   <= ex_mem.csr_we;
				mem_wb.csr_addr <= ex_mem.csr_addr;
				mem_wb.csr_old_data <= ex_mem.csr_old_data;
				mem_wb.csr_new_data <= ex_mem.csr_new_data;

				// MEM pipeline register
				ex_mem.valid     <= ex_valid;
				ex_mem.pc        <= ex_out_pc;
				ex_mem.instr     <= ex_out_instr;
				ex_mem.rd        <= ex_out_rd;
				ex_mem.reg_write <= ex_out_reg_write & ~ecall_fire & ~instr_fault_fire;
				ex_mem.result    <= ex_result_final;
				ex_mem.is_load   <= ex_out_is_load;
				ex_mem.is_store  <= ex_out_is_store;
				ex_mem.mem_size  <= ex_out_mem_size;
				ex_mem.load_unsigned <= ex_out_load_unsigned;
				ex_mem.mem_addr  <= ex_out_mem_addr;
				ex_mem.store_data<= ex_out_store_data;
				ex_mem.is_ebreak <= ex_out_is_ebreak;
				ex_mem.is_trap   <= ex_out_is_trap;
				ex_mem.is_csr    <= id_ex.is_csr;
				ex_mem.csr_we    <= ex_csr_we;
				ex_mem.csr_addr  <= id_ex.csr_addr;
				ex_mem.csr_old_data <= ex_csr_old_data;
				ex_mem.csr_new_data <= ex_csr_new_data;

				if (branch_mispredict || csr_redirect_valid || trap_redirect_valid) begin
					// 冲刷水线中所有年轻指令
					if_id.valid <= 1'b0;
					id_ex.valid <= 1'b0;
				end else if (decode_jal_redirect) begin
					// JAL/JALR：将跳转指令送入 EX，取指重定向到目标，丢弃 fall-through
					id_ex.valid      <= 1'b1;
					id_ex.pc         <= if_id.pc;
					id_ex.instr      <= if_id.instr;
					id_ex.rd         <= dec_rd;
					id_ex.rs1        <= dec_rs1;
					id_ex.rs2        <= dec_rs2;
					id_ex.op1        <= id_op1_pre;
					id_ex.rs2_val    <= id_rs2_pre;
					id_ex.imm        <= dec_imm;
					id_ex.reg_write  <= dec_reg_write;
					id_ex.is_imm     <= dec_is_imm;
					id_ex.is_word    <= dec_is_word;
					id_ex.is_branch  <= dec_is_branch;
					id_ex.is_jal     <= dec_is_jal;
					id_ex.is_jalr    <= dec_is_jalr;
					id_ex.is_auipc   <= dec_is_auipc;
					id_ex.is_lui     <= dec_is_lui;
					id_ex.is_load    <= dec_is_load;
					id_ex.is_store   <= dec_is_store;
					id_ex.mem_size   <= dec_mem_size;
					id_ex.load_unsigned <= dec_load_unsigned;
					id_ex.is_ebreak  <= dec_is_ebreak;
					id_ex.is_trap    <= dec_is_trap;
					id_ex.is_ecall   <= dec_is_ecall;
					id_ex.is_mret    <= dec_is_mret;
					id_ex.is_muldiv  <= dec_is_muldiv;
					id_ex.is_csr     <= dec_is_csr;
					id_ex.csr_addr   <= dec_csr_addr;
					id_ex.csr_op     <= dec_csr_op;
					id_ex.csr_use_imm<= dec_csr_use_imm;
					id_ex.csr_we_intent <= dec_csr_we_intent;
					id_ex.br_funct3  <= dec_br_funct3;
					id_ex.alu_op     <= dec_alu_op;
					id_ex.pred_taken <= dec_pred_taken;
					id_ex.pred_target<= dec_pred_target;
					if_id.valid <= 1'b0;
				end else if (load_use_hazard) begin
					// load-use：插入一个气泡，等待 load 结果到 MEM/WB 可前递
					id_ex <= '0;
				end else begin
					// ID/EX
					id_ex.valid      <= if_id.valid;
					id_ex.pc         <= if_id.pc;
					id_ex.instr      <= if_id.instr;
					id_ex.rd         <= dec_rd;
					id_ex.rs1        <= dec_rs1;
					id_ex.rs2        <= dec_rs2;
					id_ex.op1        <= id_op1_pre;
					id_ex.rs2_val    <= id_rs2_pre;
					id_ex.imm        <= dec_imm;
					id_ex.reg_write  <= dec_reg_write;
					id_ex.is_imm     <= dec_is_imm;
					id_ex.is_word    <= dec_is_word;
					id_ex.is_branch  <= dec_is_branch;
					id_ex.is_jal     <= dec_is_jal;
					id_ex.is_jalr    <= dec_is_jalr;
					id_ex.is_auipc   <= dec_is_auipc;
					id_ex.is_lui     <= dec_is_lui;
					id_ex.is_load    <= dec_is_load;
					id_ex.is_store   <= dec_is_store;
					id_ex.mem_size   <= dec_mem_size;
					id_ex.load_unsigned <= dec_load_unsigned;
					id_ex.is_ebreak  <= dec_is_ebreak;
					id_ex.is_trap    <= dec_is_trap;
					id_ex.is_ecall   <= dec_is_ecall;
					id_ex.is_mret    <= dec_is_mret;
					id_ex.is_muldiv  <= dec_is_muldiv;
					id_ex.is_csr     <= dec_is_csr;
					id_ex.csr_addr   <= dec_csr_addr;
					id_ex.csr_op     <= dec_csr_op;
					id_ex.csr_use_imm<= dec_csr_use_imm;
					id_ex.csr_we_intent <= dec_csr_we_intent;
					id_ex.br_funct3  <= dec_br_funct3;
					id_ex.alu_op     <= dec_alu_op;
					id_ex.pred_taken <= dec_pred_taken;
					id_ex.pred_target<= dec_pred_target;

					// IF/ID
					if (fetch_accept) begin
						if_id.valid <= 1'b1;
						if_id.pc    <= fetch_pc;
						if_id.instr <= fetch_instr;
					end else begin
						if_id.valid <= 1'b0;
					end
				end
			end
		end
	end

	`UNUSED_OK({trint, swint, exint, fetch_ok, wb_is_ebreak, rf_next_reg[0]})

`ifdef VERILATOR
	DifftestInstrCommit DifftestInstrCommit(
		.clock              (clk),
		.coreid             (csr_mhartid[7:0]),
		.index              (0),
		.valid              (commit_valid),
		.pc                 (commit_pc),
		.instr              (commit_instr),
		.skip               (commit_skip),
		.isRVC              (0),
		.scFailed           (0),
		.wen                (commit_wen),
		.wdest              ({3'b0, commit_wdest}),
		.wdata              (commit_wdata)
	);

	DifftestArchIntRegState DifftestArchIntRegState (
		.clock              (clk),
		.coreid             (csr_mhartid[7:0]),
		.gpr_0              (rf_reg_state[0]),
		.gpr_1              (rf_reg_state[1]),
		.gpr_2              (rf_reg_state[2]),
		.gpr_3              (rf_reg_state[3]),
		.gpr_4              (rf_reg_state[4]),
		.gpr_5              (rf_reg_state[5]),
		.gpr_6              (rf_reg_state[6]),
		.gpr_7              (rf_reg_state[7]),
		.gpr_8              (rf_reg_state[8]),
		.gpr_9              (rf_reg_state[9]),
		.gpr_10             (rf_reg_state[10]),
		.gpr_11             (rf_reg_state[11]),
		.gpr_12             (rf_reg_state[12]),
		.gpr_13             (rf_reg_state[13]),
		.gpr_14             (rf_reg_state[14]),
		.gpr_15             (rf_reg_state[15]),
		.gpr_16             (rf_reg_state[16]),
		.gpr_17             (rf_reg_state[17]),
		.gpr_18             (rf_reg_state[18]),
		.gpr_19             (rf_reg_state[19]),
		.gpr_20             (rf_reg_state[20]),
		.gpr_21             (rf_reg_state[21]),
		.gpr_22             (rf_reg_state[22]),
		.gpr_23             (rf_reg_state[23]),
		.gpr_24             (rf_reg_state[24]),
		.gpr_25             (rf_reg_state[25]),
		.gpr_26             (rf_reg_state[26]),
		.gpr_27             (rf_reg_state[27]),
		.gpr_28             (rf_reg_state[28]),
		.gpr_29             (rf_reg_state[29]),
		.gpr_30             (rf_reg_state[30]),
		.gpr_31             (rf_reg_state[31])
	);

    DifftestTrapEvent DifftestTrapEvent(
		.clock              (clk),
		.coreid             (csr_mhartid[7:0]),
		.valid              (commit_valid & commit_is_trap),
		.code               (rf_reg_state[10][2:0]),
		.pc                 (commit_pc),
		.cycleCnt           (cycle_cnt_n),
		.instrCnt           (instr_cnt_n)
	);

	DifftestCSRState DifftestCSRState(
		.clock              (clk),
		.coreid             (csr_mhartid[7:0]),
		.priviledgeMode     (priv_mode),
		.mstatus            (csr_mstatus & MSTATUS_MASK),
		.sstatus            (csr_mstatus & SSTATUS_MASK),
		.mepc               (csr_mepc),
		.sepc               (0),
		.mtval              (csr_mtval),
		.stval              (0),
		.mtvec              (csr_mtvec & MTVEC_MASK),
		.stvec              (0),
		.mcause             (csr_mcause),
		.scause             (0),
		.satp               (csr_satp),
		.mip                (csr_mip & MIP_MASK),
		.mie                (csr_mie),
		.mscratch           (csr_mscratch),
		.sscratch           (0),
		.mideleg            (0),
		.medeleg            (0)
	);
`endif
endmodule
`endif