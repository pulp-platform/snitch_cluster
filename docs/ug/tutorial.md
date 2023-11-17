# Tutorial

The following tutorial will guide you through the use of the Snitch/SNAX cluster. You will learn how to develop, simulate, debug and benchmark software for the Snitch/SNAX cluster architecture.

## Quick Start
<!---
The following documentation is directly included from `../../target/snitch_cluster/README.md`
-->
{%
   include-markdown '../../target/snitch_cluster/README.md'
   comments=false
   start="## Quick Start"
%}

## Using Verilator with LLVM

LLVM+clang can be used to build the Verilator model. Optionally specify a path
to the LLVM toolchain in `CLANG_PATH` and set `VLT_USE_LLVM=ON`.
For the verilated model itself to be complied with LLVM, verilator must be built
with LLVM (`CC=clang CXX=clang++ ./configure`). The `VLT` environment variable
can then be used to point to the verilator binary.

```bash
# Optional: Specify which llvm to use
export CLANG_PATH=/path/to/llvm-12.0.1
# Optional: Point to a verilator binary compiled with LLVM
export VLT=/path/to/verilator-llvm/bin/verilator
make VLT_USE_LLVM=ON bin/snitch_cluster.vlt
```
