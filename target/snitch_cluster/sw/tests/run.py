#!/usr/bin/env python3
#
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
import simutils
from pathlib import Path

sys.path.append(str(Path(__file__).parent / '../../../../util'))


def main():
    simutils.main(lambda test: Path(__file__).parent / f'build/{test}.elf')


if __name__ == '__main__':
    sys.exit(main())
