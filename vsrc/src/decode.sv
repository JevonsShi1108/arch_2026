`ifndef __DECODE_SV
`define __DECODE_SV

`ifdef VERILATOR
`include "include/common.sv"
`endif

module decode import common::*;(
    input  u64   pc,
    input  u32   instr,
    output u5    rs1,
    output u5    rs2,
    output u5    rd,
    output u64   imm,
    output logic use_rs1,
    output logic use_rs2,
    output logic reg_write,
    output logic is_imm,
    output logic is_word,
    output logic is_branch,
    output logic is_jal,
    output logic is_jalr,
    output logic is_ebreak,
    output logic is_trap,
    output logic is_muldiv,
    output u3    br_funct3,
    output u4    alu_op
);
    localparam u4 ALU_ADD = 4'd0;
    localparam u4 ALU_SUB = 4'd1;
    localparam u4 ALU_AND = 4'd2;
    localparam u4 ALU_OR  = 4'd3;
    localparam u4 ALU_XOR = 4'd4;

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    u64 imm_i;
    u64 imm_b;
    u64 imm_j;

    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign rd  = instr[11:7];

    assign imm_i = {{52{instr[31]}}, instr[31:20]};
    assign imm_b = {{51{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
    assign imm_j = {{43{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};

    always_comb begin
        use_rs1   = 1'b0;
        use_rs2   = 1'b0;
        reg_write = 1'b0;
        is_imm    = 1'b0;
        is_word   = 1'b0;
        is_branch = 1'b0;
        is_jal    = 1'b0;
        is_jalr   = 1'b0;
        is_ebreak = 1'b0;
        is_trap   = 1'b0;
        is_muldiv = 1'b0;
        br_funct3 = funct3;
        alu_op    = ALU_ADD;
        imm       = 64'd0;

        unique case (opcode)
            7'b0010011: begin // OP-IMM
                use_rs1   = 1'b1;
                reg_write = 1'b1;
                is_imm    = 1'b1;
                imm       = imm_i;
                unique case (funct3)
                    3'b000: alu_op = ALU_ADD; // addi
                    3'b100: alu_op = ALU_XOR; // xori
                    3'b110: alu_op = ALU_OR;  // ori
                    3'b111: alu_op = ALU_AND; // andi
                    default: begin
                        reg_write = 1'b0;
                    end
                endcase
            end
            7'b0011011: begin // OP-IMM-32
                use_rs1   = 1'b1;
                reg_write = 1'b1;
                is_imm    = 1'b1;
                is_word   = 1'b1;
                imm       = imm_i;
                if (funct3 != 3'b000) begin
                    reg_write = 1'b0;
                end
            end
            7'b0110011: begin // OP
                use_rs1   = 1'b1;
                use_rs2   = 1'b1;
                reg_write = 1'b1;
                unique case ({funct7, funct3})
                    {7'b0000000, 3'b000}: alu_op = ALU_ADD; // add
                    {7'b0100000, 3'b000}: alu_op = ALU_SUB; // sub
                    {7'b0000000, 3'b111}: alu_op = ALU_AND; // and
                    {7'b0000000, 3'b110}: alu_op = ALU_OR;  // or
                    {7'b0000000, 3'b100}: alu_op = ALU_XOR; // xor
                    default: begin
                        // TODO: 之后在这里接入 M 扩展 mul/div/rem 指令译码
                        // mul/div/divu/rem/remu
                        if (funct7 == 7'b0000001) begin
                            is_muldiv = 1'b1;
                        end
                        reg_write = 1'b0;
                    end
                endcase
            end
            7'b0111011: begin // OP-32
                use_rs1   = 1'b1;
                use_rs2   = 1'b1;
                reg_write = 1'b1;
                is_word   = 1'b1;
                unique case ({funct7, funct3})
                    {7'b0000000, 3'b000}: alu_op = ALU_ADD; // addw
                    {7'b0100000, 3'b000}: alu_op = ALU_SUB; // subw
                    default: begin
                        // TODO: 之后在这里接入 M 扩展 32 位指令译码
                        // mulw/divw/divuw/remw/remuw
                        if (funct7 == 7'b0000001) begin
                            is_muldiv = 1'b1;
                        end
                        reg_write = 1'b0;
                    end
                endcase
            end
            7'b1100011: begin // BRANCH
                use_rs1   = 1'b1;
                use_rs2   = 1'b1;
                is_branch = 1'b1;
                imm       = imm_b;
            end
            7'b1101111: begin // JAL
                reg_write = 1'b1;
                is_jal    = 1'b1;
                imm       = imm_j;
            end
            7'b1100111: begin // JALR
                use_rs1   = 1'b1;
                reg_write = 1'b1;
                is_jalr   = 1'b1;
                imm       = imm_i;
            end
            7'b1110011: begin
                // ebreak: 0x00100073
                if (instr == 32'h00100073) begin
                    is_ebreak = 1'b1;
                    is_trap   = 1'b1;
                end
            end
            7'b1101011: begin
                // Lab1 结束指令（nemu_trap），例如 0x0005006b
                is_trap = 1'b1;
            end
            default: begin
                // 其他指令暂不实现，按 NOP 处理
            end
        endcase
    end
endmodule

`endif
