#!/usr/bin/env python3
# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

"""PACE JSON/JSON5 configuration loading."""

import json5
from pathlib import Path


class PaceJsonConfigLoader:
    """Load PACE JSON/JSON5 config files with the previous fallback behavior."""

    @staticmethod
    def load(path):
        text = Path(path).read_text()
        return json5.loads(text)
