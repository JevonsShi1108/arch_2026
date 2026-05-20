`ifndef __MULDIV_SV
`define __MULDIV_SV

`ifdef VERILATOR
`include "include/common.sv"
`endif

module muldiv import common::*;(
    input  logic clk,
    input  logic reset,
    input  logic req_valid,
    input  u64   op_a,
    input  u64   op_b,
    input  u3    op_sel,
    input  logic is_word,
    output logic busy,
    output logic ready,
    output logic result_valid,
    output u64   result
);
    typedef enum logic [1:0] {
        MD_IDLE = 2'd0,
        MD_MUL  = 2'd1,
        MD_DIV  = 2'd2
    } md_state_t;

    md_state_t state;
    u64        a_q, b_q;
    u3         sel_q;
    u7         iter_q;
    u64        raw_result;
    logic      ready_q;
    u128       mul_res;
    u64        rem_q;
    u64        quot_q;
    u64        div_a;
    u64        div_b;
    logic      neg_quot_q;
    logic      neg_rem_q;

    u64        rem_shifted;
    u64        abs_a;
    u64        abs_b;
    logic      rem_ge;
    logic      div_by_zero;
    logic      signed_op;
    logic      unsigned_op;
    logic      signed_overflow;

    assign busy         = (state != MD_IDLE);
    assign ready        = ready_q;
    assign result_valid = ready_q;

    assign div_by_zero    = (op_b == 64'd0);
    assign signed_op      = (op_sel == 3'b100) || (op_sel == 3'b110);
    assign unsigned_op    = (op_sel == 3'b101) || (op_sel == 3'b111);
    assign signed_overflow = signed_op && (op_b == 64'hffff_ffff_ffff_ffff) &&
                             ((op_a == 64'h8000_0000_0000_0000) ||
                              (op_a == 64'hffff_ffff_8000_0000));

    assign rem_shifted = {rem_q[62:0], div_a[63]};
    assign rem_ge      = (rem_shifted >= div_b);

    always_comb begin
        raw_result = 64'd0;
        unique case (sel_q)
            3'b000: raw_result = mul_res[63:0];
            3'b001: raw_result = mul_res[127:64];
            3'b100, 3'b101: begin
                raw_result = quot_q;
                if (neg_quot_q) begin
                    raw_result = -$signed(raw_result);
                end
            end
            3'b110, 3'b111: begin
                raw_result = rem_q;
                if (neg_rem_q) begin
                    raw_result = -$signed(raw_result);
                end
            end
            default: raw_result = 64'd0;
        endcase
        result = raw_result;
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            state      <= MD_IDLE;
            ready_q    <= 1'b0;
            neg_quot_q <= 1'b0;
            neg_rem_q  <= 1'b0;
        end else begin
            ready_q <= 1'b0;
            unique case (state)
                MD_IDLE: begin
                    if (req_valid) begin
                        a_q   <= op_a;
                        b_q   <= op_b;
                        sel_q <= op_sel;
                        if (op_sel == 3'b000 || op_sel == 3'b001) begin
                            mul_res <= u128'(op_a) * u128'(op_b);
                            state   <= MD_MUL;
                        end else if (div_by_zero || signed_overflow) begin
                            // quot_q/rem_q 已是最终数值，禁止再对 result 做符号修正（否则除零/溢出会二次取负）。
                            neg_quot_q <= 1'b0;
                            neg_rem_q  <= 1'b0;
                            if (signed_overflow) begin
                                quot_q <= op_a;
                                rem_q  <= 64'd0;
                            end else begin
                                quot_q <= 64'hffff_ffff_ffff_ffff;
                                rem_q  <= op_a;
                            end
                            ready_q <= 1'b1;
                        end else begin
                            // 必须用本拍 op_a/op_b：a_q 为 NBA，同拍读取会得到上一条指令的操作数。
                            neg_quot_q <= signed_op &&
                                          (($signed(op_a) < 0) ^ ($signed(op_b) < 0));
                            neg_rem_q  <= signed_op &&
                                          (is_word ? op_a[31] : ($signed(op_a) < 0));
                            if (unsigned_op) begin
                                abs_a = op_a;
                                abs_b = op_b;
                            end else begin
                                abs_a = ($signed(op_a) < 0) ? -$signed(op_a) : op_a;
                                abs_b = ($signed(op_b) < 0) ? -$signed(op_b) : op_b;
                            end
                            // 必须用本拍 is_word：word_q <= is_word 为 NBA，同拍读 word_q 是上一条指令的值。
                            if (is_word) begin
                                // W 除法：被除数放在移位寄存器高 32 位；core 把 OP-32 操作数扩在 XLEN 低半字。
                                div_a <= {abs_a[31:0], 32'd0};
                                div_b <= {32'd0, abs_b[31:0]};
                                iter_q <= 7'd32;
                            end else begin
                                div_a <= abs_a;
                                div_b <= abs_b;
                                iter_q <= 7'd64;
                            end
                            rem_q  <= 64'd0;
                            quot_q <= 64'd0;
                            state  <= MD_DIV;
                        end
                    end
                end
                MD_MUL: begin
                    state   <= MD_IDLE;
                    ready_q <= 1'b1;
                end
                MD_DIV: begin
                    if (iter_q == 0) begin
                        state   <= MD_IDLE;
                        ready_q <= 1'b1;
                    end else begin
                        div_a <= {div_a[62:0], 1'b0};
                        if (rem_ge) begin
                            rem_q  <= rem_shifted - div_b;
                            quot_q <= {quot_q[62:0], 1'b1};
                        end else begin
                            rem_q  <= rem_shifted;
                            quot_q <= {quot_q[62:0], 1'b0};
                        end
                        iter_q <= iter_q - 1;
                    end
                end
                default: state <= MD_IDLE;
            endcase
        end
    end
endmodule

`endif
