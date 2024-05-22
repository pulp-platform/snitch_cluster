![CI](https://github.com/pulp-platform/snitch_cluster/actions/workflows/ci.yml/badge.svg)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# SNAX Cluster

This repository hosts the hardware and software for the SNAX cluster and its generator. SNAX is a high-efficiency compute cluster platform designed for computation- and data- intensive artificial intelligence workloads. It provides a standard SNAX shell for conveniently integrating versatile accelerators. The SNAX shell leverages CSR manager for programming the accelerators in the control plane and data streamers for data access in the data plane.

The figure below shows an architectural overview of the SNAX cluster.

![image](https://github.com/KULeuven-MICAS/snax_cluster/assets/26665295/9242dd65-be3a-4472-8ae5-e026992f6a95)

SNAX supports several design-time and run-time configurations to support a variety of accelerators. For example, some design-time configurations include customizing the memory sizes, the interconnect structure connecting the accelerators to memory, the number of Snitch cores controlling accelerators, and so much more. For run-time configurations, we provide data streamers and reshufflers to aid accelerators in organizing data layouts in memory and managing data access patterns.

## Getting Started

To get started, check out the [getting started guide](https://kuleuven-micas.github.io/snax_cluster/ug/getting_started.html).

We provide a [detailed tutorial](https://kuleuven-micas.github.io/snax_cluster/tutorial/introduction.html) on integrating an accelerator into the SNAX cluster platform. 

## Content

What can you expect to find in this repository?

- The RISC-V [Snitch integer core](https://pulp-platform.github.io/snitch_cluster/rm/snitch.html). This can be useful stand-alone if you are just interested in re-using the core for your project, e.g., as a tiny control core or you want to make a peripheral smart. The sky is the limit.
- The [SNAX cluster](https://kuleuven-micas.github.io/snax_cluster/tutorial/architectural_overview.html). A highly configurable cluster provides a standard and clean accelerator integration interface.

- A [CSR Manager](https://kuleuven-micas.github.io/snax_cluster/tutorial/csrman_design.html) is included to support a standardized control and management of registers through CSR instructions.
  
- The [Data Streamer](https://kuleuven-micas.github.io/snax_cluster/tutorial/streamer_design.html) streamlines the data access patterns for the accelerator.
- Versatile accelerator examples, including a [Chisel-based GEMM accelerator generator](https://github.com/KULeuven-MICAS/snax-gemm), a [rescale SIMD accelerator generator](https://github.com/KULeuven-MICAS/snax-postprocessing-simd), and a [Data Reshuffler]() for data layout transformation, are provided for reference.
- Software example applications for the SNAX cluster and corresponding accelerators.
- RTL simulation environments for Verilator, Questa Advanced Simulator, and VCS.

## Directory Structure

The project is organized as a monolithic repository. Both hardware and software are co-located. Standalone accelerators can have their own repositories and can be imported here using [Bender](https://github.com/pulp-platform/bender).

The file tree is visualized as follows:

```
├── hw
│   ├── chisel
│   │   ├── csr_manager
│   │   └── streamer
│   ├── snax_accelerator_1
│   ├── snax_accelerator_2
│   ├── snitch_stuff
│   └── templates
├── sw
├── target
│   └── snitch_cluster
│       ├── config
│       ├── generated
│       └── sw
│           ├── apps
│           │   ├── snax_system_1
│           │   └── snax_system_2
│           └── snax_lib 
│               ├── snax_system_1
│               └── snax_system_2
└── util
    ├── clustergen
    └── wrappergen
```

The top-level is structured as follows:

* `docs`: [Documentation](documentation.md) of the generator and software.
  Contains additional user guides.
* `hw`: All hardware IP components. The source files are either specified by SystemVerilog, Chisel, or a template to generate these files.
* `sw`: Hardware independent software, libraries, runtimes, etc.
* `target`: Contains the testbench setup, cluster configuration specific hardware and software, libraries, runtimes, etc.
* `util`: Utility and helper scripts.

# Acknowledgement

SNAX is an extension of the original [Snitch Cluster](https://github.com/pulp-platform/snitch_cluster) framework. SNAX got its name as "SNitch Acceleration eXtension".
