#!/bin/bash
# Copyright 2024 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

docker create --name dummy ghcr.io/kuleuven-micas/snax:latest
docker cp dummy:/opt ${PREFIX}/snax-utils
mkdir -p ${PREFIX}/bin
docker cp dummy:/bin/spike-dasm ${PREFIX}/bin/spike-dasm
docker rm dummy
