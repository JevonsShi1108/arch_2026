`ifdef VERILATOR
`include "include/common.sv"
`include "src/core.sv"
`include "util/IBusToCBus.sv"
`include "util/DBusToCBus.sv"
`include "util/CBusArbiter.sv"
`include "util/MMU.sv"

module SimTop import common::*;(
  input         clock,
  input         reset,
  input  [63:0] io_logCtrl_log_begin,
  input  [63:0] io_logCtrl_log_end,
  input  [63:0] io_logCtrl_log_level,
  input         io_perfInfo_clean,
  input         io_perfInfo_dump,
  output        io_uart_out_valid,
  output [7:0]  io_uart_out_ch,
  output        io_uart_in_valid,
  input  [7:0]  io_uart_in_ch
);

    cbus_req_t  oreq;
    cbus_resp_t oresp;
    logic trint, swint, exint;

    ibus_req_t  ireq;
    ibus_resp_t iresp;
    dbus_req_t  dreq;
    dbus_resp_t dresp;
    cbus_req_t  icreq,  dcreq;
    cbus_resp_t icresp, dcresp;
    cbus_req_t  mmu_ireq;
    cbus_resp_t mmu_iresp;
    u2          mmu_priv;
    u2          ireq_priv;
    u2          dreq_priv;
    u2          priv_mode_o;
    u64         satp_o;

    core core(
      .clk(clock), .reset, .ireq, .iresp, .dreq, .dresp,
      .ireq_priv, .dreq_priv,
      .priv_mode_o, .satp_o, .trint, .swint, .exint
    );

    IBusToCBus icvt(.*);
    DBusToCBus dcvt(.*);
    CBusArbiter mux(
        .clk(clock), .reset,
        .ireqs({icreq, dcreq}),
        .iprivs({ireq_priv, dreq_priv}),
        .iresps({icresp, dcresp}),
        .opriv(mmu_priv),
        .oreq(mmu_ireq),
        .oresp(mmu_iresp)
    );

    MMU mmu(
        .clk(clock),
        .reset,
        .up_req(mmu_ireq),
        .up_resp(mmu_iresp),
        .dn_req(oreq),
        .dn_resp(oresp),
        .priv_mode(mmu_priv),
        .satp(satp_o)
    );

    RAMHelper2 ram(
        .clk(clock), .reset, .oreq, .oresp, .trint, .swint, .exint
    );

    assign {io_uart_out_valid, io_uart_out_ch, io_uart_in_valid} = '0;

endmodule
`endif