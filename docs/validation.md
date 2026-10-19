# Setup validation

Date: 2026-10-19. Host: Windows; intended simulator host: Linux.

## Successfully checked

- Cloned the official upstream and detached checkout at `516bd5dadc3365b7f9e225d2af8fe0b8d804fe53`.
- Inspected the complete DUT RTL, upstream README, cocotb harness, and Makefile; the source list contains only axi_cdma.v plus the local harness.
- Confirmed all 47 RTL ports have exactly one matching named harness connection, every listed source exists, and upstream has no working-tree changes.
- Confirmed Git records the DUT as a mode-160000 gitlink at the documented SHA, with the official URL in .gitmodules. Normalized its metadata using submodule absorbgitdirs.
- Successfully ran `git submodule update --init --recursive` on the populated checkout. A fresh remote clone of the parent was not tested (no hosted parent repository exists).
- Bash syntax check (`bash -n`) and launcher help passed using Git Bash. The invalid-seed path rejected input, and the missing-Xcelium path reported its diagnostic.
- Confirmed shell script LF line endings and parsed the regression placeholder with Python's compiler.

Git Bash initially failed to start inside the restricted execution sandbox; the listed Bash checks and submodule metadata normalization succeeded outside that restriction.

## Untested / unresolved

Xcelium, Icarus, and Verilator were not found on PATH. No HDL compiler, elaborator, simulation, waveform generation, UVM integration, functional test, or coverage collection was run. Port and file checks are static checks, not HDL syntax/type validation. Launcher command forwarding with a real Xcelium executable and simulator-version-specific options remain to be validated on Linux. The current UVM selection option is a future integration hook only.

First target-host checks:

```sh
xrun -version
bash sim/run.sh --elaborate
bash sim/run.sh --seed 1 --waves
```

Review each generated results/run.* directory and its logs. A successful idle run establishes integration only, not DMA correctness. No additional RTL dependency was identified by source inspection.
