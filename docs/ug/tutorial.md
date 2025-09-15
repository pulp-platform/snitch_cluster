# Tutorial

The following tutorial will guide you through the use of the Snitch cluster. You will learn how to develop, simulate, debug and benchmark software for the Snitch cluster architecture.

You can assume the working directory to be the root of this repository. All paths are to be assumed relative to this directory, unless mentioned otherwise.

## Setup

If you don't have access to an IIS machine, and you have set up the Snitch Docker container as described in the [getting started guide](getting_started.md), all of the commands presented in this tutorial will have to be executed in the Docker container.

{%
   include-markdown '../../util/container/README.md'
   start="## Usage"
   end="## Limitations"
   comments=false
   heading-offset=1
%}

Where you should replace `<path_to_repository_root>` with the path to the root directory of the Snitch cluster repository cloned on your machine.

!!! warning
    As QuestaSim and VCS are proprietary tools and require a license, only Verilator is provided within the container for RTL simulations.

## Building the hardware

To run software on Snitch without a physical chip, you will need a simulation model of the Snitch cluster. You can build a cycle-accurate simulation model from the RTL sources directly using QuestaSim, VCS or Verilator, with either of the following commands:

=== "Verilator"
    ```shell
    make verilator
    ```

=== "Questa"
    ```shell
    make DEBUG=ON vsim
    ```

=== "VCS"
    ```shell
    make vcs
    ```

The artifacts of these commands can be found under `target/sim/build`. 
Particularly, each command compiles the RTL sources with the selected simulator, respectively in `work-vlt`, `work-vsim` and `work-vcs`. Additionally, common C++ testbench sources (e.g. the [frontend server (fesvr)](https://github.com/riscv-software-src/riscv-isa-sim)) are compiled under `work`. Each command will also generate a script or an executable (e.g. `bin/snitch_cluster.vsim`) which we can use to simulate software on Snitch, as we will see in section [Running a simulation](#running-a-simulation).

!!! important
    The variable `DEBUG=ON` is required when using QuestaSim to preserve the visibility of all internal signals. If you need to inspect the simulation waveforms, you should set this variable when building the simulation model. For faster simulations you can omit the variable assignment, allowing QuestaSim to optimize internal signals away.

## Configuring the hardware

The Snitch cluster RTL sources are partly automatically generated from a configuration file provided in [JSON5](https://json5.org/) format. Several RTL files are templated and use the `.json` configuration file as input to fill in the template. An example is [snitch_cluster_wrapper.sv.tpl](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/hw/snitch_cluster/src/snitch_cluster_wrapper.sv.tpl).

In the [`cfg`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/cfg) folder, different configurations are provided. The [`cfg/default.json`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/cfg/default.json) configuration instantiates 8 compute cores + 1 DMA core in the cluster.

The command you previously executed automatically generated the RTL sources from the templates, and it implicitly used the default configuration file.
To override the default configuration file, e.g. to use the omega TCDM interconnect, define the following variable when you invoke `make`:
```shell
make CFG_OVERRIDE=cfg/omega.json verilator
```

If you want to use a custom configuration, just point `CFG_OVERRIDE` to the path of your configuration file.

!!! tip
    When you override the configuration file on the `make` command-line, the configuration is stored in the `cfg/lru.json` file. Successive invocations of `make` will automatically pick up the `cfg/lru.json` file. You can therefore omit the `CFG_OVERRIDE` definition in successive commands unless you want to override the least-recently used configuration.

## Building the software

To build all of the software for the Snitch cluster, run the following command. Different simulators may require different C runtime or library function implementations, so different options have to be specified to select the appropriate implementation, e.g. for OpenOCD semi-hosting:

=== "RTL"

    ```bash
    make DEBUG=ON sw -j
    ```

=== "OpenOCD"

    ```bash
    make DEBUG=ON OPENOCD_SEMIHOSTING=ON sw -j
    ```

This builds all software targets defined in the repository, e.g. the Snitch runtime library and all applications. Artifacts are stored in the build directory of each target. For example, have a look inside `sw/kernels/blas/axpy/build/` and you will find the artifacts of the AXPY application build, e.g. the compiled executable `axpy.elf` and a disassembly `axpy.dump`.

If you only want to build a specific software target, you can by replacing `sw` with the name of that target, e.g. the name of an application:

```bash
make DEBUG=ON axpy -j
```

For this to be possible, we require all software targets to have unique and distinct names from any other Make target.

!!! warning
    The RTL is not the only source which is generated from the configuration file. The software stack also depends on the configuration file. Make sure you always build the software with the same configuration of the hardware you are going to run it on.

!!! info
    The `DEBUG=ON` flag is used to tell the compiler to produce debugging symbols and disassemble the generated ELF binaries for inspection (`.dump` files in the build directories). Debugging symbols are required by the `annotate` target, showcased in the [Debugging and benchmarking](#debugging-and-benchmarking) section of this guide.

!!! tip
    On GVSOC, it is better to use OpenOCD semi-hosting to prevent putchar from disturbing the DRAMSys timing model.

## Running a simulation

Run one of the executables which was compiled in the previous step on your Snitch cluster simulator of choice:

=== "Verilator"

    ```shell
    snitch_cluster.vlt sw/kernels/blas/axpy/build/axpy.elf
    ```

=== "Questa"

    ```shell
    snitch_cluster.vsim sw/kernels/blas/axpy/build/axpy.elf
    ```

=== "VCS"

    ```shell
    snitch_cluster.vcs sw/kernels/blas/axpy/build/axpy.elf
    ```

The simulator binaries can be invoked from any directory, just adapt the relative path to the software binary in the preceding commands accordingly, or use absolute paths. We refer to the working directory where the simulation is launched as the _simulation directory_. Within it, you will find several log files produced by the RTL simulation.

!!! note
    The `bin/` directory was added to the `$PATH` variable as part of the [getting started](getting_started.md) steps. It is thanks to this that the simulation binaries can be used without specifying their full path.

!!! tip
    If you don't want the simulation artifacts to pollute the root of your repository, move to the `test` folder, using that as the simulation directory, so that all simulation artifacts are contained therein.

!!! tip
    If you don't want your log files to be overriden when you run another simulation, just create separate simulation directories for every simulation whose artifacts you want to preserve, and run the simulations therein.

The previous commands will launch the simulation on the console. QuestaSim simulations can also be launched with the GUI, e.g. for waveform inspection. Just adapt the previous command to:

```shell
snitch_cluster.vsim.gui sw/kernels/blas/axpy/build/axpy.elf
```

For convenience, we also provide the following phony Make target as an alias to the simulation command with QuestaSim:
```shell
make vsim-run BINARY=$PWD/sw/kernels/blas/axpy/build/axpy.elf SIM_DIR=test
```
Behind the scenes, this will launch the previous command in the specified simulation directory (`SIM_DIR`). Note, the path to the software binary must be absolute or relative to the simulation directory. When `SIM_DIR` is omitted it will default to the `test` directory.

You can use the `DEBUG` flag to launch the command with the GUI:
```shell
make vsim-run BINARY=$PWD/sw/kernels/blas/axpy/build/axpy.elf DEBUG=ON
```

## Debugging and benchmarking

When you run a simulation, every core logs all the instructions it executes in a trace file. The traces are located in the `logs` folder within the _simulation directory_. Every trace is identified by a hart ID, that is a unique ID for every _hardware thread (hart)_ in a RISC-V system (and since all our cores have a single thread that is a unique ID per core).

The simulation dumps the traces in a non-human-readable format with `.dasm` extension. To convert these to a human-readable form run:

```bash
make traces -j
```

If the simulation directory does not coincide with the current working directory, you will have to provide the path to the simulation directory explicitly, this holds for all of the commands in this seciton:

```bash
make traces SIM_DIR=<path_to_simulation_directory> -j
```

This will generate human-readable traces with `.txt` extension. In addition, several performance metrics will be computed and appended to the end of the trace. These and additional metrics are also dumped to a `.json` file for further processing. Detailed information on how to interpret the traces and performance metrics can be found in the [Trace Analysis](trace_analysis.md) page.

Debugging a program from the traces alone can be quite tedious and time-consuming, as it would require you to manually understand which lines in your source code every instruction originates from. Surely, you can help yourself with the disassembly, but we can do better.

You can automatically annotate every instruction with the originating source line using:

```bash
make annotate -j
```

This will produce a `.s` file from every `.txt` trace, in which the instructions from the `.txt` trace are now interleaved with comments indicating which source lines those instructions correspond to.

!!! note
    The `annotate` target uses the `addr2line` binutil behind the scenes, which needs debugging symbols to correlate instruction addresses with originating source code lines. The `DEBUG=ON` flag you specified when building the software is necessary for this step to succeed.

Every performance metric is associated to a region in the trace. You can define regions by instrumenting your code with calls to the `snrt_mcycle()` function. Every call to this function defines two code regions:

- the code preceding the call, up to the previous `snrt_mcycle()` call or the start of the program
- the code following the call, up to the next `snrt_mcycle()` call or the end of the program

If you would like to benchmark a specific part of your program, you would call `snrt_mcycle()` before and after that part. Performance metrics, such as the IPC, will be extracted for that region separately from other regions.

Sometimes you may want to graphically visualize the regions in your traces, to have a holistic and high-level view over all cores' operations. This can be useful e.g. to visualize if the compute and DMA phases in a double-buffered application overlap correctly and to what extent. To achieve this, you can use the following command, provided a file specifying the _regions of interest (ROI)_ and associating a textual label to each region:

```shell
make visual-trace ROI_SPEC=sw/kernels/blas/axpy/roi.json -j
```

Where `ROI_SPEC` points to the mentioned specification file.

This command generates the `logs/trace.json` file, which you can graphically visualize in your browser. Go to [http://ui.perfetto.dev/](http://ui.perfetto.dev/) and load the trace file. You can now graphically view the compute and DMA transfer regions in your code. If you click on a region, you will be able to see the performance metrics extracted for that region. Furthermore, you can also view the low-level traces of each core, with the individual instructions. Click on an instruction, and you will be able to see the originating source line information, the same you've seen to be generated by the `annotate` target.

!!! note
    As mentioned also for the `annotate` target, the `DEBUG=ON` flag is required when building the software for the source line information to be extracted.

!!! info
    If you want to dig deeper into the ROI specification file syntax and how the visual trace is built behind the scenes, have a look at the documentation for the [`roi.py`](../rm/sw/bench/roi.md) and [`visualize.py`](../rm/sw/bench/visualize.md) scripts or at the sources themselves, hosted in the [`util/bench`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/util/bench) folder.

## Developing your first Snitch application

In the following you will create your own AXPY kernel implementation as an example how to develop software for Snitch.

### Writing the C code

Create a directory for your AXPY kernel:

```bash
mkdir sw/kernels/misc/tutorial
```

And a `src` subdirectory to host your source code:

```bash
mkdir sw/kernels/misc/tutorial/src
```

Here, create a new file named `tutorial.c` with the following contents:

```C
#include "snrt.h"
#include "data.h"

// Define your kernel
void axpy(uint32_t l, double a, double *x, double *y, double *z) {
    int core_idx = snrt_cluster_core_idx();
    int offset = core_idx * l;

    for (int i = 0; i < l; i++) {
        z[offset] = a * x[offset] + y[offset];
        offset++;
    }
    snrt_fpu_fence();
}

int main() {
    // Read the mcycle CSR (this is our way to mark/delimit a specific code region for benchmarking)
    uint32_t start_cycle = snrt_mcycle();

    // DM core does not participate in the computation
    if(snrt_is_compute_core())
        axpy(L / snrt_cluster_compute_core_num(), a, x, y, z);

    // Read the mcycle CSR
    uint32_t end_cycle = snrt_mcycle();
}

```

The [`snrt.h`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/sw/runtime/impl/snrt.h) file implements the Snitch runtime API, a library of convenience functions to program Snitch-cluster-based systems, and it is automatically referenced by our compilation scripts. Documentation for the Snitch runtime can be found at the [Snitch Runtime](../doxygen/html/index.html) pages.

We will have to instead create the `data.h` file ourselves. Create a folder to host the data for your kernel to operate on:

```bash
mkdir sw/kernels/misc/tutorial/data
```

Here, create a C file named `data.h` with the following contents:

```C
uint32_t L = 16;

double a = 2;

double x[16] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};

double y[16] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  1,  1,  1,  1,  1,  1};

double z[16];

```

In this file we hardcode the data to be used by the kernel. This data will be loaded in memory together with your application code.

### Compiling the C code

In your `tutorial` folder, create a new file named `app.mk` with the following contents:

```make
APP              := tutorial
$(APP)_BUILD_DIR := $(SN_ROOT)/sw/kernels/misc/$(APP)/build
SRCS             := $(SN_ROOT)/sw/kernels/misc/$(APP)/src/$(APP).c
$(APP)_INCDIRS   := $(SN_ROOT)/sw/kernels/misc/$(APP)/data

include $(SN_ROOT)/sw/kernels/common.mk
```

This file will be included in the top-level Makefile, compiling your source code into an executable with the name provided in the `APP` variable.

In order for the top-level Makefile to find your application, add your application's directory to the `SN_APPS` variable in [`sw.mk`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/make/sw.mk):

```
SN_APPS += sw/kernels/misc/tutorial
```

Now you can recompile the software, including your newly added tutorial application, as shown in section [Building the software](#building-the-software).

!!! note
    Only the software targets depending on the sources you have added/modified have been recompiled.

!!! info
    If you want to dig deeper into how our build system works and how these files were generated you can start from the [top-level Makefile](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/Makefile) and work your way through the other Makefiles included within it.

### Running your application

You can then run your application as shown in section [Running a simulation](#running-a-simulation). Make sure to pick up the right binary, i.e. `sw/kernels/misc/tutorial/build/tutorial.elf`.

### Generating input data

In general, you may want to randomly generate the data for your application. You may also want to test your kernel on different problem sizes, e.g. varying the length of the AXPY vectors, without having to manually rewrite the file.

The approach we use is to generate the header file with a Python script. An input `.json` file can be used to configure the data generation, e.g. to set the length of the AXPY vectors. Have a look at the [`datagen.py`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/sw/kernels/blas/axpy/scripts/datagen.py) and [`params.json`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/sw/kernels/blas/axpy/data/params.json) files in our full-fledged [AXPY application](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/sw/kernels/blas/axpy/) as an example. As you can see, the data generation script reuses many convenience classes and functions from the [`data_utils`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/util/sim/data_utils.py) module. We advise you to do the same. Documentation for this module can be found at the [auto-generated pages](../rm/sw/sim/data_utils.md).

### Verifying your application

When developing an application, it is good practice to verify the results of your application against a golden model. The traditional approach is to generate expected results in your data generation script, dump these into the header file and extend your application to check its results against the expected results, _in simulation_! We refer to this approach as the _Built-in self-test (BIST)_ approach.
The built-in self-test logic could e.g. count the number of errors and return that as an exit code. Any non-zero return code indicates a failure. When using Verilator, the return code of the simulated Snitch binary will be propagated to the return code of the simulation command, and can be inspected e.g. by running the following command in a bash terminal:
```bash
echo $?
```
When using QuestaSim and VCS, the return code will be printed to stdout by the simulation command.

The problem with the BIST approach is that every cycle spent on verification is simulated, and this may take a significant time for large designs.

A better alternative is to read out the results from the simulation memory at the end of the simulation, and compare them outside of the simulation. You may have a look at our AXPY's [`verify.py`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/sw/kernels/blas/axpy/scripts/verify.py) script as an example. We can reuse this script to verify our application, by prepending it to the usual simulation command, as:

```shell
sw/kernels/blas/axpy/scripts/verify.py snitch_cluster.vlt sw/kernels/misc/tutorial/build/tutorial.elf
```

You can test if the verification passed by checking that the exit code of the previous command is 0 (e.g. in a bash terminal):
```bash
echo $?
```

When using the Make target alias to run the simulation, you can pass the verification script through the `VERIFY_PY` flag:
```shell
make vsim-run BINARY=$PWD/sw/kernels/blas/axpy/build/axpy.elf VERIFY_PY=$PWD/sw/kernels/blas/axpy/scripts/verify.py
```
Again, note that the path must be absolute or relative to the selected simulation directory.

Most of the logic in our verification script is implemented in convenience classes and functions provided by the [`verif_utils`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/util/sim/verif_utils.py) module. Documentation for this module can be found at the [auto-generated pages](../rm/sw/sim/verif_utils.md).

!!! info
    The `verif_utils` functions build upon a complex verification infrastructure, which uses inter-process communication (IPC) between the Python process and the simulation process to get the results of your application at the end of the simulation. If you want to dig deeper into how this framework is implemented, have a look at the [`SnitchSim.py`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/util/sim/SnitchSim.py) module and the IPC files within the [`target/sim/tb`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/target/sim/tb) folder.

## Implementing the hardware

If you make changes to the hardware, you probably also want to physically implement it to estimate the PPA impact of your modifications. As the physical implementation flow involves proprietary tools licensed under non-disclosure agreements, our physical implementation flow is contained in a separate private git repository. If you are an IIS user, with access to our Gitlab server and IIS machines, you may follow the next instructions to replicate our implementation flow.

Firstly, we need to clone all the sources for the physical flow. The following command takes care of everything for you:
```shell
make nonfree
```

Behind the scenes, it will clone the `snitch-cluster-nonfree` repo under the `nonfree` folder. Let's move into this folder:

```shell
cd nonfree
```

Here, you will find a Makefile with a series of convenience targets to launch our flow up to a certain stage: may it be elaboration (`elab`), synthesis (`synth`) or place-and-route (`pnr`). If you can wait long enough you may also launch the entire flow to produce a final optimized post-layout netlist:

```shell
make post-layout-netlist
```

This may take as long as a day, or more, depending on your machine's performance. If you previously launched the flow up to a certain stage, you can resume it from that point without restarting from scratch. Just specify the `FIRST_STAGE` flag with the name of the stage you want to start from, e.g.:

```shell
make FIRST_STAGE=synth-init-opto post-layout-netlist
```

You will find reports and output files produced by the flow in the `nonfree/gf12/fusion/runs/0/` folder, respectively in the `reports` and `out` subdirectories, separated into individual subdirectories for every stage in the flow. These are all you should need to derive area and timing numbers for your design.

## Running a physical simulation

Once your design is physically implemented, you want to also verify that it works as intended.
Assuming you used the previous command to get a final optimized post-layout netlist, you can directly build a simulation model out of it. Head back to the main repository, in the root directory, and build the simulation model with the following flag:

```shell
make clean-vsim
make PL_SIM=1 vsim
```

This resembles the commands you've previously seen in section [Building the hardware](#building-the-hardware). In fact, all testbench components are the same, we simply use the added flag to tell [Bender](https://github.com/pulp-platform/bender) to reference the physical netlist in place of the source RTL as a DUT during compilation.
The `Bender.yml` file automatically references the final netlist in our flow, but you could replace that with a netlist from an intermediate stage if you do not intend to run the whole flow.

!!! note
    Make does not track changes in the flags passed to it, so it does not know that it has to update the RTL source list for compilation. To ensure that it is updated, we can delete the compilation script, which was implicitly generated when you last built the simulation model. The first command above achieves this, by deleting all artifacts from the last build with QuestaSim.

Running a physical simulation is then no different from running a functional simulation, so you may continue using the commands introduced in section [Running a simulation](#running-a-simulation).

## Power estimation

During physical implementation, the tools are able to independently generate area and timing numbers. For a complete PPA analysis, you will want to include power estimates as well.

Power numbers are extremely dependent on the switching activity in your circuit, which in turn depends on the stimuli you feed in to your DUT, so you are in charge of providing this information to the tools. The switching activity is typically recorded in the form of a [VCD](https://en.wikipedia.org/wiki/Value_change_dump) file, and can be generated by most RTL simulators.

To do so, set the `VCD_DUMP` flag when building the physical simulation model:
```shell
make PL_SIM=1 VCD_DUMP=1 DEBUG=ON vsim
``` 

!!! danger
    When using QuestaSim for VCD generation, you must build the model with the `DEBUG=ON` flag, to ensure that all nets are preserved during compilation, preventing them from being optimized away. This guarantees that the VCD file contains switching activity for all nets in your circuit. 

When you run a simulation, the simulator will now automatically create a `vcd` subdirectory within the _simulation directory_, where a VCD file is generated.

Most often you are not interested in estimating the power of an entire simulation, but only of a specific section, e.g. while executing a part of a kernel computation.
You can pass start and end times (in ns) for VCD recording to the simulation as environment variables:

```shell
VCD_START=127 VCD_END=8898 snitch_cluster.vsim sw/kernels/blas/axpy/build/axpy.elf
```

!!! note
    Variable assignments must preceed the executable in a shell command to be interpreted as environment variable assignments. Note that environment variables set this way only persist for the current command.

A benefit of RTL simulations is that they are cycle-accurate. You can thus use them as a reference to find the start and end times of interest with the help of the simulation traces (unavailable during physical simulation), and directly apply these to the physical simulation.

With a VCD file at your disposal, you can now estimate the power consumption of your circuit. In the non-free repository, run the following command:
```shell
make SIM_DIR=<path_to_simulation_directory> power
```
You need to point the command to the _simulation directory_ in which the VCD dump was generated, for it to find the VCD file.

!!! note
    Since the actual simulation command is run in a different directory, you need to point to the _simulation directory_ using an absolute path.

Once the command terminates, you will find power reports in the `nonfree/gf12/synopsys/reports` folder, from which you can extract relevant power numbers.
