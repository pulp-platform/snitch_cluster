# Introduction

**SNAX** is an open-source platform with a hybrid-coupled heterogeneous accelerator-centric architecture. This system allows users to explore various architectural combinations of accelerators packed in a single shared memory. We provide useful setups, scripts, and supporting modules to make it easy to integrate new accelerators. The figure below shows an overview of the SNAX architecture:

![image](https://github.com/KULeuven-MICAS/snitch_cluster/assets/26665295/a00b8e87-48db-422d-b673-cfdd43dc6782)


SNAX supports several design-time and run-time configurations to support different accelerators. For example, some design-time configurations include: customizing the memory sizes, the interconnect structure connecting the accelerators to memory, the number of [Snitch](https://github.com/pulp-platform/snitch_cluster) cores controlling accelerators, and so much more. For run-time configuration, we provide data streamers and reshufflers to aid accelerators in handling memory-layout and data access pattern management. 

# Outline

In this tutorial, we will explore how to attach your own custom accelerator to the SNAX platform. The outline below guides any new user on a simple ALU accelerator example. Have fun!

1 - [Architectural Overview](./architectural_overview.md)
- In this section, we will describe the design goals for the example.
- There is also a guide on the configurations to change.
- We also describe the overview of the directory structure.

2 - [Accelerator Design](./accelerator_design.md)
- This section describes a simple ALU processing element that will serve as the accelerator of interest - We focus only on the data path design and control status registers (CSR) that go along with it.

3 - [CSR Manager Design](./csrman_design.md)
- This section describes the features of our pre-built CSR manager feature - It helps in hiding set-up delays in between accelerator runs.

4 - [Streamer Design](./streamer_design.md)
- This section guides you on how to generate the streamer which accesses data from the memory for your accelerator.
- It also contains an overview of the configuration file on how to modify the target streamer.

5 - [Building the Architecture](./build_system.md)
- This guide shows how to build the architecture.

6 - [Programming your Core](./programming.md)
- We demonstrate here how to program the accelerator of interest.
- We also show how to build the program and run simulations.

7 - [Other Tools](./other_tools.md)
- There exists tools that can help profile and analyze your design.

8 - [Other Designs](./more_designs.md)
- We've used our SNAX platform for various accelerators already - In this section, we demonstrate these accelerators and how we profiled them.
- We also show synthesized results of our work to see how the designs turn out.

# Getting Started

To follow along with the tutorial, we recommend to create a GitHub Codespace. Alternatively, you can clone the repository locally and use our prebuilt docker container or install the requirements locally yourself.

## Github Codespace

Opening a Github Codespace is the most convenient way to get started quickly. To create a new codespace, go to the main repository, and follow code -> codespace -> create codespace. Or access this at [SNAX cluster codespace](https://codespaces.new/KULeuven-MICAS/snitch_cluster).

![image](https://github.com/KULeuven-MICAS/snitch_cluster/assets/47864363/27f3c084-ba26-4653-ad68-d9e898ca0597)

This will launch a new window where the container image for the codespace will be built. This can take a couple of minutes, but is only required to run once. After this, a Visual Studio Code client will be launched in your browser. This system has all the requirements for developing, building and simulating a SNAX Cluster preinstalled. If you prefer this, you can also launch this codespace in the Visual Studio Code desktop client.

## Cloning the Repository Locally

First let's clone the main repository. Do not forget to include the `--recurse-submodules`.

```bash
git clone https://github.com/KULeuven-MICAS/snitch_cluster.git --recurse-submodules
```

If you had already cloned the repository without the `--recurse-submodules` flag, clone its submodules with:

```bash
git submodule init --recursive
```

## Docker Container

For this tutorial, we recommend that you use our pre-built docker container.

```bash
docker pull ghcr.io/kuleuven-micas/snax:main
```

Go to the root of the `snax_cluster` repository and mount the directory unto the container:

```bash
docker run -it -v `pwd`:/repo -w /repo ghcr.io/kuleuven-micas/snax:main
```

This way the container sees the `snax_cluster` directory and you can run the pre-built packages and installed sotfware.
