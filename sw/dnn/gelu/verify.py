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
from data.datagen import golden_model

sys.path.append(str(Path(__file__).parent / '../../../util/sim/'))
import verification  # noqa: E402
from elf import Elf  # noqa: E402
from data_utils import from_buffer, ctype_from_precision_t  # noqa: E402


ERR_THRESHOLD = 1E-0


def main():
    # Run simulation and get outputs
    args = verification.parse_args()
    raw_results = verification.simulate(sim_bin=args.sim_bin,
                                        snitch_bin=args.snitch_bin,
                                        symbols_bin=args.symbols_bin,
                                        log=args.log,
                                        output_uids=['ofmap'])

    # Extract input operands from ELF file
    if args.symbols_bin:
        elf = Elf(args.symbols_bin)
    else:
        elf = Elf(args.snitch_bin)

    layer_struct = {
        'size': 'I',
        'ifmap': 'I',
        'ofmap': 'I',
        'dtype': 'I'
    }
    layer = elf.from_symbol('layer', layer_struct)
    prec = layer['dtype']

    ifmap = elf.from_symbol('ifmap', ctype_from_precision_t(prec))
    ifmap = torch.from_numpy(ifmap)

    # Verify results
    ofmap_actual = from_buffer(raw_results['ofmap'], ctype_from_precision_t(prec))
    ofmap_golden = golden_model(ifmap).detach().numpy().flatten()
    relative_err = np.absolute((ofmap_golden - ofmap_actual) / ofmap_golden)
    fail = np.any(relative_err > ERR_THRESHOLD)

    # Print results
    if (fail):
        verification.dump_results_to_csv([ofmap_golden, ofmap_actual, relative_err],
                                         Path.cwd() / 'gelu_results.csv')
        print('Maximum relative error:', np.max(relative_err))

    return int(fail)


if __name__ == "__main__":
    sys.exit(main())
