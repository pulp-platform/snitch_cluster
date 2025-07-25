# Integrating the Snitch cluster in an SoC

While this repository provides many IPs that can be reused independently, we suggest to integrate the Snitch cluster as a whole, that is the `snitch_cluster` module, in derived systems.

The `snitch_cluster` module is implemented in [snitch_cluster.sv](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/hw/snitch_cluster/src/snitch_cluster.sv).

## Configurability

A reference instantiation of the Snitch cluster can be found in the testbench used to test the cluster within this repository, see [testharness.sv](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/target/snitch_cluster/test/testharness.sv).

As you may note, we do not instantiate the `snitch_cluster` directly but a so-called `snitch_cluster_wrapper`, with a much simplified interface. All parameters of the `snitch_cluster` module are set within the wrapper.

The benefit of the wrapper is that it can be programmatically generated from a single source of truth, namely a JSON5 configuration file, from which the software hardware-abstraction layer (HAL), and all other sources dependent on the configuration within the repository, are also generated.

This way, if you want to modify the cluster configuration, you don't have to go and manually change it in multiple places (the RTL, the HAL, etc.), but only in the single-source-of-truth cluster configuration file. More information on the configuration file can be found in the [tutorial](tutorial.md#configuring-the-hardware).

We suggest that the same approach is used when integrating the Snitch cluster in an SoC. This allows you to easily test different configurations of the cluster inside your SoC.

## Integrating the RTL

We provide Make rules to generate the cluster wrapper and other RTL files. Include the following lines in a Makefile, to inherit Snitch's rules:
```Makefile
SN_ROOT = $(shell $(BENDER) path snitch_cluster)

include $(SN_ROOT)/target/common/common.mk
include $(SN_ROOT)/target/common/rtl.mk
```

!!! note
    Snitch's Makefiles require `SN_ROOT` to be defined and to point to the root of the Snitch cluster repository. You can set this however you prefer, i.e. you don't have to use Bender if you manage your dependencies in a different way.

You can then use the `sn-rtl` and `sn-clean-rtl` targets to respectively build and clean all of Snitch's generated RTL sources.
<!-- TODO(colluca): In Picobello we explicitly use the $(SN_CLUSTER_WRAPPER) $(SN_CLUSTER_PKG) variables to build only the generated sources that depend on the cluster config. Find a common ground, probably define targets for only those files. -->

## Integrating the software

Similarly, Snitch comes with a collection of software tests and applications. These build on the functions provided by the Snitch runtime library, so they must be linked against an implementation of the latter. The runtime library abstracts away all the low-level characteristics of the system, allowing applications to be written in a mostly system-independent way, and to be portable to any multi-cluster Snitch-based system.
To this end, every system must implement a hardware abstraction layer (HAL) for the Snitch runtime, which the mentioned infrastructure builds on.

Given a path to the platform-specific HAL sources, you can reuse the Snitch cluster's Make rules to build the runtime, tests and applications for the target platform.
Include the following lines in a Makefile, to inherit Snitch's rules:

```Makefile
SN_RUNTIME_HAL_DIR = sw/runtime/hal

include $(SN_ROOT)/target/common/sw.mk
```

The included Makefile(s) can be customized to some extent by overriding some variables before the Makefile inclusion line.
For example by setting `SNRT_BUILD_APPS = OFF` none of the default Snitch applications will be built.
You can explicitly set the list of applications to be built via the `SNRT_APPS` variable, which can include additional system-dependent applications you may develop in the system repository. For further information on the available customization options you may want to take a look inside the recursively included Makefiles.
