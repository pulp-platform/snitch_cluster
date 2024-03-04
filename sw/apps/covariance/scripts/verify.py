#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
from pathlib import Path
import numpy as np
from datagen import CovarianceDataGen

sys.path.append(str(Path(__file__).parent / "../../../util/sim/"))
import verification  # noqa: E402
from elf import Elf  # noqa: E402
from data_utils import from_buffer  # noqa: E402


ERR_THRESHOLD = 1e-10


def main():
    # Run simulation and get outputs
    args = verification.parse_args()
    raw_results = verification.simulate(
        sim_bin=args.sim_bin,
        snitch_bin=args.snitch_bin,
        symbols_bin=args.symbols_bin,
        log=args.log,
        output_uids=['cov'],
    )

    # Extract input operands from ELF file
    if args.symbols_bin:
        elf = Elf(args.symbols_bin)
    else:
        elf = Elf(args.snitch_bin)
    M = elf.from_symbol('M', 'uint32_t')[0]
    N = elf.from_symbol('N', 'uint32_t')[0]
    data = elf.from_symbol('data', 'double')
    data = np.reshape(data, (N, M))

    # Verify results
    cov_actual = from_buffer(raw_results['cov'], 'double')
    cov_golden = CovarianceDataGen().golden_model(data).flatten()

    relative_err = np.absolute((cov_golden - cov_actual) / cov_golden)
    fail = np.any(relative_err > ERR_THRESHOLD)
    if (fail):
        print('Simulation results are incorrect.')
        verification.dump_results_to_csv([cov_golden, cov_actual, relative_err],
                                         Path.cwd() / 'results.csv')

    return int(fail)


if __name__ == "__main__":
    sys.exit(main())
