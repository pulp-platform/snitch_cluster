# Copyright 2020 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Docker container for Snitch development.

# 1. Stage
FROM ubuntu:24.04 AS builder
ARG CMAKE_VERSION=3.19.4
ARG BENDER_VERSION=0.27.1
ARG VERILATOR_VERSION=5.006
ARG DOXYGEN_VERSION=1.12.0

# Install APT requirements
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt update && \
    apt install -y \
        curl \
        wget \
        git \
        tar \
        software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt update && \
    # python needs `software-properties-common` to add the deadsnakes PPA
    apt install -y python3.11

# Build Rust tools
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup install 1.70.0
RUN rustup override set 1.70.0

# Install Verilator
RUN apt install -y verilator=${VERILATOR_VERSION}

# Change working directory
WORKDIR /tools

# Install a newer version of cmake (we need this for banshee)
RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz && \
    tar -x -f cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz --strip-components=1 -C . && \
    rm -rf cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz
ENV PATH="/tools/bin:${PATH}"

# Install `banshee` (needs cmake)
RUN rustup install 1.67.0
RUN rustup override set 1.67.0
RUN git clone https://github.com/pulp-platform/banshee.git /tmp/banshee --recurse-submodules
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

# Install (and cleanup) required packages (from apt-requirements.txt)
# The list of extra packages is leftover from before this Dockerfile used
# apt-requirements.txt
#
COPY apt-requirements.txt /tmp/apt-requirements.txt
RUN apt update && \
    sed 's/#.*//' /tmp/apt-requirements.txt \
        | xargs apt install -y && \
    apt install -y --no-install-recommends \
        ca-certificates \
        gnupg2 \
        curl \
        wget \
        build-essential \
        git && \
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
COPY --from=builder /opt/python /opt/python
COPY --from=builder /tools/verilator /tools/verilator/
COPY --from=builder /tools/doxygen/bin/doxygen bin/

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
# Add Verilator to PATH
ENV PATH="/tools/verilator/bin:${PATH}"
ENV VLT_ROOT="/tools/verilator/share/verilator/"

# Set locale to UTF-8, required because Python 3.6 defaults on ASCII encoding.
# See https://click.palletsprojects.com/en/8.1.x/unicode-support/
ENV LC_ALL="C.UTF-8"
ENV LANG="C.UTF-8"
