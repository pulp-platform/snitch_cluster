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
from data_utils import from_buffer, ctype_from_precision_t, check_result  # noqa: E402


ERR_THRESHOLD = 1E-6


def main():
    # Run simulation and get outputs
    args = verification.parse_args()
    raw_results = verification.simulate(sim_bin=args.sim_bin,
                                        snitch_bin=args.snitch_bin,
                                        symbols_bin=args.symbols_bin,
                                        log=args.log,
                                        output_uids=['linear_output'])

    # Extract input operands from ELF file
    if args.symbols_bin:
        elf = Elf(args.symbols_bin)
    else:
        elf = Elf(args.snitch_bin)

    layer_struct = {
        'num_inputs': 'I',
        'in_height': 'I',
        'in_width': 'I',
        'out_height': 'I',
        'out_width': 'I',
        'inputs': 'I',
        'weights': 'I',
        'concat_output': 'I',
        'linear_output': 'I',
        'dtype': 'I',
        'baseline': 'I'
    }
    layer = elf.from_symbol('layer', layer_struct)
    num_inputs = layer['num_inputs']
    input_shape = [layer['in_height'], layer['in_width']]
    weights_shape = [layer['in_width']*num_inputs, layer['out_width']]
    prec = layer['dtype']

    inputs = [elf.from_symbol(f'input_{i}', ctype_from_precision_t(prec))
              for i in range(num_inputs)]
    inputs = [torch.from_numpy(tensor.reshape(input_shape)) for tensor in inputs]
    weights = elf.from_symbol('weights', ctype_from_precision_t(prec))
    weights = torch.from_numpy(weights.reshape(weights_shape))

    # Verify results
    output_actual = from_buffer(raw_results['linear_output'], ctype_from_precision_t(prec))
    output_golden, _ = golden_model(inputs, weights)
    output_golden = output_golden.detach().numpy().flatten()

    fail, rel_err = check_result(output_golden, output_actual, rtol=ERR_THRESHOLD)
    if fail:
        verification.dump_results_to_csv([output_golden, output_actual, rel_err],
                                         Path.cwd() / 'results.csv')
        print('Maximum relative error:', np.max(rel_err))

    return int(fail)


if __name__ == "__main__":
    sys.exit(main())
