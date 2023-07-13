![CI](https://github.com/pulp-platform/snitch_cluster/actions/workflows/ci.yml/badge.svg)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# Snitch Cluster

This repository hosts the hardware and software for the Snitch cluster and its generator. Snitch is a high-efficiency compute cluster platform focused on floating-point workloads. It is developed as part of the PULP project, a joint effort between ETH Zurich and the University of Bologna.

## Getting Started

To get started, check out the [getting started guide](https://pulp-platform.github.io/snitch_cluster/ug/getting_started.html).

## Content

What can you expect to find in this repository?

- The RISC-V [Snitch integer core](https://pulp-platform.github.io/snitch_cluster/rm/snitch.html). This can be useful stand-alone if you are just interested in re-using the core for your project, e.g., as a tiny control core or you want to make a peripheral smart. The sky is the limit.
- The [Snitch cluster](https://pulp-platform.github.io/snitch_cluster/rm/snitch_cluster.html). A highly configurable cluster containing one to many integer cores with optional floating-point capabilities as well as our custom ISA extensions `Xssr`, `Xfrep`, and `Xdma`.
- A runtime and example applications for the Snitch cluster.
- RTL simulation environments for Verilator, Questa Advanced Simulator, and VCS, as well as configurations for our [Banshee system simulator](https://github.com/pulp-platform/banshee)

This code was previously hosted in the [Snitch monorepo](https://github.com/pulp-platform/snitch) and was spun off into its own repository to simplify maintenance and dependency handling. Note that our Snitch-based manycore system [Occamy](https://github.com/pulp-platform/occamy) has also moved.

## Tool Requirements

* `verilator >= v4.1`
* `bender >= v0.27.0`

## License

Snitch is being made available under permissive open source licenses.

The following files are released under Apache License 2.0 (`Apache-2.0`) see `LICENSE`:

- `sw/`
- `util/`

The following files are released under Solderpad v0.51 (`SHL-0.51`) see `hw/LICENSE`:

- `hw/`

The `sw/deps` directory references submodules that come with their own
licenses. See the respective folder for the licenses used.

- `sw/deps/`

## Publications


If you use the Snitch cluster or its extensions in your work, you can cite us:

<details>
<summary><b>Snitch: A tiny Pseudo Dual-Issue Processor for Area and Energy Efficient Execution of Floating-Point Intensive Workloads</b></summary>
<p>

```
@article{zaruba2020snitch,
  title={Snitch: A tiny Pseudo Dual-Issue Processor for Area and Energy Efficient Execution of Floating-Point Intensive Workloads},
  author={Zaruba, Florian and Schuiki, Fabian and Hoefler, Torsten and Benini, Luca},
  journal={IEEE Transactions on Computers},
  year={2020},
  publisher={IEEE}
}
```

</p>
</details>

<details>
<summary><b>Stream semantic registers: A lightweight risc-v isa extension achieving full compute utilization in single-issue cores</b></summary>
<p>

```
@article{schuiki2020stream,
  title={Stream semantic registers: A lightweight risc-v isa extension achieving full compute utilization in single-issue cores},
  author={Schuiki, Fabian and Zaruba, Florian and Hoefler, Torsten and Benini, Luca},
  journal={IEEE Transactions on Computers},
  volume={70},
  number={2},
  pages={212--227},
  year={2020},
  publisher={IEEE}
}
```

</p>
</details>

<details>
<summary><b>Indirection Stream Semantic Register Architecture for Efficient Sparse-Dense Linear Algebra</b></summary>
<p>

```
@inproceedings{scheffler2021indirect,
  author={Scheffler, Paul and Zaruba, Florian and Schuiki, Fabian and Hoefler, Torsten and Benini, Luca},
  booktitle={2021 Design, Automation & Test in Europe Conference & Exhibition (DATE)},
  title={Indirection Stream Semantic Register Architecture for Efficient Sparse-Dense Linear Algebra},
  year={2021},
  volume={},
  number={},
  pages={1787-1792}
}
```

</p>
</details>

<details>
<summary><b>MiniFloat-NN and ExSdotp: An ISA Extension and a Modular Open Hardware Unit for Low-Precision Training on RISC-V Cores</b></summary>
<p>

```
@inproceedings{bertaccini2022minifloat,
  author={Bertaccini, Luca and Paulin, Gianna and Fischer, Tim and Mach, Stefan and Benini, Luca},
  booktitle={2022 IEEE 29th Symposium on Computer Arithmetic (ARITH)},
  title={MiniFloat-NN and ExSdotp: An ISA Extension and a Modular Open Hardware Unit for Low-Precision Training on RISC-V Cores},
  year={2022},
  volume={},
  number={},
  pages={1-8}
}
```

</p>
</details>

<details>
<summary><b>Soft Tiles: Capturing Physical Implementation Flexibility for Tightly-Coupled Parallel Processing Clusters</b></summary>
<p>

```
@inproceedings{paulin2022softtiles,
  author={Paulin, Gianna and Cavalcante, Matheus and Scheffler, Paul and Bertaccini, Luca and Zhang, Yichao and Gürkaynak, Frank and Benini, Luca},
  booktitle={2022 IEEE Computer Society Annual Symposium on VLSI (ISVLSI)},
  title={Soft Tiles: Capturing Physical Implementation Flexibility for Tightly-Coupled Parallel Processing Clusters},
  year={2022},
  volume={},
  number={},
  pages={44-49},
  doi={10.1109/ISVLSI54635.2022.00021}
}
```

</p>
