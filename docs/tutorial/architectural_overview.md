# Architectural Overview

In this tutorial, we will build a simple SNAX system supporting one simple ALU accelerator. The figure below shows the target architecture we will build in this tutorial:

![image](https://github.com/KULeuven-MICAS/snitch_cluster/assets/26665295/458fa1b4-0b56-4913-9798-353c7dad803a)

Notable characteristics are numbered:

1 - It has a memory that is 128kB large, with 32 banks where each bank has 64 bits of data width. We call this memory the tighly coupled data memory (TCDM).

2 - There is a complex TCDM interconnect that handles data transfers from Snitch CPU cores, accelerator core, the DMA and an AXI port.

3 - There exists Snitch CPU cores that control the accelerator. The Snitch is a light-weight RV32I core for minimal management and dispatching commands to the accelerator. A separate CPU core is given to the DMA to allow parallel operations.

4 - **Any accelerator sits in a shell marked by the yellow highlight**. This shell provides control and data interfaces to the accelerator (SNAX ALU). The SNAX shell consists of a control and status register (CSR) manager and a data streamer.

5 - The control and status register (CSR) manager handles CSR requests from a CPU core to the accelerator.

6 - The data streamers provide flexible data access for the accelerators. These design and run time flexible streamers are provided as support for managing data that gets into the ALU.

7 - There is a DMA to transfer data from the outside memory into the local TCDM. The programmer has full control of this DMA.

8 - There are shared instruction caches for the CPU cores.

9 - AXI narrow and wide interconnects for data transactions to wards the outside of the SNAX cluster.

As we go through the tutorial, you will see that several of these components are design-time configurable. A user can add their own custom accelerator within the broken lines of the SNAX shell. They only need to comply with the control interface coming from a CSR manager and a streamer interface for accessing data from memory.


# What Do You Need to Build This System?

These are major steps that you will see in going through this tutorial. We emphasize that these make it easy for someone new to integrate there accelerator into the system. To give the users a perspective on what they need to work on, we only need the following:

## Building Your Accelerator Shell

The first step is to build your accelerator shell to comply with the control and data interfaces. The [Accelerator Design](./accelerator_design.md) section provides you with a discussion about our example SNAX ALU and the required interfaces. The user only needs to focus on making a shell that connects the appropriate signals for the control and data ports.

## Configuring the System and Accelerators

In the directory `./target/snitch_cluster/cfg/` you will find several configurations describing different systems. The `snax-alu.hjson` file contains the configurations we have for the SNAX ALU system (refer to figure above). This configuration file several system customizations. It includes the size of the memory, the connection for the accelerators to the TCDM interconnect, the configurations for the CSR manager and streamer, and so on.

For example, you would find the cluster or system configuration at the first part:

```hjson
cluster: {
   boot_addr: 4096, // 0x1000
   cluster_base_addr: 268435456, // 0x1000_0000
   cluster_base_offset: 0,
   cluster_base_hartid: 0,
   addr_width: 48,
   data_width: 64,
   tcdm: {
      size: 128,
      banks: 32,
   },
   // Other things below
```

Parameters like the `tcdm` configurations indicate the `size` in kB and the number of memory banks. These settings automatically adjust the system. You can find more details in the [Hardware Schema](schema-doc/snitch_cluster.md) section. 

{%
   include-markdown './accelerator_design.md'
   start="# Adding Your Accelerator to the Configuration File"
   comments=false
%}

## Configuring the SNAX CSR Manager

A CSR manager is available to handle the control from the Snitch cores and dispatching the configuration registers to the accelerator. The accelerator needs to get the set registers through a decoupled interface. More details are in [CSR Manager Design](./csrman_design.md)

## Configuring the SNAX Streamer

A streamer is available for providing reconfigurable and flexible data access from the L1 TCDM to the accelerator. The accelerator needs to comply with the decoupled data interfaces. More details are in [Streamer Design](./streamer_design.md).

## Building Your System

Building your system is fully-automated by the scripts and makefiles in this platform. As long as you configure your system accordingly, then the entire build process can be excuted with a single `make` command. More details are in the [Building the Architecture](./build_system.md) section.

## Programming Your System

After building the system, we can immediatley test and profile your work through a C-code program. We write CSR functions to configure the accelerator. We provide a detail tutorial in [Programming Your Design](./programming.md).

# General Directory Structure

It is nice to familiarize yourself with the directory structure of the platform. There are several files and hooks but the important directories are described in the tree below:

{%
   include-markdown '../ug/directory_structure.md'
   start="# Directory Structure"
   end="## Hardware `hw` Directory"
   comments=false
%}

We will revisit these things later on but first let's explore and understand the first step: **Building your Accelerator**.
