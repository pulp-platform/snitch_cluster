#!/usr/bin/env python3
# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

"""PACE C preprocessor define emitters."""


class PaceBreakpointModeDefines:
    """C preprocessor defines for the breakpoint-generation mode."""

    def __init__(self, mode):
        self.mode = str(mode).lower()

    def defines(self):
        is_linear = self.mode in ("linear", "uniform")
        is_nonuniform = self.mode in ("nonuniform", "chebyshev")
        if not (is_linear or is_nonuniform):
            raise ValueError(f"Unsupported breakpoint generation mode: {self.mode}")
        return [
            f"#define PACE_BP_MODE_NONUNIFORM {int(is_nonuniform)}",
            f"#define PACE_BP_MODE_LINEAR {int(is_linear)}",
        ]
