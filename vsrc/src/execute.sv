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
    input  u64   rs2_val,
    input  u64   imm,
    input  logic reg_write,
    input  logic is_imm,
    input  logic is_word,
    input  logic is_branch,
    input  logic is_jal,
    input  logic is_jalr,
    input  logic is_auipc,
    input  logic is_lui,
    input  logic is_load,
    input  logic is_store,
    input  msize_t mem_size,
    input  logic load_unsigned,
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
    output logic out_is_load,
    output logic out_is_store,
    output msize_t out_mem_size,
    output logic out_load_unsigned,
    output u64   out_mem_addr,
    output u64   out_store_data,
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
    localparam u4 ALU_SLL = 4'd5;
    localparam u4 ALU_SRL = 4'd6;
    localparam u4 ALU_SRA = 4'd7;
    localparam u4 ALU_SLT = 4'd8;
    localparam u4 ALU_SLTU= 4'd9;

    u64  alu_raw;
    logic branch_taken;
    u64  branch_target;
    logic is_ctrl;
    logic signed_lt;
    logic unsigned_lt;
    logic eq_rs;
    u64  pc_plus4;
    u64  wb_val;
    u64  alu_src2;
    logic alu_slt_signed;
    logic alu_slt_unsigned;
    u6   shamt_64_reg;
    u6   shamt_64_imm;
    u5   shamt_32_reg;
    u5   shamt_32_imm;
    logic is_shift_op;

    assign pc_plus4 = pc + 64'd4;
    assign alu_src2 = is_imm ? imm : rs2_val;
    assign shamt_64_reg = rs2_val[5:0];
    assign shamt_64_imm = instr[25:20];
    assign shamt_32_reg = rs2_val[4:0];
    assign shamt_32_imm = instr[24:20];
    assign is_shift_op  = (alu_op == ALU_SLL) || (alu_op == ALU_SRL) || (alu_op == ALU_SRA);
    assign alu_slt_signed   = ($signed(op1) < $signed(alu_src2));
    assign alu_slt_unsigned = (op1 < alu_src2);

    always_comb begin
        unique case (alu_op)
            ALU_ADD: alu_raw = op1 + alu_src2;
            ALU_SUB: alu_raw = op1 - alu_src2;
            ALU_AND: alu_raw = op1 & alu_src2;
            ALU_OR : alu_raw = op1 | alu_src2;
            ALU_XOR: alu_raw = op1 ^ alu_src2;
            ALU_SLL: begin
                if (is_word) begin
                    // RV64 W 类移位：先在 32 位做移位，再在后面统一符号扩展。
                    alu_raw = {{32{1'b0}}, (op1[31:0] << (is_imm ? shamt_32_imm : shamt_32_reg))};
                end else begin
                    alu_raw = op1 << (is_imm ? shamt_64_imm : shamt_64_reg);
                end
            end
            ALU_SRL: begin
                if (is_word) begin
                    alu_raw = {{32{1'b0}}, (op1[31:0] >> (is_imm ? shamt_32_imm : shamt_32_reg))};
                end else begin
                    alu_raw = op1 >> (is_imm ? shamt_64_imm : shamt_64_reg);
                end
            end
            ALU_SRA: begin
                if (is_word) begin
                    alu_raw = {{32{1'b0}}, ($signed(op1[31:0]) >>> (is_imm ? shamt_32_imm : shamt_32_reg))};
                end else begin
                    alu_raw = $signed(op1) >>> (is_imm ? shamt_64_imm : shamt_64_reg);
                end
            end
            ALU_SLT:  alu_raw = {63'd0, alu_slt_signed};
            ALU_SLTU: alu_raw = {63'd0, alu_slt_unsigned};
            default: alu_raw = 64'd0;
        endcase

        signed_lt   = ($signed(op1) < $signed(rs2_val));
        unsigned_lt = (op1 < rs2_val);
        eq_rs       = (op1 == rs2_val);

        branch_taken  = 1'b0;
        branch_target = pc_plus4;

        if (is_branch) begin
            unique case (br_funct3)
                3'b000: branch_taken = eq_rs;               // beq
                3'b001: branch_taken = !eq_rs;              // bne
                3'b100: branch_taken = signed_lt;           // blt
                3'b101: branch_taken = !signed_lt;          // bge
                3'b110: branch_taken = unsigned_lt;         // bltu
                3'b111: branch_taken = !unsigned_lt;        // bgeu
                default: branch_taken = 1'b0;
            endcase
            branch_target = pc + imm;
        end else if (is_jal) begin
            branch_taken  = 1'b1;
            // JAL 目标 = 当前指令 PC + imm_j
            branch_target = pc + imm;
        end else if (is_jalr) begin
            branch_taken  = 1'b1;
            // JALR 目标 = (rs1 + imm_i) & ~1
            branch_target = (op1 + imm) & 64'hffff_ffff_ffff_fffe;
        end

        is_ctrl = is_branch | is_jal | is_jalr;

        wb_val = alu_raw;
        if (is_lui) begin
            wb_val = imm;
        end
        if (is_auipc) begin
            wb_val = pc + imm;
        end
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
    assign out_is_load    = is_load;
    assign out_is_store   = is_store;
    assign out_mem_size   = mem_size;
    assign out_load_unsigned = load_unsigned;
    assign out_mem_addr   = op1 + imm;
    assign out_store_data = rs2_val;
    assign out_is_ebreak  = is_ebreak;
    assign out_is_trap    = is_trap;
    assign out_result     = wb_val;
    assign out_reg_write  = valid & reg_write & !is_trap & !is_branch & !is_muldiv & !is_store;

    // 现在 mul/div 未实现: 检测到 muldiv 指令时先不写回，由 TODO 接管。
    // EX 给出真实跳转结果，与静态预测结果比对后触发重定向/flush。
    assign branch_mispredict = valid & is_ctrl &
                               ((branch_taken != pred_taken) |
                                (branch_taken & pred_taken & (branch_target != pred_target)));
    assign branch_correct_pc = branch_taken ? branch_target : pc_plus4;

    `UNUSED_OK({muldiv_busy, muldiv_ready, muldiv_result_valid, is_shift_op})
endmodule

`endif
