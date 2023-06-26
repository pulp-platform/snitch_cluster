# Getting Started

In the following some quick start instructions are given. A more detailed documentation on how to use the Snitch cluster setup is given [here](../snitch_cluster/).

## Quick Start with Ubuntu Docker Image

This will take you through the necessary steps to get a sample program running on a cluster of Snitch cores.

1. Clone the repository.
   ```
   git clone https://github.com/pulp-platform/snitch_cluster.git --recurse-submodules
   ```
2. Start the Docker container containing all necessary development tools. If you
   do not want (or can not) use Docker please see the
   [prerequisites](#prerequisites) sections on how to obtain all required tools.
    ```
    docker run -it -v `pwd`/snitch_cluster:/repo -w /repo ghcr.io/pulp-platform/snitch_cluster
    ```
3. Enter the `snitch_cluster` target:
    ```
    cd target/snitch_cluster
    ```
4. Build the software.
    ```
    make sw
    ```
5. To simulate a cluster of Snitch cores you need to build the Verilator model for the Snitch cluster.
    ```
    make bin/snitch_cluster.vlt
    ```
6. Rrun sample tests and applications on the Verilator model.
    ```
    ./sw/tests/run.py sw/tests/passing-apps.list --simulator verilator
    ./sw/apps/run.py sw/apps/passing-apps.list --simulator verilator
    ```
6. Generate the annotated traces and inspect the trace for core 0.
    ```
    make traces
    less trace_hart_00000000.txt
    ```
    Optionally you can inspect the dumped waveforms (`snitch_cluster.vcd`).
    `spike-dasm` is required to generate the traces. Using the source from this repository supports disassembly of Snitch-custom instructions.
    ```
    cd sw/vendor/riscv-isa-sim
    mkdir build; cd build
    ../configure; make spike-dasm
    ```
7. Visualize the traces with the `util/trace/tracevis.py` script.
    ```
    ./util/trace/tracevis.py -o trace.json sw/build/benchmark/benchmark-matmul-all hw/system/snitch_cluster/logs/trace_hart_*.txt
    ```
    The generated JSON file can be visualized with [Trace-Viewer](https://github.com/catapult-project/catapult/tree/master/tracing), or by loading it into Chrome's `about:tracing`. You can check out an example trace [here](../example_trace.html).
8. Annotate the traces with the `util/trace/annotate.py` script.
    ```
    ./util/trace/annotate.py -o annotated.s sw/build/benchmark/benchmark-matmul-all hw/system/snitch_cluster/logs/trace_hart_00001.txt
    ```
    The generated `annotated.s` interleaves source code with retired instructions.

## Quick Start on IIS Machines

First, be aware of the shell which you are using.

1. We recommend using bash:
    ```bash
    bash
    ```
2. Clone the repository and enter the directory.
   ```bash
   git clone https://github.com/pulp-platform/snitch_cluster.git --recurse-submodules
   cd snitch_cluster
   ```
3. Set the correct environmental variables to ensure you are using the correct tool versions.
    ```bash
    export PYTHON=/usr/local/anaconda3-2022.05/bin/python3
    export BENDER=bender-0.27.1
    export CC=gcc-9.2.0
    export CXX=g++-9.2.0
    export VCS=vcs-2020.12
    export VERILATOR=verilator-4.110
    export QUESTA=questa-2022.3
    export LLVM_BINROOT=/usr/pack/riscv-1.0-kgf/pulp-llvm-0.12.0/bin
    ```
4. Install the python dependencies.
    ```bash
    $PYTHON -m venv .venv
    source .venv/bin/activate
    pip install -r python-requirements.txt
    ```
5. Enter the `snitch_cluster` target.
    ```bash
    cd target/snitch_cluster
    ```
6. Build the software.
    ```bash
    make sw
    ```
7. Compile the hardware for **Verilator** and run the SW tests.
    ```bash
    $VERILATOR make bin/snitch_cluster.vlt
    $VERILATOR ./sw/test/run.py sw/tests/passing-apps.list --simulator verilator
    $VERILATOR ./sw/apps/run.py sw/apps/passing-apps.list --simulator verilator
    ```
    or compile the hardware for **VCS** and run the SW tests.
    ```bash
    $VCS make bin/snitch_cluster.vcs
    $VCS ./sw/test/run.py sw/tests/passing-apps.list --simulator vcs
    $VCS ./sw/apps/run.py sw/apps/passing-apps.list --simulator vcs
    ```
    or compile the hardware for **Modelsim** and run the SW tests.
    ```bash
    $QUESTA make bin/snitch_cluster.vsim
    $QUESTA ./sw/test/run.py sw/tests/passing-apps.list --simulator vsim
    $QUESTA ./sw/apps/run.py sw/apps/passing-apps.list --simulator vsim
    ```

## Prerequisites

We recommend using the Docker container. If that should not be possible (because
of missing privileges for example) you can install the required tools and
components yourself.

We recommend a reasonable new Linux distribution, for example, Ubuntu 18.04:

- Install essential packages:
    ```
    sudo apt-get install build-essential python3 python3-pip python3-setuptools python3-wheel
    ```
- Install the Python requirements using:
    ```
    pip3 install --user -r python-requirements.txt
    ```
- We are using `Bender` for file list generation. The easiest way to obtain `Bender` is through its binary release channel:
    ```
    curl --proto '=https' --tlsv1.2 https://pulp-platform.github.io/bender/init -sSf | sh
    ```
- Finally, get a RISC-V toolchain. We recommend obtaining binary releases for your operating system from [SiFive's SW site](https://www.sifive.com/software).
    - Unpack the toolchain to a location of your choice (assuming `$RISCV` here). For example for Ubuntu you do:
      ```
      mkdir -p $RISCV && tar -x -f riscv64-unknown-elf-gcc-8.3.0-2020.04.0-x86_64-linux-ubuntu14.tar.gz --strip-components=1 -C $RISCV
      ```
    - Add the `$RISCV/bin` folder to your path variable.
      ```
      export PATH=$RISCV/bin:$PATH
      ```
    - The downloaded toolchain is a multi-lib toolchain, nevertheless our SW scripts currently expect binaries named `riscv32-*`. You can just alias `riscv64-*` to `riscv32-*` using:
      ```
      cd $RISCV/bin && for file in riscv64-*; do ln -s $file $(echo "$file" | sed 's/^riscv64/riscv32/g'); done
      ```

An alternative way, if you have Rust installed, is `cargo install bender`.

### Tool Requirements

- `bender >= 0.21`
- `verilator >= 4.100`

### Software Development

- The `banshee` simulator is built using Rust. We recommend [`rustup`](https://rustup.rs/) if you haven't installed Rust already.
- C/C++ code is formatted using `clang-format`.

### Hardware Development

- We use `verible` for style linting. Either build it from [source](https://github.com/google/verible) or, if available for your platform,  use one of the [pre-built images](https://github.com/google/verible/releases).
- We support simulation with Verilator, VCS and Modelsim.
