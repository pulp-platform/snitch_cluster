# Snitch

The Snitch project is an open-source RISC-V hardware research project of ETH Zurich and University of Bologna targeting highest possible energy-efficiency. The system is designed around a versatile and small integer core, which we call Snitch. The system is ought to be highly parameterizable and suitable for many use-cases, ranging from small, control-only cores, to large many-core system made for pure number crunching in the HPC domain.

## Getting Started

To get started working with Snitch go through the [User guide](ug/getting_started.md).

For more information on the Snitch hardware and software, you can consult the "Reference Manual" pages.

## About this Repository

The original repository [https://github.com/pulp-platform/snitch](https://github.com/pulp-platform/snitch) was developed as a monorepo where external dependencies are "vendored-in" and checked in. For easier integration into heterogeneous systems with other PULP Platform IPs, the original repo was archived. This new repository [https://github.com/pulp-platform/snitch_cluster](https://github.com/pulp-platform/snitch_cluster) handles depenencies with [Bender](https://github.com/pulp-platform/bender) and has a couple of repositories as submodules.
The Occamy System part of the original repository is being moved to its own repository [https://github.com/pulp-platform/occamy](https://github.com/pulp-platform/occamy).


## Licensing

Snitch is being made available under permissive open source licenses. See the `README.md` for a more detailed break-down.
