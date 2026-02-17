---
name: run-sim
description: Execute software binaries on a Snitch cluster simulation using previously built hardware. Use when you need to run simulations and capture execution traces from compiled software.
---

# Run Simulation Skill

## Overview

This skill provides instructions for executing software on a previously built Snitch cluster simulation model. After building hardware and compiling software, use this skill to run simulations and capture execution traces. If the user doesn't specify which simulator to use, and this is not implicit from the context, then ask before taking any further action.

## Prerequisites

- Hardware simulation binary built (from the `build-hw` skill)
- Software executable compiled (typically with `.elf` extension)

## Description

### Basic Simulation Execution

To run a compiled software binary on the Snitch cluster simulator, execute one of the following commands depending on which simulator was used to build the hardware:

#### Verilator
```bash
snitch_cluster.vlt <path_to_binary.elf>
```
- Example: `snitch_cluster.vlt sw/kernels/blas/axpy/build/axpy.elf`
- Output: Console output + log files in simulation directory

#### QuestaSim (Questa)
```bash
snitch_cluster.vsim <path_to_binary.elf>
```
- Example: `snitch_cluster.vsim sw/kernels/blas/axpy/build/axpy.elf`
- Output: Console output + log files in simulation directory

#### VCS
```bash
snitch_cluster.vcs <path_to_binary.elf>
```
- Example: `snitch_cluster.vcs sw/kernels/blas/axpy/build/axpy.elf`
- Output: Console output + log files in simulation directory

#### Using Make Target (QuestaSim)

For convenience, a Make target alias is provided:
```bash
make vsim-run BINARY=<path_to_binary.elf> SIM_DIR=<simulation_directory>
```

**Parameters**:
- `BINARY`: Absolute or relative path to the ELF file (path is relative to simulation directory if relative)
- `SIM_DIR`: Directory where simulation artifacts will be created (default: `test`)

**Example**:
```bash
make vsim-run BINARY=$PWD/sw/kernels/blas/axpy/build/axpy.elf SIM_DIR=test
```

### Kernel Verification

To verify results, prepend a verification script to the simulation command:

```bash
sw/kernels/blas/axpy/scripts/verify.py snitch_cluster.vlt sw/kernels/misc/tutorial/build/tutorial.elf
```

Check the exit code to confirm verification success (exit code $0$ means success):

```bash
echo $?
```

**Note**: Not all kernels provide a verification script. Only add the verification script when simulating a kernel that provides one at the path `<kernel_folder>/scripts/`.

#### Verification with the Make Target (QuestaSim)

When using the `vsim-run` alias, pass the verification script with `VERIFY_PY`:

```bash
make vsim-run BINARY=$PWD/sw/kernels/blas/axpy/build/axpy.elf VERIFY_PY=$PWD/sw/kernels/blas/axpy/scripts/verify.py
```

The `VERIFY_PY` path must be absolute or relative to the simulation directory.

## Path Resolution

- Simulator binaries can be invoked from any directory
- The `target/sim/build/bin/` folder, containing the simulator binaries, is automatically added to the `$PATH`, so the simulator binaries don't need to be prefixed
- Adapt the relative path to the software binary accordingly, or use absolute paths

## Output Files

After simulation completion, the simulation directory will contain:

- **Trace files** (`logs/` subdirectory):
  - One file per core, identified by hart ID
  - `.dasm` extension (non-human-readable)
  - Can be converted to human-readable format (see `annotate-traces` skill)

- **Simulation-specific artifacts**: Log files and outputs from the simulator

## Important Notes

- Ensure the software binary was compiled with the same hardware configuration as the simulator binary
- Log files will be overwritten if you run another simulation in the same directory

## Related Skills

- **build-hw**: Build the hardware simulation binary before running simulations
- **build-sw**: Compile software binaries for simulation (referenced in `build-hw`)
