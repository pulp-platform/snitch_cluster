# Introduction

**SNAX** is an open-source platform with a hybrid-coupled heterogeneous accelerator-centric architecture. This system allows users to explore various architectural combinations of accelerators packed in a single shared memory. We provide useful setups, scripts, and supporting modules to make it easy to integrate new accelerators. The figure below shows an overview of the SNAX architecture:

![image](https://github.com/KULeuven-MICAS/snax_cluster/assets/26665295/9242dd65-be3a-4472-8ae5-e026992f6a95)

SNAX supports several design-time and run-time configurations to support different accelerators and corresponding data layouts. For example, some design-time configurations include: customizing the memory sizes, the interconnect structure connecting the accelerators to memory, the number of [Snitch](https://github.com/pulp-platform/snitch_cluster) cores controlling accelerators, and so much more. For run-time configuration, we provide data streamers and reshufflers to aid accelerators in handling data layout in memory and data access pattern management. 

# Outline

In this tutorial, we will explore how to attach your custom accelerator to the SNAX platform. The outline below guides any new user on a simple ALU accelerator example. Have fun!

1 - [Architectural Overview](./architectural_overview.md)

- In this section, we will describe the design goals for the example.
- There is also a guide on the configurations to change.
- We also describe the overview of the directory structure.

2 - [Accelerator Design](./accelerator_design.md)

- This section describes a simple ALU processing element that will serve as the accelerator of interest
- We focus on the data path design and control status registers (CSR) that go with it.
- We emphasize the need to comply with the CSR manager and streamer interfaces.

3 - [CSR Manager Design](./csrman_design.md)

- This section describes the features of our pre-built CSR manager.
- It helps in hiding set-up delays between accelerator runs by introducing a configuration preloading mechanism.

4 - [Streamer Design](./streamer_design.md)

- This section talks about our design- and run-time configurable streamer.
- Streamer helps streamline data accesses for an accelerator. It decouples the data access with the acceleration computation datapath and introduces a prefetch mechanism to boost the utilization of the accelerator

5 - [Building the System](./build_system.md)

- This guide shows how to build the architecture.

6 - [Programming your Core](./programming.md)

- We demonstrate how to program the accelerator of interest.
- We also show how to build the program and run simulations.

7 - [Other Tools](./other_tools.md)

- There exists tools that can help profile and analyze your design.

8 - [Other Designs](./more_designs.md)

- We've used our SNAX platform for various accelerators already.
- In this section, we demonstrate these accelerators and how we profiled them.
- We also show synthesized results of our work to see how the designs turn out.

# Getting Started

To follow along with the tutorial, we recommend to **create a GitHub Codespace**. Alternatively, you can also **clone the repository locally** and use our prebuilt docker container.

## Option 1: Github Codespace

!!! note

    It is recommended you open Codespace in Chrome.

Opening a Github Codespace is the most convenient way to get started quickly. To create a new codespace, go to the main repository, and follow code -> codespace -> create codespace. Or access this at [SNAX cluster codespace](https://codespaces.new/KULeuven-MICAS/snitch_cluster).

![image](https://github.com/KULeuven-MICAS/snax_cluster/assets/26665295/2831e951-84ec-4909-a3a1-e3eef816c56e)

This will launch a new window where the container image for the codespace will be built. This can take a couple of minutes but you only run this once. After this, a Visual Studio Code client will be launched in your browser. This system has all the requirements for developing, building, and simulating a SNAX Cluster preinstalled. If you prefer this, you can launch this codespace in the Visual Studio Code desktop client.

After initializing the Codespace, run the following command in VSCode's shell terminal to fetch all necessary sub modules:

```bash
git submodule update --init --recursive
```

## Option 2: Cloning the Repository Locally

First, let's clone the main repository. Do not forget to include the `--recurse-submodules`.

```bash
git clone https://github.com/KULeuven-MICAS/snax_cluster.git --recurse-submodules
```

If you have already cloned the repository without the `--recurse-submodules` flag, clone its submodules with:

```bash
git submodule update --init --recursive
```

### Docker Container

If you locally cloned the repository, we recommend using our pre-built docker container.

```bash
docker pull ghcr.io/kuleuven-micas/snax:main
```

Go to the root of the `snax_cluster` repository and mount the directory to the container:

```bash
docker run -it -v `pwd`:/repo -w /repo ghcr.io/kuleuven-micas/snax:main
```

This way the container sees the `snax_cluster` directory and you can run the pre-built packages and installed software.

## Installing Packages and Programs Locally

There are several required packages and programs in the container. If you insist on installing these yourself, then you may refer to the `Dockerfile` for guidance. You can find this at `./util/container/Dockerfile`.

## Check if The System Works!

To check if the system is working, let's do a quick run for building the HW and SW, then running the program.

1 - Build the HW:

```bash
make CFG_OVERRIDE=cfg/snax-alu.hjson bin/snitch_cluster.vlt -j
```

2 - Build the SW:

```bash
make CFG_OVERRIDE=cfg/snax-alu.hjson SELECT_RUNTIME=rtl-generic SELECT_TOOLCHAIN=llvm-generic sw -j
```

3 - Run the program:

```bash
bin/snitch_cluster.vlt sw/apps/snax-alu/build/snax-alu.elf
```

If it returns 0 errors, then you have the correct setup!
