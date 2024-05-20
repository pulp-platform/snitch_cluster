# SARIS Stencil Kernels

This directory contains the baseline- and SSSR-accelerated Snitch cluster stencil kernels used in the evaluation section of the paper _"SARIS: Accelerating Stencil Computations on Energy-Efficient RISC-V Compute Clusters with Indirect Stream Registers"_. In our paper, we describe how indirect stream register architectures such as SSSRs can significantly accelerate stencil codes.

If you use our code or compare against our work, please cite us:

```
@misc{scheffler2024saris,
      title={SARIS: Accelerating Stencil Computations on Energy-Efficient
             RISC-V Compute Clusters with Indirect Stream Registers},
      author={Paul Scheffler and Luca Colagrande and Luca Benini},
      year={2024},
      eprint={2404.05303},
      archivePrefix={arXiv},
      primaryClass={cs.MS}
}
```

> [!IMPORTANT]
> - Unlike other software in this repository, compiling this code requires a **custom version of the LLVM 15 toolchain** with some extensions and improvements. The source code for this LLVM fork can be found [here](https://github.com/pulp-platform/llvm-project/tree/15.0.0-saris-0.1.0).
> - The generated example programs are only intended to be used **in RTL simulation of a default, SSSR-extended cluster**, using the cluster configuration `cfg/default.hjson`.

## Directory Structure

* `stencils/`: Baseline (`istc.par.hpp`) and SARIS-accelerated (`istc.issr.hpp`) stencil codes.
* `runtime/`: Additional runtime code and linking configuration needed for compilation.
* `util/`: Evaluation program generator supporting different grid sizes and kernel calls.
* `eval.json`: Configuration for test program generator.

## Compile Evaluation Programs

Before you can compile test problems, you need the [SARIS LLVM 15 toolchain](https://github.com/pulp-platform/llvm-project/tree/15.0.0-saris-0.1.0) along with `newlib` and `compiler-rt`. The required build steps are outlined [here](https://github.com/pulp-platform/llvm-toolchain-cd/blob/main/README.md).

Then, you can build the test programs specified in `eval.json` by running:

```
make LLVM_BINROOT=<llvm_install_path>/bin all
```

By default, `eval.json` specifies RV32G and SSSR-accelerated test programs for all included stencils as specified in our paper. Binaries are generated in `bin/` and disassembled program dumps in `dump/`.


## Run Evaluation Programs

Evaluation programs can only be run in RTL simulation of a Snitch cluster using the default, SSSR-enhanced configuration `cfg/default.json`. For example, when building a QuestaSim RTL simulation setup from `target/snitch_cluster`:

```
make CFG_OVERRIDE=cfg/default.hjson bin/snitch_cluster.vsim
```

Then, the built evaluation programs can be run on this simulation setup as usual, for example:

```
bin/snitch_cluster.vsim ../../sw/saris/bin/istc.pb_jacobi_2d_ml_issr.elf
```

Performance metrics can be analyzed using the annotating Snitch tracer (`make traces`). In the default evaluation programs, the section of interest is section 2.
