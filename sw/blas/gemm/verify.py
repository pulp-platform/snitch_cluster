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
from data_utils import bytes_to_doubles, bytes_to_uint32s  # noqa: E402


ERR_THRESHOLD = 0.001


def main():
    # Run simulation and get outputs
    args = verification.parse_args()
    raw_results = verification.simulate(sim_bin=args.sim_bin,
                                        snitch_bin=args.snitch_bin,
                                        symbols_bin=args.symbols_bin,
                                        log=args.log,
                                        output_uids=['c'])
    c_actual = np.array(bytes_to_doubles(raw_results['c']))

    # Extract input operands from ELF file
    if args.symbols_bin:
        elf = Elf(args.symbols_bin)
    else:
        elf = Elf(args.snitch_bin)
    a = np.array(bytes_to_doubles(elf.get_symbol_contents('a')))
    b = np.array(bytes_to_doubles(elf.get_symbol_contents('b')))
    c = np.array(bytes_to_doubles(elf.get_symbol_contents('c')))
    beta = bytes_to_uint32s(elf.get_symbol_contents('BETA'))[0]
    m = bytes_to_uint32s(elf.get_symbol_contents('M'))[0]
    n = bytes_to_uint32s(elf.get_symbol_contents('N'))[0]
    k = bytes_to_uint32s(elf.get_symbol_contents('K'))[0]
    tb = bytes_to_uint32s(elf.get_symbol_contents('TB'))[0]
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
