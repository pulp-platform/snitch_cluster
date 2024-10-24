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
  wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && ./llvm.sh 17 && rm llvm.sh && \
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
  clang-format-17 python3 \
  help2man perl make autoconf g++ flex bison ccache \
  libgoogle-perftools-dev numactl perl-doc \
  libfl2 libfl-dev zlib1g zlib1g-dev \
  sbt \
  python3-pip && \
  # create symbolic links for all *-17 binaries
  for f in /usr/bin/*-17; do ln -s $f ${f%-17}; done && \
  # Enable break-system-packages for non-venv package installs
  python3 -m pip config set global.break-system-packages true

# Get prebuilt mlir
# Set the URL for the download
ENV MLIR_URL=https://github.com/KULeuven-MICAS/llvm-build/releases/latest/download/mlir.tar.gz

# Download, extract, and install the specified files
RUN curl -L $MLIR_URL -o /tmp/mlir.tar.gz && \
    mkdir /tmp/mlir && \
    tar -xzvf /tmp/mlir.tar.gz -C /tmp/mlir && \
    cp /tmp/mlir/build/bin/mlir-opt /usr/bin/ && \
    cp /tmp/mlir/build/bin/mlir-translate /usr/bin/ && \
    cp /tmp/mlir/build/bin/mlir-cpu-runner /usr/bin/ && \
    rm -rf /tmp/mlir /tmp/mlir.tar.gz

# Temporarily install python3.10 until xdsl has moved to newer MLIR version
RUN add-apt-repository -y ppa:deadsnakes/ppa && \
  apt update && \
  apt install -y python3.10 && \
  ln -fs /usr/bin/python3.10 /usr/bin/python3 && \
  ln -fs /bin/python3.10 /bin/python3


# Get the CVA6 GCC toolchain
ARG RISCV_GCC_VERSION=8.3.0-2020.04.0
WORKDIR /tools
RUN curl -Ls -o riscv-gcc.tar.gz https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-${RISCV_GCC_VERSION}-x86_64-linux-ubuntu14.tar.gz && \
    mkdir -p /tools/riscv && chmod 777 /tools/riscv && \
    tar -C /tools/riscv -xf riscv-gcc.tar.gz --strip-components=1 && \
    rm -rf riscv-gcc.tar
ENV RISCV_GCC_BINROOT="/tools/riscv/bin"
WORKDIR /


# Install Verilator
RUN git clone https://github.com/verilator/verilator && \
  cd verilator && \
  git checkout v5.024 && \
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

# vcd-to-csv
RUN wget https://github.com/KULeuven-MICAS/vcd-to-csv/releases/latest/download/vcd-to-csv -P /usr/bin && chmod +x /usr/bin/vcd-to-csv

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

# Copy snax_cluster contents to /snax_cluster
COPY . /snax_cluster

# Install Python Requirements from kuleuven-micas/snax_cluster
WORKDIR /snax_cluster/
RUN pip3 install --no-cache-dir -r python-requirements.txt && \
    cd .. && \
    rm -rf snax_cluster && \
# Install Python Requirements from kuleuven-micas/snax-mlir
    git clone https://github.com/kuleuven-micas/snax-mlir.git && \
    cd snax-mlir && pip3 install --no-cache-dir -r requirements.txt && \
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

COPY . /src/
RUN cd /src && sbt package && \
    cd /src && \
    make -C target/snitch_cluster rtl-gen \
    CFG_OVERRIDE=cfg/snax_mac_cluster.hjson && \
    make DEBUG=ON sw -j$(nproc) \
    -C target/snitch_cluster \
    SELECT_TOOLCHAIN=llvm-generic \
    SELECT_RUNTIME=rtl-generic \
    CFG_OVERRIDE=cfg/snax_mac_cluster.hjson && \
    cd /src && \
    make -C target/snitch_cluster bin/snitch_cluster.vlt \
    CFG_OVERRIDE=cfg/snax_mac_cluster.hjson -j $(nproc)

FROM base as snax-alu

COPY . /src/
RUN cd /src && sbt package && \
    cd /src && \
    make -C target/snitch_cluster rtl-gen \
    CFG_OVERRIDE=cfg/snax_alu_cluster.hjson && \
    make DEBUG=ON sw -j$(nproc) \
    -C target/snitch_cluster \
    SELECT_TOOLCHAIN=llvm-generic \
    SELECT_RUNTIME=rtl-generic \
    CFG_OVERRIDE=cfg/snax_alu_cluster.hjson && \
    cd /src && \
    make -C target/snitch_cluster bin/snitch_cluster.vlt \
    CFG_OVERRIDE=cfg/snax_alu_cluster.hjson -j $(nproc)

FROM base as snax-streamer-gemm

COPY . /src/
RUN cd /src && sbt package && \
    cd /src && \
    make -C target/snitch_cluster rtl-gen \
    CFG_OVERRIDE=cfg/snax_streamer_gemm_cluster.hjson && \
    make DEBUG=ON sw -j$(nproc) \
    -C target/snitch_cluster \
    SELECT_TOOLCHAIN=llvm-generic \
    SELECT_RUNTIME=rtl-generic \
    CFG_OVERRIDE=cfg/snax_streamer_gemm_cluster.hjson && \
    cd /src && \
    make -C target/snitch_cluster bin/snitch_cluster.vlt \
    CFG_OVERRIDE=cfg/snax_streamer_gemm_cluster.hjson -j $(nproc)


FROM base as snax-streamer-gemm-add-c

COPY . /src/
RUN cd /src && sbt package && \
    cd /src && \
    make -C target/snitch_cluster rtl-gen \
    CFG_OVERRIDE=cfg/snax_streamer_gemm_add_c_cluster.hjson && \
    make DEBUG=ON sw -j$(nproc) \
    -C target/snitch_cluster \
    SELECT_TOOLCHAIN=llvm-generic \
    SELECT_RUNTIME=rtl-generic \
    CFG_OVERRIDE=cfg/snax_streamer_gemm_add_c_cluster.hjson && \
    cd /src && \
    make -C target/snitch_cluster bin/snitch_cluster.vlt \
    CFG_OVERRIDE=cfg/snax_streamer_gemm_add_c_cluster.hjson -j $(nproc)

FROM base as snax-kul-cluster-mixed-narrow-wide

COPY . /src/
RUN cd /src && sbt package && \
    cd /src && \
    make -C target/snitch_cluster rtl-gen \
    CFG_OVERRIDE=cfg/snax_KUL_cluster.hjson && \
    make DEBUG=ON sw -j$(nproc) \
    -C target/snitch_cluster \
    SELECT_TOOLCHAIN=llvm-generic \
    SELECT_RUNTIME=rtl-generic \
    CFG_OVERRIDE=cfg/snax_KUL_cluster.hjson && \
    cd /src && \
    make -C target/snitch_cluster bin/snitch_cluster.vlt \
    CFG_OVERRIDE=cfg/snax_KUL_cluster.hjson -j $(nproc)


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

COPY --from=snax-alu /src/target/snitch_cluster/bin/snitch_cluster.vlt /opt/snax-alu-rtl/bin/snitch_cluster.vlt
COPY --from=snax-alu /src/sw/snRuntime /opt/snax-alu/sw/snRuntime
COPY --from=snax-alu /src/target/snitch_cluster/sw/runtime/rtl /opt/snax-alu/target/snitch_cluster/sw/runtime/rtl
COPY --from=snax-alu /src/target/snitch_cluster/sw/runtime/rtl-generic /opt/snax-alu/target/snitch_cluster/sw/runtime/rtl-generic
COPY --from=snax-alu /src/target/snitch_cluster/sw/runtime/common /opt/snax-alu/target/snitch_cluster/sw/runtime/common
COPY --from=snax-alu /src/target/snitch_cluster/sw/snax/ /opt/snax-alu/target/snitch_cluster/sw/snax
COPY --from=snax-alu /src/sw/math/ /opt/snax-alu/sw/math/
COPY --from=snax-alu /src/sw/deps/riscv-opcodes /opt/snax-alu/sw/deps/riscv-opcodes
COPY --from=snax-alu /src/sw/deps/printf /opt/snax-alu/sw/deps/printf

COPY --from=snax-streamer-gemm /src/target/snitch_cluster/bin/snitch_cluster.vlt /opt/snax-streamer-gemm-rtl/bin/snitch_cluster.vlt
COPY --from=snax-streamer-gemm /src/sw/snRuntime /opt/snax-streamer-gemm/sw/snRuntime
COPY --from=snax-streamer-gemm /src/target/snitch_cluster/sw/runtime/rtl /opt/snax-streamer-gemm/target/snitch_cluster/sw/runtime/rtl
COPY --from=snax-streamer-gemm /src/target/snitch_cluster/sw/runtime/rtl-generic /opt/snax-streamer-gemm/target/snitch_cluster/sw/runtime/rtl-generic
COPY --from=snax-streamer-gemm /src/target/snitch_cluster/sw/runtime/common /opt/snax-streamer-gemm/target/snitch_cluster/sw/runtime/common
COPY --from=snax-streamer-gemm /src/target/snitch_cluster/sw/snax/ /opt/snax-streamer-gemm/target/snitch_cluster/sw/snax
COPY --from=snax-streamer-gemm /src/sw/math/ /opt/snax-streamer-gemm/sw/math/
COPY --from=snax-streamer-gemm /src/sw/deps/riscv-opcodes /opt/snax-streamer-gemm/sw/deps/riscv-opcodes
COPY --from=snax-streamer-gemm /src/sw/deps/printf /opt/snax-streamer-gemm/sw/deps/printf

COPY --from=snax-streamer-gemm-add-c /src/target/snitch_cluster/bin/snitch_cluster.vlt /opt/snax-streamer-gemm-add-c-rtl/bin/snitch_cluster.vlt
COPY --from=snax-streamer-gemm-add-c /src/sw/snRuntime /opt/snax-streamer-gemm-add-c/sw/snRuntime
COPY --from=snax-streamer-gemm-add-c /src/target/snitch_cluster/sw/runtime/rtl /opt/snax-streamer-gemm-add-c/target/snitch_cluster/sw/runtime/rtl
COPY --from=snax-streamer-gemm-add-c /src/target/snitch_cluster/sw/runtime/rtl-generic /opt/snax-streamer-gemm-add-c/target/snitch_cluster/sw/runtime/rtl-generic
COPY --from=snax-streamer-gemm-add-c /src/target/snitch_cluster/sw/runtime/common /opt/snax-streamer-gemm-add-c/target/snitch_cluster/sw/runtime/common
COPY --from=snax-streamer-gemm-add-c /src/target/snitch_cluster/sw/snax/ /opt/snax-streamer-gemm-add-c/target/snitch_cluster/sw/snax
COPY --from=snax-streamer-gemm-add-c /src/sw/math/ /opt/snax-streamer-gemm-add-c/sw/math/
COPY --from=snax-streamer-gemm-add-c /src/sw/deps/riscv-opcodes /opt/snax-streamer-gemm-add-c/sw/deps/riscv-opcodes
COPY --from=snax-streamer-gemm-add-c /src/sw/deps/printf /opt/snax-streamer-gemm-add-c/sw/deps/printf

COPY --from=snax-kul-cluster-mixed-narrow-wide /src/target/snitch_cluster/bin/snitch_cluster.vlt /opt/snax-kul-cluster-mixed-narrow-wide-rtl/bin/snitch_cluster.vlt
COPY --from=snax-kul-cluster-mixed-narrow-wide /src/sw/snRuntime /opt/snax-kul-cluster-mixed-narrow-wide/sw/snRuntime
COPY --from=snax-kul-cluster-mixed-narrow-wide /src/target/snitch_cluster/sw/runtime/rtl /opt/snax-kul-cluster-mixed-narrow-wide/target/snitch_cluster/sw/runtime/rtl
COPY --from=snax-kul-cluster-mixed-narrow-wide /src/target/snitch_cluster/sw/runtime/rtl-generic /opt/snax-kul-cluster-mixed-narrow-wide/target/snitch_cluster/sw/runtime/rtl-generic
COPY --from=snax-kul-cluster-mixed-narrow-wide /src/target/snitch_cluster/sw/runtime/common /opt/snax-kul-cluster-mixed-narrow-wide/target/snitch_cluster/sw/runtime/common
COPY --from=snax-kul-cluster-mixed-narrow-wide /src/target/snitch_cluster/sw/snax/ /opt/snax-kul-cluster-mixed-narrow-wide/target/snitch_cluster/sw/snax
COPY --from=snax-kul-cluster-mixed-narrow-wide /src/sw/math/ /opt/snax-kul-cluster-mixed-narrow-wide/sw/math/
COPY --from=snax-kul-cluster-mixed-narrow-wide /src/sw/deps/riscv-opcodes /opt/snax-kul-cluster-mixed-narrow-wide/sw/deps/riscv-opcodes
COPY --from=snax-kul-cluster-mixed-narrow-wide /src/sw/deps/printf /opt/snax-kul-cluster-mixed-narrow-wide/sw/deps/printf

WORKDIR /
