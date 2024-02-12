#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
from pathlib import Path
from data.datagen import golden_model

sys.path.append(str(Path(__file__).parent / '../../../util/sim/'))
import verification  # noqa: E402
from elf import Elf  # noqa: E402
from data_utils import from_buffer, check_result  # noqa: E402


ERR_THRESHOLD = 1E-10


def main():
    # Run simulation and get outputs
    args = verification.parse_args()
    raw_results = verification.simulate(sim_bin=args.sim_bin,
                                        snitch_bin=args.snitch_bin,
                                        symbols_bin=args.symbols_bin,
                                        log=args.log,
                                        output_uids=['z'])
    z_actual = from_buffer(raw_results['z'], 'double')

    # Extract input operands from ELF file
    if args.symbols_bin:
        elf = Elf(args.symbols_bin)
    else:
        elf = Elf(args.snitch_bin)
    a = elf.from_symbol('a', 'double')
    x = elf.from_symbol('x', 'double')
    y = elf.from_symbol('y', 'double')

    # Verify results
    z_golden = golden_model(a, x, y)
    fail, rel_err = check_result(z_golden, z_actual, rtol=ERR_THRESHOLD)

    if fail:
        verification.dump_results_to_csv([z_golden, z_actual, rel_err],
                                         Path.cwd() / 'axpy_results.csv')

    return int(fail)


if __name__ == "__main__":
    sys.exit(main())
