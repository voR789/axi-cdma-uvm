# DUT overview

Upstream: [alexforencich/verilog-axi](https://github.com/alexforencich/verilog-axi)
Pinned revision: `516bd5dadc3365b7f9e225d2af8fe0b8d804fe53`.
Source: `dut/verilog-axi/rtl/axi_cdma.v`; upstream license: `dut/verilog-axi/COPYING` (MIT, copyright Alex Forencich). Original notices remain intact. Local project files use the root MIT license.

## Function and architecture

`axi_cdma` copies a descriptor-specified byte count from a source address to a destination address through an AXI4 master interface. Internal read-request and write/datapath state machines split transfers into bursts. A shift datapath supports optional byte realignment, with internal output and completion FIFOs (32 entries each). These are arrays inside the module, not external module dependencies.

Only full bus-width INCR bursts are generated. Burst segmentation respects the maximum burst length and 4 KiB boundaries on source and destination. Partial final words use write strobes. With `ENABLE_UNALIGNED=0`, descriptor addresses are masked down to bus-word boundaries; with it enabled, source and destination offsets are handled by the shifting logic. There is no AXI-Lite programming interface, scatter/gather descriptor fetcher, or external stream payload interface in this module. Overlapping-copy and zero-length behavior are not specified here.

## Parameters

| Public parameter | Default | Meaning |
|---|---|---|
| AXI_DATA_WIDTH | 32 | Data bits |
| AXI_ADDR_WIDTH | 16 | Address bits |
| AXI_STRB_WIDTH | AXI_DATA_WIDTH/8 | Byte-lane strobes |
| AXI_ID_WIDTH | 8 | AXI ID bits |
| AXI_MAX_BURST_LEN | 16 | Maximum beats, permitted range 1â€“256 |
| LEN_WIDTH | 20 | Descriptor length bits |
| TAG_WIDTH | 8 | Descriptor tag bits |
| ENABLE_UNALIGNED | 0 | Optional unaligned support |

The module also declares derived sizing parameters and FIFO address widths in its body; the harness retains all defaults. RTL startup checks require consistent data/strobe sizing, a power-of-two strobe width, and a maximum burst length within 1â€“256. The intended standard configuration uses eight bits per byte lane.

## Interfaces

- `clk`: rising-edge clock. `rst`: synchronous active-high reset. The harness uses a 10 ns clock and holds reset for five cycles, releasing on a falling edge.
- `s_axis_desc_read_addr`, `s_axis_desc_write_addr`: source and destination addresses, each AXI_ADDR_WIDTH bits. `s_axis_desc_len`: byte count, LEN_WIDTH bits. `s_axis_desc_tag`: TAG_WIDTH bits. Descriptors handshake on `s_axis_desc_valid` and `s_axis_desc_ready`.
- `m_axis_desc_status_tag`, `m_axis_desc_status_error[3:0]`, `m_axis_desc_status_valid`: completion notification. There is no status-ready input; consumers cannot backpressure this notification. Status is produced on the final burst completion for a descriptor. Implemented error reporting selects read SLVERR/DECERR (4/5), then write SLVERR/DECERR (6/7), otherwise success (0). Other declared error constants do not imply implemented error detection.
- AXI write address: `m_axi_aw{id,addr,len,size,burst,lock,cache,prot,valid,ready}`; data: `m_axi_w{data,strb,last,valid,ready}`; response: `m_axi_b{id,resp,valid,ready}`.
- AXI read address: `m_axi_ar{id,addr,len,size,burst,lock,cache,prot,valid,ready}`; data: `m_axi_r{id,data,resp,last,valid,ready}`.
- Address/data request signals are outputs; AWREADY/WREADY/ARREADY and B/R response payloads and valid signals are inputs. BREADY/RREADY are outputs. IDs are driven to zero, sizes are log2(strobe width), burst types are INCR, lock is zero, cache is 0011, and protection is 010. No QoS, region, or user sidebands are exposed. RID, BID, and RLAST are present as ports but not consumed by the transfer logic.
- `enable`: gates acceptance readiness for new descriptors; it is not a synchronous reset or an abort interface.

## Dependencies and upstream references

The only required RTL source is `rtl/axi_cdma.v`: it contains no module instantiations or include directives. The independent descriptor mux is not required. Upstream `tb/axi_cdma/Makefile` and the simulator source list in `tb/axi_cdma/test_axi_cdma.py` corroborate this dependency.

Upstream `README.md`, section `axi_cdma`, describes burst and unaligned capabilities and links to the author's AXI documentation. Upstream cocotb tests use pytest, cocotb-test, and cocotbext-axi's AxiRam and descriptor streams; those Python dependencies are not required for this repository's idle SystemVerilog harness. Upstream marks verilog-axi deprecated in favor of taxi; this project targets the pinned verilog-axi implementation.

## Simulation integration

No vendor primitive libraries, generated IP, or extra RTL packages are required. The supplied harness drives all DUT inputs to idle values, including `enable=0` and descriptor-valid=0. It runs for 150 ns then finishes. It contains no memory responder, functional stimulus, checking, or UVM. A future functional environment must provide AXI responses. The `--test` option forwards UVM selection arguments; UVM startup is not yet implemented.
