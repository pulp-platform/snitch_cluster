# Shared target components

This directory contains shared target components.

## `test`

Contains an abstract testbench for Snitch-based targets with multiple memory
interfaces (e.g. AXI) accessing an infinite simulation memory.

Furthermore, it allows linking to a system-specific `bootrom`.

The testbench mimics the behavior of an infinite memory. The `tb_memory_*`
module turns read and write transactions into DPI calls into the simulation
memory (`GlobalMemory` in `tb_lib.hh`).

The testbench can interface directly with the global memory or the RISC-V
front-end server (`fesvr`) can interact with the DUT through memory map
operations. This allows the software on the DUT to make proxied system calls.

The `SnitchSim` Python class provides an IPC-based interface to control and
access the memory of `tb_lib` testbenches.
