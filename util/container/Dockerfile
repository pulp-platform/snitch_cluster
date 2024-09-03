# Copyright 2020 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Docker container for Snitch development.

# 1. Stage
FROM ubuntu:22.04 AS builder
ARG BENDER_VERSION=0.27.1
ARG VERILATOR_VERSION=5.020
ARG PYTHON_VERSION=3.11
ARG DOXYGEN_VERSION=1.12.0
ARG RUST_VERSION=1.67.0
# Run dpkg without interactive dialogue
ARG DEBIAN_FRONTEND=noninteractive

# Install APT requirements
RUN apt update && \
    apt install -y \
        # General requirements
        curl wget git tar \
        # Required for Verilator
        autoconf flex bison help2man \
        libfl2 libfl-dev zlib1g zlib1g-dev \
        mold libgoogle-perftools-dev numactl \
        # Required for rust
        build-essential \
        # Required for banshee
        cmake llvm-12-dev libclang-common-12-dev

# Build Verilator
RUN git clone https://github.com/verilator/verilator && \
    cd verilator && \
    git checkout "v${VERILATOR_VERSION}" && \
    autoconf && \
    ./configure --prefix /tools/verilator && \
    make -j && \
    make install

# Build Rust tools
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup install ${RUST_VERSION} && \
    rustup override set ${RUST_VERSION}

# Change working directory
WORKDIR /tools

# Install `banshee` (needs cmake)
RUN git clone https://github.com/pulp-platform/banshee.git /tmp/banshee --recurse-submodules && \
    cargo install --path /tmp/banshee

# Install Bender
RUN wget https://github.com/pulp-platform/bender/releases/download/v${BENDER_VERSION}/bender-${BENDER_VERSION}-x86_64-linux-gnu-ubuntu18.04.tar.gz && \
    tar xzf bender-${BENDER_VERSION}-x86_64-linux-gnu-ubuntu18.04.tar.gz

# Install Doxygen
RUN wget https://www.doxygen.nl/files/doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz && \
    tar xzf doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz && \
    mv doxygen-${DOXYGEN_VERSION} doxygen

# 2. Stage
FROM ubuntu:22.04 AS snitch_cluster
ARG SNITCH_LLVM_VERSION=latest
ARG VERIBLE_VERSION=0.0-3318-g8d254167

LABEL version="0.1"
LABEL description="Snitch container for hardware and software development."
LABEL maintainer="zarubaf@iis.ee.ethz.ch"
LABEL org.opencontainers.image.source=https://github.com/pulp-platform/snitch_cluster

WORKDIR /tools

RUN apt update && \
    apt install -y --no-install-recommends \
        # General requirements
        curl \
        wget \
        build-essential \
        git \
        # Required for python
        software-properties-common \
        # Required for getting LLVM toolchain
        ca-certificates \
        gnupg2

# Get the precompiled LLVM toolchain
RUN latest_tag=`curl -s -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/pulp-platform/llvm-project/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'` && \
    echo "SNITCH_LLVM_VERSION=${SNITCH_LLVM_VERSION} LLVM_TAR=${LLVM_TAR} latest_tag=${latest_tag}" && \
    test "${SNITCH_LLVM_VERSION}" = "latest" && SNITCH_LLVM_VERSION=${latest_tag} || : ; \
    LLVM_TAR=riscv32-pulp-llvm-ubuntu2004-$(echo $SNITCH_LLVM_VERSION | cut -d '-' -f3-).tar.gz && \
    mkdir -p riscv-llvm && \
    echo "SNITCH_LLVM_VERSION=${SNITCH_LLVM_VERSION} LLVM_TAR=${LLVM_TAR} latest_tag=${latest_tag}" && \
    wget -qO- https://github.com/pulp-platform/llvm-project/releases/download/${SNITCH_LLVM_VERSION}/${LLVM_TAR} | \
    tar xvz --strip-components=1 -C riscv-llvm
ENV LLVM_BINROOT="/tools/riscv-llvm/bin"

# Install Verible
RUN wget https://github.com/chipsalliance/verible/releases/download/v${VERIBLE_VERSION}/verible-v${VERIBLE_VERSION}-linux-static-x86_64.tar.gz && \
    tar -x -f verible-v${VERIBLE_VERSION}-linux-static-x86_64.tar.gz --strip-components=1 -C . && \
    rm -rf verible-v${VERIBLE_VERSION}-linux-static-x86_64.tar.gz
ENV PATH="/tools/bin:${PATH}"

# Install Python
RUN apt-add-repository ppa:deadsnakes/ppa && \
    apt update && \
    apt install -y --no-install-recommends \
        python${PYTHON_VERSION} && \
    apt clean ; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Copy artifacts from stage 1.
COPY --from=builder /tools/bender bin/
COPY --from=builder /root/.cargo/bin/banshee bin/
COPY --from=builder /tools/doxygen/bin/doxygen bin/
COPY --from=builder /tools/verilator /tools/verilator/

# Add Verilator to PATH
ENV PATH "/tools/verilator/bin:${PATH}"
ENV VLT_ROOT "/tools/verilator/share/verilator/"

RUN which python${PYTHON_VERSION} && python${PYTHON_VERSION} --version

# Create and activate virtual environment
ENV VIRTUAL_ENV="/root/.venvs/snitch_cluster"
RUN python${PYTHON_VERSION} -m venv ${VIRTUAL_ENV} && source ${VIRTUAL_ENV}/bin/activate
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

# Install Python requirements
COPY pyproject.toml .
COPY sw/dnn ./sw/dnn
COPY sw/blas ./sw/blas
COPY util ./util
RUN pip install .
