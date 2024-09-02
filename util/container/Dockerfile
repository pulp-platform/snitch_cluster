# Copyright 2020 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Docker container for Snitch development.

# 1. Stage
FROM ubuntu:24.04 AS builder
ARG BENDER_VERSION=0.27.1
ARG VERILATOR_VERSION=5.020
ARG DOXYGEN_VERSION=1.12.0
ARG RUST_VERSION=1.67.0
# Run dpkg without interactive dialogue
ARG DEBIAN_FRONTEND=noninteractive

# Install APT requirements
RUN apt update && \
    apt install -y \
        # General requirements
        curl \
        wget \
        git \
        tar \
        # Required for rust
        build-essential \
        # Required for python 3.11
        software-properties-common\
        # Required for banshee
        cmake \
        llvm-15-dev \
        libpolly-15-dev \
        zlib1g-dev \
        libzstd-dev

# Install python 3.11
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt update && \
    apt install -y python3.11

# Install verilator
RUN apt install -y verilator=${VERILATOR_VERSION}-1

# Build Rust tools
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup install ${RUST_VERSION}
RUN rustup override set ${RUST_VERSION}

# Change working directory
WORKDIR /tools

# Install `banshee` (needs cmake)
ENV LLVM_SYS_150_PREFIX="/usr/lib/llvm-15"
RUN git clone https://github.com/pulp-platform/banshee.git /tmp/banshee --recurse-submodules && \
cd /tmp/banshee && git checkout llvm-15
RUN cargo install --path /tmp/banshee

# Install Bender
RUN wget https://github.com/pulp-platform/bender/releases/download/v${BENDER_VERSION}/bender-${BENDER_VERSION}-x86_64-linux-gnu-ubuntu18.04.tar.gz
RUN tar xzf bender-${BENDER_VERSION}-x86_64-linux-gnu-ubuntu18.04.tar.gz

# Install Doxygen
RUN wget https://www.doxygen.nl/files/doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz
RUN tar xzf doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz
RUN mv doxygen-${DOXYGEN_VERSION} doxygen

# 2. Stage
FROM ubuntu:24.04 AS snitch_cluster
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
        # Required for getting LLVM toolchain
        ca-certificates \
        gnupg2 && \
    apt clean ; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

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

# Copy artifacts from stage 1.
COPY --from=builder /tools/bender bin/
COPY --from=builder /root/.cargo/bin/banshee bin/
COPY --from=builder /tools/doxygen/bin/doxygen bin/
COPY --from=builder /usr/bin/python3.11 /usr/bin/python
COPY --from=builder /usr/bin/verilator /usr/bin/verilator

RUN which python
RUN python --version
RUN /usr/bin/python --version

# Create and activate virtual environment
ENV VIRTUAL_ENV="/root/.venvs/snitch_cluster"
RUN /opt/python/bin/python3 -m venv ${VIRTUAL_ENV}
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

# Install Python requirements
COPY pyproject.toml .
COPY sw/dnn ./sw/dnn
COPY sw/blas ./sw/blas
COPY util ./util
RUN pip install .
