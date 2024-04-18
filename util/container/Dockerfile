FROM ubuntu:22.04 AS builder

# apt update and upgrade
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        build-essential \
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
RUN rustup install 1.76.0
RUN rustup override set 1.76.0

# Install Bender
RUN cargo install bender --version 0.27.1

# Install Verilator
RUN apt-get install -y verilator

# Install LLVM 17
RUN  wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && ./llvm.sh 17 && rm llvm.sh

# Install the Chisel Environment
RUN apt-get update && \
    apt-get install -y openjdk-11-jre-headless openjdk-11-jdk-headless

RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list && \
    echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list && \
    curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add && \
    apt-get update

RUN apt-get install -y sbt

# Install the FIRRTL Compiler
RUN wget https://github.com/llvm/circt/releases/download/firtool-1.73.0/firrtl-bin-linux-x64.tar.gz && \
    tar -xvzf firrtl-bin-linux-x64.tar.gz && \
    rm firrtl-bin-linux-x64.tar.gz
 
# Install Oh-My-Zsh and Autocomplete Plugin
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN echo "source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
RUN chsh -s $(which zsh)

# Zsh as default shell
CMD ["zsh"]
