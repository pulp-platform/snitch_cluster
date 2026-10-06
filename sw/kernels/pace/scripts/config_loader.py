#!/usr/bin/env python3
# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

"""PACE JSON/JSON5 configuration loading."""

import json
from pathlib import Path

try:
    import json5

    _HAS_JSON5 = True
except ModuleNotFoundError:
    json5 = None
    _HAS_JSON5 = False


class PaceJsonConfigLoader:
    """Load PACE JSON/JSON5 config files with the previous fallback behavior."""

    @staticmethod
    def load(path):
        text = Path(path).read_text()
        if _HAS_JSON5:
            return json5.loads(text)
        filtered = "\n".join(
            line for line in text.splitlines() if not line.lstrip().startswith("//")
        )
        return json.loads(filtered)
