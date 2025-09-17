![CI](https://github.com/pulp-platform/snitch_cluster/actions/workflows/ci.yml/badge.svg)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# Snitch Cluster

This repository hosts the hardware and software for the Snitch cluster and its generator. Snitch is a high-efficiency compute cluster platform focused on floating-point workloads. It is developed as part of the PULP project, a joint effort between ETH Zurich and the University of Bologna.

## Getting Started

To get started working with Snitch check out our [documentation pages](https://pulp-platform.github.io/snitch_cluster). The documentation is built from the latest commit on the main branch.

## Content

What can you expect to find in this repository?

- The RISC-V [Snitch integer core](https://pulp-platform.github.io/snitch_cluster/rm/snitch.html). This can be useful stand-alone if you are just interested in re-using the core for your project, e.g., as a tiny control core or you want to make a peripheral smart. The sky is the limit.
- The [Snitch cluster](https://pulp-platform.github.io/snitch_cluster/rm/snitch_cluster.html). A highly configurable cluster containing one to many integer cores with optional floating-point capabilities as well as our custom ISA extensions `Xssr`, `Xfrep`, and `Xdma`.
- A runtime and example applications for the Snitch cluster.
- RTL simulation environments for Verilator, Questa Advanced Simulator, and VCS, as well as configurations for the [GVSoC system simulator](https://github.com/gvsoc/gvsoc).

This code was previously hosted in the [Snitch monorepo](https://github.com/pulp-platform/snitch) and was spun off into its own repository to simplify maintenance and dependency handling. Note that our Snitch-based manycore system [Occamy](https://github.com/pulp-platform/occamy) has also moved.

## License

Snitch is being made available under permissive open source licenses.

The following files are released under Solderpad v0.51 (`SHL-0.51`) see `hw/LICENSE`:

- `hw/`

The `sw/deps` directory references submodules that come with their own
licenses. See the respective folder for the licenses used.

- `sw/deps/`

All other files are released under Apache License 2.0 (`Apache-2.0`) see `LICENSE`.

## Contributing

If you would like to contribute to this project, please check our [contribution guidelines](CONTRIBUTING.md).


## Publications

<!--start-publications-->

If you use the Snitch cluster or its extensions in your work, you can cite us:

<details>
<summary><b><a href="https://doi.org/10.1109/TC.2020.3027900">Snitch: A Tiny Pseudo Dual-Issue Processor for Area and Energy Efficient Execution of Floating-Point Intensive Workloads</a></a></b></summary>
<p>

```
@ARTICLE{zaruba2021snitch,
  author={Zaruba, Florian and Schuiki, Fabian and Hoefler, Torsten and Benini, Luca},
  journal={IEEE Transactions on Computers}, 
  title={Snitch: A Tiny Pseudo Dual-Issue Processor for Area and Energy Efficient Execution of Floating-Point Intensive Workloads}, 
  year={2021},
  volume={70},
  number={11},
  pages={1845-1860},
  doi={10.1109/TC.2020.3027900}
}
```

</p>
</details>

<details>
<summary><b><a href="https://doi.org/10.1109/TC.2020.2987314">Stream Semantic Registers: A Lightweight RISC-V ISA Extension Achieving Full Compute Utilization in Single-Issue Cores</a></b></summary>
<p>

```
@ARTICLE{schuiki2021ssr,
  author={Schuiki, Fabian and Zaruba, Florian and Hoefler, Torsten and Benini, Luca},
  journal={IEEE Transactions on Computers}, 
  title={Stream Semantic Registers: A Lightweight RISC-V ISA Extension Achieving Full Compute Utilization in Single-Issue Cores}, 
  year={2021},
  volume={70},
  number={2},
  pages={212-227},
  doi={10.1109/TC.2020.2987314}
}
```

</p>
</details>

<details>
<summary><b><a href="https://doi.org/10.1109/TPDS.2023.3322029">Sparse Stream Semantic Registers: A Lightweight ISA Extension Accelerating General Sparse Linear Algebra</a></b></summary>
<p>

```
@ARTICLE{scheffler2023sparsessr,
  author={Scheffler, Paul and Zaruba, Florian and Schuiki, Fabian and Hoefler, Torsten and Benini, Luca},
  journal={IEEE Transactions on Parallel and Distributed Systems}, 
  title={Sparse Stream Semantic Registers: A Lightweight ISA Extension Accelerating General Sparse Linear Algebra}, 
  year={2023},
  volume={34},
  number={12},
  pages={3147-3161},
  doi={10.1109/TPDS.2023.3322029}
}
```

</p>
</details>

<details>
<summary><b><a href="https://doi.org/10.1109/TC.2023.3329930">A High-Performance, Energy-Efficient Modular DMA Engine Architecture</a></b></summary>
<p>

```
@ARTICLE{benz2024idma,
  author={Benz, Thomas and Rogenmoser, Michael and Scheffler, Paul and Riedel, Samuel and Ottaviano, Alessandro and Kurth, Andreas and Hoefler, Torsten and Benini, Luca},
  journal={IEEE Transactions on Computers}, 
  title={A High-Performance, Energy-Efficient Modular DMA Engine Architecture}, 
  year={2024},
  volume={73},
  number={1},
  pages={263-277},
  doi={10.1109/TC.2023.3329930}
}
```

</p>
</details>

<details>
<summary><b><a href="https://doi.org/10.1109/ARITH54963.2022.00010">MiniFloat-NN and ExSdotp: An ISA Extension and a Modular Open Hardware Unit for Low-Precision Training on RISC-V Cores</a></b></summary>
<p>

```
@INPROCEEDINGS{bertaccini2022minifloat,
  author={Bertaccini, Luca and Paulin, Gianna and Fischer, Tim and Mach, Stefan and Benini, Luca},
  booktitle={2022 IEEE 29th Symposium on Computer Arithmetic (ARITH)}, 
  title={MiniFloat-NN and ExSdotp: An ISA Extension and a Modular Open Hardware Unit for Low-Precision Training on RISC-V Cores}, 
  year={2022},
  volume={},
  number={},
  pages={1-8},
  doi={10.1109/ARITH54963.2022.00010}
}
```

</p>
</details>

<details>
<summary><b><a href="https://doi.org/10.1109/ISVLSI54635.2022.00021">Soft Tiles: Capturing Physical Implementation Flexibility for Tightly-Coupled Parallel Processing Clusters</a></b></summary>
<p>

```
@INPROCEEDINGS{paulin2022softtiles,
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
</details>

<details>
<summary><b><a href="https://doi.org/10.1145/3649329.3658494">SARIS: Accelerating Stencil Computations on Energy-Efficient RISC-V Compute Clusters with Indirect Stream Registers</a></b></summary>
<p>

```
@INPROCEEDINGS{scheffler2024saris,
  author={Paul Scheffler and Luca Colagrande and Luca Benini},
  title={SARIS: Accelerating Stencil Computations on Energy-Efficient RISC-V Compute Clusters with Indirect Stream Registers},
  booktitle = {Proceedings of the 61st ACM/IEEE Design Automation Conference},
  year={2024},
  doi = {10.1145/3649329.3658494}
}
```

</p>
</details>

<details>
<summary><b><a href="https://arxiv.org/abs/2503.20590">Dual-Issue Execution of Mixed Integer and Floating-Point Workloads on Energy-Efficient In-Order RISC-V Cores</a></b></summary>
<p>

```
@misc{colagrande2025copift,
  title={Dual-Issue Execution of Mixed Integer and Floating-Point Workloads on Energy-Efficient In-Order RISC-V Cores},
  author={Luca Colagrande and Luca Benini},
  year={2025},
  eprint={2503.20590},
  archivePrefix={arXiv},
  primaryClass={cs.AR},
  url={https://arxiv.org/abs/2503.20590}
}
```

</p>
</details>

<details>
<summary><b><a href="https://arxiv.org/abs/2503.20609">Late Breaking Results: A RISC-V ISA Extension for Chaining in Scalar Processors</a></b></summary>
<p>

```
@misc{colagrande2025chaining,
  title={Late Breaking Results: A RISC-V ISA Extension for Chaining in Scalar Processors},
  author={Luca Colagrande and Jayanth Jonnalagadda and Luca Benini},
  year={2025},
  eprint={2503.20609},
  archivePrefix={arXiv},
  primaryClass={cs.AR},
  url={https://arxiv.org/abs/2503.20609}
}
```

</p>
</details>

<!--end-publications-->
