# Copyright 2020 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
# 
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>
# 
# Docker containers for Snitch hardware and software development.

# Ubuntu version must be aligned with OSEDA version
ARG OSEDA_VERSION=2025.07
ARG UBUNTU_VERSION=24.04
# Run dpkg without interactive dialogue
ARG DEBIAN_FRONTEND=noninteractive
ARG REPO_DIR=/repo
ARG TOOL_DIR=/tools

#-------------------------------------------------------------------------------
# Stage 1: Tool builder
# Installs generic tool binaries.
#------------------------------------------------------------------------------

FROM ubuntu:${UBUNTU_VERSION} AS tool-builder
ARG BENDER_VERSION=0.28.2
ARG DOXYGEN_VERSION=1.12.0
ARG SNITCH_LLVM_VERSION=15.0.0-snitch-0.5.0
ARG UBUNTU_VERSION
ARG DEBIAN_FRONTEND

# Install APT requirements
RUN apt-get update && \
    apt-get install -y \
    # General requirements
    curl wget git tar

# Change working directory
WORKDIR /tools

# Install Bender
RUN wget https://github.com/pulp-platform/bender/releases/download/v${BENDER_VERSION}/bender-${BENDER_VERSION}-x86_64-linux-gnu-ubuntu${UBUNTU_VERSION}.tar.gz && \
    tar xzf bender-${BENDER_VERSION}-x86_64-linux-gnu-ubuntu${UBUNTU_VERSION}.tar.gz

# Install Doxygen
RUN wget https://www.doxygen.nl/files/doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz && \
    tar xzf doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz && \
    mv doxygen-${DOXYGEN_VERSION} doxygen

# Get the precompiled LLVM toolchain
RUN wget https://github.com/pulp-platform/llvm-project/releases/download/${SNITCH_LLVM_VERSION}/riscv32-snitch-llvm-ubuntu2204-${SNITCH_LLVM_VERSION}.tar.gz && \
    tar xvf riscv32-snitch-llvm-ubuntu2204-${SNITCH_LLVM_VERSION}.tar.gz && \
    mv riscv32-snitch-llvm-ubuntu2204-${SNITCH_LLVM_VERSION} riscv-llvm

# Install uv
ENV UV_INSTALL_DIR=/tools
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh

#-------------------------------------------------------------------------------
# Stage 2: Hardware development stage
# Builds on open-source EDA tool image from Harald Pretl and installs all tools
# required for both hardware and software development.
#------------------------------------------------------------------------------

FROM hpretl/iic-osic-tools:${OSEDA_VERSION} AS oseda

FROM ubuntu:${UBUNTU_VERSION} AS snitch_cluster-hw
ARG DEBIAN_FRONTEND
ARG REPO_DIR
ARG TOOL_DIR

LABEL version="0.1"
LABEL description="Snitch container for hardware and software development."
LABEL maintainer="colluca@iis.ee.ethz.ch"
LABEL org.opencontainers.image.source=https://github.com/pulp-platform/snitch_cluster

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        # General requirements
        curl wget build-essential git ca-certificates \
        # Required for Verilator
        ccache mold binutils \
        # Required for fesvr
        device-tree-compiler \
        # Shared libraries required by yosys (see https://github.com/iic-jku/IIC-OSIC-TOOLS/blob/main/_build/images/base-dev/scripts/install.sh)
        libboost-filesystem-dev \
        libboost-python-dev \
        libexpat1-dev \
        libffi-dev \
        libreadline-dev \
        libz-dev \
        python3-dev \
        tcl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Copy tools from the builder stage
COPY --from=tool-builder /tools/bender ${TOOL_DIR}/bin/
COPY --from=tool-builder /tools/uv ${TOOL_DIR}/bin/
COPY --from=tool-builder /tools/doxygen/bin/doxygen ${TOOL_DIR}/bin/
COPY --from=tool-builder /tools/riscv-llvm ${TOOL_DIR}/riscv-llvm

# Copy tools from OSEDA container
COPY --from=oseda /foss/tools/verilator ${TOOL_DIR}/verilator
COPY --from=oseda /foss/tools/yosys ${TOOL_DIR}/yosys

# Overwrite .bashrc to make sure PYTHONPATH variable does not conflict with uv
RUN echo "export PS1='\[\033[0;32m\]\w >\[\033[0;38m\] '" > ~/.bashrc

# Modify environment and path variables
ENV SN_LLVM_BINROOT="${TOOL_DIR}/riscv-llvm/bin"
ENV PATH="${REPO_DIR}/target/sim/build/bin:${PATH}"
ENV PATH="${TOOL_DIR}/bin:${PATH}"
ENV PATH="${TOOL_DIR}/verilator/bin:${PATH}"
ENV PATH="${TOOL_DIR}/yosys/bin:${PATH}"

# Define uv environment
ENV UV_LINK_MODE=copy
ENV SN_UV="uv run --all-extras"

# Define default working directory and entrypoint
WORKDIR ${REPO_DIR}
ENTRYPOINT ["/bin/bash"]

#-------------------------------------------------------------------------------
# Stage 3: Hardware build
# Builds a Verilated model of the default Snitch cluster.
#------------------------------------------------------------------------------

FROM snitch_cluster-hw AS hw-builder
ARG REPO_DIR

# Copy the snitch_cluster repository from the build context into ${REPO_DIR}
COPY . ${REPO_DIR}
WORKDIR ${REPO_DIR}

# Build the verilator model
RUN make verilator

#-------------------------------------------------------------------------------
# Stage 4: Software development stage
# Copies the Verilated model and all (and only) tools required for software
# development from the previous stages.
#------------------------------------------------------------------------------

FROM ubuntu:${UBUNTU_VERSION} AS snitch_cluster-sw
ARG PYTHON_VERSION
ARG DEBIAN_FRONTEND
ARG REPO_DIR

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        # General requirements
        curl wget build-essential git ca-certificates && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Copy the tools from the builder stages
COPY --from=tool-builder /tools/bender /tools/bin/
COPY --from=tool-builder /tools/uv /tools/bin/
COPY --from=tool-builder /tools/doxygen/bin/doxygen /tools/bin/
COPY --from=tool-builder /tools/riscv-llvm /tools/riscv-llvm
COPY --from=hw-builder ${REPO_DIR}/target/sim/build/bin/snitch_cluster_bin.vlt /tools/bin/snitch_cluster.vlt

# Modify environment and path variables
ENV SN_LLVM_BINROOT="/tools/riscv-llvm/bin"
ENV PATH="/tools/bin:${PATH}"

# Define uv environment
ENV UV_LINK_MODE=copy
ENV SN_UV="uv run --all-extras"

# Define default working directory and entrypoint
WORKDIR /foss/designs/snitch_cluster
ENTRYPOINT ["/bin/bash"]
