#!/usr/bin/env python3
#
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent / '../../../../util/sim'))
import sim_utils # noqa: E402,E261


def main():
    sim_utils.main(lambda test: Path(__file__).parent / f'{test}/build/{Path(test).name}.elf')


if __name__ == '__main__':
    sys.exit(main())
