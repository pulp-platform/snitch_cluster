# Architectural Overview

In this tutorial, we will build a simple SNAX system supporting one simple ALU accelerator. The figure below shows the target architecture we will build:

![image](https://github.com/KULeuven-MICAS/snitch_cluster/assets/26665295/458fa1b4-0b56-4913-9798-353c7dad803a)

We annotate some notable characteristics:

(1) - It has a memory that is 128kB large, with 32 banks where each bank has 64 bits of data width. We call this memory the **tighly coupled data memory (TCDM)**.

(2) - There is a complex TCDM interconnect that handles data transfers from Snitch CPU cores, accelerator core, the DMA and an AXI port to the entire TCDM memory. It can suppport both 64-bit and 512-bit transfers.

(3) - There exists Snitch CPU cores that control the accelerator. The Snitch is a light-weight RV32I core for dispatching commands to the accelerator. 

(4) - **Any accelerator sits on a shell marked by the yellow highlight**. This shell provides control and data interfaces to the accelerator (SNAX ALU). The SNAX shell consists of a control and status register (CSR) manager and a data streamer.

(5) - The **control and status register (CSR) manager** handles CSR requests from a CPU core to the accelerator.

(6) - The **data streamers** provide flexible data access for the accelerators. These design and run time flexible streamers help in streamlining data delivery to the accelerator and vice versa.

(7) - There is a DMA to transfer data from the outside memory into the local TCDM. A dedicated Snitch core is given to a DMA to allow parallel operations. The programmer has full control of this DMA.

(8) - There are shared instruction caches for the CPU cores.

(9) - AXI narrow and wide interconnects for data transactions towards the outside of the SNAX cluster.

As we go through the tutorial, you will see that several of these components are design-time configurable. A user only needs to modify a configuration file to get these components in place.

Any user, with their own custom accelerator, connects their design within the broken lines of the SNAX shell. They need to comply with the control interface coming from a CSR manager and a streamer interface for accessing data from memory.

# What Do You Need to Build This System?

These are major steps that you will see in going through this tutorial. We emphasize that these make it easy for someone new to integrate there accelerator into the system. To give the users a perspective on what they need to work on, we only need the following:

## Building Your Accelerator Shell

**The first step is to build your accelerator shell to comply with the control and data interfaces**. The [Accelerator Design](./accelerator_design.md) section provides you with a discussion about our example SNAX ALU and the required interfaces. The user needs to focus on making a shell that connects the appropriate signals for the control and data ports. This is probably the most-challenging part already: *getting the connections right*.

## Configuring the SNAX CSR Manager

A CSR manager is available to handle the control from the Snitch cores and dispatching the configuration registers to the accelerator. The accelerator needs to get the set of configured registers through a decoupled interface. More details are in [CSR Manager Design](./csrman_design.md)

## Configuring the SNAX Streamer

A streamer is available for providing reconfigurable and flexible data access from the L1 TCDM to the accelerator. The accelerator needs to comply with the decoupled data interfaces. More details are in [Streamer Design](./streamer_design.md).

## Building Your System

Building your system is fully-automated by the scripts and makefiles in this platform. The only input that this system needs is a configuration `.hjson` file. In the directory `./target/snitch_cluster/cfg/` you will find several configurations describing different systems. 

The `snax-alu.hjson` file contains the configurations we have for the SNAX ALU system (refer to figure above). This configuration file several system customizations. It includes the size of the memory, the connection for the accelerators to the TCDM interconnect, the configurations for the CSR manager and streamer, and so on.

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

Parameters like the `tcdm` configurations indicate the TCDM memory `size` in kB and the number of memory `banks`. These settings automatically adjust the system. You can find more details in the [Hardware Schema](https://github.com/KULeuven-MICAS/snax_cluster/blob/main/docs/schema/snitch_cluster.schema.json) section. 

{%
   include-markdown './accelerator_design.md'
   start="# Adding Your Accelerator to the Configuration File"
   comments=false
%}

As long as you configure your system accordingly, then the entire build process can be excuted with a single `make` command. More details are in the [Building the System](./build_system.md) section.

## Programming Your System

After building the system, we can immediatley test and profile your work through a C-code program. We write the configuration to the CSRs using read and write commands to configure the accelerator. We provide a detailed tutorial in [Programming Your Design](./programming.md). We also provide some useful tools for debugging and profiling your design in [Other Tools](./other_tools.md).

# General Directory Structure

It is nice to familiarize yourself with the directory structure of the platform. There are several files and hooks but the important directories are described in the tree below:

{%
   include-markdown '../ug/directory_structure.md'
   start="# Directory Structure"
   end="## Hardware `hw` Directory"
   comments=false
%}

We will revisit these things later on but first let's explore and understand the first step: [Building the System](./build_system.md).

# Some Exercises!

<details>
  <summary> What do you think does the configuration `snax_tcdm_ports` do? Where can I find the actual definition? </summary>
  It specifies how many TCDM ports it needs to connect to. You can find it in schema-doc/snitch_cluster.md!
</details>

<details>
  <summary> In which directory would I find the IP of the `snax_alu` accelerator? </summary>
  Go to `./hw/snax_alu/src/.`
</details>

<details>
  <summary> How many major steps does it take to build the entire HW to SW stack? </summary>
  5 easy steps!

  1. Build your accelerator shell.
  2. Configure the CSR manager.
  3. Configure the streamer.
  4. Build your architecture.
  5. Program it!
</details>

