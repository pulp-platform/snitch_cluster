# Directory Structure

The project is organized as a monolithic repository. Both hardware and software
are co-located. The top-level ist structured as follows:

* `docs`: [Documentation](documentation.md) of the generator and software.
  Contains additional user guides.
* `hw`: All hardware IP components.
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


## Target `target` Directory
<!---
The following documentation is directly included from `../../sw/README.md`
-->
{%
   include-markdown '../../target/README.md'
   start="# HW Targets"
   comments=false
%}
