#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
from pathlib import Path
import torch
from data.datagen import golden_model

sys.path.append(str(Path(__file__).parent / '../../../util/sim/'))
import verification  # noqa: E402
from elf import Elf  # noqa: E402
from data_utils import from_buffer, ctype_from_precision_t, check_result  # noqa: E402


ERR_THRESHOLD = 0.003


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
        'batch_size': 'I',
        'seq_len': 'I',
        'input_samples': 'I',
        'reduce_dim': 'i',
        'ifmap_ptr': 'I',
        'ofmap_ptr': 'I',
        'dtype': 'I'
    }
    layer = elf.from_symbol('layer', layer_struct)
    batch_size = layer['batch_size']
    seq_len = layer['seq_len']
    input_samples = layer['input_samples']
    reduce_dim = layer['reduce_dim']
    prec = layer['dtype']

    ifmap = elf.from_symbol('ifmap', ctype_from_precision_t(prec))
    ifmap = ifmap.reshape(batch_size, seq_len, input_samples)
    ifmap = torch.from_numpy(ifmap)

    # Verify results
    ofmap_actual = from_buffer(raw_results['ofmap'], ctype_from_precision_t(prec))
    ofmap_golden = golden_model(ifmap, reduce_dim).detach().numpy().flatten()

    fail, abs_err = check_result(ofmap_golden, ofmap_actual, atol=ERR_THRESHOLD)
    if (fail):
        verification.dump_results_to_csv([ofmap_golden, ofmap_actual, abs_err],
                                         Path.cwd() / 'softmax_results.csv')

    return int(fail)


if __name__ == "__main__":
    sys.exit(main())
