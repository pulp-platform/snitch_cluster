# Copyright 2020 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Docker container for Snitch development.

# 1. Stage
FROM ubuntu:18.04 AS builder
ARG CMAKE_VERSION=3.19.4
ARG PYTHON_VERSION=3.9.12
ARG BENDER_VERSION=0.27.1
ARG SPIKE_DASM_VERSION=0.1.0
# Run dpkg without interactive dialogue
ARG DEBIAN_FRONTEND=noninteractive

# Install APT requirements
COPY apt-requirements.txt /tmp/apt-requirements.txt
RUN apt-get update && \
    sed 's/#.*//' /tmp/apt-requirements.txt \
        | xargs apt-get install -y && \
    apt-get install -y \
        build-essential \
        curl \
        git \
        gnupg2 \
        lsb-release \
        software-properties-common \
        unzip \
        wget
# Required to install Python
RUN apt-get update && apt-get install -y \
        zlib1g-dev \
        libreadline-gplv2-dev \
        libncursesw5-dev \
        libssl-dev \
        libsqlite3-dev \
        tk-dev \
        libgdbm-dev \
        libc6-dev \
        libbz2-dev \
        libffi-dev

# Install Python
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
RUN tar xzf Python-${PYTHON_VERSION}.tgz
RUN cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations --prefix=/opt/python/ && \
    make install -j

# Build Rust tools
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH "/root/.cargo/bin:${PATH}"
RUN rustup install 1.70.0
RUN rustup override set 1.70.0

# Get LLVM 12
RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN ./llvm.sh 12

# Change working directory
WORKDIR /tools

# Install a newer version of cmake (we need this for banshee)
RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz && \
    tar -x -f cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz --strip-components=1 -C . && \
    rm -rf cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz
ENV PATH "/tools/bin:${PATH}"

# Install `banshee` (needs cmake)
RUN rustup install 1.63.0
RUN rustup override set 1.63.0
RUN git clone https://github.com/pulp-platform/banshee.git /tmp/banshee --recurse-submodules
RUN cargo install --path /tmp/banshee

# Install Bender
RUN wget https://github.com/pulp-platform/bender/releases/download/v${BENDER_VERSION}/bender-${BENDER_VERSION}-x86_64-linux-gnu-ubuntu18.04.tar.gz
RUN tar xzf bender-${BENDER_VERSION}-x86_64-linux-gnu-ubuntu18.04.tar.gz

# Install spike-dasm
RUN wget https://github.com/pulp-platform/riscv-isa-sim/releases/download/snitch-v${SPIKE_DASM_VERSION}/snitch-spike-dasm-${SPIKE_DASM_VERSION}-x86_64-linux-gnu-ubuntu18.04.tar.gz
RUN tar xzf snitch-spike-dasm-${SPIKE_DASM_VERSION}-x86_64-linux-gnu-ubuntu18.04.tar.gz

# 2. Stage
FROM ubuntu:18.04 AS snitch_cluster
ARG SNITCH_LLVM_VERSION=latest
ARG VERIBLE_VERSION=0.0-776-g09e0b87
ARG VERILATOR_VERSION=4.110

LABEL version="0.1"
LABEL description="Snitch container for hardware and software development."
LABEL maintainer="zarubaf@iis.ee.ethz.ch"
LABEL org.opencontainers.image.source https://github.com/pulp-platform/snitch_cluster

WORKDIR /tools

# Install (and cleanup) required packages (from apt-requirements.txt)
# The list of extra packages is leftover from before this Dockerfile used
# apt-requirements.txt
#
COPY apt-requirements.txt /tmp/apt-requirements.txt
RUN apt-get update && \
    sed 's/#.*//' /tmp/apt-requirements.txt \
        | xargs apt-get install -y && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg2 \
        curl \
        wget \
        build-essential \
        git && \
    apt-get clean ; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Install Verilator
RUN echo 'deb http://download.opensuse.org/repositories/home:/phiwag:/edatools/xUbuntu_18.04/ /' | tee /etc/apt/sources.list.d/home:phiwag:edatools.list && \
    curl -fsSL https://download.opensuse.org/repositories/home:phiwag:edatools/xUbuntu_18.04/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/home_phiwag_edatools.gpg > /dev/null && \
    apt-get update && apt-get install -y verilator-${VERILATOR_VERSION} && \
    apt-get clean ; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
ENV VLT_ROOT "/usr/share/verilator"

# Get the precompiled LLVM toolchain
RUN latest_tag=`curl -s -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/pulp-platform/llvm-project/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'` && \
    echo "SNITCH_LLVM_VERSION=${SNITCH_LLVM_VERSION} LLVM_TAR=${LLVM_TAR} latest_tag=${latest_tag}" && \
    test "${SNITCH_LLVM_VERSION}" = "latest" && SNITCH_LLVM_VERSION=${latest_tag} || : ; \
    LLVM_TAR=riscv32-pulp-llvm-ubuntu1804-$(echo $SNITCH_LLVM_VERSION | cut -d '-' -f3-).tar.gz && \
    mkdir -p riscv-llvm && \
    echo "SNITCH_LLVM_VERSION=${SNITCH_LLVM_VERSION} LLVM_TAR=${LLVM_TAR} latest_tag=${latest_tag}" && \
    wget -qO- https://github.com/pulp-platform/llvm-project/releases/download/${SNITCH_LLVM_VERSION}/${LLVM_TAR} | \
    tar xvz --strip-components=1 -C riscv-llvm
ENV LLVM_BINROOT "/tools/riscv-llvm/bin"

# Install Verible
RUN wget https://github.com/google/verible/releases/download/v${VERIBLE_VERSION}/verible-v${VERIBLE_VERSION}-Ubuntu-18.04-bionic-x86_64.tar.gz && \
    tar -x -f verible-v${VERIBLE_VERSION}-Ubuntu-18.04-bionic-x86_64.tar.gz --strip-components=1 -C . && \
    rm -rf verible-v${VERIBLE_VERSION}-Ubuntu-18.04-bionic-x86_64.tar.gz
ENV PATH "/tools/bin:${PATH}"

# Install git>=2.18, required by Github checkout action to recurse submodules
RUN apt-get update && apt-get install software-properties-common -y && \
    add-apt-repository -y ppa:git-core/ppa && \
    apt-get update && \
    apt-get install git -y

# Copy artifacts from stage 1.
COPY --from=builder /tools/bender bin/
COPY --from=builder /tools/spike-dasm bin/
COPY --from=builder /root/.cargo/bin/banshee bin/
COPY --from=builder /opt/python /opt/python

# Create and activate virtual environment
ENV VIRTUAL_ENV "/root/.venvs/snitch_cluster"
RUN /opt/python/bin/python3 -m venv ${VIRTUAL_ENV}
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
# Install Python requirements
COPY python-requirements.txt /tmp/python-requirements.txt
COPY docs/requirements.txt /tmp/docs/requirements.txt
COPY sw/dnn/requirements.txt /tmp/sw/dnn/requirements.txt
RUN pip install -r /tmp/python-requirements.txt

# Set locale to UTF-8, required because Python 3.6 defaults on ASCII encoding.
# See https://click.palletsprojects.com/en/8.1.x/unicode-support/
ENV LC_ALL "C.UTF-8"
ENV LANG   "C.UTF-8"
