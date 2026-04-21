---
name: build-hw
description: Build a cycle-accurate simulation model of the Snitch cluster from RTL sources using Verilator, QuestaSim, or VCS. Use when you need to compile hardware for simulation before running software.
---

# Build Hardware Skill

## Overview

This skill provides instructions for building a cycle-accurate simulation model of the Snitch cluster from RTL sources. The simulation model is required to run software on Snitch without a physical chip.

## Prerequisites

- One of the following simulators installed:
  - **Verilator** (open-source, recommended for containers)
  - **QuestaSim** (proprietary, requires license)
  - **VCS** (proprietary, requires license)

## Description

To build a simulation model of the Snitch cluster, run one of the following commands from the repository root:

### Verilator
```bash
make verilator
```
- Output: `target/sim/build/bin/snitch_cluster.vlt` executable
- Compiled sources: `target/sim/build/work-vlt`

### QuestaSim (Questa)
```bash
make DEBUG=ON vsim
```
- Output: `target/sim/build/bin/snitch_cluster.vsim` executable
- Compiled sources: `target/sim/build/work-vsim`
- **Important**: Always use `DEBUG=ON` flag to preserve visibility of all internal signals for waveform inspection

### VCS
```bash
make vcs
```
- Output: `target/sim/build/bin/snitch_cluster.vcs` executable
- Compiled sources: `target/sim/build/work-vcs`

## Build Artifacts

All build artifacts are located in `target/sim/build/`:

- **Simulator-specific compilations**:
  - `work-vlt/`: Verilator compilation
  - `work-vsim/`: QuestaSim compilation
  - `work-vcs/`: VCS compilation

- **Common C++ testbench sources**: `work/` (includes frontend server)

- **Executable scripts**: `bin/snitch_cluster.<simulator>` (vlt, vsim, or vcs)

Executables in `bin/` are ready to run software simulations.

## Configuration

By default, the hardware is built using the configuration from `cfg/default.json`.

### Using a Custom Configuration

To override the default configuration:

```bash
make CFG_OVERRIDE=cfg/omega.json vsim
```

All available configurations are contained in the `cfg/` folder.

### Configuration Persistence

When you specify `CFG_OVERRIDE` on the command line:
- The configuration is automatically stored in `cfg/lru.json`
- Successive `make` invocations automatically use `cfg/lru.json`
- You can omit `CFG_OVERRIDE` in subsequent builds unless you want to change the configuration

## Notes

- All paths are relative to the repository root
- Software built for simulation must use the same hardware configuration used for the simulation model

## Related Skills

- **build-sw**: Compile software binaries to run on the compiled hardware model
- **run-sim**: Run simulations with the built hardware and compiled software
