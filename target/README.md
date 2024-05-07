# HW Targets

This subdirectory contains the supported systems and their simulation environment including testbenches and bootrom.

  - `shared`: contains the shared fesvr related testbench components.
  - `snitch_cluster`
    - `cfg`: containing the configuration files `*.hsjon` for a specific snax-cluster configuration. This is the only place where system specific parameters are set.
    - `generated`: contains the generated `bootdata.cc` and wrapper files for the snax cluster.
      - `snax-acc-1`
        - `csr_wrapper.sv`
        - `streamer_wrapper.sv`
        - `top_wrapper.sv`
        - `...`
      - `snax-acc-2`
    - `src`: contains the [Banshee](https://github.com/pulp-platform/banshee) configuration for the snitch cluster.
    - `sw`: contains all shared
      - `apps`: contains applications for the snitch cluster.
      - `runtime`: contains the HW specific runtime implementation for the snitch cluster.
        - `rtl`: RTL-related startup implmentations.
        - `banshee`: Banshee-related startup SW implmentations.
      - `tests`: lists of tests that can run on the snitch cluster.
        - `snax-cluster-1`
        - `snax-cluster-2`
      - `snax-lib`: C libraries to run specific kernels on a snax-cluster.
        - `snax-cluster-1`
        - `snax-cluster-2`
    - `test`: contains testharness and bootrom of the snitch cluster
