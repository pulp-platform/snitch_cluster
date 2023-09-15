#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
from pathlib import Path
import numpy as np
from data.datagen import golden_model

sys.path.append(str(Path(__file__).parent / '../../../util/sim/'))
import verification  # noqa: E402
from elf import Elf  # noqa: E402
from data_utils import bytes_to_doubles  # noqa: E402


ERR_THRESHOLD = 1E-10


def main():
    # Run simulation and get outputs
    args = verification.parse_args()
    raw_results = verification.simulate(sim_bin=args.sim_bin,
                                        snitch_bin=args.snitch_bin,
                                        symbols_bin=args.symbols_bin,
                                        log=args.log,
                                        output_uids=['z'])
    z_actual = np.array(bytes_to_doubles(raw_results['z']))

    # Extract input operands from ELF file
    if args.symbols_bin:
        elf = Elf(args.symbols_bin)
    else:
        elf = Elf(args.snitch_bin)
    a = np.array(bytes_to_doubles(elf.get_symbol_contents('a')))
    x = np.array(bytes_to_doubles(elf.get_symbol_contents('x')))
    y = np.array(bytes_to_doubles(elf.get_symbol_contents('y')))

    # Verify results
    z_golden = golden_model(a, x, y)
    relative_err = np.absolute((z_golden - z_actual) / z_golden)
    fail = np.any(relative_err > ERR_THRESHOLD)
    if (fail):
        verification.dump_results_to_csv([z_golden, z_actual, relative_err],
                                         Path.cwd() / 'axpy_results.csv')

    return int(fail)


if __name__ == "__main__":
    sys.exit(main())
