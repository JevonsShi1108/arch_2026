`ifndef __EXECUTE_SV
`define __EXECUTE_SV

`ifdef VERILATOR
`include "include/common.sv"
`endif

module execute import common::*;(
    input  logic valid,
    input  u64   pc,
    input  u32   instr,
    input  u5    rd,
    input  u64   op1,
    input  u64   op2,
    input  u64   imm,
    input  logic reg_write,
    input  logic is_word,
    input  logic is_branch,
    input  logic is_jal,
    input  logic is_jalr,
    input  logic is_ebreak,
    input  logic is_trap,
    input  logic is_muldiv,
    input  u3    br_funct3,
    input  u4    alu_op,
    input  logic pred_taken,
    input  u64   pred_target,
    input  logic muldiv_busy,
    input  logic muldiv_ready,
    input  logic muldiv_result_valid,
    input  u64   muldiv_result,
    output logic out_valid,
    output u64   out_pc,
    output u32   out_instr,
    output u5    out_rd,
    output logic out_reg_write,
    output u64   out_result,
    output logic out_is_ebreak,
    output logic out_is_trap,
    output logic branch_mispredict,
    output u64   branch_correct_pc
);
    localparam u4 ALU_ADD = 4'd0;
    localparam u4 ALU_SUB = 4'd1;
    localparam u4 ALU_AND = 4'd2;
    localparam u4 ALU_OR  = 4'd3;
    localparam u4 ALU_XOR = 4'd4;

    u64  alu_raw;
    logic branch_taken;
    u64  branch_target;
    logic is_ctrl;
    logic signed_lt;
    logic unsigned_lt;
    logic op2_is_zero;
    u64  pc_plus4;
    u64  wb_val;

    assign pc_plus4 = pc + 64'd4;

    always_comb begin
        unique case (alu_op)
            ALU_ADD: alu_raw = op1 + op2;
            ALU_SUB: alu_raw = op1 - op2;
            ALU_AND: alu_raw = op1 & op2;
            ALU_OR : alu_raw = op1 | op2;
            ALU_XOR: alu_raw = op1 ^ op2;
            default: alu_raw = 64'd0;
        endcase

        signed_lt   = ($signed(op1) < $signed(op2));
        unsigned_lt = (op1 < op2);
        op2_is_zero = (op2 == 64'd0);

        branch_taken  = 1'b0;
        branch_target = pc_plus4;

        if (is_branch) begin
            unique case (br_funct3)
                3'b000: branch_taken = op2_is_zero;         // beq
                3'b001: branch_taken = !op2_is_zero;        // bne
                3'b100: branch_taken = signed_lt;           // blt
                3'b101: branch_taken = !signed_lt;          // bge
                3'b110: branch_taken = unsigned_lt;         // bltu
                3'b111: branch_taken = !unsigned_lt;        // bgeu
                default: branch_taken = 1'b0;
            endcase
            branch_target = pc + imm;
        end else if (is_jal) begin
            branch_taken  = 1'b1;
            branch_target = pc + imm;
        end else if (is_jalr) begin
            branch_taken  = 1'b1;
            branch_target = (op1 + imm) & 64'hffff_ffff_ffff_fffe;
        end

        is_ctrl = is_branch | is_jal | is_jalr;

        wb_val = alu_raw;
        if (is_jal || is_jalr) begin
            wb_val = pc_plus4;
        end
        if (is_word) begin
            wb_val = {{32{wb_val[31]}}, wb_val[31:0]};
        end

        // TODO: 之后 M 扩展执行路径改为 muldiv 多周期单元握手。
        if (is_muldiv) begin
            wb_val = muldiv_result;
        end
    end

    assign out_valid      = valid;
    assign out_pc         = pc;
    assign out_instr      = instr;
    assign out_rd         = rd;
    assign out_is_ebreak  = is_ebreak;
    assign out_is_trap    = is_trap;
    assign out_result     = wb_val;
    assign out_reg_write  = valid & reg_write & !is_trap & !is_branch & !is_muldiv;

    // 现在 mul/div 未实现: 检测到 muldiv 指令时先不写回，由 TODO 接管。
    assign branch_mispredict = valid & is_ctrl &
                               ((branch_taken != pred_taken) |
                                (branch_taken & pred_taken & (branch_target != pred_target)));
    assign branch_correct_pc = branch_taken ? branch_target : pc_plus4;

    `UNUSED_OK({muldiv_busy, muldiv_ready, muldiv_result_valid})
endmodule

`endif
