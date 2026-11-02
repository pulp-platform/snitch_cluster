#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import sys
from pathlib import Path

_PACE_SCRIPTS_DIR = Path(__file__).resolve().parents[2] / "scripts"
if str(_PACE_SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(_PACE_SCRIPTS_DIR))

from verify_common import PaceVerifier


if __name__ == "__main__":
    sys.exit(PaceVerifier().main())
