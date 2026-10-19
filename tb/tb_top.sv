// Integration harness only: no stimulus, checking, or UVM.
module tb_top;
  timeunit 1ns; timeprecision 1ps;
  localparam AXI_DATA_WIDTH=32, AXI_ADDR_WIDTH=16, AXI_STRB_WIDTH=4,
             AXI_ID_WIDTH=8, LEN_WIDTH=20, TAG_WIDTH=8;
  logic  clk = 0;
  logic  rst = 0;
  logic [AXI_ADDR_WIDTH-1:0] s_axis_desc_read_addr = 0;
  logic [AXI_ADDR_WIDTH-1:0] s_axis_desc_write_addr = 0;
  logic [LEN_WIDTH-1:0] s_axis_desc_len = 0;
  logic [TAG_WIDTH-1:0] s_axis_desc_tag = 0;
  logic  s_axis_desc_valid = 0;
  logic  s_axis_desc_ready;
  logic [TAG_WIDTH-1:0] m_axis_desc_status_tag;
  logic [3:0] m_axis_desc_status_error;
  logic  m_axis_desc_status_valid;
  logic [AXI_ID_WIDTH-1:0] m_axi_awid;
  logic [AXI_ADDR_WIDTH-1:0] m_axi_awaddr;
  logic [7:0] m_axi_awlen;
  logic [2:0] m_axi_awsize;
  logic [1:0] m_axi_awburst;
  logic  m_axi_awlock;
  logic [3:0] m_axi_awcache;
  logic [2:0] m_axi_awprot;
  logic  m_axi_awvalid;
  logic  m_axi_awready = 0;
  logic [AXI_DATA_WIDTH-1:0] m_axi_wdata;
  logic [AXI_STRB_WIDTH-1:0] m_axi_wstrb;
  logic  m_axi_wlast;
  logic  m_axi_wvalid;
  logic  m_axi_wready = 0;
  logic [AXI_ID_WIDTH-1:0] m_axi_bid = 0;
  logic [1:0] m_axi_bresp = 0;
  logic  m_axi_bvalid = 0;
  logic  m_axi_bready;
  logic [AXI_ID_WIDTH-1:0] m_axi_arid;
  logic [AXI_ADDR_WIDTH-1:0] m_axi_araddr;
  logic [7:0] m_axi_arlen;
  logic [2:0] m_axi_arsize;
  logic [1:0] m_axi_arburst;
  logic  m_axi_arlock;
  logic [3:0] m_axi_arcache;
  logic [2:0] m_axi_arprot;
  logic  m_axi_arvalid;
  logic  m_axi_arready = 0;
  logic [AXI_ID_WIDTH-1:0] m_axi_rid = 0;
  logic [AXI_DATA_WIDTH-1:0] m_axi_rdata = 0;
  logic [1:0] m_axi_rresp = 0;
  logic  m_axi_rlast = 0;
  logic  m_axi_rvalid = 0;
  logic  m_axi_rready;
  logic  enable = 0;
  always #5 clk = ~clk;
  initial begin
    rst = 1;
    repeat (5) @(negedge clk);
    rst = 0;
    repeat (10) @(negedge clk);
    $display("Idle integration harness finished; no functional verification performed.");
    $finish;
  end
  initial if ($test$plusargs("WAVES")) begin
    $dumpfile("waves.vcd");
    $dumpvars(0, tb_top);
  end
  axi_cdma dut (
    .clk(clk),
    .rst(rst),
    .s_axis_desc_read_addr(s_axis_desc_read_addr),
    .s_axis_desc_write_addr(s_axis_desc_write_addr),
    .s_axis_desc_len(s_axis_desc_len),
    .s_axis_desc_tag(s_axis_desc_tag),
    .s_axis_desc_valid(s_axis_desc_valid),
    .s_axis_desc_ready(s_axis_desc_ready),
    .m_axis_desc_status_tag(m_axis_desc_status_tag),
    .m_axis_desc_status_error(m_axis_desc_status_error),
    .m_axis_desc_status_valid(m_axis_desc_status_valid),
    .m_axi_awid(m_axi_awid),
    .m_axi_awaddr(m_axi_awaddr),
    .m_axi_awlen(m_axi_awlen),
    .m_axi_awsize(m_axi_awsize),
    .m_axi_awburst(m_axi_awburst),
    .m_axi_awlock(m_axi_awlock),
    .m_axi_awcache(m_axi_awcache),
    .m_axi_awprot(m_axi_awprot),
    .m_axi_awvalid(m_axi_awvalid),
    .m_axi_awready(m_axi_awready),
    .m_axi_wdata(m_axi_wdata),
    .m_axi_wstrb(m_axi_wstrb),
    .m_axi_wlast(m_axi_wlast),
    .m_axi_wvalid(m_axi_wvalid),
    .m_axi_wready(m_axi_wready),
    .m_axi_bid(m_axi_bid),
    .m_axi_bresp(m_axi_bresp),
    .m_axi_bvalid(m_axi_bvalid),
    .m_axi_bready(m_axi_bready),
    .m_axi_arid(m_axi_arid),
    .m_axi_araddr(m_axi_araddr),
    .m_axi_arlen(m_axi_arlen),
    .m_axi_arsize(m_axi_arsize),
    .m_axi_arburst(m_axi_arburst),
    .m_axi_arlock(m_axi_arlock),
    .m_axi_arcache(m_axi_arcache),
    .m_axi_arprot(m_axi_arprot),
    .m_axi_arvalid(m_axi_arvalid),
    .m_axi_arready(m_axi_arready),
    .m_axi_rid(m_axi_rid),
    .m_axi_rdata(m_axi_rdata),
    .m_axi_rresp(m_axi_rresp),
    .m_axi_rlast(m_axi_rlast),
    .m_axi_rvalid(m_axi_rvalid),
    .m_axi_rready(m_axi_rready),
    .enable(enable)
  );
endmodule
