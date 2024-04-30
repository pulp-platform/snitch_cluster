# Copyright 2020 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

FROM ubuntu:22.04 AS builder

# apt update and upgrade
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        build-essential \
        device-tree-compiler \
        curl \
        git \
        gnupg2 \
        lsb-release \
        software-properties-common \
        tar \
        unzip \
        wget \
        zlib1g-dev \
        zsh \
        vim \
        nano 

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup install 1.77.2
RUN rustup override set 1.77.2

# Install Bender
RUN cargo install bender --version 0.28.1

# Install Verilator
RUN apt-get install -y \
    git help2man perl make autoconf g++ flex bison ccache \
    libgoogle-perftools-dev numactl perl-doc
RUN apt-get install -y libfl2 libfl-dev zlibc zlib1g zlib1g-dev || true
RUN git clone https://github.com/verilator/verilator && \
    cd verilator && \
    git checkout stable && \
    unset VERILATOR_ROOT && \
    autoconf && \
    ./configure && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf verilator
ENV VLT_ROOT /usr/local/share/verilator

# Install Verible
ENV VERIBLE_VERSION 0.0-3644-g6882622d
RUN wget https://github.com/chipsalliance/verible/releases/download/v${VERIBLE_VERSION}/verible-v${VERIBLE_VERSION}-linux-static-x86_64.tar.gz && \
    mkdir tempdir && \
    tar -x -f verible-v${VERIBLE_VERSION}-linux-static-x86_64.tar.gz --strip-components=1 -C tempdir && \
    cp -rn tempdir/bin/* ./bin/ && \
    rm -rf verible-v${VERIBLE_VERSION}-linux-static-x86_64.tar.gz tempdir

# Install LLVM 17 + MLIR + clang-format
RUN wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && ./llvm.sh 17 && rm llvm.sh
RUN apt-get -y install mlir-17-tools
RUN apt-get -y install clang-format-17

# create symbolic links for all *-17 binaries
RUN for f in /usr/bin/*-17; do ln -s $f ${f%-17}; done

# Install the Chisel Environment
RUN apt-get update && \
    apt-get install -y openjdk-11-jre-headless openjdk-11-jdk-headless

RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list && \
    echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list && \
    curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add && \
    apt-get update

RUN apt-get install -y sbt

# Install pip3
RUN apt-get install -y python3-pip

# Install Python Requirements from kuleuven-micas/snitch_cluster
RUN git clone https://github.com/kuleuven-micas/snitch_cluster.git
RUN cd snitch_cluster && pip3 install -r python-requirements.txt
RUN cd ..
RUN rm -rf snitch_cluster

# Install the FIRRTL Compiler
RUN wget https://github.com/llvm/circt/releases/download/firtool-1.42.0/firrtl-bin-ubuntu-20.04.tar.gz && \
    tar -xvzf firrtl-bin-ubuntu-20.04.tar.gz && \
    rm firrtl-bin-ubuntu-20.04.tar.gz
ENV PATH="/firtool-1.42.0//bin:${PATH}"
 
# Install Oh-My-Zsh and Autocomplete Plugin
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN echo "source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
RUN chsh -s $(which zsh)

# Zsh as default shell
CMD ["zsh"]
