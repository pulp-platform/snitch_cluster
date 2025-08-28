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
                                        output_uids=['fusedconv_pOutBuffer_dram'])

    # Extract input operands from ELF file
    if args.symbols_bin:
        elf = Elf(args.symbols_bin)
    else:
        elf = Elf(args.snitch_bin)

    layer_struct = {
        'ch_in': 'I',
        'ch_out': 'I',
        'dim_in_x': 'I',
        'dim_in_y': 'I',
        'dim_kernel_x': 'I',
        'dim_kernel_y': 'I',
        'dim_out_x': 'I',
        'dim_out_y': 'I',
        'padding_y_top': 'I',
        'padding_y_bottom': 'I',
        'padding_x_left': 'I',
        'padding_x_right': 'I',
        'stride_x': 'I',
        'stride_y': 'I',
        'flag_relu': 'I',
        'flag_batch_norm': 'I',
        'depthwise': 'I',
        'chw_layer': 'I',
        'flag_y_accumulate_start': 'I',
        'flag_y_accumulate_end': 'I',
        'pInBuffer': 'I',
        'pWeight': 'I',
        'lambda': 'I',
        'kappa': 'I',
        'pOutBuffer': 'I',
        'pIm2ColBuffer': 'I',
        'memory_chan': 'I',
        'bias': 'I',
        'bias_shift': 'I',
        'out_shift': 'I',
        'out_mult': 'I',
        'dtype': 'I'
    }

    layer = elf.from_symbol('layer', layer_struct)
    dim_in_y = layer['dim_in_y']
    dim_in_x = layer['dim_in_x']
    dim_kernel_y = layer['dim_kernel_y']
    dim_kernel_x = layer['dim_kernel_x']
    ch_in = layer['ch_in']
    ch_out = layer['ch_out']
    prec = layer['dtype']

    ifmap = elf.from_symbol('fusedconv_pInBuffer_dram', ctype_from_precision_t(prec))
    ifmap = torch.from_numpy(ifmap.reshape(dim_in_y, dim_in_x, ch_in))
    kernel = elf.from_symbol('fusedconv_pWeight_dram', ctype_from_precision_t(prec))
    if not layer['depthwise']:
        kernel = torch.from_numpy(kernel.reshape(ch_out, dim_kernel_y, dim_kernel_x, ch_in))
    else:
        kernel = torch.from_numpy(kernel.reshape(dim_kernel_y, dim_kernel_x, ch_out))

    bn_k = elf.from_symbol('fusedconv_kappa_dram', ctype_from_precision_t(prec))
    bn_k = torch.from_numpy(bn_k)
    bn_l = elf.from_symbol('fusedconv_lambda_dram', ctype_from_precision_t(prec))
    bn_l = torch.from_numpy(bn_l)

    flag_y_accumulate_start = layer['flag_y_accumulate_start']

    # Verify results
    output_actual = from_buffer(raw_results['fusedconv_pOutBuffer_dram'],
                                ctype_from_precision_t(prec))
    output_golden, _, _ = golden_model(ifmap, kernel,
                                       bn_k, bn_l,
                                       layer,
                                       layer,
                                       layer['flag_batch_norm'],
                                       layer['flag_relu'],
                                       not flag_y_accumulate_start,
                                       layer['depthwise'])
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
