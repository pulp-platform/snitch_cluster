# Copyright 2020 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

FROM ghcr.io/prefix-dev/pixi AS build

WORKDIR /pixi
COPY pixi.toml .
COPY pixi.lock .
RUN pixi install --locked
RUN pixi shell-hook -s bash > /pixi/shell-hook
RUN echo "#!/bin/bash" > /pixi/entrypoint.sh
RUN cat /pixi/shell-hook >> /pixi/entrypoint.sh
# extend the shell-hook script to run the command passed to the container
RUN echo 'exec "$@"' >> /pixi/entrypoint.sh

FROM alpine:latest as gcc-download
RUN apk add --no-cache curl
# TODO: move these to pixi configuration
# Get the CVA6 GCC toolchain
ARG RISCV_GCC_VERSION=8.3.0-2020.04.0
WORKDIR /tools
RUN curl -Ls -o riscv-gcc.tar.gz https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-${RISCV_GCC_VERSION}-x86_64-linux-ubuntu14.tar.gz && \
    mkdir -p /tools/riscv && chmod 777 /tools/riscv && \
    tar -C /tools/riscv -xf riscv-gcc.tar.gz --strip-components=1 && \
    rm -rf riscv-gcc.tar

FROM ubuntu:24.04
COPY --from=build /pixi/.pixi/envs/default /pixi/.pixi/envs/default
COPY --from=build /pixi/entrypoint.sh /pixi/entrypoint.sh
RUN chmod +x /pixi/entrypoint.sh

COPY --from=gcc-download /tools/riscv /tools/riscv
ENV RISCV_GCC_BINROOT="/tools/riscv/bin"

ENTRYPOINT [ "/pixi/entrypoint.sh" ]
CMD ["/bin/bash"]
