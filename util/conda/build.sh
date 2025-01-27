#!/bin/bash
# Copyright 2024 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
 
# Function to build multiple snitch_cluster.vlt instances
build_snax_verilator() {
    local config_file="$1"
    local target_dir="$2"
    
    if [ -z "$config_file" ]; then
        echo "Error: Configuration file not provided"
        echo "Usage: build_snitch_cluster <config_file>"
        return 1
    fi

    if [ ! -f "target/snitch_cluster/$config_file" ]; then
        echo "Error: Configuration file '$config_file' not found"
        return 1
    fi 
    
    # Generate RTL
    make -C target/snitch_cluster rtl-gen \
        CFG_OVERRIDE="$config_file"
    
    # Build software
    make DEBUG=ON sw -j$(nproc) \
        -C target/snitch_cluster \
        SELECT_TOOLCHAIN=llvm-generic \
        SELECT_RUNTIME=rtl-generic \
        CFG_OVERRIDE="$config_file"
    
    # Generate Verilator files
    make -C target/snitch_cluster bin/snitch_cluster.vlt \
        CFG_OVERRIDE="$config_file" -j$(nproc)
    
    echo "Build completed for '$config_file' successfully"

    mkdir -p ${target_dir}-rtl/bin
    cp target/snitch_cluster/bin/snitch_cluster.vlt ${target_dir}-rtl/bin/snitch_cluster.vlt
    mkdir -p ${target_dir}/target/snitch_cluster/sw/runtime
    cp -R target/snitch_cluster/sw/runtime/rtl ${target_dir}/target/snitch_cluster/sw/runtime
    cp -R target/snitch_cluster/sw/runtime/rtl-generic ${target_dir}/target/snitch_cluster/sw/runtime
    cp -R target/snitch_cluster/sw/runtime/common ${target_dir}/target/snitch_cluster/sw/runtime
    cp -R target/snitch_cluster/sw/snax ${target_dir}/target/snitch_cluster/sw
    mkdir -p ${target_dir}/sw/deps
    cp -R sw/snRuntime ${target_dir}/sw
    cp -R sw/math ${target_dir}/sw
    cp -R sw/deps/riscv-opcodes ${target_dir}/sw/deps
    cp -R sw/deps/printf ${target_dir}/sw/deps

    echo "Successfully installed in '$target_dir'"

    make -C target/snitch_cluster clean \
        CFG_OVERRIDE="$config_file" -j$(nproc)

    return 0
}

export VLT_ROOT="${BUILD_PREFIX}/share/verilator"
PIP_NO_INDEX= pip install hjson #Unset PIP_NO_INDEX to allow pypi installation
wget https://github.com/pulp-platform/riscv-isa-sim/releases/download/snitch-v0.1.0/snitch-spike-dasm-0.1.0-x86_64-linux-gnu-ubuntu18.04.tar.gz
tar xzf snitch-spike-dasm-0.1.0-x86_64-linux-gnu-ubuntu18.04.tar.gz
rm snitch-spike-dasm-0.1.0-x86_64-linux-gnu-ubuntu18.04.tar.gz
mkdir -p ${PREFIX}/bin
cp spike-dasm ${PREFIX}/bin/spike-dasm
mkdir -p ${PREFIX}/snax-utils
cp util/trace/gen_trace.py ${PREFIX}/snax-utils
build_snax_verilator cfg/snax_mac_cluster.hjson ${PREFIX}/snax-utils/snax-mac
build_snax_verilator cfg/snax_alu_cluster.hjson ${PREFIX}/snax-utils/snax-alu
build_snax_verilator cfg/snax_streamer_gemm_add_c_cluster.hjson ${PREFIX}/snax-utils/snax-streamer-gemm-add-c
build_snax_verilator cfg/snax_KUL_cluster.hjson ${PREFIX}/snax-utils/snax-kul-cluster-mixed-narrow-wide
