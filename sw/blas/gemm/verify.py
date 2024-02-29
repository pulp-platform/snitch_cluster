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

sys.path.append(str(Path(__file__).parent / "../../../util/sim/"))
import verification  # noqa: E402
from elf import Elf  # noqa: E402
from data_utils import from_buffer, ctype_from_precision_t  # noqa: E402


ERR_THRESHOLD = {8: 1e-6, 4: 1e-6, 2: 1e-2, 1: 1e-1}


def main():
    # Run simulation and get outputs
    args = verification.parse_args()
    raw_results = verification.simulate(
        sim_bin=args.sim_bin,
        snitch_bin=args.snitch_bin,
        symbols_bin=args.symbols_bin,
        log=args.log,
        output_uids=["c"],
    )

    # Extract input operands from ELF file
    if args.symbols_bin:
        elf = Elf(args.symbols_bin)
    else:
        elf = Elf(args.snitch_bin)
    prec = elf.from_symbol('dtype_size', 'uint32_t')[0]
    a = elf.from_symbol('a', ctype_from_precision_t(prec))
    b = elf.from_symbol('b', ctype_from_precision_t(prec))
    c = elf.from_symbol('c', ctype_from_precision_t(prec))
    beta = elf.from_symbol('BETA', 'uint32_t')[0]
    m = elf.from_symbol('M', 'uint32_t')[0]
    n = elf.from_symbol('N', 'uint32_t')[0]
    k = elf.from_symbol('K', 'uint32_t')[0]
    tb = elf.from_symbol('TB', 'uint32_t')[0]
    a = np.reshape(a, (m, k))
    if tb:
        b = np.reshape(b, (n, k))
        b = b.transpose()
    else:
        b = np.reshape(b, (k, n))
    c = np.reshape(c, (m, n))

    # Verify results
    c_actual = from_buffer(raw_results['c'], ctype_from_precision_t(prec))
    c_golden = golden_model(1, a, b, beta, c).flatten()

    absolute_err = np.absolute(c_golden - c_actual)
    fail = np.any(absolute_err > ERR_THRESHOLD[prec])
    if (fail or args.dump_results):
        print('Simulation results are incorrect.')
        verification.dump_results_to_csv([c_golden, c_actual, absolute_err],
                                         Path.cwd() / 'results.csv')

    return int(fail)


if __name__ == "__main__":
    sys.exit(main())
