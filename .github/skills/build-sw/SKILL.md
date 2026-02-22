---
name: build-sw
description: Compile software for the Snitch cluster, including the runtime library and applications. Use when you need to build ELF binaries for simulation.
---

# Build Software Skill

## Overview

This skill provides instructions for compiling software for the Snitch cluster. The software stack depends on the hardware configuration, so the same configuration used to build the hardware must be used when building software.

## Description

### Building All Software Targets

To build all software targets defined in the repository (runtime library and all kernels):

```bash
make DEBUG=ON sw -j
```

**Parameters**:
- `DEBUG=ON`: Generates disassemblies and enables debugging symbols. This is required for trace annotation
- `-j`: Parallel build

### Building Specific Software Targets

To build a single software target (e.g., a kernel):

```bash
make DEBUG=ON <target_name> -j
```

**Example**:
```bash
make DEBUG=ON axpy -j
```

**Note**: All software targets have unique names distinct from any other Make target, and every kernel can be individually built using the kernel name as a target.

## Build Artifacts

Build artifacts are stored in the build directory of each kernel:

- **Location**: `<kernel_folder>/build/`
- **Compiled executable**: `<kernel_name>.elf`
- **Disassembly**: `<kernel_name>.dump` (generated with `DEBUG=ON`)

**Example** (AXPY application):
```
sw/kernels/blas/axpy/build/
├── axpy.elf        # Compiled executable
├── axpy.dump       # Disassembly (with DEBUG=ON)
└── [other artifacts]
```

## Configuration Management

### Critical Requirement

**The software stack depends on the hardware configuration file.** Make sure you always build the software with the same configuration of the hardware you are going to run it on.

### Configuration Tracking

The hardware configuration is automatically tracked:
- When you override the configuration during hardware build, it's stored in `cfg/lru.json`
- Successive Make invocations automatically pick up `cfg/lru.json`
- Ensure software is built after hardware with the same configuration

## Important Notes

- Software must match the hardware configuration - always build them together
- The `DEBUG=ON` flag is essential for trace annotation

## Related Skills

- **build-hw**: Build the hardware simulation binary before building software
- **run-sim**: Execute the compiled software binaries on the built hardware
