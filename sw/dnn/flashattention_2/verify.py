#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
from pathlib import Path
import numpy as np
import torch
from data.datagen import exact_golden_model

sys.path.append(str(Path(__file__).parent / '../../../util/sim/'))
import verification  # noqa: E402
from elf import Elf  # noqa: E402
from data_utils import bytes_to_float, bytes_to_struct  # noqa: E402


ERR_THRESHOLD = 1E-6

PRECISION_T = {
    8: '64',
    4: '32',
    2: '16',
    1: '8'
}

NUMPY_T = {
    '64': np.float64,
    '32': np.float32,
    '16': np.float16
}


def main():
    # Run simulation and get outputs
    args = verification.parse_args()
    raw_results = verification.simulate(sim_bin=args.sim_bin,
                                        snitch_bin=args.snitch_bin,
                                        symbols_bin=args.symbols_bin,
                                        log=args.log,
                                        output_uids=['O'])

    # Extract input operands from ELF file
    if args.symbols_bin:
        elf = Elf(args.symbols_bin)
    else:
        elf = Elf(args.snitch_bin)

    layer_struct = {
        'N': 'I',
        'd': 'I',
        'B_r': 'I',
        'B_c': 'I',
        'Q': 'I',
        'K': 'I',
        'V': 'I',
        'O': 'I',
        'dtype': 'I'
    }
    layer = bytes_to_struct(elf.get_symbol_contents('layer'), layer_struct)
    N = layer['N']
    d = layer['d']
    B_r = layer['B_r']
    B_c = layer['B_c']
    prec = PRECISION_T[layer['dtype']]

    Q = np.array(bytes_to_float(elf.get_symbol_contents('Q'), prec), dtype=NUMPY_T[prec])
    K = np.array(bytes_to_float(elf.get_symbol_contents('K'), prec), dtype=NUMPY_T[prec])
    V = np.array(bytes_to_float(elf.get_symbol_contents('V'), prec), dtype=NUMPY_T[prec])
    Q = torch.from_numpy(Q.reshape(N, d))
    V = torch.from_numpy(V.reshape(N, d))
    # Golden model expects key matrix in (N, d) form, while Snitch binary stores it in (d, N)
    K = torch.from_numpy(K.reshape(d, N))
    K = torch.transpose(K, 0, 1)

    # Verify results
    O_actual = np.array(bytes_to_float(raw_results['O'], prec), dtype=NUMPY_T[prec])
    O_golden = exact_golden_model(Q, K, V, B_r, B_c).flatten()
    # O_golden = torch_golden_model(Q, K, V).detach().numpy().flatten()

    relative_err = np.absolute((O_golden - O_actual) / O_golden)
    fail = np.any(relative_err > ERR_THRESHOLD)
    if (fail):
        verification.dump_results_to_csv([O_golden, O_actual, relative_err],
                                         Path.cwd() / 'flashattention_2_results.csv')
        print('Maximum relative error:', np.max(relative_err))

    return int(fail)


if __name__ == "__main__":
    sys.exit(main())
