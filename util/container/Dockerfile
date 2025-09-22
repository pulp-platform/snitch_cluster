# Copyright 2020 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Docker container for Snitch development.

ARG VERILATOR_VERSION=5.034
ARG UBUNTU_VERSION=22.04
ARG PYTHON_VERSION=3.11
# Run dpkg without interactive dialogue
ARG DEBIAN_FRONTEND=noninteractive

#-------------------------------------------------------------------------------
# Stage 1: Tool builder
# Installs generic tool binaries.
#------------------------------------------------------------------------------

FROM ubuntu:${UBUNTU_VERSION} AS tool-builder
ARG BENDER_VERSION=0.28.1
ARG DOXYGEN_VERSION=1.12.0
ARG SNITCH_LLVM_VERSION=15.0.0-snitch-0.2.0
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

#-------------------------------------------------------------------------------
# Stage 2: Hardware development stage
# Builds on Verilator image and installs all tools required for both hardware
# and software development.
#------------------------------------------------------------------------------

FROM verilator/verilator:v${VERILATOR_VERSION} AS snitch_cluster-hw
ARG PYTHON_VERSION
ARG DEBIAN_FRONTEND

LABEL version="0.1"
LABEL description="Snitch container for hardware and software development."
LABEL maintainer="colluca@iis.ee.ethz.ch"
LABEL org.opencontainers.image.source=https://github.com/pulp-platform/snitch_cluster

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        # General requirements
        curl wget build-essential git \
        # Required for python
        software-properties-common gnupg2 \
        # Required for fesvr
        device-tree-compiler && \
    # Install Python (both binaries and headers)
    apt-add-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        python${PYTHON_VERSION}-venv \
        python${PYTHON_VERSION}-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Copy all needed files to install the package
COPY . /repo

# Create and activate virtual environment
ENV VIRTUAL_ENV="/root/.venvs/snitch_cluster"
RUN python${PYTHON_VERSION} -m venv ${VIRTUAL_ENV}

# Copy the tools from the builder stage
COPY --from=tool-builder /tools/bender /tools/bin/
COPY --from=tool-builder /tools/doxygen/bin/doxygen /tools/bin/
COPY --from=tool-builder /tools/riscv-llvm /tools/riscv-llvm

# Modify environment and path variables
ENV SN_VLT="verilator"
ENV SN_LLVM_BINROOT="/tools/riscv-llvm/bin"
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
ENV PATH="/tools/bin:${PATH}"
ENV PATH="/tools/riscv-llvm/bin:${PATH}"
ENV PATH="/repo/target/sim/build/bin:${PATH}"

# Upgrade pip and install packages using the virtual environment's pip
# Don't cache pip files to avoid polluting the docker container
# Install torch from the CPU-only index to avoid installing the GPU version.
# Since we previously added the venv's bin/ directory to the path, pip here resolves to that.
ARG PIP_NO_CACHE_DIR=1
RUN pip install --upgrade pip && \
    pip install torch --index-url https://download.pytorch.org/whl/cpu && \
    pip install /repo[all]

#-------------------------------------------------------------------------------
# Stage 3: Hardware build
# Builds a Verilated model of the default Snitch cluster.
#------------------------------------------------------------------------------

FROM snitch_cluster-hw AS hw-builder

# Copy the snitch_cluster repository from the build context into /repo
COPY . /repo
# Build the verilator model
RUN cd /repo && make verilator

#-------------------------------------------------------------------------------
# Stage 4: Software development stage
# Copies the Verilated model and all (and only) tools required for software
# development from the previous stages.
#------------------------------------------------------------------------------

FROM ubuntu:${UBUNTU_VERSION} AS snitch_cluster-sw
ARG PYTHON_VERSION
ARG DEBIAN_FRONTEND

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        # General requirements
        curl wget build-essential git \
        # Required for python
        software-properties-common gnupg2 && \
    # Install Python (both binaries and headers)
    apt-add-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        python${PYTHON_VERSION}-venv \
        python${PYTHON_VERSION}-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Copy all needed files to install the package
COPY . /repo

# Create and activate virtual environment
ENV VIRTUAL_ENV="/root/.venvs/snitch_cluster"
RUN python${PYTHON_VERSION} -m venv ${VIRTUAL_ENV}

# Copy the tools from the builder stages
COPY --from=tool-builder /tools/bender /tools/bin/
COPY --from=tool-builder /tools/doxygen/bin/doxygen /tools/bin/
COPY --from=tool-builder /tools/riscv-llvm /tools/riscv-llvm
COPY --from=hw-builder /repo/target/sim/build/bin/snitch_cluster_bin.vlt /tools/bin/snitch_cluster.vlt

# Modify environment and path variables
ENV SN_LLVM_BINROOT="/tools/riscv-llvm/bin"
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
ENV PATH="/tools/bin:${PATH}"
ENV PATH="/tools/riscv-llvm/bin:${PATH}"

# Upgrade pip and install packages using the virtual environment's pip
# Don't cache pip files to avoid polluting the docker container
# Install torch from the CPU-only index to avoid installing the GPU version
# Since we previously added the venv's bin/ directory to the path, pip here resolves to that.
ARG PIP_NO_CACHE_DIR=1
RUN pip install --upgrade pip && \
    pip install torch --index-url https://download.pytorch.org/whl/cpu && \
    pip install /repo[all]
