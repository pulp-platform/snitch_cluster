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

These are the three major steps that you will see in going through this tutorial. We emphasize that these make it easy for someone new to integrate there accelerator into the system. To give the users a perspective on what they need to work on, we only need the following:

1 - Build your accelerator shell to comply with the control and data interfaces.

- All other connections are provided to you through a wrapper generator we provide to the users. The user only needs to focus on connecting the appropriate signals only.

2 - Set the system configuration file to the desired customizations.

- Later, there is a configuration file that encompasses all system customizations. This includes the size of the memory, the link for the accelerator to the interconnect, the configurations for the CSR manager and streamer, and so on.
- A CSR manager is available to handle the control from the Snitch cores and dispatching the configuration registers to the accelerator. The accelerator needs to get the set registers through a decoupled interface. More details are in [CSR Manager Design](./csrman_design.md)
- A streamer is available for providing reconfigurable and flexible data access from the L1 TCDM to the accelerator. The accelerator needs to comply with the decoupled data interfaces. More details are in [Streamer Design](./streamer_design.md).

3 - Making the software code and runnning the program.

- After building the system, we can immediatley test and profile your work through a C-code program. We write CSR functions to configure the accelerator.


# General Directory Structure

It is nice to familiarize yourself with the directory structure of the platform. There are several files and hooks but the important directories are described in the tree below:

{%
   include-markdown '../ug/directory_structure.md'
   start="# Directory Structure"
   end="## Hardware `hw` Directory"
   comments=false
%}

We will revisit these things later on but first let's explore and understand the first step: **Building your Accelerator**.
