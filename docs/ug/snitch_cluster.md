<!---
The following documentation is directly included from `../../target/snitch_cluster/README.md`
-->
{%
   include-markdown '../../target/snitch_cluster/README.md'
   comments=false
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
