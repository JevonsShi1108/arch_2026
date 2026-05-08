`ifndef __MEM_SV
`define __MEM_SV

`ifdef VERILATOR
`include "include/common.sv"
`endif

module mem_stage import common::*;(
    input  logic clk,
    input  logic reset,
    input  logic flush,
    input  logic in_valid,
    input  u64   in_pc,
    input  u32   in_instr,
    input  u5    in_rd,
    input  logic in_reg_write,
    input  u64   in_result,
    input  logic in_is_load,
    input  logic in_is_store,
    input  msize_t in_mem_size,
    input  logic in_load_unsigned,
    input  u64   in_mem_addr,
    input  u64   in_store_data,
    input  logic in_is_ebreak,
    input  logic in_is_trap,
    output dbus_req_t dreq,
    input  dbus_resp_t dresp,
    output logic mem_wait,
    output logic out_valid,
    output u64   out_pc,
    output u32   out_instr,
    output u5    out_rd,
    output logic out_reg_write,
    output u64   out_result,
    output logic out_is_load,
    output logic out_is_store,
    output u64   out_mem_addr,
    output logic out_is_ebreak,
    output logic out_is_trap
);
    logic   pending;
    u64     pend_pc;
    u32     pend_instr;
    u5      pend_rd;
    logic   pend_reg_write;
    u64     pend_result;
    logic   pend_is_load;
    logic   pend_is_store;
    msize_t pend_mem_size;
    logic   pend_load_unsigned;
    u64     pend_mem_addr;
    u64     pend_store_data;
    logic   pend_is_ebreak;
    logic   pend_is_trap;

    logic cur_valid;
    u64   cur_pc;
    u32   cur_instr;
    u5    cur_rd;
    logic cur_reg_write;
    u64   cur_result;
    logic cur_is_load;
    logic cur_is_store;
    msize_t cur_mem_size;
    logic cur_load_unsigned;
    u64   cur_mem_addr;
    u64   cur_store_data;
    logic cur_is_ebreak;
    logic cur_is_trap;

    logic cur_is_mem;
    logic cur_done;
    u3    byte_off;
    u6    bit_off;
    u64   shifted_store_data;
    u8    strobe_base;
    u8    shifted_strobe;
    u64   shifted_load_data;
    u64   load_result;
    logic is_device_addr;
    logic is_device_in;

    function automatic logic is_mmio_addr(input u64 addr);
        begin
            is_mmio_addr = 1'b0;
            if (addr >= 64'h0000_0000_4060_0000 && addr <= 64'h0000_0000_4060_000c)
                is_mmio_addr = 1'b1;
            else if (addr >= 64'h0000_0000_2333_3000 && addr <= 64'h0000_0000_2333_300f)
                is_mmio_addr = 1'b1;
            else if (addr >= 64'h0000_0000_3800_bff8 && addr <= 64'h0000_0000_3800_bfff)
                is_mmio_addr = 1'b1;
            else if (addr >= 64'h0000_0000_2000_3000 && addr <= 64'h0000_0000_2000_30ff)
                is_mmio_addr = 1'b1;
        end
    endfunction

`ifndef SYNTHESIS
    task automatic debug_log_mem(
        input string run_id,
        input string hypothesis_id,
        input string location,
        input string message,
        input u64 pc,
        input u64 addr,
        input logic is_load,
        input logic is_store,
        input logic data_ok,
        input logic pending_now
    );
        integer fd;
        string payload;
        begin
            fd = $fopen("/home/jevonsshi/arch_2026/.cursor/debug-f06466.log", "a");
            if (fd != 0) begin
                payload = $sformatf(
                    "{\"sessionId\":\"f06466\",\"runId\":\"%s\",\"hypothesisId\":\"%s\",\"location\":\"%s\",\"message\":\"%s\",\"data\":{\"pc\":\"0x%016h\",\"addr\":\"0x%016h\",\"isLoad\":%0d,\"isStore\":%0d,\"dataOk\":%0d,\"pending\":%0d},\"timestamp\":%0t}",
                    run_id, hypothesis_id, location, message, pc, addr, is_load, is_store, data_ok, pending_now, $time
                );
                $fdisplay(fd, "%s", payload);
                $fclose(fd);
            end
        end
    endtask
`endif

    always_comb begin
        cur_valid         = pending ? 1'b1 : in_valid;
        cur_pc            = pending ? pend_pc : in_pc;
        cur_instr         = pending ? pend_instr : in_instr;
        cur_rd            = pending ? pend_rd : in_rd;
        cur_reg_write     = pending ? pend_reg_write : in_reg_write;
        cur_result        = pending ? pend_result : in_result;
        cur_is_load       = pending ? pend_is_load : in_is_load;
        cur_is_store      = pending ? pend_is_store : in_is_store;
        cur_mem_size      = pending ? pend_mem_size : in_mem_size;
        cur_load_unsigned = pending ? pend_load_unsigned : in_load_unsigned;
        cur_mem_addr      = pending ? pend_mem_addr : in_mem_addr;
        cur_store_data    = pending ? pend_store_data : in_store_data;
        cur_is_ebreak     = pending ? pend_is_ebreak : in_is_ebreak;
        cur_is_trap       = pending ? pend_is_trap : in_is_trap;
        is_device_addr    = is_mmio_addr(cur_mem_addr);
        is_device_in      = is_mmio_addr(in_mem_addr);
    end

    assign cur_is_mem = cur_valid & (cur_is_load | cur_is_store);
`ifdef VERILATOR
    assign cur_done   = ~cur_is_mem | dresp.data_ok;
`else
    assign cur_done = ~cur_is_mem
                    | (cur_is_load  ? dresp.data_ok
                       : (cur_is_store && !is_device_addr ? dresp.data_ok : 1'b1));
`endif
    assign mem_wait   = cur_is_mem & ~cur_done;

    assign byte_off          = cur_mem_addr[2:0];
    assign bit_off           = {byte_off, 3'b000};
    assign shifted_store_data= cur_store_data << bit_off;
    assign shifted_load_data = dresp.data >> bit_off;

    always_comb begin
        unique case (cur_mem_size)
            MSIZE1: strobe_base = 8'b0000_0001;
            MSIZE2: strobe_base = 8'b0000_0011;
            MSIZE4: strobe_base = 8'b0000_1111;
            default: strobe_base = 8'b1111_1111;
        endcase
    end
    assign shifted_strobe = strobe_base << byte_off;

    always_comb begin
        unique case (cur_mem_size)
            MSIZE1: load_result = cur_load_unsigned ?
                                  {56'd0, shifted_load_data[7:0]} :
                                  {{56{shifted_load_data[7]}}, shifted_load_data[7:0]};
            MSIZE2: load_result = cur_load_unsigned ?
                                  {48'd0, shifted_load_data[15:0]} :
                                  {{48{shifted_load_data[15]}}, shifted_load_data[15:0]};
            MSIZE4: load_result = cur_load_unsigned ?
                                  {32'd0, shifted_load_data[31:0]} :
                                  {{32{shifted_load_data[31]}}, shifted_load_data[31:0]};
            default: load_result = shifted_load_data;
        endcase
    end

    assign dreq.valid  = cur_is_mem;
    assign dreq.addr   = cur_mem_addr;
    assign dreq.size   = cur_mem_size;
    assign dreq.strobe = cur_is_store ? shifted_strobe : 8'd0;
    assign dreq.data   = cur_is_store ? shifted_store_data : 64'd0;

    assign out_valid     = cur_valid & cur_done;
    assign out_pc        = cur_pc;
    assign out_instr     = cur_instr;
    assign out_rd        = cur_rd;
    assign out_reg_write = cur_reg_write;
    assign out_result    = cur_is_load ? load_result : cur_result;
    assign out_is_load   = cur_is_load;
    assign out_is_store  = cur_is_store;
    assign out_mem_addr  = cur_mem_addr;
    assign out_is_ebreak = cur_is_ebreak;
    assign out_is_trap   = cur_is_trap;

    always_ff @(posedge clk) begin
        if (reset || flush) begin
`ifndef SYNTHESIS
            if (pending) begin
                debug_log_mem("pre-fix", "H1", "mem.sv:flush_clear", "flush/reset cleared pending request",
                              pend_pc, pend_mem_addr, pend_is_load, pend_is_store, dresp.data_ok, pending);
            end
`endif
            pending <= 1'b0;
        end else begin
`ifdef VERILATOR
            if (!pending && in_valid && (in_is_load || in_is_store) && !dresp.data_ok) begin
`else
    if (!pending && in_valid &&
        ((in_is_load || (in_is_store && !is_device_in)) && !dresp.data_ok)) begin
`endif
`ifndef SYNTHESIS
                debug_log_mem("pre-fix", "H1", "mem.sv:pending_set", "request entered pending wait",
                              in_pc, in_mem_addr, in_is_load, in_is_store, dresp.data_ok, pending);
`endif
                pending             <= 1'b1;
                pend_pc             <= in_pc;
                pend_instr          <= in_instr;
                pend_rd             <= in_rd;
                pend_reg_write      <= in_reg_write;
                pend_result         <= in_result;
                pend_is_load        <= in_is_load;
                pend_is_store       <= in_is_store;
                pend_mem_size       <= in_mem_size;
                pend_load_unsigned  <= in_load_unsigned;
                pend_mem_addr       <= in_mem_addr;
                pend_store_data     <= in_store_data;
                pend_is_ebreak      <= in_is_ebreak;
                pend_is_trap        <= in_is_trap;
            end else if (pending && dresp.data_ok) begin
`ifndef SYNTHESIS
                debug_log_mem("pre-fix", "H1", "mem.sv:pending_clear", "pending request observed data_ok",
                              pend_pc, pend_mem_addr, pend_is_load, pend_is_store, dresp.data_ok, pending);
`endif
                pending <= 1'b0;
            end
        end
    end
endmodule

`endif
