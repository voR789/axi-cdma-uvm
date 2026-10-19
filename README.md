# axi-cdma-uvm

Independent, coverage-driven SystemVerilog/UVM verification project for Alex Forencich's AXI Central DMA controller. Current status: repository and integration scaffolding only. No UVM environment, functional tests, verification results, or coverage claims exist yet.

Long-term work includes requirements traceability, modular UVM, constrained-random stimulus, reference modeling and scoreboarding, assertions, coverage closure, regressions, and fault-injection analysis. These remain future work for the project author.

## Upstream attribution

Official RTL: https://github.com/alexforencich/verilog-axi

Pinned commit: `516bd5dadc3365b7f9e225d2af8fe0b8d804fe53`, recorded as a Git submodule at `dut/verilog-axi`. Upstream is MIT licensed; see its `COPYING` and source notices. The root MIT license covers independent project files, not a replacement for upstream attribution. Upstream is deprecated in favor of taxi; the requested target is intentionally retained.

## Setup on Linux

Requires Git, Bash, a licensed Cadence Xcelium installation (`xrun`), and a working simulator environment. No university installation paths are assumed. Python 3 is reserved for future regression tooling.

```sh
git clone --recurse-submodules <your-repository-url> axi-cdma-uvm
cd axi-cdma-uvm
# For an existing clone:
git submodule update --init --recursive
# Load the site's simulator/license environment before running:
bash sim/run.sh --elaborate
bash sim/run.sh --seed 1
bash sim/run.sh --seed 42 --waves
```

`--elaborate` compiles and elaborates without running. The normal command compiles, elaborates, and runs the idle clock/reset harness. Optional waves are VCD in the run directory. Each invocation creates an isolated ignored `results/run.*` directory containing the resolved source list, quoted command, simulator logs, and generated files.

Use `XRUN=/path/to/xrun` to select an executable, otherwise PATH discovery is used. `TOP` or `--top` selects a module already present in the file list (default `tb_top`). Edit `sim/filelist.f` when adding sources; its paths are repository-root-relative, one source per line. No UVM package is required for the present harness.

```sh
XRUN=/path/to/xrun bash sim/run.sh --elaborate --top tb_top
# Future integration only; no test is implemented or run by tb_top today:
bash sim/run.sh --test my_future_test --seed 42
# Additional simulator options can follow --:
bash sim/run.sh --elaborate -- -messages
```

`--test` enables Xcelium UVM support and forwards `+UVM_TESTNAME`; the future harness must import UVM and call run_test before selection has any effect. Seeds are forwarded with `-svseed`. `sim/regress.py` explicitly reports that regressions are unimplemented.

## Layout

```text
axi-cdma-uvm/
├── README.md
├── LICENSE
├── .gitattributes
├── .gitignore
├── .gitmodules
├── dut/verilog-axi/          # pinned upstream submodule
├── tb/
│   ├── interfaces/
│   ├── agents/
│   ├── env/
│   ├── sequences/
│   ├── tests/
│   ├── assertions/
│   └── tb_top.sv            # idle integration harness
├── sim/
│   ├── filelist.f
│   ├── run.sh
│   └── regress.py          # explicit future-work stub
├── docs/
│   ├── dut_overview.md
│   ├── verification_plan.md
│   ├── architecture.md
│   ├── coverage_matrix.md
│   ├── progress.md
│   └── validation.md
└── results/                 # generated output ignored
```

Empty directories contain only `.gitkeep`. See [DUT overview](docs/dut_overview.md), [progress](docs/progress.md), and [validation limits](docs/validation.md).

## Next development steps

1. Run compilation, elaboration, and the idle harness on the TAMU Xcelium environment, recording tool version and logs.
2. Author the verification plan and requirements traceability from the pinned DUT behavior.
3. Design the UVM architecture and interfaces before implementing components and initial functional scenarios.
