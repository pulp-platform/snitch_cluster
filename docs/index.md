# Snitch Cluster
The Snitch project is an open-source RISC-V hardware research project of ETH Zurich and University of Bologna targeting highest possible energy-efficiency. The system is designed around a versatile and small integer core, which we call Snitch. The system is ought to be highly parameterizable and suitable for many use-cases, ranging from small, control-only cores, to large many-core system made for pure number crunching in the HPC domain. The figure below shows a simplified overview of the Snitch cluster.

![Snitch Cluster](https://drive.google.com/uc?id=1SGog8sbGcCkSuyD_X2uLteuqpqYAhJKS)

!!! note "This is the SNAX repo"

    You are looking at the KULeuven fork of Snitch Cluster developed by the PULP group. This fork, called SNAX, provides extra infrastructure for quickly adding tightly coupled  accelerators to a systems on a Snitch Cluster Level.

# SNitch Acceleration eXtension (SNAX)
SNitch Acceleration eXtension (SNAX) is an extension of the Snitch platform that provides the basic needs of an accelerator in a multi-core system. SNAX allows multi-core accelerators at the cluster level.

* Users can control their accelerator with RISCV control status register (CSR) instructions.
* These accelerators can access a direct memory with high flexibility and bandwidth through the tightly-coupled data memory (TCDM).
* The platform is a complete hw-sw test environment where users can also profile the performance immediately.

The figure below shows a simplified overview of the SNAX cluster. 

![SNAX Cluster](https://drive.google.com/uc?id=1PqMhcxbqWnJdn-EawCfGetc0CbqfFCK_)


## Getting Started

See our dedicated [getting started guide](ug/getting_started.md).

## Documentation

The documentation is built from the latest master and hosted at github pages: [https://github.com/KULeuven-MICAS/snitch_cluster](https://github.com/KULeuven-MICAS/snitch_cluster).

## About this Repository

* This SNAX repository is maintained by KULeuven but it consists of several IPs originating from the PULP Snitch cluster.
* The original repository [https://github.com/pulp-platform/snitch](https://github.com/pulp-platform/snitch) was developed as a monorepo where external dependencies are "vendored-in" and checked in. For easier integration into heterogeneous systems with other PULP Platform IPs, the original repo was archived.
* The Snitch cluster repository [https://github.com/pulp-platform/snitch_cluster](https://github.com/pulp-platform/snitch_cluster) handles depenencies with [Bender](https://github.com/pulp-platform/bender) and has a couple of repositories as submodules.
* The Occamy System part of the original repository is being moved to its own repository [https://github.com/pulp-platform/occamy](https://github.com/pulp-platform/occamy). 


## Licensing

Snitch is being made available under permissive open source licenses. See the `README.md` for a more detailed break-down.
