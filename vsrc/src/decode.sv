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
    output logic is_auipc,
    output logic is_lui,
    output logic is_load,
    output logic is_store,
    output msize_t mem_size,
    output logic load_unsigned,
    output logic is_ebreak,
    output logic is_trap,
    output logic is_muldiv,
    output logic is_csr,
    output u12   csr_addr,
    output u2    csr_op,
    output logic csr_use_imm,
    output logic csr_we_intent,
    output u3    br_funct3,
    output u4    alu_op
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
    localparam u2 CSR_OP_NONE  = 2'd0;
    localparam u2 CSR_OP_WRITE = 2'd1;
    localparam u2 CSR_OP_SET   = 2'd2;
    localparam u2 CSR_OP_CLEAR = 2'd3;

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    u64 imm_i;
    u64 imm_s;
    u64 imm_b;
    u64 imm_j;
    u64 imm_u;

    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign rd  = instr[11:7];

    assign imm_i = {{52{instr[31]}}, instr[31:20]};
    assign imm_s = {{52{instr[31]}}, instr[31:25], instr[11:7]};
    assign imm_b = {{51{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
    assign imm_j = {{43{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
    assign imm_u = {{32{instr[31]}}, instr[31:12], 12'b0};

    always_comb begin
        use_rs1   = 1'b0;
        use_rs2   = 1'b0;
        reg_write = 1'b0;
        is_imm    = 1'b0;
        is_word   = 1'b0;
        is_branch = 1'b0;
        is_jal    = 1'b0;
        is_jalr   = 1'b0;
        is_auipc  = 1'b0;
        is_lui    = 1'b0;
        is_load   = 1'b0;
        is_store  = 1'b0;
        mem_size  = MSIZE8;
        load_unsigned = 1'b0;
        is_ebreak = 1'b0;
        is_trap   = 1'b0;
        is_muldiv = 1'b0;
        is_csr    = 1'b0;
        csr_addr  = 12'd0;
        csr_op    = CSR_OP_NONE;
        csr_use_imm = 1'b0;
        csr_we_intent = 1'b0;
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
                    3'b001: begin // slli
                        if (instr[31:26] == 6'b000000) begin
                            alu_op = ALU_SLL;
                        end else begin
                            reg_write = 1'b0;
                        end
                    end
                    3'b010: alu_op = ALU_SLT;  // slti
                    3'b011: alu_op = ALU_SLTU; // sltiu
                    3'b101: begin // srli/srai
                        if (instr[31:26] == 6'b000000) begin
                            alu_op = ALU_SRL;
                        end else if (instr[31:26] == 6'b010000) begin
                            alu_op = ALU_SRA;
                        end else begin
                            reg_write = 1'b0;
                        end
                    end
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
                unique case (funct3)
                    3'b000: alu_op = ALU_ADD; // addiw
                    3'b001: begin // slliw
                        if (funct7 == 7'b0000000) begin
                            alu_op = ALU_SLL;
                        end else begin
                            reg_write = 1'b0;
                        end
                    end
                    3'b101: begin // srliw/sraiw
                        if (funct7 == 7'b0000000) begin
                            alu_op = ALU_SRL;
                        end else if (funct7 == 7'b0100000) begin
                            alu_op = ALU_SRA;
                        end else begin
                            reg_write = 1'b0;
                        end
                    end
                    default: begin
                        reg_write = 1'b0;
                    end
                endcase
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
                    {7'b0000000, 3'b001}: alu_op = ALU_SLL; // sll
                    {7'b0000000, 3'b101}: alu_op = ALU_SRL; // srl
                    {7'b0100000, 3'b101}: alu_op = ALU_SRA; // sra
                    {7'b0000000, 3'b010}: alu_op = ALU_SLT; // slt
                    {7'b0000000, 3'b011}: alu_op = ALU_SLTU;// sltu
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
                    {7'b0000000, 3'b001}: alu_op = ALU_SLL; // sllw
                    {7'b0000000, 3'b101}: alu_op = ALU_SRL; // srlw
                    {7'b0100000, 3'b101}: alu_op = ALU_SRA; // sraw
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
            7'b0110111: begin // LUI
                reg_write = 1'b1;
                is_lui    = 1'b1;
                is_imm    = 1'b1;
                imm       = imm_u;
            end
            7'b0010111: begin // AUIPC
                reg_write = 1'b1;
                is_auipc  = 1'b1;
                is_imm    = 1'b1;
                imm       = imm_u;
            end
            7'b0000011: begin // LOAD
                use_rs1   = 1'b1;
                reg_write = 1'b1;
                is_imm    = 1'b1;
                is_load   = 1'b1;
                imm       = imm_i;
                unique case (funct3)
                    3'b000: begin mem_size = MSIZE1; load_unsigned = 1'b0; end // lb
                    3'b001: begin mem_size = MSIZE2; load_unsigned = 1'b0; end // lh
                    3'b010: begin mem_size = MSIZE4; load_unsigned = 1'b0; end // lw
                    3'b011: begin mem_size = MSIZE8; load_unsigned = 1'b0; end // ld
                    3'b100: begin mem_size = MSIZE1; load_unsigned = 1'b1; end // lbu
                    3'b101: begin mem_size = MSIZE2; load_unsigned = 1'b1; end // lhu
                    3'b110: begin mem_size = MSIZE4; load_unsigned = 1'b1; end // lwu
                    default: begin
                        reg_write = 1'b0;
                        is_load   = 1'b0;
                    end
                endcase
            end
            7'b0100011: begin // STORE
                use_rs1   = 1'b1;
                use_rs2   = 1'b1;
                is_imm    = 1'b1;
                is_store  = 1'b1;
                imm       = imm_s;
                unique case (funct3)
                    3'b000: mem_size = MSIZE1; // sb
                    3'b001: mem_size = MSIZE2; // sh
                    3'b010: mem_size = MSIZE4; // sw
                    3'b011: mem_size = MSIZE8; // sd
                    default: begin
                        is_store = 1'b0;
                    end
                endcase
            end
            7'b1110011: begin
                if (funct3 == 3'b000) begin
                    if (instr == 32'h00100073) begin
                        is_ebreak = 1'b1;
                        is_trap   = 1'b1;
                    end
                end else begin
                    is_csr      = 1'b1;
                    reg_write   = 1'b1;
                    csr_addr    = instr[31:20];
                    csr_use_imm = funct3[2];
                    unique case (funct3)
                        3'b001: begin // csrrw
                            use_rs1       = 1'b1;
                            csr_op        = CSR_OP_WRITE;
                            csr_we_intent = 1'b1;
                        end
                        3'b010: begin // csrrs
                            use_rs1       = 1'b1;
                            csr_op        = CSR_OP_SET;
                            csr_we_intent = (rs1 != 5'd0);
                        end
                        3'b011: begin // csrrc
                            use_rs1       = 1'b1;
                            csr_op        = CSR_OP_CLEAR;
                            csr_we_intent = (rs1 != 5'd0);
                        end
                        3'b101: begin // csrrwi
                            csr_op        = CSR_OP_WRITE;
                            csr_we_intent = 1'b1;
                        end
                        3'b110: begin // csrrsi
                            csr_op        = CSR_OP_SET;
                            csr_we_intent = (instr[19:15] != 5'd0);
                        end
                        3'b111: begin // csrrci
                            csr_op        = CSR_OP_CLEAR;
                            csr_we_intent = (instr[19:15] != 5'd0);
                        end
                        default: begin
                            is_csr      = 1'b0;
                            reg_write   = 1'b0;
                            csr_op      = CSR_OP_NONE;
                            csr_we_intent = 1'b0;
                        end
                    endcase
                end
            end
            7'b1101011: begin
                // Lab1 结束指令（nemu_trap）
                is_trap = 1'b1;
            end
            default: begin
                // 其他指令暂不实现，按 NOP 处理
            end
        endcase
    end
    `UNUSED_OK(pc)
endmodule

`endif
