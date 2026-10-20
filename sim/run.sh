#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
mode=run
top=${TOP:-tb_top}
seed=1
test_name=
waves=0
usage() { echo "Usage: $0 [--elaborate] [--top MODULE] [--seed N] [--test NAME] [--waves] [-- simulator arguments]"; }
while (($#)); do
  case "$1" in
    --elaborate) mode=elaborate; shift ;;
    --top|--seed|--test)
      (($# >= 2)) || { usage >&2; exit 2; }
      case "$1" in --top) top=$2;; --seed) seed=$2;; --test) test_name=$2;; esac
      shift 2 ;;
    --waves) waves=1; shift ;;
    -h|--help) usage; exit 0 ;;
    --) shift; break ;;
    *) usage >&2; exit 2 ;;
  esac
done
[[ $seed =~ ^[0-9]+$ ]] || { echo "Seed must be a nonnegative integer" >&2; exit 2; }
xrun=${XRUN:-xrun}
command -v "$xrun" >/dev/null || { echo "Xcelium unavailable: set XRUN or load your simulator environment" >&2; exit 127; }
[[ -f "$root/dut/verilog-axi/rtl/axi_cdma.v" ]] || { echo "Initialize submodules first" >&2; exit 2; }
# Resolve the root-relative file list before changing to an isolated output directory.
run_dir=$(mktemp -d "$root/results/run.XXXXXXXX")
while IFS= read -r source || [[ -n $source ]]; do
  [[ -z $source || $source == \#* ]] && continue
  printf '"%s/%s"\n' "$root" "$source"
done < "$root/sim/filelist.f" > "$run_dir/sources.f"
# Ignore missing optional library paths in the site Cadence installation.
args=(-64bit -sv -nowarn DLCPTH -f "$run_dir/sources.f" -top "$top" -svseed "$seed")
[[ $mode == elaborate ]] && args+=(-elaborate)
[[ -n $test_name ]] && args+=(-uvm "+UVM_TESTNAME=$test_name")
((waves)) && args+=(-access +rwc +WAVES)
printf '%q ' "$xrun" "${args[@]}" "$@" > "$run_dir/command.txt"
printf '\n' >> "$run_dir/command.txt"
echo "Output: $run_dir"
[[ -z $test_name ]] || echo "UVM test selection forwarded; the current harness does not run UVM."
cd -- "$run_dir"
exec "$xrun" "${args[@]}" "$@"
