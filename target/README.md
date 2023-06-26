# HW Targets

This subdirectory contains the supported systems and their simulation environment including testbenches and bootrom.

  - `shared`: contains the shared fesvr related testbench components.
  - `snitch_cluster`
    - `cfg`: containing the configuration files `*.hsjon`.
    - `generated`: contains the generated `bootdata.cc` and RTL wrapper for the snitch cluster `snitch_cluster_wrapper.sv`.
    - `src`: contains the [Banshee](https://github.com/pulp-platform/banshee) configuration for the snitch cluster.
    - `sw`: contains all shared
      - `apps`: contains applications for the snitch cluster.
      - `runtime`: contains the HW specific runtime implementation for the snitch cluster.
        - `rtl`: RTL-related startup implmentations.
        - `banshee`: Banshee-related startup SW implmentations.
      - `tests`: lists of tests that can run on the snitch cluster.
    - `test`: contains testharness and bootrom of the snitch cluster