# Directory Structure

The project is organized as a monolithic repository. Both hardware and software
are co-located. 

The file tree is visualized as follows:

```
├── hw
│   ├── chisel
│   │   ├── csr_manager
│   │   └── streamer
│   ├── snax_accelerator_1
│   ├── snax_accelerator_2
│   ├── snitch_stuff
│   └── templates
├── sw
├── target
│   └── snitch_cluster
│       ├── config
│       ├── generated
│       └── sw
│           ├── apps
│           │   ├── snax_system_1
│           │   └── snax_system_2
│           └── snax_lib 
│               ├── snax_system_1
│               └── snax_system_2
└── util
    ├── clustergen
    └── wrappergen
```

The top-level is structured as follows:

* `docs`: [Documentation](documentation.md) of the generator and software.
  Contains additional user guides.
* `hw`: All hardware IP components. The source files are either specified by SystemVerilog, Chisel, or a template to generate these files.
* `sw`: Hardware independent software, libraries, runtimes etc.
* `target`: Contains the testbench setup, cluster configuration specific hardware and software, libraries, runtimes etc.
* `util`: Utility and helper scripts.

## Hardware `hw` Directory
<!---
The following documentation is directly included from `../../hw/README.md`
-->
{%
   include-markdown '../../hw/README.md'
   start="# Snitch Hardware"
   comments=false
%}

## Target `target` Directory
<!---
The following documentation is directly included from `../../sw/README.md`
-->
{%
   include-markdown '../../target/README.md'
   start="# HW Targets"
   comments=false
%}

## Software `sw` Directory

This subdirectory contains the various bits and pieces of software for the Snitch ecosystem.

<!---
The following documentation is directly included from `../../sw/README.md`
-->
{%
   include-markdown '../../sw/README.md'
   start="## Contents"
   comments=false
%}

