#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import sys
from pathlib import Path

_REPO_ROOT = Path(__file__).resolve().parents[5]
_PACE_SCRIPTS_DIR = Path(__file__).resolve().parents[2] / "scripts"
for _path in (str(_REPO_ROOT), str(_PACE_SCRIPTS_DIR)):
    if _path not in sys.path:
        sys.path.insert(0, _path)

try:
    from snitch.pace.scripts.elementwise_datagen import PaceElementwiseDatagenCLI
except ModuleNotFoundError:
    from elementwise_datagen import PaceElementwiseDatagenCLI


if __name__ == "__main__":
    PaceElementwiseDatagenCLI().run()
