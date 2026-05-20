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
    logic      ready_q;
    u128       mul_res;
    u64        rem_q;
    u64        quot_q;
    u64        div_a;
    u64        div_b;
    logic      neg_res;

    assign busy         = (state != MD_IDLE);
    assign ready        = ready_q;
    assign result_valid = ready_q;

    always_comb begin
        result = 64'd0;
        unique case (sel_q)
            3'b000: result = mul_res[63:0];
            3'b001: result = mul_res[127:64];
            3'b100, 3'b101: result = quot_q;
            3'b110, 3'b111: result = rem_q;
            default: result = 64'd0;
        endcase
        if (neg_res && (sel_q == 3'b100 || sel_q == 3'b110)) begin
            result = -$signed(result);
        end
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            state   <= MD_IDLE;
            ready_q <= 1'b0;
        end else begin
            ready_q <= 1'b0;
            unique case (state)
                MD_IDLE: begin
                    if (req_valid) begin
                        a_q   <= op_a;
                        b_q   <= op_b;
                        sel_q <= op_sel;
                        if (op_sel == 3'b000 || op_sel == 3'b001) begin
                            mul_res <= op_a * op_b;
                            state   <= MD_MUL;
                        end else begin
                            neg_res <= ((op_sel == 3'b100 || op_sel == 3'b110) &&
                                        (($signed(op_a) < 0) ^ ($signed(op_b) < 0)));
                            if (op_sel == 3'b101 || op_sel == 3'b111) begin
                                div_a <= op_a;
                                div_b <= (op_b == 64'd0) ? 64'd1 : op_b;
                            end else begin
                                div_a <= ($signed(op_a) < 0) ? -$signed(op_a) : op_a;
                                div_b <= ($signed(op_b) < 0) ? -$signed(op_b) :
                                         ((op_b == 64'd0) ? 64'd1 : op_b);
                            end
                            rem_q  <= 64'd0;
                            quot_q <= 64'd0;
                            iter_q <= 7'd64;
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
                        rem_q  <= {rem_q[62:0], div_a[63]};
                        div_a  <= {div_a[62:0], 1'b0};
                        if (rem_q >= div_b) begin
                            rem_q  <= rem_q - div_b;
                            quot_q <= {quot_q[62:0], 1'b1};
                        end else begin
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
