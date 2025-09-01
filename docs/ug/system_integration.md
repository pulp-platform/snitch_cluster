# Integrating the Snitch cluster in an SoC

While this repository provides many IPs that can be reused independently, we suggest to integrate the Snitch cluster as a whole, that is the `snitch_cluster` module, in derived systems.

The `snitch_cluster` module is implemented in [snitch_cluster.sv](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/hw/snitch_cluster/src/snitch_cluster.sv), and is highly configurable. Shall you need to extend the Snitch cluster, reach out to us before considering to fork the repository to implement your changes. We can discuss possibilities to extend the upstream Snitch cluster to suit your needs.

For a reference implementation of the procedure described in the following sections, you may refer to Snitch's integration in [Picobello](https://github.com/pulp-platform/picobello).

## Configurability

A reference instantiation of the Snitch cluster can be found in the testbench used to test the cluster within this repository, see [testharness.sv](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/target/sim/tb/testharness.sv).

As you may note, we do not instantiate the `snitch_cluster` directly but a so-called `snitch_cluster_wrapper`, with a much simplified interface. All parameters of the `snitch_cluster` module are set within the wrapper.

The benefit of the wrapper is that it can be programmatically generated from a single source of truth, namely a JSON5 configuration file, from which the software hardware abstraction layer (HAL), and all other sources dependent on the configuration within the repository, are also generated.

This way, if you want to modify the cluster configuration, you don't have to go and manually change it in multiple places (the RTL, the HAL, etc.), but only in the single-source-of-truth cluster configuration file. More information on the configuration file can be found in the [tutorial](tutorial.md#configuring-the-hardware).

We suggest that the same approach is used when integrating the Snitch cluster in an SoC. This further allows you to easily test different configurations of the cluster inside your SoC.

## Generating the RTL

We provide Make rules to generate the cluster wrapper and other RTL files. Include the following lines in a Makefile, to inherit Snitch's rules:
```Makefile
SN_ROOT = $(shell $(BENDER) path snitch_cluster)

# Customization options should precede the following lines

include $(SN_ROOT)/make/common.mk
include $(SN_ROOT)/make/rtl.mk
```

You can then use the `sn-rtl` and `sn-clean-rtl` targets to respectively build and clean all of Snitch's generated RTL sources.

!!! note
    Snitch's Makefiles require `SN_ROOT` to be defined and to point to the root of the Snitch cluster repository. You can set this however you prefer, i.e. you don't have to use Bender if you manage your dependencies in a different way.

!!! note
    The `common.mk` fragment is required by all of the make fragments presented in the subsequent sections, so it must included before the others. 

The included Makefiles can be customized to some extent by overriding some variables before the Makefile inclusion lines.

By default, the build directories of all auto-generated sources live in the Snitch cluster repo. If you are simultaneously working on the Snitch cluster and your derived system repos, it may be beneficial to have separate build directories for your artifacts, to avoid having to regenerate the sources for the right target every time you switch between the two.

To overwrite the build directory for the generated cluster wrapper, add the following customization line to your Makefile, to point `SN_GEN_DIR` to a directory of your choice:
```Makefile
SN_GEN_DIR = $(SYSTEM_GENERATED_RTL_DIR)
```

## Integrating the hardware

Assuming you use Bender to manage your hardware dependencies, add the following lines to your `Bender.yml` file to make all Snitch cluster hardware available to your project:
```yaml
dependencies:
  snitch_cluster: { git: "https://github.com/pulp-platform/snitch_cluster.git", rev: "<hash>" }

sources:
  - <SN_GEN_DIR>/snitch_cluster_pkg.sv
  - <SN_GEN_DIR>/snitch_cluster_wrapper.sv
```

Additionally, add the `-t snitch_cluster` target flag to your `bender` commands.

## Integrating the software

The Snitch cluster repo comes with a collection of software tests and kernels.

You can reuse the Snitch cluster's Make rules to build all tests and kernels found in the Snitch repo.
Include the following line in a Makefile, to inherit Snitch's rules:
```Makefile
# Customization options should precede the following line

include $(SN_ROOT)/make/sw.mk
```

The included Makefile(s) can be customized to some extent by overriding some variables before the Makefile inclusion line.
The following subsections illustrate a few common customization options.

!!! info
    For further information on available customization options you may want to take a look inside the recursively included Makefiles.

### Customizing the Snitch runtime

The Snitch runtime library abstracts away all the low-level characteristics of the system, allowing Snitch applications to be written in a mostly system-independent way, and to be portable to any multi-cluster Snitch-based system. As such, Snitch applications must be linked against an implementation of the runtime library.

The runtime sources themselves are written in a mostly system-independent manner, building on top of a small set of system-dependent functions and macro definitions which define a hardware abstraction layer (HAL) for the Snitch runtime.
Any system that requires its own HAL must provide its own implementation of the Snitch runtime.
A sample implementation of the Snitch runtime for this repository's simulation target can be found in [`sw/runtime/impl`](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/sw/runtime/impl).

Assuming your runtime implementation adopts a similar file structure, you can simply point to it, by adding the following line to your Makefile:
```Makefile
SN_RUNTIME_SRCDIR = $(SYSTEM_SW_DIR)/snitch/runtime/src
```

Shall the file structure differ, you may have to adapt some more flags. For example, if you want to include files from newly created directories you need to add them to `SN_RUNTIME_INCDIRS`:
```Makefile
SN_RUNTIME_INCDIRS = $(SYSTEM_SW_INCDIR)
```

Also, it is common to make use of auto-generated system-dependent headers, e.g. an addrmap header generated from an RDL description.

To make sure these headers are tracked as prerequisites of the runtime, and are thus automatically built when the runtime is built, append them to the `SN_RUNTIME_HAL_HDRS` variable:
```Makefile
SN_RUNTIME_HAL_HDRS += $(SYSTEM_ADDRMAP_H)
```

It is up to you to provide Make rules to build the auto-generated headers.

### Customizing build directories and kernels

If you are simultaneously working on the Snitch cluster and your derived system repos, it may be beneficial to have separate build directories for your artifacts, to avoid having to recompile the software for the right target every time you switch between the two.

You can customize the build directories for the Snitch runtime and tests using the following lines, e.g.:
```Makefile
SN_RUNTIME_BUILDDIR = $(SYSTEM_SW_DIR)/snitch/runtime/build
SN_TESTS_BUILDDIR   = $(SYSTEM_SW_DIR)/snitch/tests/build
SN_RVTESTS_BUILDDIR = $(SYSTEM_SW_DIR)/snitch/riscv-tests/build
```

For kernels, you will probably want to also have your own local data configuration file, as e.g. systems of different scale will typically work with different problem sizes. For this reason, if you intend to heavily work on a kernel, we suggest recreating a local kernel directory altogether.

Following the standard kernel directory structure, a minimal kernel directory which reuses the scripts and sources provided in the Snitch repo could look like:
```
axpy/
├── app.mk
└── data/
    └── params.json
```

You may then add this, as well as any system-dependent kernel you may develop in the system repository, to the build targets by appending them to the `SN_APPS` variable:
```Makefile
SN_APPS += $(SYSTEM_SW_DIR)/snitch/kernels/blas/axpy
```

If you do not intend to build all kernels provided by Snitch, you may further disable the `SN_BUILD_APPS` option:
```Makefile
SN_BUILD_APPS = OFF
```
As a result, only the kernels you explicitly added to `SN_APPS` will be built.

## Integrating the trace generation

Include the following Make fragment in your Makefile to inherit Snitch's trace generation rules:
```Makefile
include $(SN_ROOT)/make/traces.mk
```

## Integrating the environment requirements

Many of the targets you integrated in the previous steps make use of Python scripts, and other executables, behind the scenes.

To make sure all Python scripts find their requirements, add the following line to your environment setup script.
```shell
python -m pip install $(shell $(BENDER) path snitch_cluster)
```

To make sure other required executables are found, add the following variable to your environment:
```shell
export SN_LLVM_BINROOT=<path_to_snitch_llvm_toolchain>
```

## Auto-dependency generation

In cases where a target may have many prerequisites, it is sometimes convenient and less error-prone to track these programmatically, rather than by hand. As an example consider an executable which may depend on many header/source files. Compilers typically provide an option, e.g. `gcc -MM`, to generate a Make fragment listing all the prerequisites of an executable target, also referred to as a dependency file, typically ending with `.d` extension.
By including a generated dependency file in a Makefile you can track all prerequisites of a target programmatically.

If an included dependency file does not exist, GNU Make will automatically search for a rule to build it, execute the rule and finally include and parse the dependency file.
This process is done upon any Make execution, no matter if the goal being executed actually needs a certain dependency file or not.
This may be time-consuming and confusing for a user of an external system.
In order to speed up this process, we use the `list-dependent-make-targets` utility, to conditionally include a dependency file only if a target which requires it is specified as a goal on the command-line.

For this to work, every Make fragment presented in the previous sections appends its dependency files to the `SN_DEPS` variable.
The `sn_include_deps` function is then provided to conditionally include all the dependency files in `SN_DEPS`, as described above.
To reuse this infrastructure simply add the following line to your top-level Makefile:
```
$(call sn_include_deps)
```

!!! important
    This line must appear after the inclusion of all other Make fragments, i.e. after all dependency files have been appended to `SN_DEPS`.

!!! tip
    For more information on auto-dependency generation with GNU Make consult https://make.mad-scientist.net/papers/advanced-auto-dependency-generation/.
