# Tutorial

The following tutorial will guide you through the use of the Snitch cluster. You will learn how to develop, simulate, debug and benchmark software for the Snitch cluster architecture.

You can assume the working directory to be `target/snitch_cluster`. All paths are to be assumed relative to this directory. Paths relative to the root of the repository are prefixed with a slash.

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
    make bin/snitch_cluster.vlt
    ```

=== "Questa"
    ```shell
    make DEBUG=ON bin/snitch_cluster.vsim
    ```

=== "VCS"
    ```shell
    make bin/snitch_cluster.vcs
    ```

These commands compile the RTL sources respectively in `work-vlt`, `work-vsim` and `work-vcs`. Additionally, common C++ testbench sources (e.g. the [frontend server (fesvr)](https://github.com/riscv-software-src/riscv-isa-sim)) are compiled under `work`. Each command will also generate a script or an executable (e.g. `bin/snitch_cluster.vsim`) which we can use to simulate software on Snitch, as we will see in section [Running a simulation](#running-a-simulation).

!!! info
    The variable `DEBUG=ON` is required when using QuestaSim to preserve the visibility of all internal signals. If you need to inspect the simulation waveforms, you should set this variable when building the simulation model. For faster simulations you can omit the variable assignment, allowing QuestaSim to optimize internal signals away.


## Building the Banshee simulator

Instead of building a simulation model from the RTL sources, you can use our instruction-accurate simulator called `banshee`. To install the simulator, please follow the instructions provided in the [Banshee repository](https://github.com/pulp-platform/banshee).

## Configuring the hardware

The Snitch cluster RTL sources are partly automatically generated from a configuration file provided in `.hjson` format. Several RTL files are templated and use the `.hjson` configuration file as input to fill in the template. An example is [snitch_cluster_wrapper.sv.tpl](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/hw/snitch_cluster/src/snitch_cluster_wrapper.sv.tpl).

In the [`cfg`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/target/snitch_cluster/cfg) folder, different configurations are provided. The [`cfg/default.hjson`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/target/snitch_cluster/cfg/default.hjson) configuration instantiates 8 compute cores + 1 DMA core in the cluster.

The command you previously executed automatically generated the RTL sources from the templates, and it implicitly used the default configuration file. In this configuration the FPU is not equipped with a floating-point divide and square-root unit.
To override the default configuration file, e.g. to use the configuration with FDIV/FSQRT unit, define the following variable when you invoke `make`:
```shell
make CFG_OVERRIDE=cfg/fdiv.hjson bin/snitch_cluster.vlt
```

If you want to use a custom configuration, just point `CFG_OVERRIDE` to the path of your configuration file.

!!! tip
    When you override the configuration file on the `make` command-line, the configuration is stored in the `cfg/lru.hjson` file. Successive invocations of `make` will automatically pick up the `cfg/lru.hjson` file. You can therefore omit the `CFG_OVERRIDE` definition in successive commands unless you want to override the least-recently used configuration.

## Building the software

To build all of the software for the Snitch cluster, run the following command. Different simulators may require different C runtime or library function implementations, so different options have to be specified to select the appropriate implementation, e.g. for Banshee simulations or OpenOCD semi-hosting:

=== "RTL"

    ```bash
    make DEBUG=ON sw -j
    ```

=== "Banshee"

    ```bash
    make DEBUG=ON SELECT_RUNTIME=banshee sw -j
    ```

=== "OpenOCD"

    ```bash
    make DEBUG=ON OPENOCD_SEMIHOSTING=ON sw -j
    ```

This builds all software targets defined in the repository, e.g. the Snitch runtime library and all applications. Artifacts are stored in the build directory of each target. For example, have a look inside `sw/apps/blas/axpy/build/` and you will find the artifacts of the AXPY application build, e.g. the compiled executable `axpy.elf` and a disassembly `axpy.dump`.

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
    bin/snitch_cluster.vlt sw/apps/blas/axpy/build/axpy.elf
    ```

=== "Questa"

    ```shell
    bin/snitch_cluster.vsim sw/apps/blas/axpy/build/axpy.elf
    ```

=== "VCS"

    ```shell
    bin/snitch_cluster.vcs sw/apps/blas/axpy/build/axpy.elf
    ```

=== "Banshee"

    ```shell
    banshee --no-opt-llvm --no-opt-jit --configuration src/banshee.yaml --trace sw/apps/blas/axpy/build/axpy.elf
    ```

The simulator binaries can be invoked from any directory, just adapt the relative paths in the preceding commands accordingly, or use absolute paths. We refer to the working directory where the simulation is launched as the _simulation directory_. Within it, you will find several log files produced by the RTL simulation.

!!! tip
    If you don't want your log files to be overriden when you run another simulation, just create separate simulation directories for every simulation whose artifacts you want to preserve, and run the simulations therein.

The previous commands will launch the simulation on the console. QuestaSim simulations can also be launched with the GUI, e.g. for waveform inspection. Just adapt the previous command to:

```shell
bin/snitch_cluster.vsim.gui sw/apps/blas/axpy/build/axpy.elf
```

## Debugging and benchmarking

When you run a simulation, every core logs all the instructions it executes in a trace file. The traces are located in the `logs` folder within the simulation directory. Every trace is identified by a hart ID, that is a unique ID for every _hardware thread (hart)_ in a RISC-V system (and since all our cores have a single thread that is a unique ID per core).

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
make visual-trace ROI_SPEC=../../sw/blas/axpy/roi.json -j
```

Where `ROI_SPEC` points to the mentioned specification file.

This command generates the `logs/trace.json` file, which you can graphically visualize in your browser. Go to [http://ui.perfetto.dev/](http://ui.perfetto.dev/) and load the trace file. You can now graphically view the compute and DMA transfer regions in your code. If you click on a region, you will be able to see the performance metrics extracted for that region. Furthermore, you can also view the low-level traces of each core, with the individual instructions. Click on an instruction, and you will be able to see the originating source line information, the same you've seen to be generated by the `annotate` target.

!!! note
    As mentioned also for the `annotate` target, the `DEBUG=ON` flag is required when building the software for the source line information to be extracted.

!!! info
    If you want to dig deeper into the ROI specification file syntax and how the visual trace is built behind the scenes, have a look at the documentation for the [`roi.py`](../rm/sw/bench/roi.md) and [`visualize.py`](../rm/sw/bench/visualize.md) scripts or at the sources themselves, hosted in the [`bench`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/util/bench) folder.

## Developing your first Snitch application

In the following you will create your own AXPY kernel implementation as an example how to develop software for Snitch.

### Writing the C code

Create a directory for your AXPY kernel:

```bash
mkdir sw/apps/tutorial
```

And a `src` subdirectory to host your source code:

```bash
mkdir sw/apps/tutorial/src
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

The [`snrt.h`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/target/snitch_cluster/sw/runtime/rtl/src/snrt.h) file implements the snRuntime API, a library of convenience functions to program Snitch-cluster-based systems, and it is automatically referenced by our compilation scripts. Documentation for the snRuntime can be found at the [Snitch Runtime](../doxygen/html/index.html) pages.

!!! note
    The [snRuntime sources](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/sw/snRuntime) only define the snRuntime API, and provide a base implementation for a subset of functions. A complete implementation of the snRuntime for RTL simulation can be found under [`target/snitch_cluster/sw/runtime/rtl`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/target/snitch_cluster/sw/runtime/rtl).

We will have to instead create the `data.h` file ourselves. Create a folder to host the data for your kernel to operate on:

```bash
mkdir sw/apps/tutorial/data
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
$(APP)_BUILD_DIR := $(ROOT)/target/snitch_cluster/sw/apps/$(APP)/build
SRCS             := $(ROOT)/target/snitch_cluster/sw/apps/$(APP)/src/$(APP).c
$(APP)_INCDIRS   := $(ROOT)/target/snitch_cluster/sw/apps/$(APP)/data

include $(ROOT)/target/snitch_cluster/sw/apps/common.mk
```

This file will be included in the top-level Makefile, compiling your source code into an executable with the name provided in the `APP` variable.

In order for the top-level Makefile to find your application, add your application's directory to the `APPS` variable in [`sw.mk`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/target/snitch_cluster/sw.mk):

```
APPS += sw/apps/tutorial
```

Now you can recompile the software, including your newly added tutorial application, as shown in section [Building the software](#building-the-software).

!!! note
    Only the software targets depending on the sources you have added/modified have been recompiled.

!!! info
    If you want to dig deeper into how our build system works and how these files were generated you can start from the [top-level Makefile](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/target/snitch_cluster/Makefile) and work your way through the other Makefiles included within it.

### Running your application

You can then run your application as shown in section [Running a simulation](#running-a-simulation). Make sure to pick up the right binary, i.e. `sw/apps/tutorial/build/tutorial.elf`.

### Generating input data

In general, you may want to randomly generate the data for your application. You may also want to test your kernel on different problem sizes, e.g. varying the length of the AXPY vectors, without having to manually rewrite the file.

The approach we use is to generate the header file with a Python script. An input `.json` file can be used to configure the data generation, e.g. to set the length of the AXPY vectors. Have a look at the [`datagen.py`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/sw/blas/axpy/scripts/datagen.py) and [`params.json`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/sw/blas/axpy/data/params.json) files in our full-fledged [AXPY application](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/sw/blas/axpy/) as an example. As you can see, the data generation script reuses many convenience classes and functions from the [`data_utils`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/util/sim/data_utils.py) module. We advise you to do the same. Documentation for this module can be found at the [auto-generated pages](../rm/sw/sim/data_utils.md).

### Verifying your application

When developing an application, it is good practice to verify the results of your application against a golden model. The traditional approach is to generate expected results in your data generation script, dump these into the header file and extend your application to check its results against the expected results, _in simulation_! Every cycle spent on verification is simulated, and this may take a significant time for large designs. We refer to this approach as the _Built-in self-test (BIST)_ approach.

A better alternative is to read out the results from your application at the end of the simulation, and compare them outside of the simulation. You may have a look at our AXPY's [`verify.py`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/sw/blas/axpy/scripts/verify.py) script as an example. We can reuse this script to verify our application, by prepending it to the usual simulation command, as:

```shell
../../sw/blas/axpy/scripts/verify.py bin/snitch_cluster.vlt sw/apps/tutorial/build/tutorial.elf
```

You can test if the verification passed by checking that the exit code of the previous command is 0 (e.g. in a bash terminal):
```bash
echo $?
```

Again, most of the logic in the script is implemented in convenience classes and functions provided by the [`verif_utils`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/util/sim/verif_utils.py) module. Documentation for this module can be found at the [auto-generated pages](../rm/sw/sim/verif_utils.md).

!!! info
    The `verif_utils` functions build upon a complex verification infrastructure, which uses inter-process communication (IPC) between the Python process and the simulation process to get the results of your application at the end of the simulation. If you want to dig deeper into how this framework is implemented, have a look at the [`SnitchSim.py`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/util/sim/SnitchSim.py) module and the IPC files within the [`test`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/target/common/test) folder.

## Code reuse

As you may have noticed, there is a good deal of code which is independent of the hardware platform we execute our AXPY kernel on. This is true for the `data.h` file and possible data generation scripts. The Snitch AXPY kernel itself is not specific to the Snitch cluster, but can be ported to any platform which provides an implementation of the snRuntime API. An example is Occamy, with its own testbench and SW development environment.

It is thus preferable to develop the data generation scripts and Snitch kernels in a shared location, from which multiple platforms can take and include the code. The `sw` directory in the root of this repository was created with this goal in mind. For the AXPY example, shared sources are hosted under the `sw/blas/axpy` directory.

We recommend that you follow this approach also in your own developments for as much of the code which can be reused.
