#!/usr/bin/env bash
# Copyright 2020 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

set -e

# We sync dependencies at Docker startup, so we don't have to bake them in in the build stage
uv sync --all-extras --locked

exec "$@"
