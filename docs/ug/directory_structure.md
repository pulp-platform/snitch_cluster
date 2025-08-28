# Directory structure

The project is organized as a monolithic repository. Both hardware and software
are co-located for simplicity, easily ensuring that the software is always up to
date with the hardware.

The root of the repository contains the following directories:

* `cfg`: Hosts alternative Snitch cluster configuration files. Both hardware and software sources depend on the configuration.
* `docs`: [Documentation](documentation.md) files.
* `hw`: Hardware description of all IPs distributed in this repo, consisting of RTL and RDL sources.
* `sw`: A software runtime, tests and kernels for multi-cluster Snitch-based systems.
* `target/sim`: Simulation target for Snitch, including verification IP and testbench files.
* `make`: Reusable Make fragments, directly included in Snitch's top-level Makefile.
* `test`: For hosting regression tests and simulation artifacts.
* `experiments`: For hosting experiments.
* `util`: Utility and helper scripts.

## Hardware `hw` directory

* `bootrom`: Sources from which the Snitch bootrom is generated. Refer to the [Boot procedure](../rm/hw/boot_procedure.md) page for more info.
* `mem_interface`, `reqrsp_interface`, `tcdm_interface`: Each folder defines an interface for communication between IPs, providing utility IPs to work with said interfaces (e.g. muxes).
* `snitch`: Contains the sources of the Snitch core.
    * `riscv_instr.sv`: Generated from the `riscv-opcodes` submodule, contains a list of instruction and CSR definitions used e.g. in Snitch's instruction decoder.
    * `snitch.sv`: This single file contains the entire Snitch core.
* `snitch_cluster`: Contains the sources of the Snitch core complex (CC) and cluster, including FPU, FREP sequencer, floating-point subsystem (FPSS), peripherals, etc.

## Software `sw` directory

* `deps`: Contains third-party dependencies.
    * `printf`: A printf implementation for embedded systems.
    * `riscv-opcodes`: Utilities to manage instruction encodings and generate functions and data structures for various languages.
    * `riscv-tests`: Unit tests for RISC-V ISA compliant processors.
* `riscv-tests`: Sources to build riscv-tests in Snitch.
* `tests`: Single-file unit tests for Snitch, written in C.
* `kernels`: Complex, potentially multi-file kernels for Snitch, written in C, often hosting additional Python scripts for data generation and verification.
    * `blas`: BLAS kernels.
    * `dnn`: DNN kernels.
    * `misc`: Miscellaneous kernels.
* `runtime`: A C runtime and library for the Snitch cluster.
    * `api`, `src`: Reusable system-independent sources.
    * `impl`: Contains a sample implementation of the Snitch runtime for the Snitch cluster testharness hosted in this repository, including a sample hardware abstraction layer (HAL) implementation.
* `saris`: Legacy directory containing the experiments for the SARIS paper.

## Target `target` directory

The term `target` refers to a setup for running software on the Snitch cluster. This repository currently hosts a single target, the _simulation_ target, providing a testbench to execute software on the Snitch cluster in RTL simulation. Alternative targets could be an FPGA target, or a chip target.

* `sim`: Simulation target for the Snitch cluster.
    * `tb`: Testbench sources.
    * `patches`: Patches for third-party tools, e.g. `fesvr`.

## Utilities `util` directory

* `sim`: Python utilities to launch, manage and verify Snitch simulations.
* `trace`: Python utilities to parse, visualize and extract performance metrics from the simulation traces.
* `bench`: Python utilities to parse and visualize benchmarking metrics.
* `experiments`: Python utilities to programmatically run experiments with different kernel parameterizations, hardware configurations, etc.
* `clustergen`: Python utilities to generate Snitch cluster sources programmatically.
    * `clustergen.py`: Python script to fill in RTL templates from a JSON configuration file.
    * `snitch_cluster.schema.json`: JSON schema describing the entries in the configuration file.
    * `gen_bootrom.py`: Python script to generate the bootrom RTL.
    * `generate-opcodes.sh`: Shell script to generate `riscv_instr.sv` from `riscv-opcodes`.
* `container`: Docker container sources.
* `lint`: Various linter configuration files.
