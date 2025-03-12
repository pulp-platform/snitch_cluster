# Copyright 2020 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

FROM ghcr.io/prefix-dev/pixi AS build

WORKDIR /pixi
COPY pixi.toml .
COPY pixi.lock .
RUN pixi install --locked
RUN pixi shell-hook -s bash > /pixi/shell-hook

FROM ubuntu:24.04

COPY --from=build /pixi/.pixi/envs/default /pixi/.pixi/envs/default
COPY --from=build /pixi/shell-hook /pixi/shell-hook
RUN chmod +x /pixi/shell-hook
RUN echo "source /pixi/shell-hook" >> /root/.bashrc
