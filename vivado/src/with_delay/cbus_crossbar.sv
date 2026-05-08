module cbus_crossbar (
    input  logic clk, reset,

    /* From CPU */
    input  logic        valid,
    input  logic [63:0] addr,
    input  logic [63:0] wdata,
    input  logic [1:0]  burst,
    input  logic [7:0]  len,
    input  logic [7:0]  wstrobe,
    output logic [63:0] rdata,
    output logic        ready,
    output logic        last,

    /* To RAM */
    output logic        ram_valid,
    output logic [63:0] ram_addr,
    output logic [63:0] ram_wdata,
    output logic [1:0]  ram_burst,
    output logic [7:0]  ram_len,
    output logic [7:0]  ram_wstrobe,
    input  logic [63:0] ram_rdata,
    input  logic        ram_ready,
    input  logic        ram_last,

    /* To Device */
    output logic        device_valid,
    output logic [63:0] device_addr,
    output logic [63:0] device_wdata,
    output logic        device_wvalid,
    input  logic [63:0] device_rdata,
    input  logic        device_ready,
    input  logic        device_last
);

    logic is_device;

    always_comb begin
        // 默认不是设备
        is_device = 1'b0;

        // UARTlite: 0x4060_0000 ~ 0x4060_000c（TX_DATA/READY 都在这里附近）
        if (addr >= 64'h0000_0000_4060_0000 && addr <= 64'h0000_0000_4060_000c)
            is_device = 1'b1;

        // FINISH + SW: 0x2333_3000 ~ 0x2333_300f
        else if (addr >= 64'h0000_0000_2333_3000 && addr <= 64'h0000_0000_2333_300f)
            is_device = 1'b1;

        // COUNTER_1: 0x3800_bff8（给一点余量）
        else if (addr >= 64'h0000_0000_3800_bff8 && addr <= 64'h0000_0000_3800_bfff)
            is_device = 1'b1;

        // COUNTER_2: 0x2000_3000（给一点余量）
        else if (addr >= 64'h0000_0000_2000_3000 && addr <= 64'h0000_0000_2000_30ff)
            is_device = 1'b1;
    end

    // 读通路：根据 is_device 选择 RAM / Device 返回数据
    assign rdata = is_device ? device_rdata : ram_rdata;
    assign ready = is_device ? device_ready : ram_ready;
    assign last  = is_device ? device_last  : ram_last;

    // 向 RAM 发请求
    assign ram_valid   = valid && !is_device;
    assign ram_addr    = addr;
    assign ram_wdata   = wdata;
    assign ram_burst   = burst;
    assign ram_len     = len;
    assign ram_wstrobe = wstrobe;

    // 向 Device 发请求
    assign device_valid  = valid && is_device;
    assign device_addr   = addr;
    assign device_wdata  = wdata;
    assign device_wvalid = |wstrobe;

endmodule