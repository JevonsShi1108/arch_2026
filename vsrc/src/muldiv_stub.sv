`ifndef __MULDIV_STUB_SV
`define __MULDIV_STUB_SV

`ifdef VERILATOR
`include "include/common.sv"
`endif

module muldiv_stub import common::*;(
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
    // TODO: 之后接入多周期乘除法单元。
    // 预期接口:
    //  - req_valid/op_a/op_b/op_sel 发起请求
    //  - busy 表示单元占用
    //  - ready/result_valid/result 返回完成握手与结果
    //  - 内部将使用 FSM + 操作数寄存器 + 计数器 + 部分结果寄存器
    assign busy         = 1'b0;
    assign ready        = 1'b0;
    assign result_valid = 1'b0;
    assign result       = 64'd0;

    `UNUSED_OK({clk, reset, req_valid, op_a, op_b, op_sel})
endmodule

`endif
