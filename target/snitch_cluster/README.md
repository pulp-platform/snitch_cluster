# Snitch cluster target

The Snitch cluster target (`target/snitch_cluster`) is a simple RTL testbench
around a Snitch cluster. The cluster can be configured using a config file. By default, the config file which will be picked up is `target/snitch_cluster/cfg/default.hsjon`.

The configuration parameters are documented using JSON schema. Documentation for the schema and available configuration options can be found in `docs/schema-doc/snitch_cluster/`).

The cluster testbench simulates an infinite memory. The RISC-V ELF file to be simulated is
preloaded using RISC-V's Front-End Server (`fesvr`).

## Tutorial

In the following tutorial you can assume the working directory to be `target/snitch_cluster`. All paths are to be assumed relative to this directory. Paths relative to the root of the repository are prefixed with a slash.

### Building the hardware

To compile the hardware for simulation run one of the following commands, depending on the desired simulator:

```shell
# Verilator
make bin/snitch_cluster.vlt

# Questa
make DEBUG=ON bin/snitch_cluster.vsim

# VCS
make bin/snitch_cluster.vcs
```

These commands compile the RTL sources respectively in `work-vlt`, `work-vsim` and `work-vcs`. Additionally, common C++ testbench sources (e.g. the [frontend server (fesvr)](https://github.com/riscv-software-src/riscv-isa-sim)) are compiled under `work`. Each command will also generate a script or an executable (e.g. `bin/snitch_cluster.vsim`) which you can invoke to simulate the hardware. We will see how to do this in a later section.
The variable `DEBUG=ON` is used to preserve the visibility of all the internal signals during simulation.

### Building the Banshee simulator
Instead of running an RTL simulation, you can use our instruction-accurate simulator called `banshee`. To install the simulator, please follow the instructions of the Banshee repository: [https://github.com/pulp-platform/banshee](https://github.com/pulp-platform/banshee).

### Cluster configuration

Note that the Snitch cluster RTL sources are partly automatically generated from a configuration file provided in `.hjson` format. Several RTL files are templated and use the `.hjson` configuration file to fill the template entries. An example is `/hw/snitch_cluster/src/snitch_cluster_wrapper.sv.tpl`.

Under the `cfg` folder, different configurations are provided. The `cfg/default.hjson` configuration instantiates 8 compute cores + 1 DMA core in the cluster. If you need a specific configuration you can create your own configuration file.

The command you executed previously automatically generated the templated RTL sources. It implicitly used the default configuration file.
To override the default configuration file, define the following variable when you invoke `make`:
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

# to use OpenOCD semi-hosting for putchar and termination
make DEBUG=ON OPENOCD_SEMIHOSTING=ON sw
```

The `sw` target first generates some C header files which depend on the hardware configuration. Hence, the need to generate the software for the same configuration as your hardware. Afterwards, it recursively invokes the `make` target in the `sw` subdirectory to build the apps/kernels which have been developed in that directory.

The `DEBUG=ON` flag is used to tell the compiler to produce debugging symbols. It is necessary for the `annotate` target, showcased in the Debugging section of this guide, to work.

The `SELECT_RUNTIME` flag is set by default to `rtl`. To build the software with the Banshee runtime, set the flag to `banshee`.

___Note:__ the RTL is not the only source which is generated from the configuration file. The software stack also depends on the configuration file. Make sure you always build the software with the same configuration of the hardware you are going to run it on._

___Note:__ on GVSOC, it is better to use OpenOCD semi-hosting to prevent putchar from disturbing the DRAMSys timing model._

### Running a simulation

Run one of the executables which was compiled in the previous step on your Snitch cluster simulator of choice:

```shell
# Verilator
bin/snitch_cluster.vlt sw/apps/blas/axpy/build/axpy.elf

# Questa
bin/snitch_cluster.vsim sw/apps/blas/axpy/build/axpy.elf

# VCS
bin/snitch_cluster.vcs sw/apps/blas/axpy/build/axpy.elf

# Banshee
banshee --no-opt-llvm --no-opt-jit --configuration src/banshee.yaml --trace sw/apps/blas/axpy/build/axpy.elf
```

The Snitch cluster simulator binaries can be invoked from any directory, just adapt the relative paths in the preceding commands accordingly, or use absolute paths. We refer to the working directory where the simulation is launched as the simulation directory. Within it, you will find several log files produced by the RTL simulation.

The previous commands will launch the simulation on the console. QuestaSim simulations can also be launched with the QuestaSim GUI, by adapting the previous command to:

```shell
# Questa
bin/snitch_cluster.vsim.gui sw/apps/blas/axpy/build/axpy.elf
```

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
    uint32_t start_cycle = snrt_mcycle();

    // DM core does not participate in the computation
    if(snrt_is_compute_core())
        axpy(L, a, x, y, z);

    // Read the mcycle CSR
    uint32_t end_cycle = snrt_mcycle();
}

```

The `snrt.h` file implements the snRuntime API, a library of convenience functions to program Snitch cluster based systems. These sources are located under `target/snitch_cluster/sw/runtime/rtl` and are automatically referenced by our compilation scripts.

___Note:__ Have a look at the files inside `sw/snRuntime` in the root of this repository to see what kind of functionality the snRuntime API defines. Note this is only an API, with some base implementations. The Snitch cluster implementation of the snRuntime for RTL simulation can be found under `target/snitch_cluster/sw/runtime/rtl`. It is automatically built and linked with user applications thanks to our compilation scripts._

We will have to instead create the `data.h` file ourselves. Create a `target/snitch_cluster/sw/apps/axpy/data` folder to host the data for your kernel to operate on:

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

In this file we hardcode the data to be used by the kernel. This data will be loaded in memory together with your application code. In general, to verify your code you may want to randomly generate the above data. You may also want to test your kernel on different problem sizes, e.g. varying the length of the vectors, without having to manually rewrite the file. This can be achieved by generating the data header file with a Python script. You may have a look at the `sw/blas/axpy/scripts/datagen.py` script in the root of this repository as an example. As you can see, it reuses many convenience classes and functions for data generation from the `data_utils` module. Documentation for this module can be found [here](https://pulp-platform.github.io/snitch_cluster/rm/sim/data_utils.html).

#### Compiling the C Code

In your `axpy` folder, create a new file named `Makefile` with the following contents:

```make
APP     = axpy
SRCS    = src/axpy.c
INCDIRS = data

include ../common.mk
```

This Makefile will be invoked recursively by the top-level Makefile, compiling your source code into an executable with the name provided in the `APP` variable.

In order for the top-level Makefile to find your application, add your application's directory to the `APPS` variable in `sw.mk`:

```
APPS += sw/apps/axpy
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
bin/snitch_cluster.vsim sw/apps/axpy/build/axpy.elf
```

### Debugging and benchmarking

When you run the simulation, every core will log all the instructions it executes (along with additional information, such as the value of the registers before/after the instruction) in a trace file. The traces are located in the `logs` folder within the simulation directory. The traces are identified by their hart ID, that is a unique ID for every hardware thread (hart) in a RISC-V system (and since all our cores have a single thread that is a unique ID per core).

The simulation logs the traces in a non-human readable format with `.dasm` extension. To convert these to a human-readable form run:

```bash
make -j traces
```

If the simulation directory does not coincide with the current working directory, you will have to specify the path explicitly:

```bash
make -j traces SIM_DIR=<path_to_simulation_directory>
```

Detailed information on how to interpret the generated traces can be found [here](../../docs/ug/trace_analysis.md).

In addition to generating readable traces (`.txt` format), the above command also computes several performance metrics from the trace and appends them at the end of the trace. These can be collected into a single CSV file with the following target:

```bash
make logs/perf.csv
# View the CSV file
libreoffice logs/perf.csv
```

In this file you can find the `X_tstart` and `X_tend` metrics. These are the cycles in which a particular code region `X` starts and ends, and can hence be used to profile your code. Code regions are defined by calls to `snrt_mcycle()`. Every call to this function defines two code regions:
- the code preceding the call, up to the previous `snrt_mcycle()` call or the start of the source file
- the code following the call, up to the next `snrt_mcycle()` call or the end of the source file

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
    uint32_t start_cycle = snrt_mcycle();

    // DM core does not participate in the computation
    if(snrt_is_compute_core())
        axpy(L / snrt_cluster_compute_core_num(), a, x, y, z);

    // Read the mcycle CSR
    uint32_t end_cycle = snrt_mcycle();
}
```

Now re-run your kernel and compare the execution time of the compute region with the previous version.

## Code Reuse

As you may have noticed, there is a good deal of code which is independent of the hardware platform we execute our AXPY kernel on. This is true for the `data.h` file and possible data generation scripts. The Snitch AXPY kernel itself is not specific to the Snitch cluster, but can be ported to any platform which provides an implementation of the snRuntime API. An example is Occamy, with its own testbench and SW development environment.

It is thus preferable to develop the data generation scripts and Snitch kernels in a shared location, from which multiple platforms can take and include the code. The `sw` directory in the root of this repository was created with this goal in mind. For the AXPY example, shared sources are hosted under the `sw/blas/axpy` directory. As an example of how these shared sources are used to build an AXPY application for a specific platform (in this case the standalone Snitch cluster) you can have a look at the `target/snitch_cluster/sw/apps/blas/axpy`.

We recommend that you follow this approach also in your own developments for as much of the code which can be reused.
