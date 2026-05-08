`ifndef __CORE_SV
`define __CORE_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "src/predictor_static.sv"
`include "src/regfile.sv"
`include "src/muldiv_stub.sv"
`include "src/fetch.sv"
`include "src/decode.sv"
`include "src/execute.sv"
`include "src/mem.sv"
`include "src/writeback.sv"
`endif

module core import common::*;(
	input  logic       clk, reset,
	output ibus_req_t  ireq,
	input  ibus_resp_t iresp,
	output dbus_req_t  dreq,
	input  dbus_resp_t dresp,
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
		logic is_muldiv;
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
		u64   mem_addr;
		logic is_ebreak;
		logic is_trap;
	} mem_wb_t;

	localparam u4 ALU_ADD = 4'd0;
	localparam u4 ALU_SUB = 4'd1;
	localparam u4 ALU_AND = 4'd2;
	localparam u4 ALU_OR  = 4'd3;
	localparam u4 ALU_XOR = 4'd4;

	if_id_t  if_id;
	id_ex_t  id_ex;
	ex_mem_t ex_mem;
	mem_wb_t mem_wb;

	// Fetch
	logic fetch_ok;
	logic fetch_valid;
	logic fetch_stale;
	u64   fetch_pc;
	u32   fetch_instr;
	logic branch_mispredict;
	u64   branch_correct_pc;
	logic cpu_halt;
	logic mem_wait;

	fetch u_fetch(
		.clk,
		.reset,
		.stop_fetch(cpu_halt | mem_wait),
		.redirect_valid(branch_mispredict),
		.redirect_pc(branch_correct_pc),
		.fetch_ok,
		.fetch_valid,
		.fetch_stale,
		.fetch_pc,
		.fetch_instr,
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
	logic dec_is_ebreak, dec_is_trap, dec_is_muldiv;
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
		.is_muldiv(dec_is_muldiv),
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

	// MEM
	logic mem_out_valid, mem_out_reg_write, mem_out_is_load, mem_out_is_store, mem_out_is_ebreak, mem_out_is_trap;
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
		.dreq,
		.dresp,
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
		.out_is_ebreak(mem_out_is_ebreak),
		.out_is_trap(mem_out_is_trap)
	);

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
	logic commit_valid, commit_wen, commit_is_trap, commit_is_mem;
	u64   commit_pc, commit_wdata, commit_mem_addr;
	u32   commit_instr;
	u5    commit_wdest;

`ifndef SYNTHESIS
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
			commit_mem_addr<= 64'd0;
			cpu_halt     <= 1'b0;
			cycle_cnt <= 64'd0;
			instr_cnt <= 64'd0;
			mem_wait_cycles <= '0;
		end else begin
			cycle_cnt <= cycle_cnt_n;
			instr_cnt <= instr_cnt_n;
			if (mem_wait) begin
				mem_wait_cycles <= mem_wait_cycles + 8'd1;
			end else begin
				mem_wait_cycles <= '0;
			end

`ifndef SYNTHESIS
			// #region agent log
			if (ex_valid && (ex_out_pc >= 64'h0000_0000_8000_0fa8) && (ex_out_pc <= 64'h0000_0000_8000_1020) &&
			    (ex_out_is_load || ex_out_is_store || id_ex.is_branch || id_ex.is_jal || id_ex.is_jalr)) begin
				debug_log_core("pre-fix", "H4", "core.sv:exec_window", "execute window around stuck PC",
				               ex_out_pc, ex_out_mem_addr, id_ex.op1, id_ex.imm,
				               ex_out_is_load, ex_out_is_store, branch_mispredict);
			end
			// #endregion
`endif

`ifndef SYNTHESIS
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
			commit_mem_addr<= mem_wb.mem_addr;

`ifndef SYNTHESIS
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
`ifndef SYNTHESIS
				// #region agent log
				if (branch_mispredict) begin
					debug_log_core("pre-fix", "H3", "core.sv:branch_flush", "execute reported branch mispredict",
					               ex_out_pc, branch_correct_pc, id_ex.pred_target, ex_out_mem_addr,
					               id_ex.pred_taken, ex_valid, ex_out_is_store);
				end
				// #endregion
`endif

`ifndef SYNTHESIS
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
				mem_wb.mem_addr <= mem_out_mem_addr;
				mem_wb.is_ebreak<= mem_out_is_ebreak;
				mem_wb.is_trap  <= mem_out_is_trap;

				// MEM pipeline register
				ex_mem.valid     <= ex_valid;
				ex_mem.pc        <= ex_out_pc;
				ex_mem.instr     <= ex_out_instr;
				ex_mem.rd        <= ex_out_rd;
				ex_mem.reg_write <= ex_out_reg_write;
				ex_mem.result    <= ex_out_result;
				ex_mem.is_load   <= ex_out_is_load;
				ex_mem.is_store  <= ex_out_is_store;
				ex_mem.mem_size  <= ex_out_mem_size;
				ex_mem.load_unsigned <= ex_out_load_unsigned;
				ex_mem.mem_addr  <= ex_out_mem_addr;
				ex_mem.store_data<= ex_out_store_data;
				ex_mem.is_ebreak <= ex_out_is_ebreak;
				ex_mem.is_trap   <= ex_out_is_trap;

				if (branch_mispredict) begin
					// 冲刷水线中所有年轻指令
					if_id.valid <= 1'b0;
					id_ex.valid <= 1'b0;
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
					id_ex.is_muldiv  <= dec_is_muldiv;
					id_ex.br_funct3  <= dec_br_funct3;
					id_ex.alu_op     <= dec_alu_op;
					id_ex.pred_taken <= dec_pred_taken;
					id_ex.pred_target<= dec_pred_target;

					// IF/ID
					if (fetch_valid && !fetch_stale && !cpu_halt) begin
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
		.coreid             (0),
		.index              (0),
		.valid              (commit_valid),
		.pc                 (commit_pc),
		.instr              (commit_instr),
		.skip               (commit_is_mem && (commit_mem_addr[31] == 1'b0)),
		.isRVC              (0),
		.scFailed           (0),
		.wen                (commit_wen),
		.wdest              ({3'b0, commit_wdest}),
		.wdata              (commit_wdata)
	);

	DifftestArchIntRegState DifftestArchIntRegState (
		.clock              (clk),
		.coreid             (0),
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
		.coreid             (0),
		.valid              (commit_valid & commit_is_trap),
		.code               (rf_reg_state[10][2:0]),
		.pc                 (commit_pc),
		.cycleCnt           (cycle_cnt_n),
		.instrCnt           (instr_cnt_n)
	);

	DifftestCSRState DifftestCSRState(
		.clock              (clk),
		.coreid             (0),
		.priviledgeMode     (3),
		.mstatus            (0),
		.sstatus            (0 /* mstatus & SSTATUS_MASK */),
		.mepc               (0),
		.sepc               (0),
		.mtval              (0),
		.stval              (0),
		.mtvec              (0),
		.stvec              (0),
		.mcause             (0),
		.scause             (0),
		.satp               (0),
		.mip                (0),
		.mie                (0),
		.mscratch           (0),
		.sscratch           (0),
		.mideleg            (0),
		.medeleg            (0)
	);
`endif
endmodule
`endif