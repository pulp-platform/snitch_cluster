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
from data_utils import bytes_to_float, bytes_to_int  # noqa: E402


ERR_THRESHOLD = 0.001


def main():
    # Run simulation and get outputs
    args = verification.parse_args()
    raw_results = verification.simulate(sim_bin=args.sim_bin,
                                        snitch_bin=args.snitch_bin,
                                        symbols_bin=args.symbols_bin,
                                        log=args.log,
                                        output_uids=['c'])
    c_actual = np.array(bytes_to_float(raw_results['c'], prec='64'))

    # Extract input operands from ELF file
    if args.symbols_bin:
        elf = Elf(args.symbols_bin)
    else:
        elf = Elf(args.snitch_bin)
    a = np.array(bytes_to_float(elf.get_symbol_contents('a'), prec='64'))
    b = np.array(bytes_to_float(elf.get_symbol_contents('b'), prec='64'))
    c = np.array(bytes_to_float(elf.get_symbol_contents('c'), prec='64'))
    beta = bytes_to_int(elf.get_symbol_contents('BETA'), prec='32', signedness='unsigned')[0]
    m = bytes_to_int(elf.get_symbol_contents('M'), prec='32', signedness='unsigned')[0]
    n = bytes_to_int(elf.get_symbol_contents('N'), prec='32', signedness='unsigned')[0]
    k = bytes_to_int(elf.get_symbol_contents('K'), prec='32', signedness='unsigned')[0]
    tb = bytes_to_int(elf.get_symbol_contents('TB'), prec='32', signedness='unsigned')[0]
    a = np.reshape(a, (m, k))
    if tb:
        b = np.reshape(b, (n, k))
        b = b.transpose()
    else:
        b = np.reshape(b, (k, n))
    c = np.reshape(c, (m, n))

    # Verify results
    c_golden = golden_model(1, a, b, beta, c).flatten()

    absolute_err = np.absolute(c_golden - c_actual)
    fail = np.any(absolute_err > ERR_THRESHOLD)
    if (fail):
        verification.dump_results_to_csv([c_golden, c_actual, absolute_err],
                                         Path.cwd() / 'gemm_results.csv')

    return int(fail)


if __name__ == "__main__":
    sys.exit(main())
