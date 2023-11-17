# Snitch/SNAX Cluster Target

## Details
The Snitch cluster target (`target/snitch_cluster`) is a simple RTL testbench
around a SNAX cluster. It is still the same as the Snitch cluster but with SNAX modifications. The cluster can be configured using a config file. By default, the config file which will be picked up is `target/snitch_cluster/cfg/default.hjson`.

The configuration parameters are documented using JSON schema. Documentation for the schema and available configuration options can be found in `docs/schema-doc/snitch_cluster/`).

The cluster testbench simulates an infinite memory. The RISC-V ELF file to be simulated is
preloaded using RISC-V's Front-End Server (`fesvr`).

## Quick Start

These quick start steps demonstrate how you quickly run a simple MAC-engine accelerator in SNAX shell. This assumes you either have the necessary dependencies already or have the docker started (see [getting started](ug/getting_started.md)). Use this if you want to try out a simple test quickly. More details for each step are in the [Detailed Tutorial](#detailed-tutorial) section.

1. Move into `./target/snitch_cluster/.`

```shell
cd ./target/snitch_cluster/.
```

2. Build custom hardware using one of the `cfg.hjson` files for a SNAX accelerator. The code below builds the SNAX with HWPE MAC engine. Add the `-j` option to set the number of  cores to run the build. The output is a RTL Verilator binary which runs the system. 

```shell
make CFG_OVERRIDE=cfg/snax-mac.hjson bin/snitch_cluster.vlt -j 16
```

3. Build the software. This produces `.elf` files (binary) which we feed into the built RTL builds.

```shell
make DEBUG=ON sw
```

4. Feed the `.elf` file into the RTL binary. Wait for the simulation to run. This produces `.dasm` (disassembly) files stored in the `./logs` directory.

```shell
bin/snitch_cluster.vlt sw/apps/snax-mac/build/snax-mac.elf
```

5. Make traces. See [Debugging and Benchmarking](#debugging-and-benchmarking) section. This produces a `.txt` dump which are the traces you can inspect.

```shell
make traces
```

## Detailed Tutorial

In the following tutorial you can assume the working directory to be `target/snitch_cluster`. All paths are to be assumed relative to this directory. Paths relative to the root of the repository are prefixed with a slash.

### Building the Hardware

To compile the default Snitch hardware for simulation run one of the following commands, depending on the desired simulator:

```shell
# Verilator (for Docker users)
make bin/snitch_cluster.vlt

# Verilator (for IIS users)
verilator-4.110 make bin/snitch_cluster.vlt

# Questa (for IIS users)
questa-2022.3 make bin/snitch_cluster.vsim

# VCS (for IIS users)
vcs-2020.12 make bin/snitch_cluster.vcs
```

!!! note

    You can find more details of the configuration file in the Cluster Configuration below.

These commands compile the RTL sources respectively in `work-vlt`, `work-vsim` and `work-vcs`. Additionally, common C++ testbench sources (e.g. the [frontend server (fesvr)](https://github.com/riscv-software-src/riscv-isa-sim)) are compiled under `work`. Each command will also generate a script or an executable (e.g. `bin/snitch_cluster.vsim`) which you can invoke to simulate the hardware. We will see how to do this in a later section.

### Building the Banshee simulator
Instead of running an RTL simulation, you can use our instruction-accurate simulator called `banshee`. To install the simulator, please follow the instructions of the Banshee repository: [https://github.com/pulp-platform/banshee](https://github.com/pulp-platform/banshee).

### Cluster Configuration

Note that the Snitch cluster RTL sources are partly automatically generated from a configuration file provided in `.hjson` format. Several RTL files are templated and use the `.hjson` configuration file to fill the template entries. An example is `/hw/snitch_cluster/src/snitch_cluster_wrapper.sv.tpl`.

Under the `cfg` folder, different configurations are provided. The `cfg/default.hjson` configuration instantiates 8 compute cores + 1 DMA core in the cluster. If you need a specific configuration you can create your own configuration file.

We have other architectures for different accelerators:
* `cfg/snax-mac.hjson` - is a SNAX shell with the simple [HWPE MAC engine](https://github.com/KULeuven-MICAS/hwpe-mac-engine).
* `cfg/snax-gemm.hjson` - is a SNAX shell with a [GEMM engine](https://github.com/KULeuven-MICAS/snax-gemm).

The command `make bin/snitch_cluster.vlt` automatically generates the default (Snitch cluster with 8 compute ores and 1 DMA core) templated RTL sources. It implicitly used the default configuration file (`cfg/default.hjson`). To override the default configuration file, define the following variable when you invoke `make` to use the custom config files:

```shell
make CFG_OVERRIDE=cfg/custom.hjson bin/snitch_cluster.vlt
```

___Note:__ whenever you override the configuration file on the `make` command-line, the configuration will be stored in the `cfg/lru.hjson` file. Successive invocations of `make` will automatically pick up the `cfg/lru.hjson` file. You can therefore omit the `CFG_OVERRIDE` definition in successive commands unless you want to override the least-recently used configuration._

Banshee uses also a cluster configuration file, however, that is given directly when simulating a specific binary with banshee with the help of `--configuration <cluster_config.yaml>`.

### Building the software

To build all of the software for the Snitch cluster, run the following command:

```bash
# for RTL simulation
make DEBUG=ON sw

# for Banshee simulation (requires slightly different runtime)
make SELECT_RUNTIME=banshee DEBUG=ON sw
```

The `sw` target first generates some C header files which depend on the hardware configuration. Hence, the need to generate the software for the same configuration as your hardware. Afterwards, it recursively invokes the `make` target in the `sw` subdirectory to build the `apps/kernels` which have been developed in that directory.

The `DEBUG=ON` flag is used to tell the compiler to produce debugging symbols. It is necessary for the `annotate` target, showcased in the Debugging section of this guide, to work.

The `SELECT_RUNTIME` flag is set by default to `rtl`. To build the software with the Banshee runtime, set the flag to `banshee`.

!!! note

    the RTL is not the only source which is generated from the configuration file. The software stack also depends on the configuration file. **Make sure you always build the software with the same configuration of the hardware you are going to run it on**

### Running a simulation

Create the `logs` directory to host the simulation traces:

```shell
# If it's the first time you run this the logs/ folder won't exist and you will have to create it
mkdir logs
```

Run one of the executables which was compiled in the previous step on your Snitch cluster hardware with your preferred simulator:

```shell
# Verilator (for Docker users)
bin/snitch_cluster.vlt sw/apps/blas/axpy/build/axpy.elf

# Verilator (for IIS users)
verilator-4.110 bin/snitch_cluster.vlt sw/apps/blas/axpy/build/axpy.elf

# Questa (for IIS users)
questa-2022.3 bin/snitch_cluster.vsim sw/apps/blas/axpy/build/axpy.elf

# VCS (for IIS users)
vcs-2020.12 bin/snitch_cluster.vcs sw/apps/blas/axpy/build/axpy.elf

# Banshee
banshee --no-opt-llvm --no-opt-jit --configuration src/banshee.yaml --trace sw/apps/blas/axpy/build/axpy.elf
```

The previous commands will run the simulation in your current terminal. You can also run the simulation in the QuestaSim GUI by adapting the previous command to:

```shell
# Questa (for IIS users)
questa-2022.3 bin/snitch_cluster.vsim.gui sw/apps/blas/axpy/build/axpy.elf
```

You can also produce a `vcd` file which you can display on [gtkwave](https://gtkwave.sourceforge.net/).

```shell
# Add the --vcd at the end to generate vcd files. This produces sim.vcd
bin/snitch_cluster.vlt sw/apps/blas/axpy/build/axpy.elf --vcd

# Display the vcd file in gtkwave
gtkwave sim.vcd
```
!!! note "SNAX does not support Banshee"

    Careful! SNAX does not support Banshee hence do not use the simulator for SNAX builds.


For Banshee, you need to give a specific cluster configuration to the simulator with the flag `--configuration <cluster_config.yaml>`. A default Snitch cluster configuration is given (`src/banshee.yaml`). The flag `--trace` enables the printing of the traces similar to the RTL simulation.
For more information and debug options, please have a look at the Banshee repository: [https://github.com/pulp-platform/banshee](https://github.com/pulp-platform/banshee).

### Creating your first Snitch app

In the following you will create your own AXPY kernel implementation as an example how to develop software for Snitch.

#### Writing the C Code

Create a directory for your AXPY kernel under `sw/`:

```bash
mkdir sw/apps/axpy
```

And a `src` subdirectory to host your source code:

```bash
mkdir sw/apps/axpy/src
```

Here, create a new file named `axpy.c` inside the `src` directory with the following contents:

```C
#include "snrt.h"
#include "data.h"

// Define your kernel
void axpy(uint32_t l, double a, double *x, double *y, double *z) {
    for (uint32_t i = 0; i < l ; i++) {
        z[i] = a * x[i] + y[i];
    }
    snrt_fpu_fence();
}

int main() {
    // Read the mcycle CSR (this is our way to mark/delimit a specific code region for benchmarking)
    uint32_t start_cycle = mcycle();

    // DM core does not participate in the computation
    if(snrt_is_compute_core())
        axpy(L, a, x, y, z);

    // Read the mcycle CSR
    uint32_t end_cycle = mcycle();
}

```

The `snrt.h` file implements the snRuntime API, a library of convenience functions to program Snitch cluster based systems. These sources are located under `target/snitch_cluster/sw/runtime/rtl` and are automatically referenced by our compilation scripts.

___Note:__ Have a look at the files inside `sw/snRuntime` in the root of this repository to see what kind of functionality the snRuntime API defines. Note this is only an API, with some base implementations. The Snitch cluster implementation of the snRuntime for RTL simulation can be found under `target/snitch_cluster/sw/runtime/rtl`. It is automatically built and linked with user applications thanks to our compilation scripts._

We will have to instead create the `data.h` file ourselves. Create a `target/snitch_cluster/sw/apps/axpy/data/data` folder to host the data for your kernel to operate on:

```bash
mkdir sw/apps/axpy/data
```

Here, create a C file named `data.h` with the following contents:

```C
uint32_t L = 16;

double a = 2;

double x[16] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};

double y[16] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  1,  1,  1,  1,  1,  1};

double z[16];

```

In this file we hardcode the data to be used by the kernel. This data will be loaded in memory together with your application code. In general, to verify your code you may want to randomly generate the above data. You may also want to test your kernel on different problem sizes, e.g. varying the length of the vectors, without having to manually rewrite the file. This can be achieved by generating the data header file with a Python script. You may have a look at the `sw/blas/axpy/datagen` folder in the root of this repository as an example. You may reuse several of the functions defined in `sw/blas/axpy/datagen/datagen.py`. Eventually, we will promote these functions to a dedicated Python module which can be easily reused.

#### Compiling the C Code

In your `axpy` folder, create a new file named `Makefile` with the following contents:

```make
APP     = axpy
SRCS    = src/axpy.c
INCDIRS = data

include ../common.mk
```

This Makefile will be invoked recursively by the top-level Makefile, compiling your source code into an executable with the name provided in the `APP` variable.

In order for the top-level Makefile to find your application, add your application's directory to the `SUBDIRS` variable in `sw/apps/Makefile`:

```
SUBDIRS += axpy
```

Now you can recompile all software, including your newly added AXPY application:

```shell
make DEBUG=ON sw
```

Note, only the targets depending on the sources you have added/modified will be recompiled.

In the `sw/apps/axpy/build` directory, you will now find your `axpy.elf` executable and some other files which were automatically generated to aid debugging. Open `axpy.dump` and search for `<x>`, `<y>` and `<z>`. You will see the addresses where the respective vectors defined in `data.h` have been allocated by the compiler. This file can also be very useful to see what assembly instructions your source code was compiled to, and correlate the traces (we will later see) with the source code.

If you want to dig deeper into how our build system works and how these files were generated you can follow the recursive Makefile invocations starting from the `sw` target in `snitch_cluster/Makefile`.

#### Run your application

You can run your application in simulation as shown in the previous sections. Make sure to pick up the right binary, e.g.:

```shell
questa-2022.3 bin/snitch_cluster.vsim sw/apps/axpy/build/axpy.elf
```

### Debugging and benchmarking

When you run the simulation, every core will log all the instructions it executes (along with additional information, such as the value of the registers before/after the instruction) in a trace file, located in the `target/snitch_cluster/logs` directory. The traces are identified by their hart ID, that is a unique ID for every hardware thread (hart) in a RISC-V system (and since all our cores have a single thread that is a unique ID per core)

You need to build and install `spike-dasm` from source first. After making the hardware build, it should create a `work-vlt` directory. Do the following to install `spike-dasm`:

1. Go to: `target/snitch_cluster/work-vlt/riscv-isa-sim`
2. `spike-dasm` uses GNU autoconf for makefile generation: `./configure --prefix="/opt/spike"`
3. Build and install `spike-dasm` with: `make -j$(nproc) install`
4. Add to path `export PATH="/opt/spike/bin:$PATH"`

The simulation logs the traces in a non-human readable format with `.dasm` extension. To convert these to a human-readable form run:

```bash
make -j traces
```

In addition to generating readable traces (`.txt` format), the above command also computes several performance metrics from the trace and appends them at the end of the trace. These can be collected into a single CSV file with the following target:

```bash
make logs/perf.csv

# View the CSV file
libreoffice logs/perf.csv
```

In this file you can find the `X_tstart` and `X_tend` metrics. These are the cycles in which a particular code region `X` starts and ends, and can hence be used to profile your code. Code regions are defined by calls to `mcycle()`. Every call to this function defines two code regions:
- the code preceding the call, up to the previous `mcycle()` call or the start of the source file
- the code following the call, up to the next `mcycle()` call or the end of the source file

The CSV file can be useful to automate collection and post-processing of benchmarking data.

Finally, debugging your program from the trace alone can be quite tedious and time-consuming. You would have to manually understand which instructions in the trace correspond to which lines in your source code. Surely, you can help yourself with the disassembly.

Alternatively, you can automatically annotate the traces with that information. With the following commands you can view the trace instructions side-by-side with the corresponding source code lines they were compiled from:

```bash
make -j annotate
kompare -o logs/trace_hart_00000.diff
```

If you prefer to view this information in a regular text editor (e.g. for search), you can open the `logs/trace_hart_xxxxx.s` files. Here, the annotations are interleaved with the trace rather than being presented side-by-side.

___Note:__ the `annotate` target uses the `addr2line` binutil behind the scenes, which needs debugging symbols to correlate instruction addresses with originating source code lines. The `DEBUG=ON` flag you specified when building the software is used to tell the compiler to produce debugging symbols when compiling your code._

The traces contain a lot of information which we might not be interested at first. To simply visualize the runtime of the compute region in our code, first create a file named `layout.csv` in `sw/apps/axpy` with the following contents:

```
            , compute
"range(0,8)",       1
8           ,

```

Then run the following commands:

```bash
# Similar to logs/perf.csv but filters all but tstart and tend metrics
make logs/event.csv
# Labels, filters and reorders the event regions as specified by an application-specific layout file
../../util/trace/layout_events.py logs/event.csv sw/apps/axpy/layout.csv -o logs/trace.csv
# Creates a trace file which can be visualized with Chrome's TraceViewer
../../util/trace/eventvis.py -o logs/trace.json logs/trace.csv
```

Go to `http://ui.perfetto.dev/`. Here you can load the `logs/trace.json` file and graphically view the runtime of the compute region in your code. To learn more about the layout file syntax and what the Python scripts do you can have a look at the description comment at the start of the scripts themselves.

__Great, but, have you noticed a problem?__

Look into `sw/apps/axpy/build/axpy.dump` and search for the address of the output variable `<z>` :

```
Disassembly of section .bss:

80000960 <z>:
	...
```

Now grep this address in your traces:

```bash
grep 80000960 logs/*.txt
...
```

It appears in every trace! All the cores issue a `fsd` (float store double) to this address. You are not parallelizing your kernel but executing it 8 times!

Modify `sw/apps/axpy/src/axpy.c` to truly parallelize your kernel:

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
    uint32_t start_cycle = mcycle();

    // DM core does not participate in the computation
    if(snrt_is_compute_core())
        axpy(L / snrt_cluster_compute_core_num(), a, x, y, z);

    // Read the mcycle CSR
    uint32_t end_cycle = mcycle();
}
```

Now re-run your kernel and compare the execution time of the compute region with the previous version.

## Code Reuse

As you may have noticed, there is a good deal of code which is independent of the hardware platform we execute our AXPY kernel on. This is true for the `data.h` file and possible data generation scripts. The Snitch AXPY kernel itself is not specific to the Snitch cluster, but can be ported to any platform which provides an implementation of the snRuntime API. An example is Occamy, with its own testbench and SW development environment.

It is thus preferable to develop the data generation scripts and Snitch kernels in a shared location, from which multiple platforms can take and include the code. The `sw` directory in the root of this repository was created with this goal in mind. For the AXPY example, shared sources are hosted under the `sw/blas/axpy` directory. As an example of how these shared sources are used to build an AXPY application for a specific platform (in this case the standalone Snitch cluster) you can have a look at the `target/snitch_cluster/sw/apps/blas/axpy`.

We recommend that you follow this approach also in your own developments for as much of the code which can be reused.
