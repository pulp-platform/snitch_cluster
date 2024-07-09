# Copyright 2020 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0


FROM ubuntu:24.04 AS build-bender

RUN apt-get update && apt-get install -y curl build-essential
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install bender --version 0.28.1

FROM ubuntu:24.04 AS base

# apt update and upgrade
RUN apt-get update && apt-get install -y lsb-release wget software-properties-common gnupg curl && \
  wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && ./llvm.sh 18 && rm llvm.sh && \
  echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list && \
  echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list && \
  curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
  build-essential \
  device-tree-compiler \
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
  nano \
  openjdk-11-jre-headless openjdk-11-jdk-headless \
  mlir-18-tools clang-format-18 python3 \
  help2man perl make autoconf g++ flex bison ccache \
  libgoogle-perftools-dev numactl perl-doc \
  libfl2 libfl-dev zlib1g zlib1g-dev \
  sbt \
  python3-pip && \
  # create symbolic links for all *-18 binaries
  for f in /usr/bin/*-18; do ln -s $f ${f%-18}; done && \
  # Enable break-system-packages for non-venv package installs
  python3 -m pip config set global.break-system-packages true



# Install Verilator
RUN git clone https://github.com/verilator/verilator && \
  cd verilator && \
  git checkout stable && \
  unset VERILATOR_ROOT && \
  autoconf && \
  ./configure && \
  make -j$(nproc) && \
  make install && \
  cd .. && \
  rm -rf verilator && \
  rm -rf /root/.cache

ENV VLT_ROOT /usr/local/share/verilator
ENV VERIBLE_VERSION 0.0-3644-g6882622d

# Install pre-builts:
# Bender
COPY --from=build-bender /root/.cargo/bin/bender /usr/bin/bender

# spike-dasm
RUN wget https://github.com/pulp-platform/riscv-isa-sim/releases/download/snitch-v0.1.0/snitch-spike-dasm-0.1.0-x86_64-linux-gnu-ubuntu18.04.tar.gz && \
    tar xzf snitch-spike-dasm-0.1.0-x86_64-linux-gnu-ubuntu18.04.tar.gz && \
    rm snitch-spike-dasm-0.1.0-x86_64-linux-gnu-ubuntu18.04.tar.gz && \
    mv /spike-dasm /usr/bin/spike-dasm && \
# Verible
    wget https://github.com/chipsalliance/verible/releases/download/v${VERIBLE_VERSION}/verible-v${VERIBLE_VERSION}-linux-static-x86_64.tar.gz && \
    mkdir tempdir && \
    tar -x -f verible-v${VERIBLE_VERSION}-linux-static-x86_64.tar.gz --strip-components=1 -C tempdir && \
    cp -rn tempdir/bin/* ./bin/ && \
    rm -rf verible-v${VERIBLE_VERSION}-linux-static-x86_64.tar.gz tempdir && \
# Install scala-cli
    curl -sSLf https://scala-cli.virtuslab.org/get | sh && \
# Install mill build tool
    curl -L https://raw.githubusercontent.com/lefou/millw/0.4.11/millw > mill && chmod +x mill && mv mill /usr/local/bin && \
# Remove cache
    rm -rf /root/.cache

# Install Python Requirements from kuleuven-micas/snax_cluster
RUN git clone https://github.com/kuleuven-micas/snax_cluster.git && \
    cd snax_cluster && pip3 install --no-cache-dir -r python-requirements.txt && \
    cd .. && \
    rm -rf snax_cluster && \
# Install Python Requirements from kuleuven-micas/snax-mlir
    git clone https://github.com/kuleuven-micas/snax-mlir.git && \
    cd snax-mlir && git checkout joren/bump-tensorflow && pip3 install --no-cache-dir -r requirements.txt && \
    cd .. && \
    rm -rf snax-mlir


# Install Oh-My-Zsh and Autocomplete Plugin
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    echo "source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc && \
    chsh -s $(which zsh)

# Zsh as default shell
CMD ["zsh"]

# Default systems
FROM base as snax-mac

RUN git clone https://github.com/kuleuven-micas/snax_cluster /src && \
    cd /src && git submodule update --init && \
    cd /src && sbt package && \
    cd /src && \
    make DEBUG=ON sw -j$(nproc) \
    -C target/snitch_cluster \
    SELECT_TOOLCHAIN=llvm-generic \
    SELECT_RUNTIME=rtl-generic \
    CFG_OVERRIDE=cfg/snax-mac.hjson && \
    cd /src && \
    make -C target/snitch_cluster bin/snitch_cluster.vlt \
    CFG_OVERRIDE=cfg/snax-mac.hjson -j $(nproc)

FROM base as snax-gemm

RUN git clone https://github.com/kuleuven-micas/snax_cluster /src && \
    cd /src && git submodule update --init && \
    cd /src && sbt package && \
    cd /src && \
    make DEBUG=ON sw -j$(nproc) \
    -C target/snitch_cluster \
    SELECT_TOOLCHAIN=llvm-generic \
    SELECT_RUNTIME=rtl-generic \
    CFG_OVERRIDE=cfg/snax-gemm.hjson && \
    cd /src && \
    make -C target/snitch_cluster bin/snitch_cluster.vlt \
    CFG_OVERRIDE=cfg/snax-gemm.hjson -j $(nproc)

FROM base as snax-alu

RUN git clone https://github.com/kuleuven-micas/snax_cluster /src && \
    cd /src && git submodule update --init && \
    cd /src && sbt package && \
    cd /src && \
    make DEBUG=ON sw -j$(nproc) \
    -C target/snitch_cluster \
    SELECT_TOOLCHAIN=llvm-generic \
    SELECT_RUNTIME=rtl-generic \
    CFG_OVERRIDE=cfg/snax-alu.hjson && \
    cd /src && \
    make -C target/snitch_cluster bin/snitch_cluster.vlt \
    CFG_OVERRIDE=cfg/snax-alu.hjson -j $(nproc)

# Copy Hardware to final image
FROM base as target

COPY --from=snax-mac /src/target/snitch_cluster/bin/snitch_cluster.vlt /opt/snax-mac-rtl/bin/snitch_cluster.vlt
COPY --from=snax-mac /src/sw/snRuntime /opt/snax-mac/sw/snRuntime
COPY --from=snax-mac /src/target/snitch_cluster/sw/runtime/rtl /opt/snax-mac/target/snitch_cluster/sw/runtime/rtl
COPY --from=snax-mac /src/target/snitch_cluster/sw/runtime/rtl-generic /opt/snax-mac/target/snitch_cluster/sw/runtime/rtl-generic
COPY --from=snax-mac /src/target/snitch_cluster/sw/runtime/common /opt/snax-mac/target/snitch_cluster/sw/runtime/common
COPY --from=snax-mac /src/target/snitch_cluster/sw/snax/ /opt/snax-mac/target/snitch_cluster/sw/snax
COPY --from=snax-mac /src/sw/math/ /opt/snax-mac/sw/math/
COPY --from=snax-mac /src/sw/deps/riscv-opcodes /opt/snax-mac/sw/deps/riscv-opcodes
COPY --from=snax-mac /src/sw/deps/printf /opt/snax-mac/sw/deps/printf
COPY --from=snax-mac /src/util/trace/gen_trace.py /opt/gen_trace.py

COPY --from=snax-gemm /src/target/snitch_cluster/bin/snitch_cluster.vlt /opt/snax-gemm-rtl/bin/snitch_cluster.vlt
COPY --from=snax-gemm /src/sw/snRuntime /opt/snax-gemm/sw/snRuntime
COPY --from=snax-gemm /src/target/snitch_cluster/sw/runtime/rtl /opt/snax-gemm/target/snitch_cluster/sw/runtime/rtl
COPY --from=snax-gemm /src/target/snitch_cluster/sw/runtime/rtl-generic /opt/snax-gemm/target/snitch_cluster/sw/runtime/rtl-generic
COPY --from=snax-gemm /src/target/snitch_cluster/sw/runtime/common /opt/snax-gemm/target/snitch_cluster/sw/runtime/common
COPY --from=snax-gemm /src/target/snitch_cluster/sw/snax/ /opt/snax-gemm/target/snitch_cluster/sw/snax
COPY --from=snax-gemm /src/sw/math/ /opt/snax-gemm/sw/math/
COPY --from=snax-gemm /src/sw/deps/riscv-opcodes /opt/snax-gemm/sw/deps/riscv-opcodes
COPY --from=snax-gemm /src/sw/deps/printf /opt/snax-gemm/sw/deps/printf

COPY --from=snax-alu /src/target/snitch_cluster/bin/snitch_cluster.vlt /opt/snax-alu-rtl/bin/snitch_cluster.vlt
COPY --from=snax-alu /src/sw/snRuntime /opt/snax-alu/sw/snRuntime
COPY --from=snax-alu /src/target/snitch_cluster/sw/runtime/rtl /opt/snax-alu/target/snitch_cluster/sw/runtime/rtl
COPY --from=snax-alu /src/target/snitch_cluster/sw/runtime/rtl-generic /opt/snax-alu/target/snitch_cluster/sw/runtime/rtl-generic
COPY --from=snax-alu /src/target/snitch_cluster/sw/runtime/common /opt/snax-alu/target/snitch_cluster/sw/runtime/common
COPY --from=snax-alu /src/target/snitch_cluster/sw/snax/ /opt/snax-alu/target/snitch_cluster/sw/snax
COPY --from=snax-alu /src/sw/math/ /opt/snax-alu/sw/math/
COPY --from=snax-alu /src/sw/deps/riscv-opcodes /opt/snax-alu/sw/deps/riscv-opcodes
COPY --from=snax-alu /src/sw/deps/printf /opt/snax-alu/sw/deps/printf
