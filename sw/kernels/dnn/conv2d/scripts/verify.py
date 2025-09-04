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

from snitch.util.sim import verification
from snitch.util.sim.elf import Elf
from snitch.util.sim.data_utils import from_buffer, ctype_from_precision_t, check_result


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

    layer = elf.from_symbol('layer', layer_struct)
    co = layer['CO']
    ci = layer['CI']
    ih = layer['IH']
    iw = layer['IW']
    fh = layer['FH']
    fw = layer['FW']
    prec = layer['dtype']

    inputs = elf.from_symbol('conv2d_ifmap_dram', ctype_from_precision_t(prec))
    inputs = torch.from_numpy(inputs.reshape(ci, ih, iw))
    filters = elf.from_symbol('conv2d_weights_dram', ctype_from_precision_t(prec))
    filters = torch.from_numpy(filters.reshape(co, ci, fh, fw))
    # Verify results
    output_actual = from_buffer(raw_results['conv2d_ofmap_dram'], ctype_from_precision_t(prec))
    output_golden = golden_model(inputs, filters, padding=1, stride=1)
    output_golden = output_golden.detach().numpy().flatten()

    fail, rel_err = check_result(output_golden, output_actual, rtol=ERR_THRESHOLD)
    if fail:
        verification.dump_results_to_csv(
            [output_golden, output_actual, rel_err],
            Path.cwd() / 'results.csv')
        print('Maximum relative error:', np.max(rel_err))

    return int(fail)


if __name__ == "__main__":
    sys.exit(main())
