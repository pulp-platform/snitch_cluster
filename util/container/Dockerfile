# Copyright 2020 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Docker container for Snitch development.

# 1. Stage: Use the verilator container to get the Verilator binary.
ARG VERILATOR_VERSION=5.020
ARG UBUNTU_VERSION=22.04

# 1. Stage: Install additional IIS tools
FROM ubuntu:${UBUNTU_VERSION} AS builder
ARG BENDER_VERSION=0.28.1
ARG DOXYGEN_VERSION=1.12.0
ARG SNITCH_LLVM_VERSION=latest
ARG RUST_VERSION=1.63.0
ARG UBUNTU_VERSION
# Run dpkg without interactive dialogue
ARG DEBIAN_FRONTEND=noninteractive

# Install APT requirements
RUN apt-get update && \
    apt-get install -y \
        # General requirements
        curl wget git tar \
        # Required for rust
        build-essential
        #\
        # # Required for banshee
        # cmake llvm-12-dev libclang-common-12-dev zlib1g-dev

# # Build Rust tools
# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# ENV PATH="/root/.cargo/bin:${PATH}"
# RUN rustup install ${RUST_VERSION} && \
#     rustup override set ${RUST_VERSION}

# Change working directory
WORKDIR /tools

# # Install `banshee` (needs cmake)
# RUN git clone https://github.com/pulp-platform/banshee.git /tmp/banshee --recurse-submodules && \
#     cargo install --path /tmp/banshee

# Install Bender
RUN wget https://github.com/pulp-platform/bender/releases/download/v${BENDER_VERSION}/bender-${BENDER_VERSION}-x86_64-linux-gnu-ubuntu${UBUNTU_VERSION}.tar.gz && \
    tar xzf bender-${BENDER_VERSION}-x86_64-linux-gnu-ubuntu${UBUNTU_VERSION}.tar.gz

# Install Doxygen
RUN wget https://www.doxygen.nl/files/doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz && \
    tar xzf doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz && \
    mv doxygen-${DOXYGEN_VERSION} doxygen

# Get the precompiled LLVM toolchain
RUN latest_tag=`curl -s -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/pulp-platform/llvm-project/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'` && \
echo "SNITCH_LLVM_VERSION=${SNITCH_LLVM_VERSION} LLVM_TAR=${LLVM_TAR} latest_tag=${latest_tag}" && \
test "${SNITCH_LLVM_VERSION}" = "latest" && SNITCH_LLVM_VERSION=${latest_tag} || : ; \
LLVM_TAR=riscv32-pulp-llvm-ubuntu2004-$(echo $SNITCH_LLVM_VERSION | cut -d '-' -f3-).tar.gz && \
mkdir -p riscv-llvm && \
echo "SNITCH_LLVM_VERSION=${SNITCH_LLVM_VERSION} LLVM_TAR=${LLVM_TAR} latest_tag=${latest_tag}" && \
wget -qO- https://github.com/pulp-platform/llvm-project/releases/download/${SNITCH_LLVM_VERSION}/${LLVM_TAR} | \
tar xvz --strip-components=1 -C riscv-llvm

# 2. Stage: Create the final container
FROM verilator/verilator:v${VERILATOR_VERSION} AS snitch_cluster
ARG PYTHON_VERSION=3.11
# Run dpkg without interactive dialogue
ARG DEBIAN_FRONTEND=noninteractive

LABEL version="0.1"
LABEL description="Snitch container for hardware and software development."
LABEL maintainer="zarubaf@iis.ee.ethz.ch"
LABEL org.opencontainers.image.source=https://github.com/pulp-platform/snitch_cluster

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        # General requirements
        curl wget build-essential git \
        # Required for python
        software-properties-common gnupg2 \
        # Required for fesvr
        device-tree-compiler && \
    # Install Python
    apt-add-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        python${PYTHON_VERSION}-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Copy all needed files to install the package
COPY pyproject.toml .
COPY sw ./sw
COPY util ./util

# Create and activate virtual environment
ARG VIRTUAL_ENV="/root/.venvs/snitch_cluster"
RUN python${PYTHON_VERSION} -m venv ${VIRTUAL_ENV}

# Upgrade pip and install packages using the virtual environment's pip
RUN ${VIRTUAL_ENV}/bin/pip install --upgrade pip && \
    ${VIRTUAL_ENV}/bin/pip install .

# Copy the tools from the builder stage
COPY --from=builder /tools/bender /tools/bin/
# COPY --from=builder /root/.cargo/bin/banshee /tools/bin/
COPY --from=builder /tools/doxygen/bin/doxygen /tools/bin/
COPY --from=builder /tools/riscv-llvm /tools/riscv-llvm

# Modify environment and path variables
ENV VLT="verilator-wrap.sh"
ENV LLVM_BINROOT="/tools/riscv-llvm/bin"
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
ENV PATH="/tools/bin:${PATH}"
ENV PATH="/tools/riscv-llvm/bin:${PATH}"
