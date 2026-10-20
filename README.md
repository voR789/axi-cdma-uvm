# AXI CDMA UVM Verification

Independent SystemVerilog/UVM verification of the `axi_cdma` memory-to-memory DMA controller from [verilog-axi](https://github.com/alexforencich/verilog-axi).

The project targets descriptor handling, AXI transfers, error reporting, and transfer alignment through constrained-random testing, assertions, scoreboarding, and functional coverage.

**Status:** Initial setup. The repository includes the pinned DUT, an idle clock/reset harness, and an Xcelium build script. UVM components and functional tests are planned. Compilation and elaboration on Xcelium are pending.

## Getting started

Requires Git, Bash, and a licensed Cadence Xcelium installation. Configure the simulator and license environment so `xrun` is available on `PATH`, then run from the repository root:

```sh
git submodule update --init --recursive
bash sim/run.sh --elaborate
```

To run the clock/reset harness and optionally record waveforms:

```sh
bash sim/run.sh --seed 1
bash sim/run.sh --seed 1 --waves
```

The harness holds the DUT idle, applies reset, and exits after 150 ns. It does not exercise DMA transfers. Each invocation writes its command, logs, and generated files to a separate `results/run.*` directory. Waveforms use VCD format.

## Simulation options

| Option | Description |
|---|---|
| `--elaborate` | Compile and elaborate without running |
| `--top MODULE` | Select the simulation top; default: `tb_top` |
| `--seed N` | Set the simulator seed; default: `1` |
| `--waves` | Enable waveform recording |
| `--test NAME` | Forward `+UVM_TESTNAME` and enable simulator UVM support |
| `-- ARGS` | Pass additional arguments to `xrun` |

`--test` is reserved for UVM integration; the current harness does not call `run_test()`. Regression execution is not implemented yet.

Set `XRUN` to use a specific executable, or `TOP` to override the default top:

```sh
XRUN=/path/to/xrun bash sim/run.sh --elaborate
bash sim/run.sh --elaborate -- -messages
```

Sources are listed in `sim/filelist.f`, with one repository-relative path per line. Add new testbench sources there as the environment grows.

## Repository layout

```text
dut/verilog-axi/    Upstream RTL submodule
tb/                Simulation top and UVM source directories
sim/               Source list and simulation scripts
docs/              DUT notes, verification plan, and architecture
results/           Generated simulation output (ignored by Git)
```

- [DUT overview](docs/dut_overview.md)
- [Verification plan](docs/verification_plan.md)
- [Testbench architecture](docs/architecture.md)
- [Requirements traceability](docs/coverage_matrix.md)

## DUT and licensing

The DUT is Alex Forencich's `axi_cdma`, pinned to commit
`516bd5dadc3365b7f9e225d2af8fe0b8d804fe53`. The module is self-contained in `rtl/axi_cdma.v`; no additional RTL modules are required.

Upstream RTL retains its [MIT license](dut/verilog-axi/COPYING) and copyright notices. Independent project files are covered by [LICENSE](LICENSE).

The upstream verilog-axi repository is deprecated in favor of [taxi](https://github.com/fpganinja/taxi). This project targets the pinned verilog-axi implementation.
