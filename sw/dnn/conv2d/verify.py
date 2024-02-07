#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

import sys
from pathlib import Path
import numpy as np
import torch
from data.datagen import golden_model

sys.path.append(str(Path(__file__).parent / '../../../util/sim/'))
import verification  # noqa: E402
from elf import Elf  # noqa: E402
from data_utils import bytes_to_float, bytes_to_struct, NUMPY_T, \
                        PRECISION_T  # noqa: E402


ERR_THRESHOLD = 1E-6


def main():
    # Run simulation and get outputs
    args = verification.parse_args()
    raw_results = verification.simulate(sim_bin=args.sim_bin,
                                        snitch_bin=args.snitch_bin,
                                        symbols_bin=args.symbols_bin,
                                        log=args.log,
                                        output_uids=['conv2d_ofmap_dram'])

    # Extract input operands from ELF file
    if args.symbols_bin:
        elf = Elf(args.symbols_bin)
    else:
        elf = Elf(args.snitch_bin)

    layer_struct = {
        'CO': 'I',
        'CI': 'I',
        'IH': 'I',
        'IW': 'I',
        'OH': 'I',
        'OW': 'I',
        'FH': 'I',
        'FW': 'I',
        'pad': 'I',
        'ifmap': 'I',
        'weights': 'I',
        'ofmap': 'I',
        'TILE_CI': 'I',
        'cluster2cluster': 'I',
        'im2col': 'I',
        'gamma': 'I',
        'beta': 'I',
        'dtype': 'I'
    }

    layer = bytes_to_struct(elf.get_symbol_contents('layer'), layer_struct)
    inputs = [np.array(bytes_to_float(
              elf.get_symbol_contents('conv2d_ifmap_dram'),
              PRECISION_T[layer['dtype']]),
              dtype=NUMPY_T[PRECISION_T[layer['dtype']]])]
    inputs = torch.from_numpy(
                inputs[0].reshape(layer['CI'], layer['IH'], layer['IW']))
    filters = [np.array(bytes_to_float(
               elf.get_symbol_contents('conv2d_weights_dram'),
               PRECISION_T[layer['dtype']]),
               dtype=NUMPY_T[PRECISION_T[layer['dtype']]])]
    filters = torch.from_numpy(
                    filters[0].reshape(
                        layer['CO'], layer['CI'], layer['FH'], layer['FW']))
    # Verify results
    output_actual = np.array(bytes_to_float(
                             raw_results['conv2d_ofmap_dram'],
                             PRECISION_T[layer['dtype']]),
                             dtype=NUMPY_T[PRECISION_T[layer['dtype']]])
    output_golden = golden_model(inputs, filters, padding=1, stride=1)
    output_golden = output_golden.detach().numpy().flatten()

    relative_err = np.absolute((output_golden - output_actual) / output_golden)
    fail = np.any(relative_err > ERR_THRESHOLD)
    if (fail):
        verification.dump_results_to_csv(
                    [output_golden, output_actual, relative_err],
                    Path.cwd() / 'results.csv')
        print('Maximum relative error:', np.max(relative_err))

    return int(fail)


if __name__ == "__main__":
    sys.exit(main())
