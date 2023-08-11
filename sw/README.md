# Snitch Software

This subdirectory contains the various bits and pieces of software for the Snitch ecosystem.

## Contents

### Libraries

- `applications`: Contains applications and kernels, mostly NN-related with SW testbenches for performance profiling.
- `cmake`: Bits and pieces for integration with the CMake build system.
- `snRuntime`: The fundamental, bare-metal runtime for Snitch systems. Exposes a minimal API to manage execution of code across the available cores and clusters, query information about a thread's context, and to coordinate and exchange data with other threads. Hardware configuration dependent implementations of the `snRuntime` can be found, e.g., under `target/snitch_cluster/sw/snRuntime`.
- `snBLAS`: A minimal reference implementation of the basic linear algebra subprograms that demonstrates the use of Snitch and its extensions.

#### math

The math sources are taken from the musl library, patched with our own modifications. The bender vendor snippet in `Bender.yml` was used to copy in the original sources. Patches were generated using the following command (from the root of the repo):
```
git format-patch --relative -o sw/deps/patches/musl/ HEAD^1
```
And can be applied by running (in the root of the repo):
```
git apply sw/deps/patches/musl/0001-musl-Patch-to-build-math-library-for-Snitch.patch
```

The `all` target in `sw/math/Makefile` should be run to generate some files.

### Tests

- `benchmark`: Benchmarking executables that evaluate the performance characteristics of a system.
- `test`: Unit tests for various aspects of a system, including the instruction set extensions. These complement the library-specific unit tests that live within the library directories proper.

### Third-Party

The `deps` directory contains third-party tools that we inline into this repository for ease of use.

- `deps/riscv-opcodes`: Utilities to manage instruction encodings and generate functions and data structurse for parsing and representation in various languages.
- `deps/printf`: A printf / sprintf implementation for embedded systems.
